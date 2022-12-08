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
        var size = titleLabel?.systemLayoutSizeFitting(CGSize(width: proposedTitleLabelWidth == 0 ? .greatestFiniteMagnitude : proposedTitleLabelWidth, height: .greatestFiniteMagnitude)) ?? .zero
        size.width = ceil(size.width + edgeInsets.leading + edgeInsets.trailing)
        size.height = ceil(max(size.height, ButtonTokenSet.minContainerHeight(style)) + edgeInsets.top + edgeInsets.bottom)

        if let image = image(for: .normal) {
            size.width += image.size.width
            if #available(iOS 15.0, *) {
                size.width += ButtonTokenSet.titleImageSpacing(style)
            }

            if titleLabel?.text?.count ?? 0 == 0 {
                size.width -= ButtonTokenSet.titleImageSpacing(style)
            }
        }

        return size
    }

    open func initialize() {
        layer.cornerRadius = tokenSet[.cornerRadius].float
        layer.cornerCurve = .continuous

        titleLabel?.font = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        titleLabel?.adjustsFontForContentSizeCategory = true

        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = edgeInsets
            let titleTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.fluent(self.tokenSet[.titleFont].fontInfo)
                return outgoing
            }
            configuration.titleTextAttributesTransformer = titleTransformer
            self.configuration = configuration
        }

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
        guard style == .primaryFilled || style == .dangerFilled,
              (self == context.nextFocusedView || self == context.previouslyFocusedView) else {
            return
        }

        updateBackgroundColor()
    }

    open override func didMoveToWindow() {
        tokenSet.update(fluentTheme)
        update()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        updateProposedTitleLabelWidth()
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
            updateBorder()
        }
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
    }

    public typealias TokenSetKeyType = ButtonTokenSet.Tokens

    lazy public var tokenSet: ButtonTokenSet = .init(style: { [weak self] in
        return self?.style ?? .primaryFilled
    })

    private func updateTitle() {
        let foregroundColor = UIColor(dynamicColor: tokenSet[.foregroundColor].dynamicColor)
        setTitleColor(foregroundColor, for: .normal)
        setTitleColor(foregroundColor, for: .focused)
        setTitleColor(UIColor(dynamicColor: tokenSet[.foregroundPressedColor].dynamicColor), for: .highlighted)
        setTitleColor(UIColor(dynamicColor: tokenSet[.foregroundDisabledColor].dynamicColor), for: .disabled)

        if #unavailable(iOS 15.0) {
            titleLabel?.font = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        }

        updateProposedTitleLabelWidth()
    }

    private func updateImage() {
        let isDisplayingImage = style != .tertiaryOutline && image != nil

        let normalColor = UIColor(dynamicColor: tokenSet[.foregroundColor].dynamicColor)
        let highlightedColor = UIColor(dynamicColor: tokenSet[.foregroundPressedColor].dynamicColor)
        let disabledColor = UIColor(dynamicColor: tokenSet[.foregroundDisabledColor].dynamicColor)
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
        updateTitle()
        updateImage()
        updateBackgroundColor()
        updateBorder()

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

        var spacing = ButtonTokenSet.titleImageSpacing(style)

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

    private func updateBackgroundColor() {
        let backgroundColor: DynamicColor

        if !isEnabled {
            backgroundColor = tokenSet[.backgroundDisabledColor].dynamicColor
        } else if isHighlighted {
            backgroundColor = tokenSet[.backgroundPressedColor].dynamicColor
        } else if isFocused {
            backgroundColor = tokenSet[.backgroundPressedColor].dynamicColor
        } else {
            backgroundColor = tokenSet[.backgroundColor].dynamicColor
        }

        self.backgroundColor = UIColor(dynamicColor: backgroundColor)
    }

    private func updateBorder() {
        let borderColor: DynamicColor

        if !isEnabled {
            borderColor = tokenSet[.borderDisabledColor].dynamicColor
        } else if isHighlighted {
            borderColor = tokenSet[.borderPressedColor].dynamicColor
        } else {
            borderColor = tokenSet[.borderColor].dynamicColor
        }

        layer.borderColor = UIColor(dynamicColor: borderColor).resolvedColor(with: traitCollection).cgColor
        layer.borderWidth = tokenSet[.borderWidth].float
    }

    private func defaultEdgeInsets() -> NSDirectionalEdgeInsets {
        let horizontalPadding = ButtonTokenSet.horizontalPadding(style)
        let verticalPadding = ButtonTokenSet.verticalPadding(style)
        return NSDirectionalEdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding)
    }

    private var normalImageTintColor: UIColor?
    private var highlightedImageTintColor: UIColor?
    private var disabledImageTintColor: UIColor?
    private var tokenSetSink: AnyCancellable?

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
