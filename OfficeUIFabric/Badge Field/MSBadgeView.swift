//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSBadgeViewDataSource

open class MSBadgeViewDataSource: NSObject {
    @objc open private(set) var text: String
    public var style: MSBadgeViewStyle

    @objc public init(text: String, style: MSBadgeViewStyle) {
        self.text = text
        self.style = style
        super.init()
    }
}

// MARK: - MSBadgeViewStyle

@objc public enum MSBadgeViewStyle: Int {
    case `default`
    case warning
    case error
}

// MARK: - MSBadgeViewDelegate

@objc public protocol MSBadgeViewDelegate {
    func didSelectBadge(_ badge: MSBadgeView)
    func didTapSelectedBadge(_ badge: MSBadgeView)
}

// MARK: - MSBadgeView

/**
 `MSBadgeView` is used to present text with a colored background in the form of a "badge". It is used in `MSBadgeField` to represent a selected item.

 `MSBadgeView` can be selected with a tap gesture and tapped again after entering a selected state for the purpose of displaying more details about the entity represented by the selected badge.
 */
open class MSBadgeView: UIView {
    private struct Constants {
        static let defaultMinWidth: CGFloat = 25
        static let backgroundViewCornerRadius: CGFloat = 2
        static let labelFont: UIFont = MSFonts.subhead
        static let paddingHorizontal: CGFloat = 5
        static let paddingVertical: CGFloat = 4
    }

    open class var defaultHeight: CGFloat {
        return Constants.paddingVertical + Constants.labelFont.deviceLineHeight + Constants.paddingVertical
    }

    private static func backgroundColor(for style: MSBadgeViewStyle, selected: Bool, enabled: Bool) -> UIColor {
        switch style {
        case .default:
            if !enabled {
                return MSColors.Badge.backgroundDisabled
            } else if selected {
                return MSColors.Badge.backgroundSelected
            } else {
                return MSColors.Badge.background
            }
        case .warning:
            if selected {
                return MSColors.Badge.backgroundWarningSelected
            } else {
                return MSColors.Badge.backgroundWarning
            }
        case .error:
            if selected {
                return MSColors.Badge.backgroundErrorSelected
            } else {
                return MSColors.Badge.backgroundError
            }
        }
    }

    private static func textColor(for style: MSBadgeViewStyle, selected: Bool, enabled: Bool) -> UIColor {
        switch style {
        case .default:
            if !enabled {
                return MSColors.Badge.textDisabled
            } else if selected {
                return MSColors.Badge.textSelected
            } else {
                return MSColors.Badge.text
            }
        case .warning:
            if selected {
                return MSColors.Badge.textWarningSelected
            } else {
                return MSColors.Badge.textWarning
            }
        case .error:
            if selected {
                return MSColors.Badge.textErrorSelected
            } else {
                return MSColors.Badge.textError
            }
        }
    }

    @objc open var dataSource: MSBadgeViewDataSource? {
        didSet {
            reload()
        }
    }

    open weak var delegate: MSBadgeViewDelegate?

    open var isEnabled: Bool = true {
        didSet {
            updateBackgroundColor()
            updateLabelTextColor()
            accessibilityHint = nil
            isUserInteractionEnabled = isEnabled
        }
    }

    open var isSelected: Bool = false {
        didSet {
            updateBackgroundColor()
            updateLabelTextColor()
            updateAccessibility()
        }
    }

    open var minWidth: CGFloat = Constants.defaultMinWidth {
        didSet {
            setNeedsLayout()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    private var badgeBackgroundColor: UIColor = MSColors.Badge.background {
        didSet {
            updateBackgroundColor()
        }
    }
    private var badgeSelectedBackgroundColor: UIColor = MSColors.Badge.backgroundSelected {
        didSet {
            updateBackgroundColor()
        }
    }
    private var badgeDisabledBackgroundColor: UIColor = MSColors.Badge.backgroundDisabled {
        didSet {
            updateBackgroundColor()
        }
    }

    private var style: MSBadgeViewStyle = .default {
        didSet {
            badgeBackgroundColor = MSBadgeView.backgroundColor(for: style, selected: false, enabled: true)
            badgeSelectedBackgroundColor = MSBadgeView.backgroundColor(for: style, selected: true, enabled: true)
            badgeDisabledBackgroundColor = MSBadgeView.backgroundColor(for: style, selected: false, enabled: false)

            textColor = MSBadgeView.textColor(for: style, selected: false, enabled: true)
            selectedTextColor = MSBadgeView.textColor(for: style, selected: true, enabled: true)
            disabledTextColor = MSBadgeView.textColor(for: style, selected: false, enabled: false)
        }
    }

    private var textColor: UIColor = MSColors.Badge.text {
        didSet {
            updateLabelTextColor()
        }
    }
    private var selectedTextColor: UIColor = MSColors.Badge.textSelected {
        didSet {
            updateLabelTextColor()
        }
    }
    private var disabledTextColor: UIColor = MSColors.Badge.textDisabled {
        didSet {
            updateLabelTextColor()
        }
    }

    private let backgroundView = UIView()

    private let label = UILabel()

    public init() {
        super.init(frame: .zero)

        backgroundView.layer.cornerRadius = Constants.backgroundViewCornerRadius
        addSubview(backgroundView)
        updateBackgroundColor()

        label.font = Constants.labelFont
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        label.backgroundColor = .clear
        addSubview(label)
        updateLabelTextColor()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(badgeTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        isAccessibilityElement = true
        accessibilityTraits = .button
        updateAccessibility()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds

        let labelHeight = label.font.deviceLineHeight
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let fittingLabelWidth = UIScreen.main.roundToDevicePixels(labelSize.width)
        let minLabelWidth = minWidth - 2 * Constants.paddingHorizontal
        let maxLabelWidth = width - 2 * Constants.paddingHorizontal
        let labelWidth = max(minLabelWidth, min(maxLabelWidth, fittingLabelWidth))
        label.frame = CGRect(x: Constants.paddingHorizontal, y: Constants.paddingVertical, width: labelWidth, height: labelHeight)
    }

    open func reload() {
        label.text = dataSource?.text
        style = dataSource?.style ?? .default
        setNeedsLayout()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let fittingLabelWidth = UIScreen.main.roundToDevicePixels(labelSize.width)
        let horizontalPadding = 2 * Constants.paddingHorizontal
        let labelWidth = max(min(fittingLabelWidth, size.width), minWidth - horizontalPadding)
        return CGSize(width: labelWidth + horizontalPadding, height: MSBadgeView.defaultHeight)
    }

    private func updateAccessibility() {
        if isSelected {
            accessibilityValue = "Accessibility.Selected.Value".localized
            accessibilityHint = "Accessibility.Selected.Hint".localized
        } else {
            accessibilityValue = nil
            accessibilityHint = "Accessibility.Select.Hint".localized
        }
    }

    private func updateBackgroundColor() {
        if !isEnabled {
            backgroundView.backgroundColor = badgeDisabledBackgroundColor
            return
        }
        backgroundView.backgroundColor = isSelected ? badgeSelectedBackgroundColor : badgeBackgroundColor
    }

    private func updateLabelTextColor() {
        if !isEnabled {
            label.textColor = disabledTextColor
            return
        }

        label.textColor = isSelected ? selectedTextColor : textColor
    }

    @objc private func badgeTapped() {
        if isSelected {
            delegate?.didTapSelectedBadge(self)
        } else {
            isSelected = true
            delegate?.didSelectBadge(self)
        }
    }

    // MARK: Accessibility

    open override var accessibilityLabel: String? { get { return label.text } set { } }
}
