//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

// MARK: SegmentedControl Colors
public extension Colors {
    struct SegmentedControl {
        struct Tabs {
            static let background: UIColor = NavigationBar.background
            static let backgroundDisabled: UIColor = background
            static let segmentText: UIColor = textSecondary
            static let segmentTextDisabled: UIColor = surfaceQuaternary
            static let segmentTextSelectedAndDisabled: UIColor = textDisabled
            static let selectionDisabled: UIColor = textDisabled
        }

        struct PrimaryPill {
            static let background = UIColor(light: surfaceTertiary, dark: surfaceSecondary)
            static let backgroundDisabled: UIColor = background
            static let segmentText = UIColor(light: textSecondary, dark: textPrimary)
            static let selectionDisabled: UIColor = surfaceQuaternary
        }

        struct OnBrandPill {
            static let background = UIColor(light: surfaceTertiary, dark: surfaceSecondary)
            static let backgroundDisabled: UIColor = background
            static let segmentText = UIColor(light: textOnAccent, dark: textPrimary)
            static let selection = UIColor(light: surfacePrimary, dark: surfaceQuaternary)
            static let selectionDisabled = UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
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
        /// Deprecated. Segments are shown as tabs. Selection is indicated by a color of the selected tab's text and by the bar on the bottom edge of the selected tab.
        case tabs
        /// Segments are shows as labels inside a pill for use with a neutral or white background. Selection is indicated by a thumb under the selected label.
        case primaryPill
        /// Segments are shows as labels inside a pill for use on a branded background that features a prominent brand color in light mode and a muted grey in dark mode.
        /// Selection is indicated by a thumb under the selected label.
        case onBrandPill

        var backgroundHasRoundedCorners: Bool { return self == .primaryPill || self == .onBrandPill }

