//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BarButtonItemView: UIView {
    let item: UIBarButtonItem
    let isLeftItem: Bool

    init(item: UIBarButtonItem, isLeftItem: Bool) {
        self.item = item
        self.isLeftItem = isLeftItem
        super.init(frame: .zero)

        container.addArrangedSubview(button)
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        container.addSubview(badgeView)

        isAccessibilityElement = true
        updateAccessibilityLabel()

        showsLargeContentViewer = true
        scalesLargeContentImage = true

        accessibilityHint = item.accessibilityHint
        accessibilityIdentifier = item.accessibilityIdentifier

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)
        ])

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

        // Need to layout container subviews now, otherwise imageView's frame will get updated later
        container.layoutSubviews()
        buttonFrame = button.frame
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            updateLayout()
        }
    }

    private struct Constants {
        static let leftBarButtonItemLeadingMargin: CGFloat = 8
        static let rightBarButtonItemHorizontalPadding: CGFloat = 10
        static let badgePortraitVerticalOffset: CGFloat = -6
        static let badgeLandscapeVerticalOffset: CGFloat = -4
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

    private var buttonFrame: CGRect = .zero {
        didSet {
            if !oldValue.equalTo(buttonFrame) {
                updateBadgeView()
            }
        }
    }

    private var badgeValue: String? {
        didSet {
            if oldValue != badgeValue {
                updateBadgeView()
                updateAccessibilityLabel()
            }
        }
    }

    private let container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.alignment = .center
        container.distribution = .fill

        return container
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()

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
        button.isEnabled = item.isEnabled

        if isLeftItem {
            let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: isRTL ? 0 : Constants.leftBarButtonItemLeadingMargin, bottom: 0, right: isRTL ? Constants.leftBarButtonItemLeadingMargin : 0)
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Constants.rightBarButtonItemHorizontalPadding, bottom: 0, right: Constants.rightBarButtonItemHorizontalPadding)
        }

        button.tag = item.tag
        button.tintColor = item.tintColor
        button.titleLabel?.font = item.titleTextAttributes(for: .normal)?[.font] as? UIFont

        var portraitImage = item.image
        if portraitImage?.renderingMode == .automatic {
            portraitImage = portraitImage?.withRenderingMode(.alwaysTemplate)
        }
        var landscapeImage = item.landscapeImagePhone ?? portraitImage
        if landscapeImage?.renderingMode == .automatic {
            landscapeImage = landscapeImage?.withRenderingMode(.alwaysTemplate)
        }

        button.setImage(traitCollection.verticalSizeClass == .regular ? portraitImage : landscapeImage, for: .normal)
        button.setTitle(item.title, for: .normal)

        if let action = item.action {
            button.addTarget(item.target, action: action, for: .touchUpInside)
        }

        button.showsLargeContentViewer = true

        if let customLargeContentSizeImage = item.largeContentSizeImage {
            button.largeContentImage = customLargeContentSizeImage
        }

        if item.title == nil {
            button.largeContentTitle = item.accessibilityLabel
        }

        if #available(iOS 13.4, *) {
            // Workaround check for beta iOS versions missing the Pointer Interactions API
            if arePointerInteractionAPIsAvailable() {
                button.isPointerInteractionEnabled = true
            }
        }
    }

    private func updateBadgeView() {
        badgeView.text = badgeValue
        badgeView.isHidden = badgeValue == nil

        if badgeValue != nil {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd

            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: button.frame.size.width, height: button.frame.size.height))
            let badgeVerticalOffset = isInPortraitMode ? Constants.badgePortraitVerticalOffset : Constants.badgeLandscapeVerticalOffset

            if badgeView.text?.count ?? 1 > 1 {
                let badgeWidth = min(max(badgeView.intrinsicContentSize.width + Constants.badgeHorizontalPadding, Constants.badgeMinWidth), Constants.badgeMaxWidth)

                badgeView.frame = CGRect(x: badgeFrameOriginX(frameWidth: badgeWidth),
                                         y: button.frame.origin.y + badgeVerticalOffset,
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

                badgeView.frame = CGRect(x: badgeFrameOriginX(frameWidth: badgeWidth),
                                         y: button.frame.origin.y + badgeVerticalOffset,
                                         width: badgeWidth,
                                         height: Constants.badgeHeight)

                path.append(UIBezierPath(ovalIn: badgeBorderRect(badgeViewFrame: badgeView.frame)))

                badgeView.layer.mask = nil
                badgeView.layer.cornerRadius = badgeWidth / 2
            }

            maskLayer.path = path.cgPath
            button.layer.mask = maskLayer
        } else {
            button.layer.mask = nil
        }
    }

    private func badgeFrameOriginX(frameWidth: CGFloat) -> CGFloat {
        var xOrigin: CGFloat = 0

        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            xOrigin = button.frame.origin.x + button.frame.size.width - Constants.rightBarButtonItemHorizontalPadding - frameWidth / 2
        } else {
            xOrigin = button.frame.origin.x + Constants.rightBarButtonItemHorizontalPadding - frameWidth / 2
        }

        return xOrigin
    }

    private func badgeBorderRect(badgeViewFrame: CGRect) -> CGRect {
        return CGRect(x: badgeViewFrame.origin.x - Constants.badgeBorderWidth - button.frame.origin.x,
                      y: badgeViewFrame.origin.y - Constants.badgeBorderWidth - button.frame.origin.y,
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
