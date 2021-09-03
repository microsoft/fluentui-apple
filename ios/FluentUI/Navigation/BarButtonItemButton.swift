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

        addSubview(badgeView)

        isAccessibilityElement = true
        updateAccessibilityLabel()

        accessibilityHint = item.accessibilityHint
        accessibilityIdentifier = item.accessibilityIdentifier

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: UIBarButtonItem.badgeValueDidChangeNotification,
                                               object: item)

        badgeValue = item.badgeValue
        updateLayout()
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
        static let rightBarButtonItemHorizontalPadding: CGFloat = 10
        static let badgeHeight: CGFloat = 18
        static let badgeMinWidth: CGFloat = 18
        static let badgeMaxWidth: CGFloat = 30
        static let badgeBorderWidth: CGFloat = 2
        static let badgeFontSize: CGFloat = 11
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCorderRadii: CGFloat = 10
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
        let badgeView = UILabel(frame: .zero)
        badgeView.layer.masksToBounds = true
        badgeView.backgroundColor = Colors.Palette.dangerPrimary.color
        badgeView.textColor = .white
        badgeView.textAlignment = .center
        badgeView.font = UIFont.systemFont(ofSize: Constants.badgeFontSize, weight: .regular)
        badgeView.isHidden = true

        return badgeView
    }()

    private func updateLayout() {
        updateButton()
        updateBadgeView()
        invalidateIntrinsicContentSize()
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
        badgeView.isHidden = badgeValue == nil

        if badgeValue != nil {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd

            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))

            if badgeView.text?.count ?? 1 > 1 {
                let badgeWidth = min(max(badgeView.intrinsicContentSize.width + Constants.badgeHorizontalPadding, Constants.badgeMinWidth), Constants.badgeMaxWidth)
                badgeView.frame = CGRect(x: badgeFrameOriginX(for: badgeWidth),
                                         y: bounds.origin.y + (bounds.size.height - intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2,
                                         width: badgeWidth,
                                         height: Constants.badgeHeight)

                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: badgeView.bounds,
                                          byRoundingCorners: .allCorners,
                                          cornerRadii: CGSize(width: Constants.badgeCorderRadii, height: Constants.badgeCorderRadii)).cgPath

                path.append(UIBezierPath(roundedRect: badgeBorderRect(badgeViewFrame: badgeView.frame),
                                         byRoundingCorners: .allCorners,
                                         cornerRadii: CGSize(width: Constants.badgeCorderRadii, height: Constants.badgeCorderRadii)))

                badgeView.layer.mask = layer
                badgeView.layer.cornerRadius = 0
            } else {
                let badgeWidth = max(badgeView.intrinsicContentSize.width, Constants.badgeMinWidth)
                badgeView.frame = CGRect(x: badgeFrameOriginX(for: badgeWidth),
                                         y: bounds.origin.y + (bounds.size.height - intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2,
                                         width: badgeWidth,
                                         height: Constants.badgeHeight)

                path.append(UIBezierPath(ovalIn: badgeBorderRect(badgeViewFrame: badgeView.frame)))

                badgeView.layer.mask = nil
                badgeView.layer.cornerRadius = badgeWidth / 2
            }

            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        } else {
            layer.mask = nil
        }
    }

    private func badgeFrameOriginX(for width: CGFloat) -> CGFloat {
        var xOrigin: CGFloat = 0

        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            xOrigin = bounds.origin.x + bounds.size.width - Constants.rightBarButtonItemHorizontalPadding - width / 2
        } else {
            xOrigin = bounds.origin.x + Constants.rightBarButtonItemHorizontalPadding - width / 2
        }

        return xOrigin
    }

    private func badgeBorderRect(badgeViewFrame: CGRect) -> CGRect {
        return CGRect(x: badgeViewFrame.origin.x - Constants.badgeBorderWidth - bounds.origin.x,
                      y: badgeViewFrame.origin.y - Constants.badgeBorderWidth - bounds.origin.y,
                      width: badgeViewFrame.size.width + 2 * Constants.badgeBorderWidth,
                      height: badgeViewFrame.size.height + 2 * Constants.badgeBorderWidth)
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
