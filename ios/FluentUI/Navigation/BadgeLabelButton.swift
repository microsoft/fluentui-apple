//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BadgeLabelButton: UIButton {

    var item: UIBarButtonItem? {
        didSet {
            setupButton()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: UIBarButtonItem.badgeValueDidChangeNotification,
                                               object: item)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupButton()
    }

    private struct Constants {
        static let badgeVerticalOffset: CGFloat = -5
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
        static let badgeMaxWidth: CGFloat = 27
        static let badgeBorderWidth: CGFloat = 2
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCornerRadii: CGFloat = 10
    }

    private let badgeLabel = BadgeLabel()

    private var badgeWidth: CGFloat {
        return min(max(badgeLabel.intrinsicContentSize.width + Constants.badgeHorizontalPadding,
                       Constants.badgeMinWidth),
                   Constants.badgeMaxWidth)
    }

    private var badgeVerticalPosition: CGFloat {
        return (frame.size.height - intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2 - Constants.badgeVerticalOffset
    }

    private var badgeFrameOriginX: CGFloat {
        let xOrigin: CGFloat = isLeftToRightUserInterfaceLayoutDirection ?
            frame.size.width - contentEdgeInsets.left  :
            contentEdgeInsets.left

        return (xOrigin - badgeWidth / 2)
    }

    private var badgeLabelFrame: CGRect {
        let targetView = isItemTitlePresent ? titleLabel : imageView

        return CGRect(x: badgeFrameOriginX - (targetView?.frame.origin.x ?? 0),
                      y: badgeVerticalPosition - (targetView?.frame.origin.y ?? 0),
                      width: badgeWidth,
                      height: Constants.badgeHeight)
    }

    private var badgeBoundsOriginX: CGFloat {
        let xOrigin: CGFloat = 0
        if isLeftToRightUserInterfaceLayoutDirection {
            return xOrigin
        } else {
            return xOrigin - badgeWidth / 2
        }
    }

    private var isLeftToRightUserInterfaceLayoutDirection: Bool {
        return effectiveUserInterfaceLayoutDirection == .leftToRight
    }

    private var isItemTitlePresent: Bool {
        return item?.title != nil
    }

    private func setupButton() {
        guard let item = item else {
            return
        }

        isEnabled = item.isEnabled
        tag = item.tag
        tintColor = item.tintColor
        titleLabel?.font = item.titleTextAttributes(for: .normal)?[.font] as? UIFont

        var portraitImage = item.image
        if portraitImage?.renderingMode == .automatic {
            portraitImage = portraitImage?.withRenderingMode(.alwaysTemplate)
        }
        var landscapeImage = item.landscapeImagePhone ?? portraitImage
        if landscapeImage?.renderingMode == .automatic {
            landscapeImage = landscapeImage?.withRenderingMode(.alwaysTemplate)
        }

        setImage(traitCollection.verticalSizeClass == .regular ? portraitImage : landscapeImage, for: .normal)
        setTitle(item.title, for: .normal)

        if let action = item.action {
            addTarget(item.target, action: action, for: .touchUpInside)
        }

        accessibilityIdentifier = item.accessibilityIdentifier
        accessibilityLabel = item.accessibilityLabel
        accessibilityHint = item.accessibilityHint
        showsLargeContentViewer = true

        if let customLargeContentSizeImage = item.largeContentSizeImage {
            largeContentImage = customLargeContentSizeImage
        }

        if item.title == nil {
            largeContentTitle = item.accessibilityLabel
        }

        if #available(iOS 13.4, *) {
            // Workaround check for beta iOS versions missing the Pointer Interactions API
            if arePointerInteractionAPIsAvailable() {
                isPointerInteractionEnabled = true
            }
        }

        if isItemTitlePresent, let titleLabel = titleLabel {
            titleLabel.addSubview(badgeLabel)
            titleLabel.isHidden = false
        } else if let imageView = imageView {
            imageView.addSubview(badgeLabel)
            imageView.isHidden = false
            imageView.clipsToBounds = false
        }

        updateBadgeLabel()
    }

    private func updateBadgeLabel() {
        badgeLabel.text = item?.badgeValue
        let isNilBadgeValue = item?.badgeValue == nil
        badgeLabel.isHidden = isNilBadgeValue

        if isNilBadgeValue {
            layer.mask = nil
        } else {
            badgeLabel.frame = badgeLabelFrame

            let badgeLabelLayer = CAShapeLayer()
            badgeLabelLayer.path = UIBezierPath(roundedRect: badgeLabel.bounds,
                                                byRoundingCorners: .allCorners,
                                                cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)).cgPath
            badgeLabel.layer.mask = badgeLabelLayer

            let computedBadgeWidth = badgeWidth
            let badgeBounds = CGRect(x: badgeFrameOriginX,
                                     y: badgeVerticalPosition,
                                     width: computedBadgeWidth,
                                     height: Constants.badgeHeight)
            let badgeCutoutPath = UIBezierPath(rect: CGRect(x: badgeBoundsOriginX,
                                                            y: 0,
                                                            width: frame.size.width + computedBadgeWidth / 2,
                                                            height: frame.size.height))
            // Adding the path for the cutout on the button's titleLabel or imageView where the badge label will be placed on top of.
            badgeCutoutPath.append(UIBezierPath(roundedRect: badgeCutoutRect(for: badgeBounds),
                                                byRoundingCorners: .allCorners,
                                                cornerRadii: CGSize(width: Constants.badgeCornerRadii,
                                                                    height: Constants.badgeCornerRadii)))
            // Adding the path that will display the badge label with rounded corners on top of the cutout.
            badgeCutoutPath.append(UIBezierPath(roundedRect: badgeBounds,
                                                byRoundingCorners: .allCorners,
                                                cornerRadii: CGSize(width: Constants.badgeCornerRadii,
                                                                    height: Constants.badgeCornerRadii)))
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd
            maskLayer.path = badgeCutoutPath.cgPath
            layer.mask = maskLayer
        }
    }

    private func badgeCutoutRect(for frame: CGRect) -> CGRect {
        return CGRect(x: frame.origin.x - Constants.badgeBorderWidth,
                      y: frame.origin.y - Constants.badgeBorderWidth,
                      width: frame.size.width + 2 * Constants.badgeBorderWidth,
                      height: frame.size.height + 2 * Constants.badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        updateBadgeLabel()
    }
}
