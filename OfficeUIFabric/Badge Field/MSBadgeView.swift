//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSBadgeViewStyle

@objc public enum MSBadgeViewStyle: Int {
    case `default`
    case warning
    case error
}

// MARK: - MSBadgeViewDataSource

open class MSBadgeViewDataSource: MSBadgeBaseViewDataSource {
    public var style: MSBadgeViewStyle

    @objc public init(text: String, style: MSBadgeViewStyle) {
        self.style = style
        super.init(text: text)
    }
}

// MARK: - MSBadgeView

/**
 `MSBadgeView` is used to present text with a colored background supplied by `MSBadgeBaseView` in the form of a "badge". It is used in `MSBadgeListField` to represent a selected item from `MSPersonaListView`.

 `MSBadgeView` can be selected with a tap gesture and tapped again after entering a selected state for the purpose of displaying more details about the entity represented by the selected badge.
 */
open class MSBadgeView: MSBadgeBaseView {
    private struct Constants {
        static let labelFont: UIFont = MSFonts.subhead
        static let paddingHorizontal: CGFloat = 5
        static let paddingVertical: CGFloat = 4
    }

    open override class var defaultHeight: CGFloat {
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

    open var badgeViewDataSource: MSBadgeViewDataSource? { return dataSource as? MSBadgeViewDataSource }

    open override var isEnabled: Bool {
        didSet {
            updateLabelTextColor()
        }
    }

    open override var isSelected: Bool {
        didSet {
            updateLabelTextColor()
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

    private let label = UILabel()

    public override init() {
        super.init()

        label.font = Constants.labelFont
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        label.backgroundColor = .clear
        addSubview(label)

        updateLabelTextColor()
        isAccessibilityElement = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func reload() {
        label.text = dataSource?.text
        style = badgeViewDataSource?.style ?? .default
        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let labelHeight = label.font.deviceLineHeight
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let fittingLabelWidth = UIScreen.main.roundToDevicePixels(labelSize.width)
        let minLabelWidth = minWidth - 2 * Constants.paddingHorizontal
        let maxLabelWidth = width - 2 * Constants.paddingHorizontal
        let labelWidth = max(minLabelWidth, min(maxLabelWidth, fittingLabelWidth))
        label.frame = CGRect(x: Constants.paddingHorizontal, y: Constants.paddingVertical, width: labelWidth, height: labelHeight)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let fittingLabelWidth = UIScreen.main.roundToDevicePixels(labelSize.width)
        let horizontalPadding = 2 * Constants.paddingHorizontal
        let labelWidth = max(min(fittingLabelWidth, size.width), minWidth - horizontalPadding)
        return CGSize(width: labelWidth + horizontalPadding, height: MSBadgeView.defaultHeight)
    }

    private func updateLabelTextColor() {
        if !isEnabled {
            label.textColor = disabledTextColor
            return
        }

        label.textColor = isSelected ? selectedTextColor : textColor
    }

    // MARK: Accessibility

    open override var accessibilityLabel: String? { get { return label.text } set { } }
}
