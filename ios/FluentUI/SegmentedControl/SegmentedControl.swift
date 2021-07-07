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
            static let background = UIColor(light: surfaceTertiary, dark: gray950)
            static let backgroundDisabled: UIColor = background
            static let segmentText = UIColor(light: textSecondary, dark: textPrimary)
            static let selectionDisabled: UIColor = surfaceQuaternary
        }

        struct OnBrandPill {
            static let background: UIColor = PrimaryPill.background
            static let backgroundDisabled: UIColor = PrimaryPill.backgroundDisabled
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

        func segmentUnreadDotColor(for window: UIWindow) -> UIColor {
            switch self {
            case .primaryPill:
                return UIColor(light: Colors.primary(for: window), dark: Colors.gray100)
            case .tabs, .onBrandPill:
                return Colors.SegmentedControl.OnBrandPill.segmentText
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
        static let pillContainerHorizontalInset: CGFloat = 16
        static let pillButtonCornerRadius: CGFloat = 16
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

    /// only used for pill style segment control. It is used to define the inset of the pillContainerView
    @objc public var contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.pillContainerHorizontalInset, bottom: 0, trailing: Constants.pillContainerHorizontalInset) {
        didSet {
            guard oldValue != contentInset else {
                return
            }
            pillContainerViewTopConstraint?.constant = contentInset.top
            pillContainerViewBottomConstraint?.constant = contentInset.bottom
            pillContainerViewLeadingConstraint?.constant = contentInset.leading
            pillContainerViewTrailingConstraint?.constant = contentInset.trailing

            invalidateIntrinsicContentSize()
        }
    }
    @objc public var selectedSegmentIndex: Int {
        get { return _selectedSegmentIndex }
        set { selectSegment(at: newValue, animated: false) }
    }

    private var _selectedSegmentIndex: Int = -1
    private var customSegmentedControlBackgroundColor: UIColor?
    private var customSegmentedControlSelectedButtonBackgroundColor: UIColor?
    private var customSegmentedControlButtonTextColor: UIColor?
    private var customSelectedSegmentedControlButtonTextColor: UIColor?

    private var items = [SegmentItem]()
    internal var style: Style {
        didSet {
            updateWindowSpecificColors()
        }
    }

    // Hierarchy for pill styles:
    //
    // pillContainerView (used to create 16pt inset on either side)
    // |--backgroundView (fill container view, uses customSegmentedControlBackgroundColor)
    // |--buttons (uses customSegmentedControlButtonTextColor)
    // |--pillMaskedLabelsContainerView (fill container view, uses customSegmentedControlSelectedButtonBackgroundColor)
    // |  |.mask -> selectionView
    // |  |--pillMaskedLabels (uses customSelectedSegmentedControlButtonTextColor)

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
    private let pillMaskedLabelsContainerView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous

        return view
    }()
    private var pillMaskedLabels = [UILabel]()
    private var pillContainerViewTopConstraint: NSLayoutConstraint?
    private var pillContainerViewBottomConstraint: NSLayoutConstraint?
    private var pillContainerViewLeadingConstraint: NSLayoutConstraint?
    private var pillContainerViewTrailingConstraint: NSLayoutConstraint?

    private var isAnimating: Bool = false

    public convenience init() {
        self.init(items: [])
    }

    /// Initializes a segmented control with the specified titles.
    ///
    /// - Parameter items: An array of Segmented Items representing the segments for this control.
    /// - Parameter style: A style used for rendering of the control.
    @objc public convenience init(items: [SegmentItem], style: Style = .primaryPill) {
        self.init(items: items,
                  style: style,
                  customSegmentedControlBackgroundColor: nil,
                  customSegmentedControlSelectedButtonBackgroundColor: nil,
                  customSegmentedControlButtonTextColor: nil,
                  customSelectedSegmentedControlButtonTextColor: nil)
    }

    /// Initializes a segmented control with the specified titles, style, and colors (colors are for pill styles only).
    ///
    /// - Parameter items: An array of Segmented Items representing the segments for this control.
    /// - Parameter style: A style used for rendering of the control.
    /// - Parameter customSegmentedControlBackgroundColor: UIColor to use as the background color
    /// - Parameter customSegmentedControlSelectedButtonBackgroundColor: UIColor to use as the selected button background color
    /// - Parameter customSegmentedControlButtonTextColor: UIColor to use as the unselected button text color
    /// - Parameter customSelectedSegmentedControlButtonTextColor: UIColor to use as the selected button text color
    @objc public init(items: [SegmentItem],
                      style: Style = .primaryPill,
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

        switch style {
        case .tabs:
            addSubview(backgroundView)
            addButtons(items: items)
            // Separator must be over buttons and selection view on top of everything
            addSubview(bottomSeparator)
            addSubview(selectionView)
        case .primaryPill, .onBrandPill:
            backgroundView.layer.cornerRadius = Constants.pillButtonCornerRadius
            pillContainerView.addSubview(backgroundView)
            selectionView.backgroundColor = .black
            pillContainerView.addSubview(selectionView)
            pillMaskedLabelsContainerView.mask = selectionView
            pillMaskedLabelsContainerView.isUserInteractionEnabled = false
            pillContainerView.addSubview(pillMaskedLabelsContainerView)
            addButtons(items: items)
            // We need to add pillMaskedLabelsContainerView to the container view
            // before the buttons in order to activate the label constraints, but
            // we want pillMaskedLabelsContainerView to show above the buttons.
            pillContainerView.bringSubviewToFront(pillMaskedLabelsContainerView)
            pillContainerView.addInteraction(UILargeContentViewerInteraction())
            addSubview(pillContainerView)
        }

        setupLayoutConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Insert new segment at index with the specified title. If a segment exists at that index, it will be inserted before and will therefore take its index.
    ///
    /// - Parameters:
    ///   - item: The item of the newly created segment
    ///   - index: The index at which to insert the newly created segment
    @objc open func insertSegment(_ item: SegmentItem, at index: Int) {
        items.insert(item, at: index)

        let button: UIButton
        // TODO: Add option for animated addition?
        switch style {
        case .tabs:
            button = createTabButton(withItem: item)
            addSubview(button)
        case .primaryPill, .onBrandPill:
            button = createPillButton(withItem: item)
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
            switch style {
            case .tabs:
                rightOffset = screen.roundToDevicePixels(CGFloat(index + 1) / CGFloat(buttons.count) * frame.width)
                button.frame = CGRect(x: leftOffset, y: 0, width: rightOffset - leftOffset, height: frame.height)
            case .primaryPill, .onBrandPill:
                if shouldSetEqualWidthForSegments {
                    rightOffset = screen.roundToDevicePixels(CGFloat(index + 1) / CGFloat(buttons.count) * pillContainerView.frame.width)
                } else {
                    let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                    rightOffset = leftOffset + screen.roundToDevicePixels(button.sizeThatFits(maxSize).width)
                }
                button.frame = CGRect(x: leftOffset, y: 0, width: rightOffset - leftOffset, height: pillContainerView.frame.height)
            }
            leftOffset = rightOffset
        }

        if style == .tabs {
            bottomSeparator.frame = CGRect(x: 0, y: frame.height - bottomSeparator.frame.height, width: frame.width, height: bottomSeparator.frame.height)
        } else {
            // flipSubviewsForRTL only works on direct children subviews
            pillContainerView.flipSubviewsForRTL()
        }

        flipSubviewsForRTL()
        layoutSelectionView()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if style != .tabs, shouldSetEqualWidthForSegments {
            invalidateIntrinsicContentSize()
        }
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

        if shouldSetEqualWidthForSegments {
            maxButtonWidth *= CGFloat(buttons.count)
        } else {
            maxButtonWidth = buttonsWidth
        }

        if style != .tabs {
            if shouldSetEqualWidthForSegments {
                if let windowWidth = window?.safeAreaLayoutGuide.layoutFrame.width {
                    if traitCollection.userInterfaceIdiom == .pad {
                        maxButtonWidth = max(windowWidth / 2, 375.0)
                    } else {
                        maxButtonWidth = windowWidth
                    }
                }
            } else {
                maxButtonWidth += (contentInset.leading + contentInset.trailing)
            }
        }
        maxButtonHeight += (contentInset.top + contentInset.bottom)

        return CGSize(width: min(maxButtonWidth, size.width), height: min(maxButtonHeight, size.height))
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

    private func addButtons(items: [SegmentItem]) {
        // Create buttons
        for (index, item) in items.enumerated() {
            insertSegment(item, at: index)
        }

        // Select first button
        if !items.isEmpty {
            selectSegment(at: 0, animated: false)
        }
    }

    private func createTabButton(withItem item: SegmentItem) -> SegmentedControlButton {
        let button = SegmentedControlButton()
        let title = item.title
        button.setTitle(title, for: .normal)
        button.accessibilityLabel = title
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        return button
    }

    private func createPillButton(withItem item: SegmentItem) -> UIButton {
        let button = SegmentPillButton(withItem: item)
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        return button
    }

    private func addMaskedPillLabel(over button: UIButton, at index: Int) {
        let maskedLabel = UILabel()
        maskedLabel.text = button.currentTitle
        maskedLabel.font = button.titleLabel?.font
        maskedLabel.translatesAutoresizingMaskIntoConstraints = false
        pillMaskedLabelsContainerView.addSubview(maskedLabel)
        pillMaskedLabels.insert(maskedLabel, at: index)

        if let buttonTitle = button.titleLabel {
            NSLayoutConstraint.activate([
                buttonTitle.leadingAnchor.constraint(equalTo: maskedLabel.leadingAnchor),
                buttonTitle.trailingAnchor.constraint(equalTo: maskedLabel.trailingAnchor),
                buttonTitle.topAnchor.constraint(equalTo: maskedLabel.topAnchor),
                buttonTitle.bottomAnchor.constraint(equalTo: maskedLabel.bottomAnchor)
                ])
        }
    }

    @objc private func handleButtonTap(_ sender: UIButton) {
        if let index = buttons.firstIndex(of: sender), selectedSegmentIndex != index {
            selectSegment(at: index, animated: isAnimated)
            sendActions(for: .valueChanged)
        }
    }

    private func setupLayoutConstraints () {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if style == .tabs {
            constraints.append(contentsOf: [
                backgroundView.leadingAnchor.constraint(equalTo: buttons.first?.leadingAnchor ?? self.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: buttons.last?.trailingAnchor ?? self.trailingAnchor),
                backgroundView.topAnchor.constraint(equalTo: buttons.first?.topAnchor ?? self.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: buttons.first?.bottomAnchor ?? self.bottomAnchor)
            ])
        } else {
            pillContainerView.translatesAutoresizingMaskIntoConstraints = false
            pillMaskedLabelsContainerView.translatesAutoresizingMaskIntoConstraints = false

            let pillContainerViewTopConstraint = pillContainerView.topAnchor.constraint(equalTo: topAnchor, constant: contentInset.top)
            let pillContainerViewBottomConstraint = pillContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInset.bottom)
            let pillContainerViewLeadingConstraint = pillContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInset.leading)
            let pillContainerViewTrailingConstraint = pillContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInset.trailing)
            self.pillContainerViewTopConstraint = pillContainerViewTopConstraint
            self.pillContainerViewBottomConstraint = pillContainerViewBottomConstraint
            self.pillContainerViewLeadingConstraint = pillContainerViewLeadingConstraint
            self.pillContainerViewTrailingConstraint = pillContainerViewTrailingConstraint

            constraints.append(contentsOf: [
                pillContainerViewTopConstraint,
                pillContainerViewBottomConstraint,
                pillContainerViewLeadingConstraint,
                pillContainerViewTrailingConstraint,
                backgroundView.leadingAnchor.constraint(equalTo: pillContainerView.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: pillContainerView.trailingAnchor),
                backgroundView.topAnchor.constraint(equalTo: pillContainerView.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: pillContainerView.bottomAnchor),

                pillMaskedLabelsContainerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
                pillMaskedLabelsContainerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                pillMaskedLabelsContainerView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                pillMaskedLabelsContainerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
            ])
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
            selectionView.layer.cornerRadius = Constants.pillButtonCornerRadius
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
                pillMaskedLabelsContainerView.backgroundColor = customSegmentedControlSelectedButtonBackgroundColor ?? (isEnabled ? style.selectionColor(for: window) : style.selectionColorDisabled)
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

                    if let switchButton = button as? SegmentPillButton {
                        switchButton.unreadDotColor = isEnabled ? style.segmentUnreadDotColor(for: window) : style.segmentTextColorDisabled(for: window)
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
        titleLabel?.font = TextStyle.subhead.font
    }
}
