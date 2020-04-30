//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeViewDataSource
@available(*, deprecated, renamed: "BadgeViewDataSource")
public typealias MSBadgeViewDataSource = BadgeViewDataSource

open class BadgeViewDataSource: NSObject {
    @objc open var text: String
    @objc open var style: BadgeView.Style
    @objc open var size: BadgeView.Size

    @objc public init(text: String, style: BadgeView.Style = .default, size: BadgeView.Size = .medium) {
        self.text = text
        self.style = style
        self.size = size
        super.init()
    }
}

// MARK: - BadgeViewDelegate
@available(*, deprecated, renamed: "BadgeViewDelegate")
public typealias MSBadgeViewDelegate = BadgeViewDelegate

@objc(MSFBadgeViewDelegate)
public protocol BadgeViewDelegate {
    func didSelectBadge(_ badge: BadgeView)
    func didTapSelectedBadge(_ badge: BadgeView)
}

// MARK: - BadgeView

/**
 `BadgeView` is used to present text with a colored background in the form of a "badge". It is used in `BadgeField` to represent a selected item.

 `BadgeView` can be selected with a tap gesture and tapped again after entering a selected state for the purpose of displaying more details about the entity represented by the selected badge.
 */

@available(*, deprecated, renamed: "MSBadgeView")
public typealias MSBadgeView = BadgeView

@objc(MSFBadgeView)
open class BadgeView: UIView {
    @objc(MSFBadgeViewStyle)
    public enum Style: Int {
        case `default`
        case warning
        case error
    }

    @objc(MSFBadgeViewSize)
    public enum Size: Int, CaseIterable {
        case small
        case medium

        var labelTextStyle: MSTextStyle {
            switch self {
            case .small:
                return .footnote
            case .medium:
                return .subhead
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small:
                return 4
            case .medium:
                return 5
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small:
                return 1.5
            case .medium:
                return 4
            }
        }

        var height: CGFloat {
            return verticalPadding + labelTextStyle.font.deviceLineHeight + verticalPadding
        }
    }

    private struct Constants {
        static let defaultMinWidth: CGFloat = 25
        static let backgroundCornerRadius: CGFloat = 3
    }

    private static func backgroundColor(for style: Style, selected: Bool, enabled: Bool) -> UIColor {
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

    private static func textColor(for style: Style, selected: Bool, enabled: Bool) -> UIColor {
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

    @objc open var dataSource: BadgeViewDataSource? {
        didSet {
            reload()
        }
    }

    @objc open weak var delegate: BadgeViewDelegate?

    @objc open var isActive: Bool = true {
        didSet {
            updateBackgroundColor()
            updateLabelTextColor()
            accessibilityHint = nil
            isUserInteractionEnabled = isActive
        }
    }

    @objc open var isSelected: Bool = false {
        didSet {
            updateBackgroundColor()
            updateLabelTextColor()
            updateAccessibility()
        }
    }

    @objc open var minWidth: CGFloat = Constants.defaultMinWidth {
        didSet {
            setNeedsLayout()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
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

    private var style: Style = .default {
        didSet {
            badgeBackgroundColor = BadgeView.backgroundColor(for: style, selected: false, enabled: true)
            badgeSelectedBackgroundColor = BadgeView.backgroundColor(for: style, selected: true, enabled: true)
            badgeDisabledBackgroundColor = BadgeView.backgroundColor(for: style, selected: false, enabled: false)

            textColor = BadgeView.textColor(for: style, selected: false, enabled: true)
            selectedTextColor = BadgeView.textColor(for: style, selected: true, enabled: true)
            disabledTextColor = BadgeView.textColor(for: style, selected: false, enabled: false)
        }
    }

    private var size: Size = .medium {
        didSet {
            label.style = size.labelTextStyle
            invalidateIntrinsicContentSize()
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

    private let label = Label()

    public init(dataSource: BadgeViewDataSource) {
        super.init(frame: .zero)

        backgroundView.layer.cornerRadius = Constants.backgroundCornerRadius
        if #available(iOS 13.0, *) {
            backgroundView.layer.cornerCurve = .continuous
        }
        addSubview(backgroundView)
        updateBackgroundColor()

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

        NotificationCenter.default.addObserver(self, selector: #selector(invalidateIntrinsicContentSize), name: UIContentSizeCategory.didChangeNotification, object: nil)

        defer {
            self.dataSource = dataSource
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds

        let labelHeight = label.font.deviceLineHeight
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
        let fittingLabelWidth = UIScreen.main.roundToDevicePixels(labelSize.width)

        let minLabelWidth = minWidth - size.horizontalPadding * 2
        let maxLabelWidth = frame.width - size.horizontalPadding * 2
        let labelWidth = max(minLabelWidth, min(maxLabelWidth, fittingLabelWidth))
        label.frame = CGRect(x: size.horizontalPadding, y: size.verticalPadding, width: labelWidth, height: labelHeight)
    }

    open func reload() {
        label.text = dataSource?.text
        style = dataSource?.style ?? .default
        size = dataSource?.size ?? .medium
        setNeedsLayout()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
        let width = UIScreen.main.roundToDevicePixels(labelSize.width) + self.size.horizontalPadding * 2
        let maxWidth = size.width > 0 ? size.width : .infinity
        return CGSize(width: max(minWidth, min(width, maxWidth)), height: self.size.height)
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
        if !isActive {
            backgroundView.backgroundColor = badgeDisabledBackgroundColor
            return
        }
        backgroundView.backgroundColor = isSelected ? badgeSelectedBackgroundColor : badgeBackgroundColor
    }

    private func updateLabelTextColor() {
        if !isActive {
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
