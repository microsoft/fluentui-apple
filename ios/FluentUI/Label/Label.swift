//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import UIKit

// MARK: - Label

/// By default, `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@objc(MSFLabel)
open class Label: UILabel, TokenizedControlInternal {
    @objc open var colorStyle: TextColorStyle = .regular {
        didSet {
            _textColor = nil
            updateTextColor()
        }
    }
    @objc open var style: AliasTokens.TypographyTokens = .body1 {
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
        didSet {
            _textColor = textColor
            updateTextColor()
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
    lazy public var tokenSet: LabelTokenSet = .init(style: { [weak self] in
        return self?.style ?? .body1
    },
                                                    colorStyle: { [weak self] in
        return self?.colorStyle ?? .regular
    })

    @objc public init(style: AliasTokens.TypographyTokens = .body1, colorStyle: TextColorStyle = .regular) {
        self.style = style
        self.colorStyle = colorStyle
        super.init(frame: .zero)
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func initialize() {
        // textColor is assigned in super.init to a default value and so we need to reset our cache afterwards
        _textColor = nil

        updateFont()
        updateTextColor()
        adjustsFontForContentSizeCategory = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleContentSizeCategoryDidChange),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever overrideTokens changes.
        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.updateTextColor()
            self?.updateFont()
        }
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateTextColor()
        updateFont()
    }

    private func updateFont() {
        // If attributedText is set, it will be prioritized over any other label property changes
        guard !isUsingCustomAttributedText else {
            return
        }

        let defaultFont = UIFont.fluent(tokenSet[.font].fontInfo)
        if maxFontSize > 0 && defaultFont.pointSize > maxFontSize {
            font = defaultFont.withSize(maxFontSize)
        } else {
            font = defaultFont
        }
    }

    private func updateTextColor() {
        // If attributedText is set, it will be prioritized over any other label property changes
        guard !isUsingCustomAttributedText else {
            return
        }
        super.textColor = _textColor ?? UIColor(dynamicColor: tokenSet[.textColor].dynamicColor)
    }

    @objc private func handleContentSizeCategoryDidChange() {
        if adjustsFontForContentSizeCategory {
            updateFont()
        }
    }

    private var _textColor: UIColor?
    private var isUsingCustomAttributedText: Bool = false
    private var tokenSetSink: AnyCancellable?
}
