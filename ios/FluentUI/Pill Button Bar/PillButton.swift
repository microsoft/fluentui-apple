//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton Colors

public extension Colors {
    struct PillButton {
        public struct Outline {
            public static var background = UIColor(light: surfaceTertiary, dark: surfaceSecondary)
            public static var title = UIColor(light: textSecondary, dark: textPrimary)
            public static var titleSelected = UIColor(light: textOnAccent, dark: textDominant)
        }
        public struct Filled {
            public static var title = UIColor(light: textOnAccent, dark: Outline.title)
        }
    }
}

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
            return Colors.PillButton.Outline.background
        case .filled:
            return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.PillButton.Outline.background)
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

    var titleColor: UIColor {
        switch self {
        case .outline:
            return Colors.PillButton.Outline.title
        case .filled:
            return Colors.PillButton.Filled.title
        }
    }

    func selectedTitleColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return  Colors.PillButton.Outline.titleSelected
        case .filled:
            return UIColor(light: Colors.primary(for: window), dark: Colors.PillButton.Outline.titleSelected)
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
    private struct Constants {
        static let bottomInset: CGFloat = 6.0
        static let cornerRadius: CGFloat = 16.0
        static let font: UIFont = Fonts.button4
        static let horizontalInset: CGFloat = 16.0
        static let topInset: CGFloat = 6.0
    }

    private var useCustomBackgroundColor: Bool = false

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
    @objc open var customBackgroundColor: UIColor = Colors.Drawer.background {
        didSet {
            useCustomBackgroundColor = true
            self.backgroundColor = customBackgroundColor
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
        layer.cornerRadius = Constants.cornerRadius
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
                    backgroundColor = style.selectedBackgroundColor(for: window)
                    setTitleColor(style.selectedTitleColor(for: window), for: .normal)
                } else {
                    backgroundColor = style.selectedDisabledBackgroundColor(for: window)
                    setTitleColor(style.selectedDisabledTitleColor(for: window), for: .normal)
                }
            } else {
                if useCustomBackgroundColor {
                    backgroundColor = customBackgroundColor
                } else {
                    backgroundColor = style.backgroundColor(for: window)
                }
                if isEnabled {
                    setTitleColor(style.titleColor, for: .normal)
                } else {
                    setTitleColor(style.disabledTitleColor(for: window), for: .disabled)
                }
            }
        }
    }
}
