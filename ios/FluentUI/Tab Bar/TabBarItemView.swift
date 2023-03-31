//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class TabBarItemView: UIControl, TokenizedControlInternal {
    let item: TabBarItem

    override var isEnabled: Bool {
        didSet {
            isUserInteractionEnabled = isEnabled
            updateColors()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateImage()
            updateColors()
            if isSelected {
                if item.isUnreadDotVisible {
                    item.isUnreadDotVisible = false
                    updateBadgeView()
                }
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
        }
    }

    /// Maximum width for the badge view where the badge value is displayed.
    var maxBadgeWidth: CGFloat = Constants.defaultBadgeMaxWidth {
        didSet {
            if oldValue != maxBadgeWidth {
                updateBadgeView()
            }
        }
    }

    /// If set to true, the item's title will always show below the image.
    /// Otherwise, depending on the traitCollection, the title will be displayed either below or to the side of the image.
    var alwaysShowTitleBelowImage: Bool = false {
        didSet {
            if oldValue != alwaysShowTitleBelowImage {
                updateLayout()
            }
        }
    }

    /// The number of lines for the item's title label.
    var numberOfTitleLines: Int = 1 {
        didSet {
            if oldValue != numberOfTitleLines {
                titleLabel.numberOfLines = numberOfTitleLines
            }
        }
    }

    /// The `preferredMaxLayoutWidth` of the underlying title label.
    var preferredLabelMaxLayoutWidth: CGFloat {
        get {
            titleLabel.preferredMaxLayoutWidth
        }
        set {
            titleLabel.preferredMaxLayoutWidth = newValue
        }
    }

    typealias TokenSetKeyType = EmptyTokenSet.Tokens
    var tokenSet: EmptyTokenSet = .init()

    init(item: TabBarItem, showsTitle: Bool, canResizeImage: Bool = true) {
        self.canResizeImage = canResizeImage
        self.item = item
        self.suggestImageSize = Constants.portraitImageSize
        super.init(frame: .zero)

        container.addArrangedSubview(imageView)

        titleLabel.isHidden = !showsTitle
        if showsTitle {
            titleLabel.text = item.title
            container.addArrangedSubview(titleLabel)
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        container.addSubview(badgeView)

        let pointerInteraction = UIPointerInteraction(delegate: self)
        addInteraction(pointerInteraction)

        isAccessibilityElement = true
        updateAccessibilityLabel()
        accessibilityIdentifier = item.accessibilityIdentifier

        self.largeContentImage = item.largeContentImage ?? item.image
        largeContentTitle = item.title
        showsLargeContentViewer = true
        scalesLargeContentImage = true

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)
        ])

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: TabBarItem.badgeValueDidChangeNotification,
                                               object: item)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(isUnreadValueDidChange),
                                               name: TabBarItem.isUnreadValueDidChangeNotification,
                                               object: item)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(accessibilityIdentifierDidChange),
                                               name: TabBarItem.accessibilityIdentifierDidChangeNotification,
                                               object: item)

        badgeValue = item.badgeValue
        updateLayout()
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateColors()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Need to layout container subviews now, otherwise imageView's frame will get updated later
        container.layoutSubviews()
        imageViewFrame = imageView.frame
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

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateColors()
    }

    private struct Constants {
        static let spacingVertical: CGFloat = 3
        static let spacingHorizontal: CGFloat = 8
        static let portraitImageSize: CGFloat = 28
        static let portraitImageWithLabelSize: CGFloat = 24
        static let landscapeImageSize: CGFloat = 24
        static let badgeVerticalOffset: CGFloat = -4
        static let badgePortraitTitleVerticalOffset: CGFloat = -2
        static let singleDigitBadgeHorizontalOffset: CGFloat = 14
        static let multiDigitBadgeHorizontalOffset: CGFloat = 12
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
        static let defaultBadgeMaxWidth: CGFloat = 42
        static let badgeBorderWidth: CGFloat = 2
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCorderRadii: CGFloat = 10
        static let unreadDotPortraitOffsetX: CGFloat = 6.0
        static let unreadDotOffsetX: CGFloat = 4.0
        static let unreadDotOffsetY: CGFloat = 20.0
        static let unreadDotSize: CGFloat = 8.0
    }

    private var badgeValue: String? {
        didSet {
            if oldValue != badgeValue {
                updateBadgeView()
                updateAccessibilityLabel()
            }
        }
    }

    @objc private func isUnreadValueDidChange() {
        isUnreadDotVisible = item.isUnreadDotVisible
        updateBadgeView()
        updateAccessibilityLabel()
        setNeedsLayout()
    }

    @objc private func accessibilityIdentifierDidChange() {
        accessibilityIdentifier = item.accessibilityIdentifier
    }

    private var isUnreadDotVisible: Bool = false

    private let container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.alignment = .center
        container.distribution = .fill

        return container
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit

        if canResizeImage {
            let sizeConstraints = (
                width: imageView.widthAnchor.constraint(equalToConstant: suggestImageSize),
                height: imageView.heightAnchor.constraint(equalToConstant: suggestImageSize)
            )
            sizeConstraints.width.isActive = true
            sizeConstraints.height.isActive = true
            imageViewSizeConstraints = sizeConstraints
        }
        return imageView
    }()

    private var imageViewSizeConstraints: (width: NSLayoutConstraint, height: NSLayoutConstraint)?

    private lazy var titleLabel: Label = {
        let titleLabel = Label()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center

        return titleLabel
    }()

    let badgeView: UILabel = BadgeLabel(frame: .zero)

    private var suggestImageSize: CGFloat {
        didSet {
            if canResizeImage,
               let sizeConstraints = imageViewSizeConstraints {
                sizeConstraints.width.constant = suggestImageSize
                sizeConstraints.height.constant = suggestImageSize
            }
        }
    }
    private let canResizeImage: Bool

    private var imageViewFrame: CGRect = .zero {
        didSet {
            if !oldValue.equalTo(imageViewFrame) {
                updateBadgeView()
            }
        }
    }

    private var isInPortraitMode: Bool {
        return alwaysShowTitleBelowImage || (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular)
    }

    private func updateColors() {
        let selectedColor = tokenSet.fluentTheme.color(.brandForeground1)
        let unselectedImageColor = tokenSet.fluentTheme.color(.foreground3)
        let unselectedTextColor = tokenSet.fluentTheme.color(.foreground2)
        let disabledColor = tokenSet.fluentTheme.color(.foregroundDisabled1)

        titleLabel.textColor = isEnabled ? (isSelected ? selectedColor : unselectedTextColor) : disabledColor
        imageView.tintColor = isEnabled ? (isSelected ? selectedColor : unselectedImageColor) : disabledColor
    }

    private func updateImage() {
        // Normally we'd set imageView.image and imageView.highlightedImage separately. However, there's a known issue with
        // UIImageView in iOS 16 where highlighted images lose their tint color in certain scenarios. While we wait for a fix,
        // this is a straightforward workaround that gets us the same effect without triggering the bug.
        imageView.image = isSelected ?
                            item.selectedImage(isInPortraitMode: isInPortraitMode, labelIsHidden: titleLabel.isHidden) :
                            item.unselectedImage(isInPortraitMode: isInPortraitMode, labelIsHidden: titleLabel.isHidden)
    }

    private func updateLayout() {
        if isInPortraitMode {
            container.axis = .vertical
            container.spacing = Constants.spacingVertical
            titleLabel.style = .caption2
            titleLabel.maxFontSize = 12

            if canResizeImage {
                suggestImageSize = titleLabel.isHidden ? Constants.portraitImageSize : Constants.portraitImageWithLabelSize
            }
        } else {
            container.axis = .horizontal
            container.spacing = Constants.spacingHorizontal
            titleLabel.style = .caption2
            titleLabel.maxFontSize = 12

            if canResizeImage {
                 suggestImageSize = Constants.landscapeImageSize
            }
        }

        updateImage()
        updateBadgeView()
        invalidateIntrinsicContentSize()
    }

    private func updateBadgeView() {
        isUnreadDotVisible = item.isUnreadDotVisible && badgeValue == nil

        // If nothing to display, remove mask and return
        if badgeValue == nil && !isUnreadDotVisible {
            badgeView.isHidden = true
            imageView.layer.mask = nil
            return
        }

        // Otherwise, show either the badgeValue or an unreadDot
        badgeView.isHidden = false
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd

        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))

        if isUnreadDotVisible {
            // Badge with empty string and round corners is a dot
            badgeView.text = ""
            let badgeVerticalOffset = !titleLabel.isHidden && isInPortraitMode ? Constants.unreadDotPortraitOffsetX : Constants.unreadDotOffsetX

            createCircularBadgeFrame(labelView: badgeView,
                                     path: path,
                                     horizontalOffset: Constants.unreadDotOffsetY,
                                     verticalOffset: badgeVerticalOffset,
                                     frameWidth: Constants.unreadDotSize,
                                     frameHeight: Constants.unreadDotSize)
        } else {
            badgeView.text = badgeValue
            let badgeVerticalOffset = !titleLabel.isHidden && isInPortraitMode ? Constants.badgePortraitTitleVerticalOffset : Constants.badgeVerticalOffset

            if badgeView.text?.count ?? 1 > 1 {
                createRoundedRectBadgeFrame(labelView: badgeView, path: path, verticalOffset: badgeVerticalOffset)
            } else {
                createCircularBadgeFrame(labelView: badgeView,
                                         path: path,
                                         horizontalOffset: Constants.singleDigitBadgeHorizontalOffset,
                                         verticalOffset: badgeVerticalOffset,
                                         frameWidth: Constants.badgeMinWidth,
                                         frameHeight: Constants.badgeHeight)
            }
        }

        maskLayer.path = path.cgPath
        imageView.layer.mask = maskLayer
    }

    private func createRoundedRectBadgeFrame(labelView: UILabel, path: UIBezierPath, verticalOffset: CGFloat) {
        let width = min(max(labelView.intrinsicContentSize.width + Constants.badgeHorizontalPadding, Constants.badgeMinWidth), maxBadgeWidth)

        labelView.frame = CGRect(x: frameOriginX(offset: Constants.multiDigitBadgeHorizontalOffset, frameWidth: width),
                                 y: imageView.frame.origin.y + verticalOffset,
                                 width: width,
                                 height: Constants.badgeHeight)

        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: labelView.bounds,
                                  byRoundingCorners: .allCorners,
                                  cornerRadii: CGSize(width: Constants.badgeCorderRadii, height: Constants.badgeCorderRadii)).cgPath

        path.append(UIBezierPath(roundedRect: badgeBorderRect(badgeViewFrame: labelView.frame),
                                 byRoundingCorners: .allCorners,
                                 cornerRadii: CGSize(width: Constants.badgeCorderRadii, height: Constants.badgeCorderRadii)))

        labelView.layer.mask = layer
        labelView.layer.cornerRadius = 0
    }

    private func createCircularBadgeFrame(labelView: UILabel, path: UIBezierPath, horizontalOffset: CGFloat, verticalOffset: CGFloat, frameWidth: CGFloat, frameHeight: CGFloat) {
        let width = max(labelView.intrinsicContentSize.width, frameWidth)

        labelView.frame = CGRect(x: frameOriginX(offset: horizontalOffset, frameWidth: width),
                                 y: imageView.frame.origin.y + verticalOffset,
                                 width: width,
                                 height: frameHeight)

        path.append(UIBezierPath(ovalIn: badgeBorderRect(badgeViewFrame: labelView.frame)))

        labelView.layer.mask = nil
        labelView.layer.cornerRadius = width / 2
    }

    private func frameOriginX(offset: CGFloat, frameWidth: CGFloat) -> CGFloat {
        var xOrigin: CGFloat = 0
        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            xOrigin = imageView.frame.origin.x + offset
        } else {
            xOrigin = imageView.frame.origin.x + imageView.frame.size.width - offset - frameWidth
        }

        return xOrigin
    }

    private func badgeBorderRect(badgeViewFrame: CGRect) -> CGRect {
        return CGRect(x: badgeViewFrame.origin.x - Constants.badgeBorderWidth - imageView.frame.origin.x,
                      y: badgeViewFrame.origin.y - Constants.badgeBorderWidth - imageView.frame.origin.y,
                      width: badgeViewFrame.size.width + 2 * Constants.badgeBorderWidth,
                      height: badgeViewFrame.size.height + 2 * Constants.badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        badgeValue = item.badgeValue
    }

    // The priority logic for accessibility label is:
    //      If the badge is visible:
    //          1. Use the badge format string supplied by the caller if available
    //          2. If not, use the default localized badge label format
    //      If the unread dot is visible, use the localized "unread" label
    //      If neither, then use the item's title, as supplied by the caller
    private func updateAccessibilityLabel() {
        if let badgeValue = badgeValue {
            if let accessibilityLabelBadgeFormatString = item.accessibilityLabelBadgeFormatString {
                accessibilityLabel = String(format: accessibilityLabelBadgeFormatString, item.title, badgeValue)
            } else {
                accessibilityLabel = String(format: "Accessibility.TabBarItemView.LabelFormat".localized, item.title, badgeValue)
            }
        } else {
            if isUnreadDotVisible {
                accessibilityLabel = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, item.title)
            } else {
                accessibilityLabel = item.title
            }
        }
    }
}

// MARK: - TabBarItemView UIPointerInteractionDelegate

extension TabBarItemView: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        let pointerEffect = UIPointerEffect.highlight(.init(view: self))

        var pointerFrame = imageView.frame

        if titleLabel.superview != nil {
            let titleFrame = titleLabel.frame
            let originX = min(pointerFrame.minX, titleFrame.minX)
            let originY = min(pointerFrame.minY, titleFrame.minY)

            pointerFrame = CGRect(x: originX,
                                  y: originY,
                                  width: max(pointerFrame.maxX, titleFrame.maxX) - originX,
                                  height: max(pointerFrame.maxY, titleFrame.maxY) - originY)
        }

        pointerFrame = pointerFrame.insetBy(dx: PointerConstants.outset, dy: PointerConstants.outset)
        pointerFrame = convert(pointerFrame, from: container)
        if let superview = superview {
            pointerFrame = superview.convert(pointerFrame, from: self)
        }

        let pointerShape = UIPointerShape.roundedRect(pointerFrame)
        return UIPointerStyle(effect: pointerEffect, shape: pointerShape)
    }

    private struct PointerConstants {
        static let outset: CGFloat = -5
    }
}
