//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BarButtonItemButton: UIButton {
    let item: UIBarButtonItem
    let isLeftItem: Bool

    init(for item: UIBarButtonItem, isLeftItem: Bool) {
        self.item = item
        self.isLeftItem = isLeftItem
        super.init(frame: .zero)

        isAccessibilityElement = true
        updateAccessibilityLabel()

        accessibilityHint = item.accessibilityHint
        accessibilityIdentifier = item.accessibilityIdentifier

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: UIBarButtonItem.badgeValueDidChangeNotification,
                                               object: item)

        badgeValue = item.badgeValue
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLayout()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    private struct Constants {
        static let leftBarButtonItemLeadingMargin: CGFloat = 8
        static let rightBarButtonItemHorizontalPadding: CGFloat = 12
        static let badgeVerticalOffset: CGFloat = -5
        static let badgePortraitTitleVerticalOffset: CGFloat = -2
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
        static let badgeMaxWidth: CGFloat = 32
        static let badgeBorderWidth: CGFloat = 2
        static let badgeFontSize: CGFloat = 11
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCornerRadii: CGFloat = 10
    }

    private var isInPortraitMode: Bool {
        return (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular)
    }

    private var badgeValue: String? {
        didSet {
            if oldValue != badgeValue {
                updateBadgeView()
                updateAccessibilityLabel()
            }
        }
    }

    private let badgeView: UILabel = {
        let badgeView = BadgeLabel(frame: .zero)
        return badgeView
    }()

    private func updateLayout() {
        updateButton()

        titleLabel?.addSubview(badgeView)
        titleLabel?.isHidden = false

        updateBadgeView()
    }

    private func updateButton() {
        isEnabled = item.isEnabled

        if isLeftItem {
            let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
            contentEdgeInsets = UIEdgeInsets(top: 0,
                                             left: isRTL ? 0 : Constants.leftBarButtonItemLeadingMargin,
                                             bottom: 0,
                                             right: isRTL ? Constants.leftBarButtonItemLeadingMargin : 0)
        } else {
            contentEdgeInsets = UIEdgeInsets(top: 0,
                                             left: Constants.rightBarButtonItemHorizontalPadding,
                                             bottom: 0,
                                             right: Constants.rightBarButtonItemHorizontalPadding)
        }

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

        showsLargeContentViewer = true
        scalesLargeContentImage = true

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
    }

    private func updateBadgeView() {
        badgeView.text = badgeValue
        let isNilBadgeValue = badgeValue == nil
        badgeView.isHidden = isNilBadgeValue

        if isNilBadgeValue {
            layer.mask = nil
        } else {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd

            var path: UIBezierPath

            if badgeView.text?.count ?? 1 > 1 {
                let badgeWidth = min(max(badgeView.intrinsicContentSize.width + Constants.badgeHorizontalPadding, Constants.badgeMinWidth), Constants.badgeMaxWidth)
                badgeView.frame = badgeFrame(for: badgeWidth, isTitleLabelPresent: item.title != nil)

                let frameForBezierPath = badgeFrame(for: badgeWidth, isTitleLabelPresent: false)
                path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.size.width + badgeWidth / 2, height: bounds.size.height))
                path.append(UIBezierPath(roundedRect: borderRect(for: frameForBezierPath),
                                         byRoundingCorners: .allCorners,
                                         cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)))

                path.append(UIBezierPath(roundedRect: frameForBezierPath,
                                         byRoundingCorners: .allCorners,
                                         cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)))

                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: badgeView.bounds,
                                          byRoundingCorners: .allCorners,
                                          cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)).cgPath
                badgeView.layer.mask = layer
                badgeView.layer.cornerRadius = 0
            } else {
                let badgeWidth = max(badgeView.intrinsicContentSize.width, Constants.badgeMinWidth)
                badgeView.frame = badgeFrame(for: badgeWidth, isTitleLabelPresent: item.title != nil)

                let frameForBezierPath = badgeFrame(for: badgeWidth, isTitleLabelPresent: false)
                path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.size.width + badgeWidth / 2, height: bounds.size.height))
                path.append(UIBezierPath(ovalIn: borderRect(for: frameForBezierPath)))
                path.append(UIBezierPath(ovalIn: frameForBezierPath))

                badgeView.layer.mask = nil
                badgeView.layer.cornerRadius = badgeWidth / 2
            }

            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
    }

    private func badgeFrame(for badgeWidth: CGFloat, isTitleLabelPresent: Bool) -> CGRect {
        let badgeVerticalOffset = isInPortraitMode ? Constants.badgePortraitTitleVerticalOffset : Constants.badgeVerticalOffset
        let badgeVerticalPosition = (bounds.size.height - intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2 - badgeVerticalOffset
        if isTitleLabelPresent {
            return CGRect(x: badgeFrameOriginX(for: badgeWidth) - (titleLabel?.frame.origin.x ?? 0),
                          y: badgeVerticalPosition - (titleLabel?.frame.origin.y ?? 0),
                          width: badgeWidth,
                          height: Constants.badgeHeight)
        } else {
            return CGRect(x: badgeFrameOriginX(for: badgeWidth),
                          y: badgeVerticalPosition,
                          width: badgeWidth,
                          height: Constants.badgeHeight)
        }
    }

    private func badgeFrameOriginX(for width: CGFloat) -> CGFloat {
        var xOrigin: CGFloat

        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            xOrigin = bounds.size.width - Constants.rightBarButtonItemHorizontalPadding - width / 2
        } else {
            xOrigin = Constants.rightBarButtonItemHorizontalPadding - width / 2
        }

        return xOrigin
    }

    private func borderRect(for frame: CGRect) -> CGRect {
        return CGRect(x: frame.origin.x - Constants.badgeBorderWidth,
                      y: frame.origin.y - Constants.badgeBorderWidth,
                      width: frame.size.width + 2 * Constants.badgeBorderWidth,
                      height: frame.size.height + 2 * Constants.badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        badgeValue = item.badgeValue
    }

    private func updateAccessibilityLabel() {
        if let badgeValue = badgeValue, let title = item.title {
            accessibilityLabel = String(format: "Accessibility.BarButtonItemView.LabelFormat".localized, title, badgeValue)
        } else {
            accessibilityLabel = item.title
        }
    }
}
