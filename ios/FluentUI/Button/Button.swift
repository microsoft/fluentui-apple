//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - Button

/// By default, `titleLabel`'s `adjustsFontForContentSizeCategory` is set to true for non-floating buttons to automatically update its font when device's content size category changes
@IBDesignable
@objc(MSFButton)
open class Button: UIButton, Shadowable, TokenizedControlInternal {
    @objc open var style: ButtonStyle = .outlineAccent {
        didSet {
            if style != oldValue {
                update()
            }
        }
    }

    @objc open var sizeCategory: ButtonSizeCategory = .medium {
        didSet {
            if sizeCategory != oldValue {
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

    /// The content insets of the buton.
    open lazy var edgeInsets: NSDirectionalEdgeInsets = defaultEdgeInsets() {
        didSet {
            isUsingCustomContentEdgeInsets = edgeInsets != defaultEdgeInsets()

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
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var contentSize = titleLabel?.systemLayoutSizeFitting(CGSize(width: proposedTitleLabelWidth <= 0 ? size.width : proposedTitleLabelWidth, height: size.height)) ?? .zero
        contentSize.height = ceil(max(contentSize.height + edgeInsets.top + edgeInsets.bottom, ButtonTokenSet.minContainerHeight(style: style, size: sizeCategory)))

        let superSize = super.sizeThatFits(size)
        contentSize.width = superSize.width

        return contentSize
    }

    open func initialize() {
        titleLabel?.adjustsFontForContentSizeCategory = !style.isFloating

        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = edgeInsets
        let titleTransformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
            var outgoing = incoming
            outgoing.font = self?.tokenSet[.titleFont].uiFont
            return outgoing
        }
        configuration.titleTextAttributesTransformer = titleTransformer
        configuration.contentInsets = edgeInsets
        self.configuration = configuration

        update()

        // Update appearance whenever overrideTokens changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.update()
        }

        addInteraction(UILargeContentViewerInteraction())
    }

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard self == context.nextFocusedView || self == context.previouslyFocusedView else {
            return
        }

        focusRing.isHidden = !isFocused
        updateBackground()
        updateBorder()
        updateShadow()
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        update()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateShadow()

        updateProposedTitleLabelWidth()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard tappableSize != .zero else {
            return super.point(inside: point, with: event)
        }

        let growX = max(0, (tappableSize.width - bounds.size.width) / 2)
        let growY = max(0, (tappableSize.height - bounds.size.height) / 2)

        return bounds.insetBy(dx: -growX, dy: -growY).contains(point)
    }

    @objc public init(style: ButtonStyle = .outlineAccent) {
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

    @available(iOS, deprecated: 17.0)
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let previousTraitCollection else {
            return
        }

        if previousTraitCollection.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateBorder()
        }

        if previousTraitCollection.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
        }
    }

    public func defaultEdgeInsets() -> NSDirectionalEdgeInsets {
        let leadingPadding = ButtonTokenSet.horizontalPadding(style: style, size: sizeCategory)
        let trailingPadding = style.isFloating && titleLabel?.text != nil && image != nil ? ButtonTokenSet.fabAlternativePadding(sizeCategory) : ButtonTokenSet.horizontalPadding(style: style, size: sizeCategory)
        return NSDirectionalEdgeInsets(top: 0, leading: leadingPadding, bottom: 0, trailing: trailingPadding)
    }

    public typealias TokenSetKeyType = ButtonTokenSet.Tokens
    public var ambientShadow: CALayer?
    public var keyShadow: CALayer?

    /// Used to increase the default tappable size of the button.
    @objc public var tappableSize: CGSize = .zero

    lazy public var tokenSet: ButtonTokenSet = .init(style: { [weak self] in
        return self?.style ?? .outlineAccent
    },
                                                     size: { [weak self] in
        return self?.sizeCategory ?? .medium
    })

    private func updateTitle() {
        let foregroundColor = tokenSet[.foregroundColor].uiColor
        setTitleColor(foregroundColor, for: .normal)
        setTitleColor(foregroundColor, for: .focused)
        setTitleColor(tokenSet[.foregroundPressedColor].uiColor, for: .highlighted)
        setTitleColor(tokenSet[.foregroundDisabledColor].uiColor, for: .disabled)

        updateProposedTitleLabelWidth()
    }

    private func updateImage() {
        let isDisplayingImage = image != nil

        let normalColor = tokenSet[.foregroundColor].uiColor
        let highlightedColor = tokenSet[.foregroundPressedColor].uiColor
        let disabledColor = tokenSet[.foregroundDisabledColor].uiColor
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
            invalidateIntrinsicContentSize()

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

            invalidateIntrinsicContentSize()

            if isUsingCustomContentEdgeInsets {
                adjustCustomContentEdgeInsetsForImage()
            }
        }
    }

    private func update() {
        updateTitle()
        updateImage()
        updateBackground()
        updateBorder()
        updateShadow()

        if !isUsingCustomContentEdgeInsets {
            edgeInsets = defaultEdgeInsets()
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

        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.contentInsets = edgeInsets
        configuration.imagePadding = ButtonTokenSet.titleImageSpacing(style: style, size: sizeCategory)
        self.configuration = configuration

        isAdjustingCustomContentEdgeInsetsForImage = false
    }

    private func updateBackground() {
        let backgroundColor: UIColor

        if !isEnabled {
            backgroundColor = tokenSet[.backgroundDisabledColor].uiColor
        } else if isHighlighted {
            backgroundColor = tokenSet[.backgroundPressedColor].uiColor
        } else if isFocused {
            backgroundColor = tokenSet[.backgroundFocusedColor].uiColor
        } else {
            backgroundColor = tokenSet[.backgroundColor].uiColor
        }

        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.background.backgroundColor = backgroundColor
        if style.isFloating {
            configuration.cornerStyle = .capsule
        } else {
            configuration.cornerStyle = .fixed
            configuration.background.cornerRadius = tokenSet[.cornerRadius].float
        }
        self.configuration = configuration
    }

    private func updateBorder() {
        let borderColor: UIColor

        if !isEnabled {
            borderColor = tokenSet[.borderDisabledColor].uiColor
        } else if isHighlighted {
            borderColor = tokenSet[.borderPressedColor].uiColor
        } else if isFocused {
            borderColor = tokenSet[.borderFocusedColor].uiColor
        } else {
            borderColor = tokenSet[.borderColor].uiColor
        }

        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.background.strokeColor = borderColor
        configuration.background.strokeWidth = tokenSet[.borderWidth].float
        self.configuration = configuration
    }

    private func updateShadow() {
        // UIButton.Configuration doesn't set the layer by default, so in order
        // for our shadow layers to work we need to update the layer.
        let configuration = self.configuration ?? UIButton.Configuration.plain()
        self.backgroundColor = configuration.background.backgroundColor
        layer.cornerCurve = .continuous
        layer.cornerRadius = style.isFloating ? frame.height / 2 : configuration.background.cornerRadius

        let shadowInfo = (!isEnabled || isHighlighted || isFocused) ? tokenSet[.shadowPressed].shadowInfo : tokenSet[.shadowRest].shadowInfo
        shadowInfo.applyShadow(to: self)
    }

    private lazy var focusRing: FocusRingView = {
        let ringView = FocusRingView()
        ringView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(ringView)
        ringView.drawFocusRing(over: self)

        return ringView
    }()

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
