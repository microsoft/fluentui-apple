//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFAvatarGroupViewStyle)
public enum AvatarGroupViewStyle: Int {
    case stack
    case pile
}

@objc(MSFAvatarGroupView)
open class AvatarGroupView: UIView {
    /// Array of avatars to display in the avatar group view.
    @objc open var avatars: [Avatar] {
        didSet {
            updateAvatars()
        }
    }

    /// The size for avatar views in the avatar group view
    @objc open var avatarSize: AvatarSize {
        didSet {
            updateAvatars()
        }
    }

    /// The avatar group view's style
    @objc open var style: AvatarGroupViewStyle {
        didSet {
            updateAvatars()
        }
    }

    /// Set to true to display avatar borders in the avatar group view.
    @objc open var displaysBorders: Bool {
        didSet {
            updateAvatars()
        }
    }

    @objc public required init(with avatars: [Avatar], size: AvatarSize, style: AvatarGroupViewStyle, displaysBorders: Bool = false) {
        self.avatars = avatars
        self.avatarSize = size
        self.displaysBorders = displaysBorders
        self.style = style
        super.init(frame: .zero)

        updateAvatars()
    }

    @available(*, unavailable)
    @objc public required override init(frame: CGRect) {
        preconditionFailure("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override var intrinsicContentSize: CGSize {
        let avatarsCount = CGFloat(avatars.count)
        var width = avatarSize.size.width * avatarsCount

        if avatarsCount > 1 {
            width += (avatarsCount - 1) * avatarSpacing()
        }

        return CGSize(width: width, height: avatarSize.size.height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerMask()
    }

    private struct Constants {
        static let avatarStackOverlapRatio: CGFloat = 0.14
    }

    private var avatarViews: [AvatarView] = []

    private func updateAvatars() {
        removeAllSubviews()

        avatarViews.removeAll()
        var constraints: [NSLayoutConstraint] = []
        var previousAvatarView: AvatarView?
        let avatarSpacing = -self.avatarSpacing()

        for avatar in avatars {
            let avatarView = AvatarView(avatarSize: avatarSize, withBorder: displaysBorders, style: .circle)
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            avatarView.setup(avatar: avatar)
            avatarViews.append(avatarView)

            addSubview(avatarView)

            constraints.append(contentsOf: [
                avatarView.topAnchor.constraint(equalTo: topAnchor),
                avatarView.bottomAnchor.constraint(equalTo: bottomAnchor),
                avatarView.widthAnchor.constraint(equalToConstant: avatarSize.size.width),
                avatarView.heightAnchor.constraint(equalToConstant: avatarSize.size.height)
            ])

            if let previousAvatarView = previousAvatarView {
                constraints.append(previousAvatarView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: avatarSpacing))
            } else {
                constraints.append(leadingAnchor.constraint(equalTo: avatarView.leadingAnchor))
            }

            previousAvatarView = avatarView
        }

        if let lastAvatarView = avatarViews.last {
            constraints.append(trailingAnchor.constraint(equalTo: lastAvatarView.trailingAnchor))
        }

        NSLayoutConstraint.activate(constraints)

        accessibilityElements = [avatarViews]

        invalidateIntrinsicContentSize()
        updateLayerMask()
    }

    private func updateLayerMask() {
        if style != .stack {
            return
        }

        if avatarViews.count <= 1 {
            for avatarView in avatarViews {
                avatarView.layer.mask = nil
            }

            return
        }

        var borderWidth = avatarBorderWidth()
        let avatarFrame = CGRect(origin: .zero, size: avatarSize.size)

        var pathFrame = avatarFrame
        if displaysBorders {
            pathFrame.origin.x -= borderWidth
            pathFrame.origin.y -= borderWidth
            pathFrame.size.width += borderWidth * 4
            pathFrame.size.height += borderWidth * 4
            borderWidth *= 2
        }

        var nextFrame = avatarFrame
        nextFrame.origin.x += avatarSize.size.width + avatarSpacing() - borderWidth
        nextFrame.origin.y -= borderWidth
        nextFrame.size.width += borderWidth * 2
        nextFrame.size.height += borderWidth * 2

        let path = UIBezierPath(rect: pathFrame)
        path.append(UIBezierPath(ovalIn: nextFrame))

        var maskedAvatares: ArraySlice<AvatarView>
        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            maskedAvatares = avatarViews.prefix(avatarViews.count - 1)
        } else {
            maskedAvatares = avatarViews.suffix(avatarViews.count - 1)
        }

        for avatarView in maskedAvatares {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = avatarFrame
            maskLayer.fillRule = .evenOdd
            maskLayer.path = path.cgPath

            avatarView.layer.mask = maskLayer
        }
    }

    private func avatarBorderWidth() -> CGFloat {
        return AvatarView.borderWidth(size: avatarSize, hasCustomBorder: false)
    }

    private func avatarSpacing() -> CGFloat {
        var spacing: CGFloat = 0
        switch style {
        case .pile:
            spacing = avatarSize.pileSpacing
            if displaysBorders {
                spacing += 2 * avatarBorderWidth()
            }
        case .stack:
            spacing = -avatarSize.size.width * Constants.avatarStackOverlapRatio
        }

        return spacing
    }
}

extension AvatarSize {
    var pileSpacing: CGFloat {
        switch self {
        case .extraSmall, .small:
            return 4
        case .medium, .large, .extraLarge, .extraExtraLarge:
            return 8
        }
    }
}
