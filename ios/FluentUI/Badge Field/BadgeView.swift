//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeViewDataSource

@available(*, deprecated, renamed: "BadgeViewDataSource")
public typealias MSBadgeViewDataSource = BadgeViewDataSource

@objc(MSFBadgeViewDataSource)
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

// MARK: - Badge Colors

public extension Colors {
    struct Badge {
        public static var background: UIColor = .clear
        public static var backgroundDisabled = UIColor(light: surfaceSecondary, dark: gray700)
        public static var backgroundError = UIColor(light: Palette.dangerTint40.color, dark: Palette.dangerTint30.color)
        public static var backgroundErrorSelected: UIColor = error
        public static var backgroundWarning = UIColor(light: Palette.warningTint40.color, dark: Palette.warningTint30.color)
        public static var backgroundWarningSelected: UIColor = warning
        public static var textSelected: UIColor = textOnAccent
        public static var textDisabled: UIColor = textSecondary
        public static var textError: UIColor = Palette.dangerShade20.color
        public static var textErrorSelected: UIColor = textOnAccent
        public static var textWarning = UIColor(light: Palette.warningShade30.color, dark: Palette.warningPrimary.color)
        public static var textWarningSelected: UIColor = .black
    }
}

// MARK: - BadgeView

/**
 `BadgeView` is used to present text with a colored background in the form of a "badge". It is used in `BadgeField` to represent a selected item.

 `BadgeView` can be selected with a tap gesture and tapped again after entering a selected state for the purpose of displaying more details about the entity represented by the selected badge.
 */

@available(*, deprecated, renamed: "BadgeView")
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

        var labelTextStyle: TextStyle {
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

    private func backgroundColor(for window: UIWindow, style: Style, selected: Bool, enabled: Bool) -> UIColor {
        switch style {
        case .default:
            if !enabled {
                return Colors.Badge.backgroundDisabled
            } else if selected {
                return Colors.primary(for: window)
            } else {
                return Colors.primaryTint40(for: window)
            }
        case .warning:
            if selected {
                return Colors.Badge.backgroundWarningSelected
            } else {
                return Colors.Badge.backgroundWarning
            }
        case .error:
            if selected {
                return Colors.Badge.backgroundErrorSelected
            } else {
                return Colors.Badge.backgroundError
            }
        }
    }

    private func textColor(for window: UIWindow, style: Style, selected: Bool, enabled: Bool) -> UIColor {
        switch style {
        case .default:
            if !enabled {
                return Colors.Badge.textDisabled
            } else if selected {
                return Colors.Badge.textSelected
            } else {
                return Colors.primary(for: window)
            }
        case .warning:
            if selected {
                return Colors.Badge.textWarningSelected
            } else {
                return Colors.Badge.textWarning
            }
        case .error:
            if selected {
                return Colors.Badge.textErrorSelected
            } else {
                return Colors.Badge.textError
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
            updateColors()
            isUserInteractionEnabled = isActive
        }
    }

    @objc open var isSelected: Bool = false {
        didSet {
            updateColors()
            updateAccessibility()
        }
    }
    
    open var labelTextColor: UIColor? {
        didSet {
            if labelTextColor != oldValue {
                updateColors()
            }
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

    private var style: Style = .default {
        didSet {
            updateColors()
        }
    }

    private var size: Size = .medium {
        didSet {
            label.style = size.labelTextStyle
            invalidateIntrinsicContentSize()
        }
    }

    private let backgroundView = UIView()

    private let label = Label()

    @objc public init(dataSource: BadgeViewDataSource) {
        super.init(frame: .zero)

        backgroundView.layer.cornerRadius = Constants.backgroundCornerRadius
        if #available(iOS 13.0, *) {
            backgroundView.layer.cornerCurve = .continuous
        }
        addSubview(backgroundView)

        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        label.backgroundColor = .clear
        addSubview(label)

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
    
    open override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor != oldValue {
                updateColors()
            }
        }
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

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateColors()
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
    
    private func updateColors() {
        updateBackgroundColor()
        updateLabelTextColor()
    }

    private func updateBackgroundColor() {
        if let window = window {
            backgroundView.backgroundColor = backgroundColor ?? backgroundColor(for: window, style: style, selected: isSelected, enabled: isActive)
            super.backgroundColor = Colors.Badge.background
        }
    }

    private func updateLabelTextColor() {
        if let window = window {
            label.textColor = labelTextColor ?? textColor(for: window, style: style, selected: isSelected, enabled: isActive)
        }
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
