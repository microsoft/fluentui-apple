//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ButtonStyle

@available(*, deprecated, renamed: "ButtonStyle")
public typealias MSButtonStyle = ButtonStyle

@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case secondaryOutline
    case tertiaryOutline
    case borderless

    public var contentEdgeInsets: UIEdgeInsets {
        switch self {
        case .primaryFilled, .primaryOutline:
            return UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        case .secondaryOutline:
            return UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        case .borderless:
            return UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
        case .tertiaryOutline:
            return UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .primaryFilled, .primaryOutline, .secondaryOutline, .borderless:
            return 8
        case .tertiaryOutline:
            return 5
        }
    }

    var hasBorders: Bool {
        switch self {
        case .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return true
        case .primaryFilled, .borderless:
            return false
        }
    }

    var minTitleLabelHeight: CGFloat {
        switch self {
        case .primaryFilled, .primaryOutline, .borderless:
            return 20
        case .secondaryOutline, .tertiaryOutline:
            return 18
        }
    }

    var titleFont: UIFont {
        switch self {
        case .primaryFilled, .primaryOutline, .borderless:
            return Fonts.button1
        case .secondaryOutline, .tertiaryOutline:
            return Fonts.button2
        }
    }

    var titleImagePadding: CGFloat {
        switch self {
        case .primaryFilled, .primaryOutline:
            return 10
        case .secondaryOutline:
            return 8
        case .tertiaryOutline, .borderless:
            return 0
        }
    }
}

// MARK: - Button Colors

public extension Colors {
    struct Button {
        public static var background: UIColor = .clear
        public static var backgroundFilledDisabled: UIColor = surfaceQuaternary
        public static var borderDisabled: UIColor = surfaceQuaternary
        public static var titleDisabled: UIColor = textDisabled
        public static var titleWithFilledBackground: UIColor = textOnAccent
    }
}

// MARK: - Button

/// By default, `titleLabel`'s `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@available(*, deprecated, renamed: "Button")
public typealias MSButton = Button

@IBDesignable
@objc(MSFButton)
open class Button: UIButton {
    private struct Constants {
        static let borderWidth: CGFloat = 1
    }

    @objc open var style: ButtonStyle = .secondaryOutline {
        didSet {
            if style != oldValue {
                update()
            }
        }
    }

