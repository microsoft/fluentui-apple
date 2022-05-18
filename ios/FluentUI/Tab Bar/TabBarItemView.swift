//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class TabBarItemView: UIControl {
    let item: TabBarItem

    override var isEnabled: Bool {
        didSet {
            titleLabel.isEnabled = isEnabled
            imageView.tintAdjustmentMode = isEnabled ? .automatic : .dimmed
            isUserInteractionEnabled = isEnabled
        }
    }

    override var isSelected: Bool {
        didSet {
            titleLabel.isHighlighted = isSelected
            imageView.isHighlighted = isSelected
            updateColors()
            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
        }
    }

    open var selectedColor: DynamicColor

    open var unselectedColor: DynamicColor

    open var spacingVertical: CGFloat

    open var spacingHorizontal: CGFloat

    open var portraitImageSize: CGFloat

    open var portraitImageWithLabelSize: CGFloat

    open var landscapeImageSize: CGFloat

    open var badgeVerticalOffset: CGFloat

    open var badgePortraitTitleVerticalOffset: CGFloat

    open var singleDigitBadgeHorizontalOffset: CGFloat

    open var multiDigitBadgeHorizontalOffset: CGFloat

    open var badgeHeight: CGFloat

    open var badgeMinWidth: CGFloat

    open var defaultBadgeMaxWidth: CGFloat

    open var badgeBorderWidth: CGFloat

    open var badgeHorizontalPadding: CGFloat

    open var badgeCornerRadii: CGFloat

    open var titleLabelPortrait: FontInfo

    open var titleLabelLandscape: FontInfo

    // TODO: move to correct location
    open func refreshView() {
        updateColors()
        updateBadgeView()
        updateLayout()
    }

    /// Maximum width for the badge view where the badge value is displayed.
    lazy var maxBadgeWidth: CGFloat = defaultBadgeMaxWidth {
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

    init(item: TabBarItem,
         showsTitle: Bool,
         canResizeImage: Bool = true,
         selectedColor: DynamicColor,
         unselectedColor: DynamicColor,
         spacingVertical: CGFloat,
         spacingHorizontal: CGFloat,
         portraitImageSize: CGFloat,
         portraitImageWithLabelSize: CGFloat,
         landscapeImageSize: CGFloat,
         badgeVerticalOffset: CGFloat,
         badgePortraitTitleVerticalOffset: CGFloat,
         singleDigitBadgeHorizontalOffset: CGFloat,
         multiDigitBadgeHorizontalOffset: CGFloat,
         badgeHeight: CGFloat,
         badgeMinWidth: CGFloat,
         defaultBadgeMaxWidth: CGFloat,
         badgeBorderWidth: CGFloat,
         badgeHorizontalPadding: CGFloat,
         badgeCornerRadii: CGFloat,
         titleLabelPortrait: FontInfo,
         titleLabelLandscape: FontInfo
    ) {
        self.canResizeImage = canResizeImage
        self.item = item
        self.suggestImageSize = portraitImageSize

        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.spacingVertical = spacingVertical
        self.spacingHorizontal = spacingHorizontal
        self.portraitImageSize = portraitImageSize
        self.portraitImageWithLabelSize = portraitImageWithLabelSize
        self.landscapeImageSize = landscapeImageSize
        self.badgeVerticalOffset = badgeVerticalOffset
        self.badgePortraitTitleVerticalOffset = badgePortraitTitleVerticalOffset
        self.singleDigitBadgeHorizontalOffset = singleDigitBadgeHorizontalOffset
        self.multiDigitBadgeHorizontalOffset = multiDigitBadgeHorizontalOffset
        self.badgeHeight = badgeHeight
        self.badgeMinWidth = badgeMinWidth
        self.defaultBadgeMaxWidth = defaultBadgeMaxWidth
        self.badgeBorderWidth = badgeBorderWidth
        self.badgeHorizontalPadding = badgeHorizontalPadding
        self.badgeCornerRadii = badgeCornerRadii
        self.titleLabelPortrait = titleLabelPortrait
        self.titleLabelLandscape = titleLabelLandscape

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

        self.largeContentImage = item.largeContentImage ?? item.image
        largeContentTitle = item.title
        showsLargeContentViewer = true
        scalesLargeContentImage = true

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)
        ])

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

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateColors()
        updateBadgeView()
        updateLayout()
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

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(dynamicColor: unselectedColor)

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
        titleLabel.textColor = UIColor(dynamicColor: unselectedColor)

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
        titleLabel.highlightedTextColor = UIColor(dynamicColor: selectedColor)
        imageView.tintColor = isSelected ? UIColor(dynamicColor: selectedColor) : UIColor(dynamicColor: unselectedColor)
    }

    private func updateLayout() {
        imageView.image = item.unselectedImage(isInPortraitMode: isInPortraitMode, labelIsHidden: titleLabel.isHidden)
        imageView.highlightedImage = item.selectedImage(isInPortraitMode: isInPortraitMode, labelIsHidden: titleLabel.isHidden)

        if isInPortraitMode {
            container.spacing = spacingVertical
            titleLabel.font = UIFont.fluent(titleLabelPortrait, shouldScale: false)

            if canResizeImage {
                suggestImageSize = titleLabel.isHidden ? portraitImageSize : portraitImageWithLabelSize
            }
        } else {
            container.axis = .horizontal
            container.spacing = spacingHorizontal
            titleLabel.font = UIFont.fluent(titleLabelLandscape, shouldScale: false)

            if canResizeImage {
                 suggestImageSize = landscapeImageSize
            }
        }

        updateBadgeView()
        invalidateIntrinsicContentSize()
    }

    private func updateBadgeView() {
        badgeView.text = badgeValue
        badgeView.isHidden = badgeValue == nil

        if badgeValue != nil {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd

            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
            let badgeVerticalOffset = !titleLabel.isHidden && isInPortraitMode ? badgePortraitTitleVerticalOffset : badgeVerticalOffset

            if badgeView.text?.count ?? 1 > 1 {
                let badgeWidth = min(max(badgeView.intrinsicContentSize.width + badgeHorizontalPadding, badgeMinWidth), maxBadgeWidth)

                badgeView.frame = CGRect(x: badgeFrameOriginX(offset: multiDigitBadgeHorizontalOffset, frameWidth: badgeWidth),
                                         y: imageView.frame.origin.y + badgeVerticalOffset,
                                         width: badgeWidth,
                                         height: badgeHeight)

                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: badgeView.bounds,
                                          byRoundingCorners: .allCorners,
                                          cornerRadii: CGSize(width: badgeCornerRadii, height: badgeCornerRadii)).cgPath

                path.append(UIBezierPath(roundedRect: badgeBorderRect(badgeViewFrame: badgeView.frame),
                                         byRoundingCorners: .allCorners,
                                         cornerRadii: CGSize(width: badgeCornerRadii, height: badgeCornerRadii)))

                badgeView.layer.mask = layer
                badgeView.layer.cornerRadius = 0
            } else {
                let badgeWidth = max(badgeView.intrinsicContentSize.width, badgeMinWidth)

                badgeView.frame = CGRect(x: badgeFrameOriginX(offset: singleDigitBadgeHorizontalOffset, frameWidth: badgeWidth),
                                         y: imageView.frame.origin.y + badgeVerticalOffset,
                                         width: badgeWidth,
                                         height: badgeHeight)

                path.append(UIBezierPath(ovalIn: badgeBorderRect(badgeViewFrame: badgeView.frame)))

                badgeView.layer.mask = nil
                badgeView.layer.cornerRadius = badgeWidth / 2
            }

            maskLayer.path = path.cgPath
            imageView.layer.mask = maskLayer
        } else {
            imageView.layer.mask = nil
        }
    }

    private func badgeFrameOriginX(offset: CGFloat, frameWidth: CGFloat) -> CGFloat {
        var xOrigin: CGFloat = 0
        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            xOrigin = imageView.frame.origin.x + offset
        } else {
            xOrigin = imageView.frame.origin.x + imageView.frame.size.width - offset - frameWidth
        }

        return xOrigin
    }

    private func badgeBorderRect(badgeViewFrame: CGRect) -> CGRect {
        return CGRect(x: badgeViewFrame.origin.x - badgeBorderWidth - imageView.frame.origin.x,
                      y: badgeViewFrame.origin.y - badgeBorderWidth - imageView.frame.origin.y,
                      width: badgeViewFrame.size.width + 2 * badgeBorderWidth,
                      height: badgeViewFrame.size.height + 2 * badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        badgeValue = item.badgeValue
    }

    private func updateAccessibilityLabel() {
        if let badgeValue = badgeValue {
            if let accessibilityLabelBadgeFormatString = item.accessibilityLabelBadgeFormatString {
                accessibilityLabel = String(format: accessibilityLabelBadgeFormatString, item.title, badgeValue)
            } else {
                accessibilityLabel = String(format: "Accessibility.TabBarItemView.LabelFormat".localized, item.title, badgeValue)
            }
        } else {
            accessibilityLabel = item.title
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
