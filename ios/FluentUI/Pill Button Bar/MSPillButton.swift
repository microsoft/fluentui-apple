//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSPillButtonStyle

@objc public enum MSPillButtonStyle: Int {
    case outline
    case filled

    var backgroundColor: UIColor {
        switch self {
        case .outline:
            return Colors.PillButton.Outline.background
        case .filled:
            return Colors.PillButton.Filled.background
        }
    }

    var selectedBackgroundColor: UIColor {
        switch self {
        case .outline:
           return Colors.PillButton.Outline.backgroundSelected
        case .filled:
           return Colors.PillButton.Filled.backgroundSelected
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

    var selectedTitleColor: UIColor {
        switch self {
        case .outline:
            return  Colors.PillButton.Outline.titleSelected
        case .filled:
            return Colors.PillButton.Filled.titleSelected
        }
    }

    var borderColor: UIColor {
        return  Colors.PillButton.border
    }

    func hasBorder(isSelected: Bool = false, isDarkMode: Bool = false) -> Bool {
        switch self {
        case .outline:
            return !isSelected && !isDarkMode
        case .filled:
            return false
        }
    }
}

// MARK: MSPillButton

/// An `MSPillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
open class MSPillButton: UIButton {
    private struct Constants {
        static let borderWidth: CGFloat = 1.0
        static let bottomInset: CGFloat = 6.0
        static let cornerRadius: CGFloat = 15.0
        static let font: UIFont = Fonts.button4
        static let horizontalInset: CGFloat = 16.0
        static let topInset: CGFloat = 4.0
    }

    public let pillBarItem: MSPillButtonBarItem

    public let style: MSPillButtonStyle

    public override var isSelected: Bool {
        didSet {
            updateAppereance()
            updateAccessibilityTraits()
        }
    }

    public init(pillBarItem: MSPillButtonBarItem, style: MSPillButtonStyle = .outline) {
        self.pillBarItem = pillBarItem
        self.style = style
        super.init(frame: .zero)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorder()
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

        updateAppereance()
    }

    private func updateAccessibilityTraits() {
        if isSelected {
            accessibilityTraits.insert(.selected)
        } else {
            accessibilityTraits.remove(.selected)
        }
    }

    private func updateAppereance() {
        if isSelected {
            backgroundColor = style.selectedBackgroundColor
            setTitleColor(style.selectedTitleColor, for: .normal)
        } else {
            backgroundColor = style.backgroundColor
            setTitleColor(style.titleColor, for: .normal)
        }

        updateBorder()
    }

    private func updateBorder() {
        let isDarkMode: Bool
        if #available(iOS 13, *) {
            isDarkMode = traitCollection.userInterfaceStyle == .dark
        } else {
            isDarkMode = false
        }

        if style.hasBorder(isSelected: isSelected, isDarkMode: isDarkMode) {
            layer.borderWidth = Constants.borderWidth
            layer.borderColor = style.borderColor.cgColor
        } else {
            layer.borderWidth = 0.0
            layer.borderColor = nil
        }
    }
}
