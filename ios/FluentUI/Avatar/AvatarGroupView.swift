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

    /// Set to true to show avatar borders in the avatar group view.
    @objc open var showBorders: Bool {
        didSet {
            updateAvatars()
        }
    }

    /// Set to true to generate border colors from InitialView ColorSet excluding the Overflow AvatarView
    @objc open var shouldGenerateBorderColor: Bool = false {
        didSet {
            if oldValue != shouldGenerateBorderColor {
                updateAvatars()
            }
        }
    }

    /// Maximum count of avatars that can be displayed in the avatar group view.
    /// If the avatars array contains more avatars than this limit, an overflow UI will be displayed with the overflow count.
    /// The overflow UI is an avatar view with a "+" sign and the overflow count.
    /// The overflow UI is not counted in the maxDisplayedAvatars.
    /// Calculation for the overflow count: max(avatars.count() - maxDisplayedAvatars, 0) + overflowCount.
    @objc open var maxDisplayedAvatars: UInt {
        didSet {
            updateAvatars()
        }
    }

    /// The overflow count will be displayed to represent the number of avatars that couldn't be displayed in the group view.
    /// If the count if avatars in the avatars array is greater than maxDisplayedAvatars, the overflow count will also include the extra avatars from that array.
    /// Calculation for the overflow count: max(avatars.count() - maxDisplayedAvatars, 0) + overflowCount.
    @objc open var overflowCount: UInt {
        didSet {
            updateAvatars()
        }
    }

    @objc public required init(avatars: [Avatar],
                               size: AvatarSize,
                               style: AvatarGroupViewStyle,
                               showBorders: Bool = false,
                               maxDisplayedAvatars: UInt = UInt.max,
                               overflowCount: UInt = 0) {
        self.avatars = avatars
        self.avatarSize = size
        self.showBorders = showBorders
        self.style = style
        self.maxDisplayedAvatars = maxDisplayedAvatars
        self.overflowCount = overflowCount
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

        for avatar in avatars.prefix(Int(maxDisplayedAvatars)) {
            let avatarView = AvatarView(avatarSize: avatarSize, withBorder: showBorders, style: .circle)
            avatarView.shouldGenerateBorderColor = shouldGenerateBorderColor
            avatarView.setup(avatar: avatar)

            constraints.append(contentsOf: insert(avatarView: avatarView, previousAvatarView: previousAvatarView))

            previousAvatarView = avatarView
        }

        var overflowCount = self.overflowCount
        if avatars.count > maxDisplayedAvatars {
            overflowCount += UInt(avatars.count) - maxDisplayedAvatars
        }

        if overflowCount > 0 {
            let avatarView = OverflowAvatarView(overflowCount: overflowCount, avatarSize: avatarSize, withBorder: showBorders)
            avatarView.translatesAutoresizingMaskIntoConstraints = false

            constraints.append(contentsOf: insert(avatarView: avatarView, previousAvatarView: previousAvatarView))
        }

        if let lastAvatarView = avatarViews.last {
            constraints.append(trailingAnchor.constraint(equalTo: lastAvatarView.trailingAnchor))
        }

        NSLayoutConstraint.activate(constraints)

        accessibilityElements = [avatarViews]

        invalidateIntrinsicContentSize()
        updateLayerMask()
    }

    private func insert(avatarView: AvatarView, previousAvatarView: AvatarView?) -> [NSLayoutConstraint] {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
        avatarViews.append(avatarView)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: [
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarSize.size.width),
            avatarView.heightAnchor.constraint(equalToConstant: avatarSize.size.height)
        ])

        if let previousAvatarView = previousAvatarView {
            constraints.append(previousAvatarView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -avatarSpacing()))
        } else {
            constraints.append(leadingAnchor.constraint(equalTo: avatarView.leadingAnchor))
        }

        return constraints
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

        let borderWidth = avatarSize.borderWidth
        let avatarFrame = CGRect(origin: .zero, size: avatarSize.size)

        var nextFrame = avatarFrame
        nextFrame.origin.x += avatarSize.size.width + avatarSpacing() - borderWidth
        nextFrame.origin.y -= borderWidth
        nextFrame.size.width += borderWidth * 2
        nextFrame.size.height += borderWidth * 2

        let path = UIBezierPath(rect: avatarFrame)
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

    private func avatarSpacing() -> CGFloat {
        var spacing: CGFloat = 0
        switch style {
        case .pile:
            spacing = avatarSize.pileSpacing
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
