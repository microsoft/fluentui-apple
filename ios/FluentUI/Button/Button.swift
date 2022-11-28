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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateBorderColor()
        }
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
        let foregroundColors = tokenSet[.foregroundColor].buttonDynamicColors
        setTitleColor(UIColor(dynamicColor: foregroundColors.rest), for: .normal)
        setTitleColor(UIColor(dynamicColor: foregroundColors.pressed), for: .highlighted)
        setTitleColor(UIColor(dynamicColor: foregroundColors.disabled), for: .disabled)
    }

    private func updateImage() {
        let isDisplayingImage = style != .tertiaryOutline && image != nil

        let foregroundColors = tokenSet[.foregroundColor].buttonDynamicColors
        let normalColor = UIColor(dynamicColor: foregroundColors.rest)
        let highlightedColor = UIColor(dynamicColor: foregroundColors.hover)
        let disabledColor = UIColor(dynamicColor: foregroundColors.disabled)
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

        layer.borderWidth = tokenSet[.borderSize].float

        if !isUsingCustomContentEdgeInsets {
            edgeInsets = defaultEdgeInsets()
        }

        updateProposedTitleLabelWidth()
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

    private func updateBackgroundColor() {
        let backgroundColors = tokenSet[.backgroundColor].buttonDynamicColors
        let backgroundColor: DynamicColor

        if !isEnabled {
            backgroundColor = backgroundColors.disabled
        } else if isHighlighted {
            backgroundColor = backgroundColors.pressed
        } else if isFocused {
            backgroundColor = backgroundColors.hover
        } else {
            backgroundColor = backgroundColors.rest
        }

        self.backgroundColor = UIColor(dynamicColor: backgroundColor)
    }

    private func updateBorderColor() {
        let borderColors = tokenSet[.borderColor].buttonDynamicColors
        let borderColor: DynamicColor

        if !isEnabled {
            borderColor = borderColors.disabled
        } else if isHighlighted {
            borderColor = borderColors.pressed
        } else {
            borderColor = borderColors.rest
        }

        layer.borderColor = UIColor(dynamicColor: borderColor).cgColor
    }

    private func defaultEdgeInsets() -> NSDirectionalEdgeInsets {
        let horizontalPadding = ButtonTokenSet.horizontalPadding(style)
        let verticalPadding = ButtonTokenSet.verticalPadding(style)
        return NSDirectionalEdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding)
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
}
