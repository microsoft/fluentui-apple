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

    @objc public let pillBarItem: PillButtonBarItem

    @objc public let style: PillButtonStyle

    public override var isSelected: Bool {
        didSet {
            updateAppereance()
            updateAccessibilityTraits()
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
    }
}
