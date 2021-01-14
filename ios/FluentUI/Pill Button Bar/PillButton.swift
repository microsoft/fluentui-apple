//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton

@available(*, deprecated, renamed: "PillButton")
public typealias MSPillButton = PillButton

/// An `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton {

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

    public override var isHighlighted: Bool {
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

    @objc public init(pillBarItem: PillButtonBarItem, style: PillButtonStyle = .primary) {
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
                        backgroundColor = isHighlighted
                            ? PillButton.selectedHighlightedBackgroundColor(for: window, for: style)
                            : PillButton.selectedBackgroundColor(for: window, for: style)
                    }

                    setTitleColor(customSelectedTextColor ?? PillButton.selectedTitleColor(for: window, for: style), for: .normal)
                    setTitleColor(customSelectedTextColor ?? PillButton.selectedHighlightedTitleColor(for: window, for: style), for: .highlighted)
                } else {
                    backgroundColor = PillButton.selectedDisabledBackgroundColor(for: window, for: style)
                    setTitleColor(PillButton.selectedDisabledTitleColor(for: window, for: style), for: .normal)
                }
            } else {
                if let customBackgroundColor = customBackgroundColor {
                    backgroundColor = customBackgroundColor
                } else {
                    backgroundColor = isEnabled
                        ? (isHighlighted
                            ? PillButton.highlightedBackgroundColor(for: window, for: style)
                            : PillButton.normalBackgroundColor(for: window, for: style))
                        : PillButton.disabledBackgroundColor(for: window, for: style)
                }

                if isEnabled {
                    setTitleColor(customTextColor ?? PillButton.titleColor(for: style), for: .normal)
                    setTitleColor(customTextColor ?? PillButton.highlightedTitleColor(for: window, for: style), for: .highlighted)
                } else {
                    setTitleColor(PillButton.disabledTitleColor(for: window, for: style), for: .disabled)
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