    /// The button's image.
    /// For ButtonStyle.primaryFilled and ButtonStyle.primaryOutline, the image must be 24x24.
    /// For ButtonStyle.secondaryOutline, the image must be 20x20.
    /// For other styles, the image is not displayed.
    @objc open var image: UIImage? {
        didSet {
            update()
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                update()
            }
        }
    }

    open override var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                update()
            }
        }
    }

    open override var contentEdgeInsets: UIEdgeInsets {
        didSet {
            isUsingCustomContentEdgeInsets = true

            updateProposedTitleLabelWidth()

            if !isAdjustingCustomContentEdgeInsetsForImage && image(for: .normal) != nil {
                adjustCustomContentEdgeInsetsForImage()
            }
        }
    }

    open override var intrinsicContentSize: CGSize {
        var size = titleLabel?.systemLayoutSizeFitting(CGSize(width: proposedTitleLabelWidth == 0 ? .greatestFiniteMagnitude : proposedTitleLabelWidth, height: .greatestFiniteMagnitude)) ?? .zero
        size.width = ceil(size.width + contentEdgeInsets.left + contentEdgeInsets.right)
        size.height = ceil(max(size.height, style.minTitleLabelHeight) + contentEdgeInsets.top + contentEdgeInsets.bottom)

        if let image = image(for: .normal) {
            size.width += image.size.width

            if titleLabel?.text?.count ?? 0 == 0 {
                size.width -= style.titleImagePadding
            }
        }

        return size
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)

        if let image = image {
            let imageHeight = image.size.height

            // If the entire image doesn't fit in the default rect, increase the rect's height
            // to fit the entire image and reposition the origin to keep the image centered.
            if imageHeight > rect.size.height {
                rect.origin.y -= round((imageHeight - rect.size.height) / 2.0)
                rect.size.height = imageHeight
            }

            rect.size.width = image.size.width
        }

        return rect
    }

    @objc public init(style: ButtonStyle = .secondaryOutline) {
        self.style = style
        super.init(frame: .zero)
        initialize()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        layer.cornerRadius = style.cornerRadius
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }

        titleLabel?.font = style.titleFont
        titleLabel?.adjustsFontForContentSizeCategory = true
        update()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
                updateBorderColor()
            }
        }
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateBackgroundColor()
        updateTitleColors()
        updateImage()
        updateBorderColor()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        updateProposedTitleLabelWidth()
    }

    private func updateTitleColors() {
        if let window = window {
            setTitleColor(normalTitleAndImageColor(for: window), for: .normal)
            setTitleColor(highlightedTitleAndImageColor(for: window), for: .highlighted)
            setTitleColor(disabledTitleAndImageColor(for: window), for: .disabled)
        }
    }

    private func updateImage() {
        let isDisplayingImage = (style == .primaryFilled || style == .primaryOutline || style == .secondaryOutline) && image != nil

        if let window = window {
            let normalColor = normalTitleAndImageColor(for: window)
            let highlightedColor = highlightedTitleAndImageColor(for: window)
            let disabledColor = disabledTitleAndImageColor(for: window)
            let needsSetImage = isDisplayingImage && image(for: .normal) == nil

            if needsSetImage || !normalColor.isEqual(normalImageTintColor) {
                normalImageTintColor = normalColor
                setImage(image?.image(withPrimaryColor: normalColor), for: .normal)
            }

            if needsSetImage || !highlightedColor.isEqual(highlightedImageTintColor) {
                highlightedImageTintColor = highlightedColor
                setImage(image?.image(withPrimaryColor: highlightedColor), for: .highlighted)
            }

            if needsSetImage || !disabledColor.isEqual(disabledImageTintColor) {
                disabledImageTintColor = disabledColor
                setImage(image?.image(withPrimaryColor: disabledColor), for: .disabled)
            }

            if needsSetImage {
                updateProposedTitleLabelWidth()

                if isUsingCustomContentEdgeInsets {
                    adjustCustomContentEdgeInsetsForImage()
                }
            }
        }

        if (image == nil || !isDisplayingImage) && image(for: .normal) != nil {
            setImage(nil, for: .normal)
            setImage(nil, for: .highlighted)
            setImage(nil, for: .disabled)

            normalImageTintColor = nil
            highlightedImageTintColor = nil
            disabledImageTintColor = nil

            updateProposedTitleLabelWidth()

            if isUsingCustomContentEdgeInsets {
                adjustCustomContentEdgeInsetsForImage()
            }
        }
    }

    private func update() {
        updateTitleColors()
        updateImage()
        updateBackgroundColor()
        updateBorderColor()

        layer.borderWidth = style.hasBorders ? Constants.borderWidth : 0

        if !isUsingCustomContentEdgeInsets {
            contentEdgeInsets = style.contentEdgeInsets
        }

        updateProposedTitleLabelWidth()
    }

    private func normalTitleAndImageColor(for window: UIWindow) -> UIColor {
        return style == .primaryFilled ? Colors.Button.titleWithFilledBackground : Colors.primary(for: window)
    }

    private func highlightedTitleAndImageColor(for window: UIWindow) -> UIColor {
        return style == .primaryFilled ? Colors.Button.titleWithFilledBackground : Colors.primaryTint20(for: window)
    }

    private func disabledTitleAndImageColor(for window: UIWindow) -> UIColor {
        return style == .primaryFilled ? Colors.Button.titleWithFilledBackground : Colors.Button.titleDisabled
    }

    private var normalImageTintColor: UIColor?
    private var highlightedImageTintColor: UIColor?
    private var disabledImageTintColor: UIColor?

    private var isUsingCustomContentEdgeInsets: Bool = false
    private var isAdjustingCustomContentEdgeInsetsForImage: Bool = false

    /// if value is 0.0, CGFloat.greatestFiniteMagnitude is used to calculate the width of the `titleLabel` in `intrinsicContentSize`
    private var proposedTitleLabelWidth: CGFloat = 0.0 {
        didSet {
            if proposedTitleLabelWidth != oldValue {
                invalidateIntrinsicContentSize()
            }
        }
    }

    private func updateProposedTitleLabelWidth() {
        if bounds.width > 0.0 {
            var labelWidth = bounds.width - (contentEdgeInsets.left + contentEdgeInsets.right)
            if let image = image(for: .normal) {
                labelWidth -= image.size.width
            }

            if labelWidth > 0.0 {
                proposedTitleLabelWidth = labelWidth
            }
        }
    }

    private func adjustCustomContentEdgeInsetsForImage() {
        isAdjustingCustomContentEdgeInsetsForImage = true

        var spacing = style.titleImagePadding

        if image(for: .normal) == nil {
            spacing = -spacing
        }

        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            contentEdgeInsets.right += spacing
            titleEdgeInsets.left += spacing
            titleEdgeInsets.right -= spacing
        } else {
            contentEdgeInsets.left += spacing
            titleEdgeInsets.right += spacing
            titleEdgeInsets.left -= spacing
        }

        isAdjustingCustomContentEdgeInsetsForImage = false
    }

    private func updateBackgroundColor() {
        if let window = window {
            let backgroundColor: UIColor
            if isHighlighted {
                backgroundColor = style == .primaryFilled ? UIColor(light: Colors.primaryTint10(for: window), dark: Colors.primaryTint20(for: window)) : Colors.Button.background
            } else if !isEnabled {
                backgroundColor = style == .primaryFilled ? Colors.Button.backgroundFilledDisabled : Colors.Button.background
            } else {
                backgroundColor = style == .primaryFilled ? Colors.primary(for: window) : Colors.Button.background
            }
            self.backgroundColor = backgroundColor
        }
    }

    private func updateBorderColor() {
        if !style.hasBorders {
            return
        }

        if let window = window {
            let borderColor: UIColor
            if isHighlighted {
                borderColor = Colors.primaryTint30(for: window)
            } else if !isEnabled {
                borderColor = Colors.Button.borderDisabled
            } else {
                borderColor = Colors.primaryTint10(for: window)
            }
            layer.borderColor = borderColor.cgColor
        }
    }
}
