//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

// MARK: - Button

/// By default, `titleLabel`'s `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@IBDesignable
@objc(MSFButton)
open class Button: UIButton, TokenizedControlInternal {
    @objc open var style: ButtonStyle = .secondaryOutline {
        didSet {
            if style != oldValue {
                update()
            }
        }
    }

    /// The button's image.
    /// For ButtonStyle.primaryFilled and ButtonStyle.primaryOutline, the image must be 24x24.
    /// For ButtonStyle.secondaryOutline and ButtonStyle.borderless, the image must be 20x20.
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

    private func defaultEdgeInsets() -> NSDirectionalEdgeInsets {
        let horizontalPadding = ButtonTokenSet.horizontalPadding(style)
        let verticalPadding = ButtonTokenSet.verticalPadding(style)
        return NSDirectionalEdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding)
    }
    
    open lazy var edgeInsets: NSDirectionalEdgeInsets = defaultEdgeInsets() {
        didSet {
            isUsingCustomContentEdgeInsets = true

            updateProposedTitleLabelWidth()

            if !isAdjustingCustomContentEdgeInsetsForImage && image(for: .normal) != nil {
                adjustCustomContentEdgeInsetsForImage()
            }

            var configuration = self.configuration ?? UIButton.Configuration.plain()
            configuration.contentInsets = edgeInsets
            self.configuration = configuration
        }
    }

    open override var intrinsicContentSize: CGSize {
        var size = titleLabel?.systemLayoutSizeFitting(CGSize(width: proposedTitleLabelWidth == 0 ? .greatestFiniteMagnitude : proposedTitleLabelWidth, height: .greatestFiniteMagnitude)) ?? .zero
        size.width = ceil(size.width + edgeInsets.leading + edgeInsets.trailing)
        size.height = ceil(max(size.height, ButtonTokenSet.minContainerHeight(style)) + edgeInsets.top + edgeInsets.bottom)

        if let image = image(for: .normal) {
            size.width += image.size.width

            if titleLabel?.text?.count ?? 0 > 0 {
                size.width += ButtonTokenSet.titleImageSpacing(style)
            }
        }

        return size
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
        layer.cornerRadius = tokenSet[.cornerRadius].float
        layer.cornerCurve = .continuous

        titleLabel?.font = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        titleLabel?.adjustsFontForContentSizeCategory = true

        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = edgeInsets
        self.configuration = configuration

        update()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever overrideTokens changes.
        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.update()
        }
    }

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard style.isFilledStyle, (self == context.nextFocusedView || self == context.previouslyFocusedView) else {
            return
        }

        updateBackgroundColor()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateBorderColor()
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

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateBackgroundColor()
        updateTitleColors()
        updateImage()
        updateBorderColor()
    }

    public typealias TokenSetKeyType = ButtonTokenSet.Tokens
    lazy public var tokenSet: ButtonTokenSet = .init(style: { [weak self] in
        return self?.style ?? .primaryFilled
    })
    var tokenSetSink: AnyCancellable?

    private func updateTitleColors() {
        if let window = window {
            setTitleColor(normalTitleAndImageColor(for: window), for: .normal)
            setTitleColor(highlightedTitleAndImageColor(for: window), for: .highlighted)
            setTitleColor(disabledTitleAndImageColor(for: window), for: .disabled)
        }
    }

    private func updateImage() {
        let isDisplayingImage = style != .tertiaryOutline && image != nil

        if let window = window {
            let normalColor = normalTitleAndImageColor(for: window)
            let highlightedColor = highlightedTitleAndImageColor(for: window)
            let disabledColor = disabledTitleAndImageColor(for: window)
            let needsSetImage = isDisplayingImage && image(for: .normal) == nil

            if needsSetImage || !normalColor.isEqual(normalImageTintColor) {
                normalImageTintColor = normalColor
                setImage(image?.withTintColor(normalColor, renderingMode: .alwaysOriginal), for: .normal)
            }

            if needsSetImage || !highlightedColor.isEqual(highlightedImageTintColor) {
                highlightedImageTintColor = highlightedColor
                setImage(image?.withTintColor(highlightedColor, renderingMode: .alwaysOriginal), for: .highlighted)
            }

            if needsSetImage || !disabledColor.isEqual(disabledImageTintColor) {
                disabledImageTintColor = disabledColor
                setImage(image?.withTintColor(disabledColor, renderingMode: .alwaysOriginal), for: .disabled)
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

        layer.borderWidth = style.hasBorders ? tokenSet[.borderSize].float : 0

        if !isUsingCustomContentEdgeInsets {
            edgeInsets = defaultEdgeInsets()
        }

        updateProposedTitleLabelWidth()
    }

    private func normalTitleAndImageColor(for window: UIWindow) -> UIColor {
        if style.isFilledStyle {
            return style.isDangerStyle ? dangerFilledTitleAndImageColor : titleWithFilledBackground
        }

        return style.isDangerStyle ? dangerTitleAndImageColor : UIColor(dynamicColor: tokenSet[.foregroundColor].buttonDynamicColors.rest)
    }

    private func highlightedTitleAndImageColor(for window: UIWindow) -> UIColor {
        if style.isFilledStyle {
            return style.isDangerStyle ? dangerFilledTitleAndImageColor : titleWithFilledBackground
        }

        return style.isDangerStyle ? dangerTitleAndImageColor : UIColor(dynamicColor: tokenSet[.foregroundColor].buttonDynamicColors.hover)
    }

    private func disabledTitleAndImageColor(for window: UIWindow) -> UIColor {
        return style.isFilledStyle ? titleWithFilledBackground : titleDisabled
    }

    private lazy var backgroundFilledDisabled: UIColor = UIColor(dynamicColor: tokenSet[.backgroundColor].buttonDynamicColors.disabled)
    private lazy var borderDisabled: UIColor = UIColor(dynamicColor: tokenSet[.borderColor].buttonDynamicColors.disabled)
    private lazy var titleDisabled: UIColor = UIColor(dynamicColor: tokenSet[.foregroundColor].buttonDynamicColors.disabled)
    private lazy var titleWithFilledBackground: UIColor = UIColor(dynamicColor: tokenSet[.foregroundColor].buttonDynamicColors.rest)
    private lazy var dangerTitleAndImageColor: UIColor = UIColor(dynamicColor: tokenSet[.foregroundColor].buttonDynamicColors.rest)
    private lazy var dangerFilledTitleAndImageColor: UIColor = UIColor(dynamicColor: tokenSet[.foregroundColor].buttonDynamicColors.rest)

    private lazy var borderWidth = tokenSet[.borderSize].float
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
            var labelWidth = bounds.width - (edgeInsets.leading + edgeInsets.trailing)
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

        var spacing = ButtonTokenSet.titleImageSpacing(style)

        if image(for: .normal) == nil {
            spacing = -spacing
        }

        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.contentInsets = edgeInsets
        configuration.imagePadding = spacing
        self.configuration = configuration

        isAdjustingCustomContentEdgeInsetsForImage = false
    }

    private func primaryFilledBackgroundColor() -> UIColor {
        if isHighlighted {
            return UIColor(dynamicColor: tokenSet[.backgroundColor].buttonDynamicColors.pressed)
        }

        if isFocused {
            return UIColor(dynamicColor: tokenSet[.backgroundColor].buttonDynamicColors.hover)
        }

        return UIColor(dynamicColor: tokenSet[.backgroundColor].buttonDynamicColors.rest)
    }

    private var primaryDangerFilledBackgroundColor: UIColor {
        // TODO: in the future, we want to have highlighted state defined for danger buttons.
        // For now, highlighted/isPressed are not differentiated for danger buttons.
        return UIColor(dynamicColor: tokenSet[.backgroundColor].buttonDynamicColors.rest)
    }

    private func updateBackgroundColor() {
        let backgroundColor: UIColor

        if !isEnabled {
            backgroundColor = style.isFilledStyle ? backgroundFilledDisabled : .clear
        } else {
            switch style {
            case .primaryFilled:
                backgroundColor = primaryFilledBackgroundColor()
            case .dangerFilled:
                backgroundColor = primaryDangerFilledBackgroundColor
            case .primaryOutline,
                    .dangerOutline,
                    .secondaryOutline,
                    .tertiaryOutline,
                    .borderless:
                backgroundColor = .clear
            }
        }

        self.backgroundColor = backgroundColor
    }

    private func updateBorderColor() {
        if !style.hasBorders {
            return
        }

        let borderColor: UIColor

        if !isEnabled {
            borderColor = borderDisabled
        } else if style.isDangerStyle {
            borderColor = UIColor(dynamicColor: tokenSet[.borderColor].buttonDynamicColors.rest)
        } else if isHighlighted {
            borderColor = UIColor(dynamicColor: tokenSet[.borderColor].buttonDynamicColors.pressed)
        } else {
            borderColor = UIColor(dynamicColor: tokenSet[.borderColor].buttonDynamicColors.rest)
        }

        layer.borderColor = borderColor.cgColor
    }
}
