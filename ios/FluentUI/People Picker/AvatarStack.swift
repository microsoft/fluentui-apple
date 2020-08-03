//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFAvatarStack)
open class AvatarStack: UIView {
    @objc open var avatars: [Avatar] {
        didSet {
            updateAvatars()
        }
    }

    @objc open var avatarSize: AvatarSize {
        didSet {
            updateAvatars()
        }
    }

    @objc public required init(with avatars: [Avatar], size: AvatarSize) {
        self.avatars = avatars
        self.avatarSize = size
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

    private struct Constants {
        static let avatarOverlapRatio: CGFloat = 0.15
    }

    private func updateAvatars() {
        removeAllSubviews()

        var avatarViews: [AvatarView] = []
        var constraints: [NSLayoutConstraint] = []
        var previousAvatarView: AvatarView?
        let avatarOverlap = self.avatarOverlap()

        for avatar in avatars {
            let avatarView = AvatarView(avatarSize: avatarSize, withBorder: false, style: .circle)
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

        invalidateIntrinsicContentSize()
    }

    private func avatarOverlap() -> CGFloat {
        return avatarSize.size.width * Constants.avatarOverlapRatio
    }
}
