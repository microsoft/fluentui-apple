//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - PillButtonStyle

@available(*, deprecated, renamed: "PillButtonStyle")
public typealias MSPillButtonStyle = PillButtonStyle

@objc(MSFPillButtonStyle)
public enum PillButtonStyle: Int {
    case outline
    case filled

    func backgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return PillButton.outlineStyleBackgroundColor
        case .filled:
            return UIColor(light: Colors.primaryShade10(for: window), dark: PillButton.outlineStyleBackgroundColor)
        }
    }

    func selectedBackgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return UIColor(light: Colors.primary(for: window), dark: Colors.surfaceQuaternary)
        case .filled:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        }
    }

    func hoverBackgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return Colors.surfaceQuaternary
        case .filled:
            return UIColor(light: Colors.primaryShade20(for: window), dark: Colors.surfaceQuaternary)
        }
    }

    var titleColor: UIColor {
        switch self {
        case .outline:
            return PillButton.outlineStyleTitleColor
        case .filled:
            return PillButton.filledStyleTitleColor
        }
    }

    func selectedTitleColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return PillButton.outlineStyleTitleSelectedColor
        case .filled:
            return UIColor(light: Colors.primary(for: window), dark: PillButton.outlineStyleTitleSelectedColor)
        }
    }

    func disabledTitleColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return Colors.textDisabled
        case .filled:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDisabled)
        }
    }

    func selectedDisabledBackgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return Colors.surfaceQuaternary
        case .filled:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        }
    }

    func selectedDisabledTitleColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.gray500)
        case .filled:
            return UIColor(light: Colors.primaryTint20(for: window), dark: Colors.gray500)
        }
    }
}

// MARK: PillButton

@available(*, deprecated, renamed: "PillButton")
public typealias MSPillButton = PillButton

/// An `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton {

    /// These PillButton constants  are public so that clients can use these colors and cornerRadius to customize their own views containing PillButtons
    @objc public static let outlineStyleBackgroundColor = UIColor(light: Colors.surfaceTertiary, dark: Colors.surfaceSecondary)
    @objc public static let outlineStyleTitleColor = UIColor(light: Colors.textSecondary, dark: Colors.textPrimary)
    @objc public static let outlineStyleTitleSelectedColor = UIColor(light: Colors.textOnAccent, dark: Colors.textDominant)
    @objc public static let filledStyleTitleColor = UIColor(light: Colors.textOnAccent, dark: outlineStyleTitleColor)
    @objc public static let cornerRadius: CGFloat = 16.0

    @objc public let pillBarItem: PillButtonBarItem

    @objc public let style: PillButtonStyle

    public override var isSelected: Bool {
        didSet {
            updateAppearance()
            updateAccessibilityTraits()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateAppearance()
            updateAccessibilityTraits()
        }
    }

    /// Set `backgroundColor` to customize background color of the pill button
    @objc open var customBackgroundColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }
    
    /// Set `selectedBackgroundColor` to customize background color of the pill button
    @objc open var customSelectedBackgroundColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }
    
    /// Set `textColor` to customize background color of the pill button
    @objc open var customTextColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }
    
    /// Set `selectedTextColor` to customize background color of the pill button
    @objc open var customSelectedTextColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }

    @objc public init(pillBarItem: PillButtonBarItem, style: PillButtonStyle = .outline) {
        self.pillBarItem = pillBarItem
        self.style = style
        super.init(frame: .zero)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateAppearance()
    }

    private func setupView() {
        setTitle(pillBarItem.title, for: .normal)
        titleLabel?.font = Constants.font
        layer.cornerRadius = PillButton.cornerRadius
        clipsToBounds = true

        if #available(iOS 13, *) {
            layer.cornerCurve = .continuous
            largeContentTitle = titleLabel?.text
            showsLargeContentViewer = true
        }

        contentEdgeInsets = UIEdgeInsets(top: Constants.topInset,
                                         left: Constants.horizontalInset,
                                         bottom: Constants.bottomInset,
                                         right: Constants.horizontalInset)

    }

    private func updateAccessibilityTraits() {
        if isSelected {
            accessibilityTraits.insert(.selected)
        } else {
            accessibilityTraits.remove(.selected)
        }

        if isEnabled {
            accessibilityTraits.remove(.notEnabled)
        } else {
            accessibilityTraits.insert(.notEnabled)
        }
    }

    private func updateAppearance() {
        if let window = window {
            if isSelected {
                if isEnabled {
                    if let customSelectedBackgroundColor = customSelectedBackgroundColor {
                        backgroundColor = customSelectedBackgroundColor
                    } else {
                        backgroundColor = style.selectedBackgroundColor(for: window)
                    }
                    
                    if let customSelectedTextColor = customSelectedTextColor {
                        setTitleColor(customSelectedTextColor, for: .normal)
                    } else {
                        setTitleColor(style.selectedTitleColor(for: window), for: .normal)
                    }
                } else {
                    backgroundColor = style.selectedDisabledBackgroundColor(for: window)
                    setTitleColor(style.selectedDisabledTitleColor(for: window), for: .normal)
                }
            } else {
                if let customBackgroundColor = customBackgroundColor {
                    backgroundColor = customBackgroundColor
                } else {
                    backgroundColor = style.backgroundColor(for: window)
                }

                if isEnabled {
                    if let customTextColor = customTextColor {
                        setTitleColor(customTextColor, for: .normal)
                    } else {
                        setTitleColor(style.titleColor, for: .normal)
                    }
                } else {
                    setTitleColor(style.disabledTitleColor(for: window), for: .disabled)
                }
            }
        }
    }

    private struct Constants {
        static let bottomInset: CGFloat = 6.0
        static let font: UIFont = Fonts.button4
        static let horizontalInset: CGFloat = 16.0
        static let topInset: CGFloat = 6.0
    }
}
