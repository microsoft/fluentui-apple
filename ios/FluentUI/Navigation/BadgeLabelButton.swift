//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BadgeLabelButton: UIButton {

    var item: UIBarButtonItem? {
        didSet {
            setupButton()
            prepareButtonForBadge()
        }
    }

    var badgeLabelStyle: BadgeLabelStyle = .system {
        didSet {
            badgeLabel.style = badgeLabelStyle
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configuration = UIButton.Configuration.plain()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(redDotVisibilitDidChanged),
                                               name: UIBarButtonItem.redDotValueDidChangeNotification,
                                               object: item)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: UIBarButtonItem.badgeValueDidChangeNotification,
                                               object: item)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contentSizeCategoryDidChange(notification:)),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        prepareButtonForBadge()
    }

    private struct Constants {
        static let badgeVerticalOffset: CGFloat = -5
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
        static let badgeMaxWidth: CGFloat = 27
        static let badgeBorderWidth: CGFloat = 2
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCornerRadii: CGFloat = 10

        static let redDotWidth: CGFloat = 10
        static let redDotHeight: CGFloat = 10
        static let redDotCornerRadius: CGFloat = 5

        // These are consistent with UIKit's default navigation bar buttons
        static let maximumContentSizeCategory: UIContentSizeCategory = .extraExtraLarge
        static let minimumContentSizeCategory: UIContentSizeCategory = .large
    }

    private let badgeLabel = BadgeLabel()

    private lazy var redDotView: UIView =  {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private var badgeWidth: CGFloat {
        return min(max(badgeLabel.intrinsicContentSize.width + Constants.badgeHorizontalPadding,
                       Constants.badgeMinWidth),
                   Constants.badgeMaxWidth)
    }

    private var badgeVerticalPosition: CGFloat {
        return (frame.size.height - intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2 - Constants.badgeVerticalOffset
    }

    private var redDotVerticalPosition: CGFloat {
        return (frame.size.height - intrinsicContentSize.height) / 2 - Constants.redDotHeight / 2 - Constants.badgeVerticalOffset
    }

    private func badgeFrameOriginX(_ viewWidth: CGFloat) -> CGFloat {
        let xOrigin: CGFloat = {
            return isLeftToRightUserInterfaceLayoutDirection ?
            frame.size.width - (configuration?.contentInsets.leading ?? 0) :
            configuration?.contentInsets.trailing ?? 0
        }()

        return (xOrigin - viewWidth / 2)
    }

    private var badgeLabelFrame: CGRect {
        let targetView = isItemTitlePresent ? titleLabel : imageView

        return CGRect(x: badgeFrameOriginX(badgeWidth) - (targetView?.frame.origin.x ?? 0),
                      y: badgeVerticalPosition - (targetView?.frame.origin.y ?? 0),
                      width: badgeWidth,
                      height: Constants.badgeHeight)
    }

    private var redDotFrame: CGRect {
        let targetView = isItemTitlePresent ? titleLabel : imageView

        return CGRect(x: badgeFrameOriginX(Constants.redDotWidth) - (targetView?.frame.origin.x ?? 0),
                      y: redDotVerticalPosition - (targetView?.frame.origin.y ?? 0),
                      width: Constants.redDotWidth,
                      height: Constants.redDotHeight)
    }

    private func badgeBoundsOriginX(_ viewWidth: CGFloat) -> CGFloat {
        let xOrigin: CGFloat = 0
        if isLeftToRightUserInterfaceLayoutDirection {
            return xOrigin
        } else {
            return xOrigin - viewWidth / 2
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

        configuration?.image = traitCollection.verticalSizeClass == .regular ? portraitImage : landscapeImage
        configuration?.title = item.title

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

        isPointerInteractionEnabled = true
    }

    private func prepareButtonForBadge() {
        if isItemTitlePresent, let titleLabel = titleLabel {
            titleLabel.addSubview(badgeLabel)
            titleLabel.addSubview(redDotView)
            titleLabel.isHidden = false
        } else if let imageView = imageView {
            imageView.addSubview(badgeLabel)
            imageView.addSubview(redDotView)
            imageView.isHidden = false
            imageView.clipsToBounds = false
        }

        updateBadge()
    }

    private func updateBadge() {
        badgeLabel.text = item?.badgeValue
        let isNilBadgeValue = item?.badgeValue == nil
        badgeLabel.isHidden = isNilBadgeValue
        redDotView.isHidden = (item?.shouldShowRedDot != true || !isNilBadgeValue)

        if isNilBadgeValue {
            if item?.shouldShowRedDot == true {
                showRedDot()
            } else {
                layer.mask = nil
            }
        } else {
            badgeLabel.frame = badgeLabelFrame
            addBadgeOrRedDot(false)
        }
    }

    private func showRedDot() {
        redDotView.frame = redDotFrame
        addBadgeOrRedDot(true)
    }

    private func addBadgeOrRedDot(_ isRedDot: Bool) {
        let viewBounds = isRedDot ? redDotView.bounds : badgeLabel.bounds
        let viewCornerRadius = isRedDot ? Constants.redDotCornerRadius : Constants.badgeCornerRadii

        let badgeLabelLayer = CAShapeLayer()
        badgeLabelLayer.path = UIBezierPath(roundedRect: viewBounds,
                                            byRoundingCorners: .allCorners,
                                            cornerRadii: CGSize(
                                                width: viewCornerRadius,
                                                height: viewCornerRadius)).cgPath

        if isRedDot {
            redDotView.layer.mask = badgeLabelLayer
        } else {
            badgeLabel.layer.mask = badgeLabelLayer
        }

        let computedBadgeWidth = isRedDot ? Constants.redDotWidth : badgeWidth
        let badgeBounds = CGRect(x: badgeFrameOriginX(computedBadgeWidth),
                                 y: isRedDot ? redDotVerticalPosition : badgeVerticalPosition,
                                 width: computedBadgeWidth,
                                 height: isRedDot ? Constants.redDotHeight : Constants.badgeHeight)


        let badgeCutoutPath = UIBezierPath(rect: CGRect(x: badgeBoundsOriginX(computedBadgeWidth),
                                                        y: badgeBounds.origin.y,
                                                        width: frame.size.width + computedBadgeWidth / 2,
                                                        height: frame.size.height))
        // Adding the path for the cutout on the button's titleLabel or imageView where the badge label OR Red Dot will be placed on top of.
        badgeCutoutPath.append(UIBezierPath(roundedRect: badgeCutoutRect(for: badgeBounds),
                                            byRoundingCorners: .allCorners,
                                            cornerRadii: CGSize(width: viewCornerRadius,
                                                                height: viewCornerRadius)))
        // Adding the path that will display the badge label with rounded corners on top of the cutout.
        badgeCutoutPath.append(UIBezierPath(roundedRect: badgeBounds,
                                            byRoundingCorners: .allCorners,
                                            cornerRadii: CGSize(width: viewCornerRadius,
                                                                height: viewCornerRadius)))
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.path = badgeCutoutPath.cgPath
        layer.mask = maskLayer
    }

    private func badgeCutoutRect(for frame: CGRect) -> CGRect {
        return CGRect(x: frame.origin.x - Constants.badgeBorderWidth,
                      y: frame.origin.y - Constants.badgeBorderWidth,
                      width: frame.size.width + 2 * Constants.badgeBorderWidth,
                      height: frame.size.height + 2 * Constants.badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        updateBadge()
        updateAccessibilityLabel()
    }

    @objc private func redDotVisibilitDidChanged() {
        updateBadge()
    }

    @objc private func contentSizeCategoryDidChange(notification: Notification) {
        guard let titleLabel = titleLabel else {
            return
        }

        let requestedContentSizeCategory = (notification.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory) ?? .unspecified

        let cappedContentSizeCategory: UIContentSizeCategory
        if requestedContentSizeCategory > Constants.maximumContentSizeCategory {
            cappedContentSizeCategory = Constants.maximumContentSizeCategory
        } else if requestedContentSizeCategory < Constants.minimumContentSizeCategory {
            cappedContentSizeCategory = Constants.minimumContentSizeCategory
        } else {
            cappedContentSizeCategory = requestedContentSizeCategory
        }

        // For some reason, titleLabel doesn't resize to fit the new font size, so we do it ourselves.
        titleLabel.font = fluentTheme.typography(.body1, contentSizeCategory: cappedContentSizeCategory)
        titleLabel.sizeToFit()
        sizeToFit()
        if superview != nil {
            centerInSuperview(horizontally: false, vertically: true)
        }
    }

    private func updateAccessibilityLabel() {
        guard let item = item else {
            return
        }
        if let badgeAccessibilityLabel = item.badgeAccessibilityLabel {
            if let itemAccessibilityLabel = item.accessibilityLabel {
                accessibilityLabel = String.localizedStringWithFormat("Accessibility.BadgeLabelButton.LabelFormat".localized,
                                                                      itemAccessibilityLabel,
                                                                      badgeAccessibilityLabel)
            } else {
                accessibilityLabel = badgeAccessibilityLabel
            }
        } else {
            accessibilityLabel = item.accessibilityLabel
        }
    }
}
