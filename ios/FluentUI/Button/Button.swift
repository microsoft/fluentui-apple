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
    @objc open var style: ButtonStyle = .outline {
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

    open lazy var edgeInsets: NSDirectionalEdgeInsets = defaultEdgeInsets() {
        didSet {
            isUsingCustomContentEdgeInsets = edgeInsets != defaultEdgeInsets()

            invalidateIntrinsicContentSize()

            if !isAdjustingCustomContentEdgeInsetsForImage && image(for: .normal) != nil {
                adjustCustomContentEdgeInsetsForImage()
            }

            if #available(iOS 15.0, *) {
                var configuration = self.configuration ?? UIButton.Configuration.plain()
                configuration.contentInsets = edgeInsets
                self.configuration = configuration
            } else {
                let left: CGFloat
                let right: CGFloat
                if effectiveUserInterfaceLayoutDirection == .leftToRight {
                    left = edgeInsets.leading
                    right = edgeInsets.trailing
                } else {
                    left = edgeInsets.trailing
                    right = edgeInsets.leading
                }
                contentEdgeInsets = UIEdgeInsets(top: edgeInsets.top, left: left, bottom: edgeInsets.bottom, right: right)
            }
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var contentSize = titleLabel?.systemLayoutSizeFitting(size) ?? .zero
        contentSize.width = ceil(contentSize.width + edgeInsets.leading + edgeInsets.trailing)
        contentSize.height = ceil(max(contentSize.height, ButtonTokenSet.minContainerHeight(style: style, size: sizeCategory)) + edgeInsets.top + edgeInsets.bottom)

        if let image = image(for: .normal) {
            contentSize.width += image.size.width
            if #available(iOS 15.0, *) {
                contentSize.width += ButtonTokenSet.titleImageSpacing(style: style, size: sizeCategory)
            }

            if titleLabel?.text?.count ?? 0 == 0 {
                contentSize.width -= ButtonTokenSet.titleImageSpacing(style: style, size: sizeCategory)
            }
        }

        return contentSize
    }

    open func initialize() {
        layer.cornerRadius = style.isFloating ? layer.frame.height / 2 : tokenSet[.cornerRadius].float
        layer.cornerCurve = .continuous

        titleLabel?.font = tokenSet[.titleFont].uiFont
        titleLabel?.adjustsFontForContentSizeCategory = !style.isFloating

        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = edgeInsets
            let titleTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = self.tokenSet[.titleFont].uiFont
                return outgoing
            }
            configuration.titleTextAttributesTransformer = titleTransformer
            self.configuration = configuration
        }

        update()

        // Update appearance whenever overrideTokens changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.update()
        }
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

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = CGRect.zero
        if #available(iOS 15, *) {
            assertionFailure("imageRect(forContentRect: ) has been deprecated in iOS 15.0")
        } else {
            rect = super.imageRect(forContentRect: contentRect)

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
        }
        return rect
    }

    @objc public init(style: ButtonStyle = .outline) {
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
            updateBorder()
        }
    }

    public typealias TokenSetKeyType = ButtonTokenSet.Tokens
    public var ambientShadow: CALayer?
    public var keyShadow: CALayer?

    lazy public var tokenSet: ButtonTokenSet = .init(style: { [weak self] in
        return self?.style ?? .outline
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

        if #available(iOS 15.0, *) {
        } else {
            titleLabel?.font = tokenSet[.titleFont].uiFont
        }

        invalidateIntrinsicContentSize()
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

    private func adjustCustomContentEdgeInsetsForImage() {
        isAdjustingCustomContentEdgeInsetsForImage = true

        var spacing = ButtonTokenSet.titleImageSpacing(style: style, size: sizeCategory)

        if image(for: .normal) == nil {
            spacing = -spacing
        }

        if #available(iOS 15.0, *) {
            var configuration = self.configuration ?? UIButton.Configuration.plain()
            configuration.contentInsets = edgeInsets
            configuration.imagePadding = spacing
            self.configuration = configuration
        } else {
            edgeInsets.trailing += spacing
            if effectiveUserInterfaceLayoutDirection == .leftToRight {
                titleEdgeInsets.left += spacing
                titleEdgeInsets.right -= spacing
            } else {
                titleEdgeInsets.right += spacing
                titleEdgeInsets.left -= spacing
            }
        }

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

        self.backgroundColor = backgroundColor
        layer.cornerRadius = style.isFloating ? layer.frame.height / 2 : tokenSet[.cornerRadius].float
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

        layer.borderColor = borderColor.resolvedColor(with: traitCollection).cgColor
        layer.borderWidth = tokenSet[.borderWidth].float
    }

    private func updateShadow() {
        let shadowInfo = !isEnabled || isHighlighted || isFocused ? tokenSet[.shadowPressed].shadowInfo : tokenSet[.shadowRest].shadowInfo
        shadowInfo.applyShadow(to: self)
    }

    private func defaultEdgeInsets() -> NSDirectionalEdgeInsets {
        let leadingPadding = ButtonTokenSet.horizontalPadding(style: style, size: sizeCategory)
        let trailingPadding = style.isFloating && titleLabel?.text != nil && image != nil ? ButtonTokenSet.fabAlternativePadding(sizeCategory) : ButtonTokenSet.horizontalPadding(style: style, size: sizeCategory)
        return NSDirectionalEdgeInsets(top: 0, leading: leadingPadding, bottom: 0, trailing: trailingPadding)
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
}
