//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TextColorStyle

@available(*, deprecated, renamed: "TextColorStyle")
public typealias MSTextColorStyle = TextColorStyle

@objc(MSFTextColorStyle)
public enum TextColorStyle: Int, CaseIterable {
    case regular
    case secondary
    case white
    case primary
    case error
    case warning
    case disabled

    public func color(for window: UIWindow) -> UIColor {
        switch self {
        case .regular:
            return Colors.textPrimary
        case .secondary:
            return Colors.textSecondary
        case .white:
            return .white
        case .primary:
            return Colors.primary(for: window)
        case .error:
            return Colors.error
        case .warning:
            return Colors.warning
        case .disabled:
            return Colors.textDisabled
        }
    }
}

// MARK: - Label

@available(*, deprecated, renamed: "Label")
public typealias MSLabel = Label

/// By default, `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@objc(MSFLabel)
open class Label: UILabel {
    @objc open var colorStyle: TextColorStyle = .regular {
        didSet {
            _textColor = nil
            updateTextColor()
        }
    }
    @objc open var style: TextStyle = .body {
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

    @objc public init(style: TextStyle = .body, colorStyle: TextColorStyle = .regular) {
        self.style = style
        self.colorStyle = colorStyle
        super.init(frame: .zero)
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTextColor()
    }

    private func initialize() {
        // textColor is assigned in super.init to a default value and so we need to reset our cache afterwards
        _textColor = nil

        updateFont()
        updateTextColor()
        adjustsFontForContentSizeCategory = true

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
        if #available(iOS 13, *) { } else {
            NotificationCenter.default.addObserver(self, selector: #selector(handleDarkerSystemColorsStatusDidChange), name: UIAccessibility.darkerSystemColorsStatusDidChangeNotification, object: nil)
        }
    }

    private func updateFont() {
        let defaultFont = style.font
        if maxFontSize > 0 && defaultFont.pointSize > maxFontSize {
            font = defaultFont.withSize(maxFontSize)
        } else {
            font = defaultFont
        }
    }

    private func updateTextColor() {
        if let window = window {
            let currentTextColor = _textColor ?? colorStyle.color(for: window)
            super.textColor = currentTextColor.current
        }
    }

    @objc private func handleContentSizeCategoryDidChange() {
        if adjustsFontForContentSizeCategory {
            updateFont()
        }
    }

    @objc private func handleDarkerSystemColorsStatusDidChange() {
        updateTextColor()
    }
}
