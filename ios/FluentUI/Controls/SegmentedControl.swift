//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: SegmentedControl Colors

public extension Colors {
    struct SegmentedControl {
        public struct Tabs {
            public static var background: UIColor = NavigationBar.background
            public static var backgroundDisabled: UIColor = background
            public static var segmentText: UIColor = textSecondary
            public static var segmentTextDisabled: UIColor = surfaceQuaternary
            public static var segmentTextSelectedAndDisabled: UIColor = textDisabled
            public static var selectionDisabled: UIColor = textDisabled
        }

        public struct Switch {
            public static var segmentText = UIColor(light: textOnAccent, dark: textPrimary)
            public static var selection = UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
            public static var selectionDisabled: UIColor = selection
        }
    }
}

// MARK: SegmentedControl

@available(*, deprecated, renamed: "SegmentedControl")
public typealias MSSegmentedControl = SegmentedControl

/// A styled segmented control that should be used instead of UISegmentedControl. It is designed to flex the button width proportionally to the control's width.
@objc(MSFSegmentedControl)
open class SegmentedControl: UIControl {
    @objc(MSFSegmentedControlStyle)
    public enum Style: Int {
        /// Segments are shown as tabs. Selection is indicated by a color of the selected tab's text and by the bar on the bottom edge of the selected tab.
        case tabs
        /// Segments are shows as labels inside a switch. Selection is indicated by a thumb under the selected label.
        case `switch`

        var backgroundHasRoundedCorners: Bool { return self == .switch }
        var segmentsHaveEqualWidth: Bool { return self == .tabs }

