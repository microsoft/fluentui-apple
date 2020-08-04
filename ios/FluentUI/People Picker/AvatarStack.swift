//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFAvatarStack)
open class AvatarStack: UIView {
    /// Array of avatars to display in the avatar stack.
    @objc open var avatars: [Avatar] {
        didSet {
            updateAvatars()
        }
    }

    /// The size for avatar views in the avatar stack
    @objc open var avatarSize: AvatarSize {
        didSet {
            updateAvatars()
        }
    }

    /// Set to true to display avatar borders in the avatar stack.
    @objc open var displaysBorders: Bool {
        didSet {
            updateAvatars()
        }
    }

    @objc public required init(with avatars: [Avatar], size: AvatarSize, displaysBorders: Bool = false) {
        self.avatars = avatars
        self.avatarSize = size
        self.displaysBorders = displaysBorders
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
        let avatarOverlap = self.avatarOverlap()

        if avatarsCount > 1 {
            width -= (avatarsCount - 1) * avatarOverlap
        }

        return CGSize(width: width, height: avatarSize.size.height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerMask()
    }

    private struct Constants {
        static let avatarOverlapRatio: CGFloat = 0.14
    }

    private var avatarViews: [AvatarView] = []

    private func updateAvatars() {
        removeAllSubviews()

        avatarViews.removeAll()
        var constraints: [NSLayoutConstraint] = []
        var previousAvatarView: AvatarView?
        let avatarOverlap = self.avatarOverlap()

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
                constraints.append(previousAvatarView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: avatarOverlap))
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
    }

    private func updateLayerMask() {
        if avatarViews.count <= 1 {
            layer.mask = nil
            return
        }

        let borderWidth: CGFloat = avatarViews[0].borderWidth
        var maskFrame = CGRect(origin: .zero, size: intrinsicContentSize)
        if displaysBorders {
            maskFrame.origin.x -= borderWidth
            maskFrame.origin.y -= borderWidth
            maskFrame.size.width += borderWidth * 4
            maskFrame.size.height += borderWidth * 4
        }

        let path = UIBezierPath(rect: maskFrame)

        for avatarView in avatarViews {
            var frame = avatarView.frame
            if displaysBorders {
                frame.size.width += borderWidth * 2
                frame.size.height += borderWidth * 2
            }

            let avatarPath = UIBezierPath()
            avatarPath.addArc(withCenter: CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2),
                           radius: frame.size.width / 2,
                           startAngle: CGFloat.pi / 2,
                           endAngle: 3 * CGFloat.pi / 2,
                           clockwise: true)
            avatarPath.addArc(withCenter: CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2),
                           radius: frame.size.width / 2 + borderWidth,
                           startAngle: CGFloat.pi / 2,
                           endAngle: 3 * CGFloat.pi / 2,
                           clockwise: true)

            path.append(avatarPath)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.frame = maskFrame
        maskLayer.fillRule = .evenOdd
        maskLayer.path = path.cgPath

        layer.mask = maskLayer
    }

    private func avatarOverlap() -> CGFloat {
        return avatarSize.size.width * Constants.avatarOverlapRatio
    }
}