        func backgroundColor(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.background
            case .primaryPill:
                return Colors.SegmentedControl.PrimaryPill.background
            case .onBrandPill:
                return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.SegmentedControl.OnBrandPill.background)
            }
        }
        func backgroundColorDisabled(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.backgroundDisabled
            case .primaryPill:
                return Colors.SegmentedControl.PrimaryPill.backgroundDisabled
            case .onBrandPill:
                return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.SegmentedControl.OnBrandPill.backgroundDisabled)
            }
        }
        func selectionColor(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
            case .primaryPill:
                return Colors.primary(for: window)
            case .onBrandPill:
                return Colors.SegmentedControl.OnBrandPill.selection
            }
        }
        var selectionColorDisabled: UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.selectionDisabled
            case .primaryPill:
                return Colors.SegmentedControl.PrimaryPill.selectionDisabled
            case .onBrandPill:
                return Colors.SegmentedControl.OnBrandPill.selectionDisabled
            }
        }
        var segmentTextColor: UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.segmentText
            case .primaryPill:
                return Colors.SegmentedControl.PrimaryPill.segmentText
            case .onBrandPill:
                return Colors.SegmentedControl.OnBrandPill.segmentText
            }
        }
        func segmentTextColorSelected(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
            case .primaryPill:
                return Colors.textOnAccent
            case .onBrandPill:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
            }
        }
        func segmentTextColorDisabled(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.segmentTextDisabled
            case .primaryPill:
                return Colors.textDisabled
            case .onBrandPill:
                return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDisabled)
            }
        }
        func segmentTextColorSelectedAndDisabled(for window: UIWindow) -> UIColor {
            switch self {
            case .tabs:
                return Colors.SegmentedControl.Tabs.segmentTextSelectedAndDisabled
            case .primaryPill:
                return UIColor(light: Colors.surfacePrimary, dark: Colors.gray500)
            case .onBrandPill:
                return UIColor(light: Colors.primaryTint20(for: window), dark: Colors.gray500)
            }
        }

        var segmentTextFont: UIFont {
            switch self {
            case .tabs:
                return TextStyle.subhead.font
            case .primaryPill, .onBrandPill:
                return UIFont.systemFont(ofSize: 16, weight: .regular)
            }
        }

        var selectionChangeAnimationDuration: TimeInterval {
            switch self {
            case .tabs:
                return 0.12
            case .primaryPill, .onBrandPill:
                return 0.2
            }
        }
    }

    private struct Constants {
        static let selectionBarHeight: CGFloat = 1.5
        static let pillHorizontalInset: CGFloat = 16
        static let pillButtonInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
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
    @objc public var shouldSetEqualWidthForSegments: Bool = true
    @objc public var selectedSegmentIndex: Int {
        get { return _selectedSegmentIndex }
        set { selectSegment(at: newValue, animated: false) }
    }

    private var _selectedSegmentIndex: Int = -1
    private var customSegmentedControlBackgroundColor: UIColor?
    private var customSegmentedControlSelectedButtonBackgroundColor: UIColor?
    private var customSegmentedControlButtonTextColor: UIColor?
    private var customSelectedSegmentedControlButtonTextColor: UIColor?

    private var items = [String]()
    private let style: Style

    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous

        return view
    }()
    private var buttons = [UIButton]()
    private let selectionView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous

        return view
    }()
    private let bottomSeparator = Separator()
    private let pillContainerView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let pillMaskedLabelLayerView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        return view
    }()
    private var pillMaskedLabels = [UILabel]()
    private var pillMaskedLabelsConstraints = [[NSLayoutConstraint]]()

    private var isAnimating: Bool = false

    public convenience init() {
        self.init(items: [])
    }

    /// Initializes a segmented control with the specified titles.
    ///
    /// - Parameter items: An array of title strings representing the segments for this control.
    /// - Parameter style: A style used for rendering of the control.
    @objc public convenience init(items: [String], style: Style = .tabs) {
        self.init(items: items,
                  style: style,
                  customSegmentedControlBackgroundColor: nil,
                  customSegmentedControlSelectedButtonBackgroundColor: nil,
                  customSegmentedControlButtonTextColor: nil,
                  customSelectedSegmentedControlButtonTextColor: nil)
    }

    /// Initializes a segmented control with the specified titles, style, and colors (colors are for pill styles only).
    ///
    /// - Parameter items: An array of title strings representing the segments for this control.
    /// - Parameter style: A style used for rendering of the control.
    /// - Parameter customSegmentedControlBackgroundColor: UIColor to use as the background color
    /// - Parameter customSegmentedControlSelectedButtonBackgroundColor: UIColor to use as the selected button background color
    /// - Parameter customSegmentedControlButtonTextColor: UIColor to use as the unselected button text color
    /// - Parameter customSelectedSegmentedControlButtonTextColor: UIColor to use as the selected button text color
    @objc public init(items: [String],
                      style: Style = .tabs,
                      customSegmentedControlBackgroundColor: UIColor? = nil,
                      customSegmentedControlSelectedButtonBackgroundColor: UIColor? = nil,
                      customSegmentedControlButtonTextColor: UIColor? = nil,
                      customSelectedSegmentedControlButtonTextColor: UIColor? = nil) {
        self.style = style
        self.customSegmentedControlBackgroundColor = customSegmentedControlBackgroundColor
        self.customSegmentedControlSelectedButtonBackgroundColor = customSegmentedControlSelectedButtonBackgroundColor
        self.customSegmentedControlButtonTextColor = customSegmentedControlButtonTextColor
        self.customSelectedSegmentedControlButtonTextColor = customSelectedSegmentedControlButtonTextColor

        super.init(frame: .zero)

        if style == .primaryPill || style == .onBrandPill {
            pillContainerView.addSubview(backgroundView)
            addButtons(titles: items)
            selectionView.backgroundColor = .black
            pillContainerView.addSubview(selectionView)
            pillMaskedLabelLayerView.mask = selectionView
            pillMaskedLabelLayerView.isUserInteractionEnabled = false
            pillContainerView.addSubview(pillMaskedLabelLayerView)
            pillContainerView.addInteraction(UILargeContentViewerInteraction())
            addSubview(pillContainerView)
        }
        if style == .tabs {
            addSubview(backgroundView)
            addButtons(titles: items)
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

        var button = UIButton()
        // TODO: Add option for animated addition?
        if style == .tabs {
            button = createTabButton(withTitle: title)
            addSubview(button)
        } else {
            button = createSwitchButton(withTitle: title)
            pillContainerView.addSubview(button)
            addMaskedPillLabel(over: button, at: index)
        }
        buttons.insert(button, at: index)
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
        if style != .tabs {
            pillMaskedLabels.remove(at: index).removeFromSuperview()
            pillMaskedLabelsConstraints.remove(at: index)
        }

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
            isAnimating = true
            UIView.animate(withDuration: style.selectionChangeAnimationDuration, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.layoutSelectionView()
            }, completion: { _ in
                self.isAnimating = false
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
            let screen = window?.windowScene?.screen ?? UIScreen.main
            if shouldSetEqualWidthForSegments {
                if style == .tabs {
                    rightOffset = screen.roundToDevicePixels(CGFloat(index + 1) / CGFloat(buttons.count) * frame.width)
                } else {
                    var suggestedWidth = frame.width

                    if let windowWidth = window?.frame.width {
                        suggestedWidth = windowWidth
                    }
                    // for iPad regular full width pill styles might look too wide
                    if traitCollection.userInterfaceIdiom == .pad {
                        suggestedWidth = max(suggestedWidth / 2, 375.0)
                    } else {
                        var insets = 2 * Constants.pillHorizontalInset
                        if let window = window {
                            insets += window.safeAreaInsets.left + window.safeAreaInsets.right
                        }
                        suggestedWidth -= insets
                    }
                    suggestedWidth = ceil(suggestedWidth)

                    rightOffset = screen.roundToDevicePixels(CGFloat(index + 1) / CGFloat(buttons.count) * suggestedWidth)
                }
            } else {
                let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                rightOffset = leftOffset + screen.roundToDevicePixels(button.sizeThatFits(maxSize).width)
            }
            button.frame = CGRect(x: leftOffset, y: 0, width: rightOffset - leftOffset, height: frame.height)
            leftOffset = rightOffset
        }

        bottomSeparator.frame = CGRect(x: 0, y: frame.height - bottomSeparator.frame.height, width: frame.width, height: bottomSeparator.frame.height)

        if style != .tabs {
            layoutPillContainerView()
            layoutPillMaskedLabelLayerView()
        }
        layoutSelectionView()
        layoutBackgroundView()

        flipSubviewsForRTL()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutSubviews()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxButtonHeight: CGFloat = 0.0
        var maxButtonWidth: CGFloat = 0.0
        var buttonsWidth: CGFloat = 0.0

        for button in buttons {
            let size = button.sizeThatFits(size)

            let screen = window?.windowScene?.screen ?? UIScreen.main
            maxButtonHeight = max(maxButtonHeight, screen.roundToDevicePixels(size.height))
            if shouldSetEqualWidthForSegments {
                maxButtonWidth = max(maxButtonWidth, screen.roundToDevicePixels(size.width))
            } else {
                buttonsWidth += screen.roundToDevicePixels(size.width)
            }
        }

        let fittingSize = CGSize(
            width: shouldSetEqualWidthForSegments ? maxButtonWidth * CGFloat(buttons.count) : buttonsWidth,
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

    /// Used to retrieve the view from the segment at the specified index
    open func segmentView(at index: Int) -> UIView? {
        guard index <= buttons.count else {
            return nil
        }

        return buttons[index] as UIView
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

    private func createTabButton(withTitle title: String) -> SegmentedControlButton {
        let button = SegmentedControlButton()
        button.setTitle(title, for: .normal)
        button.accessibilityLabel = title
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        return button
    }

    private func createSwitchButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.accessibilityLabel = title
        button.largeContentTitle = title
        button.showsLargeContentViewer = true
        button.titleLabel?.font = style.segmentTextFont
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        button.contentEdgeInsets = Constants.pillButtonInsets

        return button
    }

    private func addMaskedPillLabel(over button: UIButton, at index: Int) {
        let maskedLabel = UILabel()
        maskedLabel.text = button.currentTitle
        maskedLabel.font = style.segmentTextFont
        maskedLabel.translatesAutoresizingMaskIntoConstraints = false
        pillMaskedLabelLayerView.addSubview(maskedLabel)
        pillMaskedLabels.insert(maskedLabel, at: index)

        var constraints = [NSLayoutConstraint]()
        if let buttonTitle = button.titleLabel {
            constraints.append(contentsOf: [
                buttonTitle.leadingAnchor.constraint(equalTo: maskedLabel.leadingAnchor),
                buttonTitle.trailingAnchor.constraint(equalTo: maskedLabel.trailingAnchor),
                buttonTitle.topAnchor.constraint(equalTo: maskedLabel.topAnchor),
                buttonTitle.bottomAnchor.constraint(equalTo: maskedLabel.bottomAnchor)
                ])
        }
        pillMaskedLabelsConstraints.insert(constraints, at: index)
    }

    @objc private func handleButtonTap(_ sender: UIButton) {
        if let index = buttons.firstIndex(of: sender), selectedSegmentIndex != index {
            selectSegment(at: index, animated: isAnimated)
            sendActions(for: .valueChanged)
        }
    }

    private func layoutBackgroundView() {
        let cornerRadius = style.backgroundHasRoundedCorners ? bounds.height / 2 : 0
        backgroundView.layer.cornerRadius = cornerRadius

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [
            backgroundView.leadingAnchor.constraint(equalTo: buttons.first?.leadingAnchor ?? self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: buttons.last?.trailingAnchor ?? self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutPillContainerView() {
        var frame = bounds
        frame = frame.inset(by: UIEdgeInsets(top: 0, left: Constants.pillHorizontalInset, bottom: 0, right: Constants.pillHorizontalInset))
        pillContainerView.frame = frame
        pillContainerView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [
            self.leadingAnchor.constraint(equalTo: pillContainerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: pillContainerView.trailingAnchor),
            pillContainerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: 2 * Constants.pillHorizontalInset)
        ])
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutPillMaskedLabelLayerView () {
        pillMaskedLabelLayerView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [
            pillMaskedLabelLayerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            pillMaskedLabelLayerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            pillMaskedLabelLayerView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            pillMaskedLabelLayerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])

        for maskedLabelconstraints in pillMaskedLabelsConstraints {
            constraints.append(contentsOf: maskedLabelconstraints)
        }

        NSLayoutConstraint.activate(constraints)
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
        case .primaryPill, .onBrandPill:
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
            switch style {
            case .tabs:
                selectionView.backgroundColor = isEnabled ? style.selectionColor(for: window) : style.selectionColorDisabled
                backgroundView.backgroundColor = isEnabled ? style.backgroundColor(for: window) : style.backgroundColorDisabled(for: window)
            case .primaryPill, .onBrandPill:
                pillMaskedLabelLayerView.backgroundColor = customSegmentedControlSelectedButtonBackgroundColor ?? (isEnabled ? style.selectionColor(for: window) : style.selectionColorDisabled)
                backgroundView.backgroundColor = customSegmentedControlBackgroundColor ?? (isEnabled ? style.backgroundColor(for: window) : style.backgroundColorDisabled(for: window))
                for maskedLabel in pillMaskedLabels {
                    if isEnabled {
                        if let customSelectedButtonTextColor = self.customSelectedSegmentedControlButtonTextColor {
                            maskedLabel.textColor = customSelectedButtonTextColor
                        } else {
                                maskedLabel.textColor = style.segmentTextColorSelected(for: window)
                        }
                    } else {
                            maskedLabel.textColor = style.segmentTextColorSelectedAndDisabled(for: window)
                    }
                }
                for button in buttons {
                    if isEnabled {
                        if let customButtonTextColor = self.customSegmentedControlButtonTextColor {
                            button.setTitleColor(customButtonTextColor, for: .normal)
                        } else {
                            button.setTitleColor(style.segmentTextColor, for: .normal)
                        }
                    } else {
                            button.setTitleColor(style.segmentTextColorDisabled(for: window), for: .normal)
                    }
                }
            }
        }
    }
}

// MARK: - SegmentedControlButton
private class SegmentedControlButton: UIButton {
    private struct Constants {
        static let contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 13, right: 12)
    }

    init() {
        super.init(frame: .zero)

        contentEdgeInsets = Constants.contentEdgeInsets
        titleLabel?.lineBreakMode = .byTruncatingTail
        setTitleColor(SegmentedControl.Style.tabs.segmentTextColor, for: .normal)
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
            setTitleColor(SegmentedControl.Style.tabs.segmentTextColorDisabled(for: window), for: .disabled)
            setTitleColor(SegmentedControl.Style.tabs.segmentTextColorSelected(for: window), for: .selected)
            setTitleColor(SegmentedControl.Style.tabs.segmentTextColorSelectedAndDisabled(for: window), for: [.selected, .disabled])
        }
    }

    @objc private func updateFont() {
        titleLabel?.font = SegmentedControl.Style.tabs.segmentTextFont
    }
}
