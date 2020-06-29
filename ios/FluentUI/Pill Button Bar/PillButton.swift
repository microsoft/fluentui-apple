//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButtonStyle

@available(*, deprecated, renamed: "PillButtonStyle")
public typealias MSPillButtonStyle = PillButtonStyle

@objc(MSFPillButtonStyle)
public enum PillButtonStyle: Int {
    case outline
    case filled
    case transparent

    func backgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return Colors.PillButton.Outline.background
        case .filled:
            return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.PillButton.Outline.background)
        case .transparent:
            return .clear
        }
    }

    func selectedBackgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outline:
            return UIColor(light: Colors.primary(for: window), dark: Colors.surfaceQuaternary)
        case .filled:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        case .transparent:
            return Colors.primaryTint40(for: window)
        }
    }

    var titleColor: UIColor {
        switch self {
        case .outline, .transparent:
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
        case .transparent:
            return UIColor(light: Colors.primary(for: window), dark: Colors.primaryShade10(for: window))
        }
    }
    
    func font() -> UIFont {
        switch self {
        case .outline, .filled:
            return Fonts.button4
        case .transparent:
            return Fonts.button1
        }
    }
    
    func selectedFont() -> UIFont {
        switch self {
        case .outline, .filled:
            return Fonts.button4
        case .transparent:
            return Fonts.preferredFont(forTextStyle: .subheadline, weight: .bold)
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
        static let horizontalInset: CGFloat = 16.0
        static let topInset: CGFloat = 6.0
    }

    @objc public let pillBarItem: PillButtonBarItem

    @objc public let style: PillButtonStyle

    public override var isSelected: Bool {
        didSet {
            updateAppearance()
            updateAccessibilityTraits()
            updateFont()
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
        titleLabel?.font = style.font()
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
    }

    private func updateAppearance() {
        if let window = window {
            backgroundColor = isSelected ? style.selectedBackgroundColor(for: window) : style.backgroundColor(for: window)

            if isSelected {
                setTitleColor(style.selectedTitleColor(for: window), for: .normal)
            } else {
                setTitleColor(style.titleColor, for: .normal)
            }
        }
    }
    
    private func updateFont() {
        titleLabel?.font = isSelected ? style.selectedFont() : style.font()
    }
}