        func backgroundColor(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.background
            case .switch:
                return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.surfaceSecondary)
            }
        }
        func backgroundColorDisabled(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.backgroundDisabled
            case .switch:
                return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.surfaceSecondary)
            }
        }
        func selectionColor(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
            case .switch:
                return Colors.SegmentedControl.Switch.selection
            }
        }
        var selectionColorDisabled: UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.selectionDisabled
            case .switch:
                return Colors.SegmentedControl.Switch.selectionDisabled
            }
        }
        var segmentTextColor: UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.segmentText
            case .switch:
                return Colors.SegmentedControl.Switch.segmentText
            }
        }
        func segmentTextColorSelected(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
            case .switch:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
            }
        }
        func segmentTextColorDisabled(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.segmentTextDisabled
            case .switch:
                return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDisabled)
            }
        }
        func segmentTextColorSelectedAndDisabled(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.segmentTextSelectedAndDisabled
            case .switch:
                return UIColor(light: Colors.primaryTint20(for: window), dark: Colors.gray500)
            }
        }

        var segmentTextStyle: TextStyle {
            switch self {
            case .tabs:
                return .subhead
            case .switch:
                return .headline // TODO: update if needed after design is done
            }
        }

        var selectionChangeAnimationDuration: TimeInterval {
            switch self {
            case .tabs:
                return 0.12
            case .switch:
                return 0.2
            }
        }
    }

    private struct Constants {
        static let selectionBarHeight: CGFloat = 1.5
    }

    open override var isEnabled: Bool {
        didSet {
            for button in buttons {
                button.isEnabled = isEnabled
            }
            updateWindowSpecificColors()
        }
    }

    @objc public var isAnimated: Bool = true
    @objc public var numberOfSegments: Int { return items.count }
    @objc public var selectedSegmentIndex: Int {
        get { return _selectedSegmentIndex }
        set { selectSegment(at: newValue, animated: false) }
    }

    private var _selectedSegmentIndex: Int = -1

    private var items = [String]()
    private let style: Style

    private let backgroundView: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.layer.cornerCurve = .continuous
        }
        return view
    }()
    private var buttons = [SegmentedControlButton]()
    private let selectionView: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.layer.cornerCurve = .continuous
        }
        return view
    }()
    private let bottomSeparator = Separator()

    private var isAnimating: Bool = false

    public convenience init() {
        self.init(items: [])
    }

    /// Initializes a segmented control with the specified titles.
    ///
    /// - Parameter items: An array of title strings representing the segments for this control.
    /// - Parameter style: A style used for rendering of the control.
    @objc public init(items: [String], style: Style = .tabs) {
        self.style = style

        super.init(frame: .zero)

        addSubview(backgroundView)
        if style == .switch {
            // Selection view must be under buttons
            addSubview(selectionView)
        }
        addButtons(titles: items)
        if style == .tabs {
            // Separator must be over buttons and selection view on top of everything
            addSubview(bottomSeparator)
            addSubview(selectionView)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Insert new segment at index with the specified title. If a segment exists at that index, it will be inserted before and will therefore take its index.
    ///
    /// - Parameters:
    ///   - title: The title of the newly created segment
    ///   - index: The index at which to insert the newly created segment
    @objc open func insertSegment(withTitle title: String, at index: Int) {
        items.insert(title, at: index)

        let button = createButton(withTitle: title)
        buttons.insert(button, at: index)
        // TODO: Add option for animated addition?
        addSubview(button)
        updateButton(at: index, isSelected: false)

        // Keep selected item selected
        if index <= selectedSegmentIndex {
            _selectedSegmentIndex += 1
        }

        updateAccessibilityHints()
    }

    /// Remove the segment at the appropriate index. If there are only 2 segments in the control, or if no segment exists at the index, this method is ignored. If the segment is currently selected, we change the selection
    ///
    /// - Parameters:
    ///   - index: The index of the segment to be removed.
    @objc open func removeSegment(at index: Int) {
        guard index < items.count, numberOfSegments > 2 else {
            return
        }

        // If the to-be-removed item is selected, move the selection to the item before if possible, or after if not possible.
        if index == selectedSegmentIndex {
            if index == 0 {
                selectedSegmentIndex += 1
            } else {
                selectedSegmentIndex -= 1
            }
        }

        items.remove(at: index)
        // TODO: Add option for animated removal?
        buttons.remove(at: index).removeFromSuperview()

        // Keep selected item selected
        if index <= selectedSegmentIndex {
            _selectedSegmentIndex -= 1
        }

        updateAccessibilityHints()
    }

    /// Select segment at index
    /// Warning: when called, handlers on UIControlEvents.ValueChanged are not called
    ///
    /// - Parameters:
    ///   - index: The index of the segment to set as selected
    ///   - animated: Whether or not to animate the change in selected segment
    @objc open func selectSegment(at index: Int, animated: Bool) {
        precondition(index >= 0 && index < buttons.count, "SegmentedControl > try to selected segment index with invalid index: \(index)")

        if index == _selectedSegmentIndex {
            return
        }

        // Unselect old button
        if _selectedSegmentIndex != -1 {
            updateButton(at: _selectedSegmentIndex, isSelected: false)
        }

        // Select new button
        updateButton(at: index, isSelected: true)
        _selectedSegmentIndex = index

        if animated {
            updateBackgroundView(adjustForSelection: false)
            isAnimating = true
            UIView.animate(withDuration: style.selectionChangeAnimationDuration, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.layoutSelectionView()
            }, completion: { _ in
                self.isAnimating = false
                self.updateBackgroundView(adjustForSelection: true)
            })
        } else {
            setNeedsLayout()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if isAnimating {
            return
        }

        var rightOffset: CGFloat = 0
        var leftOffset: CGFloat = 0
        for (index, button) in buttons.enumerated() {
            if style.segmentsHaveEqualWidth {
                rightOffset = UIScreen.main.roundToDevicePixels(CGFloat(index + 1) / CGFloat(buttons.count) * frame.width)
            } else {
                let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                rightOffset = leftOffset + UIScreen.main.roundToDevicePixels(button.sizeThatFits(maxSize).width)
            }
            button.frame = CGRect(x: leftOffset, y: 0, width: rightOffset - leftOffset, height: frame.height)
            leftOffset = rightOffset
        }

        bottomSeparator.frame = CGRect(x: 0, y: frame.height - bottomSeparator.frame.height, width: frame.width, height: bottomSeparator.frame.height)

        layoutSelectionView()

        flipSubviewsForRTL()

        updateBackgroundView(adjustForSelection: true)
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxButtonHeight: CGFloat = 0.0
        var maxButtonWidth: CGFloat = 0.0
        var buttonsWidth: CGFloat = 0.0

        for button in buttons {
            let size = button.sizeThatFits(size)

            maxButtonHeight = max(maxButtonHeight, UIScreen.main.roundToDevicePixels(size.height))
            if style.segmentsHaveEqualWidth {
                maxButtonWidth = max(maxButtonWidth, UIScreen.main.roundToDevicePixels(size.width))
            } else {
                buttonsWidth += UIScreen.main.roundToDevicePixels(size.width)
            }
        }

        let fittingSize = CGSize(
            width: style.segmentsHaveEqualWidth ? maxButtonWidth * CGFloat(buttons.count) : buttonsWidth,
            height: maxButtonHeight
        )

        return CGSize(width: min(fittingSize.width, size.width), height: min(fittingSize.height, size.height))
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateWindowSpecificColors()
    }

    func intrinsicContentSizeInvalidatedForChildView() {
        invalidateIntrinsicContentSize()
    }

    private func addButtons(titles: [String]) {
        // Create buttons
        for (index, title) in titles.enumerated() {
            insertSegment(withTitle: title, at: index)
        }

        // Select first button
        if !titles.isEmpty {
            selectSegment(at: 0, animated: false)
        }
    }

    private func createButton(withTitle title: String) -> SegmentedControlButton {
        let button = SegmentedControlButton(style: style)
        button.setTitle(title, for: .normal)
        button.accessibilityLabel = title
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        return button
    }

    @objc private func handleButtonTap(_ sender: SegmentedControlButton) {
        if let index = buttons.firstIndex(of: sender), selectedSegmentIndex != index {
            selectSegment(at: index, animated: isAnimated)
            sendActions(for: .valueChanged)
        }
    }

    private func updateBackgroundView(adjustForSelection: Bool) {
        let cornerRadius = style.backgroundHasRoundedCorners ? bounds.height / 2 : 0

        backgroundView.layer.cornerRadius = cornerRadius

        var frame = bounds
        if adjustForSelection && cornerRadius != 0 {
            if selectedSegmentIndex == 0 {
                frame = frame.inset(by: UIEdgeInsets(top: 0, left: cornerRadius, bottom: 0, right: 0))
            }
            if selectedSegmentIndex == numberOfSegments - 1 {
                frame = frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cornerRadius))
            }
        }
        backgroundView.frame = frame

        backgroundView.flipForRTL()
    }

    private func updateButton(at index: Int, isSelected: Bool) {
        guard index <= buttons.count else {
            return
        }

        let button = buttons[index]
        button.isSelected = isSelected
    }

    private func layoutSelectionView() {
        guard selectedSegmentIndex != -1 else {
            return
        }
        let button = buttons[selectedSegmentIndex]

        switch style {
        case .tabs:
            selectionView.frame = CGRect(
                x: button.frame.origin.x,
                y: button.frame.maxY - Constants.selectionBarHeight,
                width: button.frame.width,
                height: Constants.selectionBarHeight
            )
        case .switch:
            selectionView.frame = button.frame
            selectionView.layer.cornerRadius = selectionView.frame.height / 2
        }
    }

    private func updateAccessibilityHints() {
        for (index, button) in buttons.enumerated() {
            button.accessibilityHint = String.localizedStringWithFormat("Accessibility.MSPillButtonBar.Hint".localized, index + 1, items.count)
        }
    }

    private func updateWindowSpecificColors() {
        if let window = window {
            selectionView.backgroundColor = isEnabled ? style.selectionColor(for: window) : style.selectionColorDisabled
            backgroundView.backgroundColor = isEnabled ? style.backgroundColor(for: window) : style.backgroundColorDisabled(for: window)
        }
    }
}

// MARK: - SegmentedControlButton

private class SegmentedControlButton: UIButton {
    private struct Constants {
        static let contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 13, right: 12)
        static let contentEdgeInsetsForSwitch = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
    }

    private let style: SegmentedControl.Style

    init(style: SegmentedControl.Style) {
        self.style = style

        super.init(frame: .zero)

        contentEdgeInsets = style == .switch ? Constants.contentEdgeInsetsForSwitch : Constants.contentEdgeInsets
        titleLabel?.lineBreakMode = .byTruncatingTail
        setTitleColor(style.segmentTextColor, for: .normal)
        updateFont()

        NotificationCenter.default.addObserver(self, selector: #selector(updateFont), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        (superview as? SegmentedControl)?.intrinsicContentSizeInvalidatedForChildView()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = window {
            setTitleColor(style.segmentTextColorDisabled(for: window), for: .disabled)
            setTitleColor(style.segmentTextColorSelected(for: window), for: .selected)
            setTitleColor(style.segmentTextColorSelectedAndDisabled(for: window), for: [.selected, .disabled])
        }
    }

    @objc private func updateFont() {
        titleLabel?.font = style.segmentTextStyle.font
    }
}
