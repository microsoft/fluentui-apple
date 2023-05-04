//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - Label

/// By default, `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@objc(MSFLabel)
open class Label: UILabel, TokenizedControlInternal {
    @objc open var colorStyle: TextColorStyle = .regular {
        didSet {
            updateTextColor()
        }
    }

    @objc open var style: AliasTokens.TypographyTokens {
        get {
            return AliasTokens.TypographyTokens(rawValue: textStyle.rawValue)!
        }
        set {
            self.textStyle = FluentTheme.TypographyToken(rawValue: newValue.rawValue)!
        }
    }

    @objc open var textStyle: FluentTheme.TypographyToken = .body1 {
        didSet {
            updateFont()
        }
    }

    /**
     The maximum allowed size point for the receiver's font. This property can be used
     to restrict the largest size of the label when scaling due to Dynamic Type. The
     default value is 0, indicating there is no maximum size.
     */
    @objc open var maxFontSize: CGFloat = 0 {
        didSet {
            updateFont()
        }
    }

    open override var textColor: UIColor! {
        get {
            return tokenSet[.textColor].uiColor
        }
        set {
            tokenSet[.textColor] = .uiColor { newValue }
        }
    }

    open override var font: UIFont! {
        get {
            return tokenSet[.font].uiFont
        }
        set {
            tokenSet[.font] = .uiFont { newValue }
        }
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateTextColor()
        updateFont()
    }

    open override var attributedText: NSAttributedString? {
        didSet {
            isUsingCustomAttributedText = attributedText != nil
        }
    }

    public typealias TokenSetKeyType = LabelTokenSet.Tokens
    lazy public var tokenSet: LabelTokenSet = .init(textStyle: { [weak self] in
        return self?.textStyle ?? .body1
    },
                                                    colorStyle: { [weak self] in
        return self?.colorStyle ?? .regular
    })

    @objc convenience public init() {
        self.init(textStyle: .body1, colorStyle: .regular)
    }

    @objc public init(style: AliasTokens.TypographyTokens = .body1, colorStyle: TextColorStyle = .regular) {
        super.init(frame: .zero)
        self.style = style
        self.colorStyle = colorStyle
        initialize()
    }

    @objc public init(textStyle: FluentTheme.TypographyToken = .body1, colorStyle: TextColorStyle = .regular) {
        super.init(frame: .zero)
        self.textStyle = textStyle
        self.colorStyle = colorStyle
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func initialize() {
        // textColor and font in the tokenSet are assigned in super.init to a default value and so we need to remove the override
        tokenSet.removeOverride(.textColor)
        tokenSet.removeOverride(.font)

        updateFont()
        updateTextColor()
        adjustsFontForContentSizeCategory = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleContentSizeCategoryDidChange),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)

        // Update appearance whenever overrideTokens changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateTextColor()
            self?.updateFont()
        }
    }

    private func updateFont() {
        // If attributedText is set, it will be prioritized over any other label property changes
        guard !isUsingCustomAttributedText else {
            return
        }

        let labelFont = tokenSet[.font].uiFont
        if maxFontSize > 0 && labelFont.pointSize > maxFontSize {
            super.font = labelFont.withSize(maxFontSize)
        } else {
            super.font = labelFont
        }
    }

    private func updateTextColor() {
        // If attributedText is set, it will be prioritized over any other label property changes
        guard !isUsingCustomAttributedText else {
            return
        }
        super.textColor = tokenSet[.textColor].uiColor
    }

    @objc private func handleContentSizeCategoryDidChange() {
        if adjustsFontForContentSizeCategory {
            updateFont()
        }
    }

    private var isUsingCustomAttributedText: Bool = false
}
