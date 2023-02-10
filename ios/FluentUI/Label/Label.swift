//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TextColorStyle

@objc(MSFTextColorStyle)
public enum TextColorStyle: Int, CaseIterable {
    case regular
    case secondary
    case white
    case primary
    case error

    func color(fluentTheme: FluentTheme) -> UIColor {
        switch self {
        case .regular:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
        case .secondary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground2])
        case .white:
            return .white
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForeground1])
        case .error:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.dangerForeground2])
        }
    }
}

// MARK: - Label

/// By default, `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@objc(MSFLabel)
open class Label: UILabel {
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
    private var _textColor: UIColor?

    private var isUsingCustomAttributedText: Bool = false

    @objc public init(style: AliasTokens.TypographyTokens = .body1, colorStyle: TextColorStyle = .regular) {
        self.style = style
        self.colorStyle = colorStyle
        super.init(frame: .zero)
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

	open override func willMove(toWindow newWindow: UIWindow?) {
		super.willMove(toWindow: newWindow)
        updateTextColor()
    }

    open override var attributedText: NSAttributedString? {
      didSet {
          isUsingCustomAttributedText = attributedText != nil
        }
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
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        updateTextColor()
    }

    private func updateFont() {
        // If attributedText is set, it will be prioritized over any other label property changes
        guard !isUsingCustomAttributedText else {
            return
        }

        let defaultFont = UIFont.fluent(fluentTheme.aliasTokens.typography[style])
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
        super.textColor = _textColor ?? colorStyle.color(fluentTheme: fluentTheme)
    }

    @objc private func handleContentSizeCategoryDidChange() {
        if adjustsFontForContentSizeCategory {
            updateFont()
        }
    }
}
