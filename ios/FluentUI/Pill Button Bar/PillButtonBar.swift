//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButtonBarItem

/// `PillButtonBarItem` is an item that can be presented as a pill shaped text button.
@objc(MSFPillButtonBarItem)
open class PillButtonBarItem: NSObject {
    @objc public let title: String

    /// Creates a new instance of the PillButtonBarItem that holds data used to create a pill button in a PillButtonBar.
    /// - Parameter title: Title that will be displayed by a pill button in the PillButtonBar.
    @objc public init(title: String) {
        self.title = title
        super.init()
    }

    /// Creates a new instance of the PillButtonBarItem that holds data used to create a pill button in a PillButtonBar.
    /// - Parameters:
    ///   - title: Title that will be displayed by a pill button in the PillButtonBar.
    ///   - isUnread: Whether the pill button shows the mark that represents the "unread" state.
    @objc public convenience init(title: String, isUnread: Bool = false) {
        self.init(title: title)
        self.isUnread = isUnread
    }

    /// This value will determine whether or not to show the mark that represents the "unread" state (dot next to the pill button label).
    /// The default value of this property is false.
    public var isUnread: Bool = false {
       didSet {
           if oldValue != isUnread {
               NotificationCenter.default.post(name: PillButtonBarItem.isUnreadValueDidChangeNotification, object: self)
           }
       }
   }

    /// Notification sent when item's `isUnread` value changes.
    static let isUnreadValueDidChangeNotification = NSNotification.Name(rawValue: "PillButtonBarItemisUnreadValueDidChangeNotification")
}

// MARK: PillButtonBar

/// `PillButtonBar` is a horizontal scrollable list of pill shape text buttons in which only one button can be selected at a given time.
/// Set the `items` property to determine what buttons will be shown in the bar. Each `PillButtonBarItem` will be represented as a button.
/// Set the `delegate` property to listen to selection changes.
/// Set the `selectedItem` property if the selection needs to be programatically changed.
/// Once a button is selected, the previously selected button will be deselected.
@objc(MSFPillButtonBar)
open class PillButtonBar: UIScrollView, FluentUIWindowProvider, ControlConfiguration, TokenizedControlInternal {
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        pillButtonBarTokens.updateForCurrentTheme()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.width == 0 {
            return
        }

        if needsButtonSizeReconfiguration {
            ensureMinimumButtonWidth()
            updateHeightConstraint()
            adjustButtonsForCurrentScrollFrame()
            needsButtonSizeReconfiguration = false
            if let selectedButton = selectedButton {
                layoutIfNeeded()
                scrollButtonToVisible(selectedButton)
            }
        }
    }

    public override var bounds: CGRect {
        didSet {
            if bounds.width > 0, lastKnownScrollFrameWidth > 0, bounds.width != lastKnownScrollFrameWidth {
                // Frame changes can happen because of rotation, split view or adding the view for the first
                // time into a superview. First time layout already has buttons in default sizes, recreate
                // them so that the next time we layout subviews we'll recalculate their optimal sizes.
                recreateButtons()
                stackView.spacing = pillButtonBarTokens.minButtonsSpacing
            }

            lastKnownScrollFrameWidth = bounds.width
        }
    }

    public func overrideTokens (_ tokens: PillButtonBarTokens?) -> Self {
        overrideTokens = tokens
        return self
    }
    /// Initializes the PillButtonBar using the provided style.
    ///
    /// - Parameters:
    ///   - pillButtonStyle: The style override for the pill buttons in this pill button bar
    @objc public init(pillButtonStyle: PillButtonStyle = .primary) {
        self.pillButtonStyle = pillButtonStyle
        super.init(frame: .zero)
        setupScrollView()
        setupStackView()

        let pointerInteraction = UIPointerInteraction(delegate: self)
        addInteraction(pointerInteraction)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc public func selectItem(_ item: PillButtonBarItem) {
        guard let index = indexOfButtonWithItem(item) else {
            return
        }

        selectedButton = buttons[index]
    }

    @objc public func selectItem(atIndex index: Int) -> Bool {
        if index < 0 || index >= buttons.count {
            return false
        }

        selectedButton = buttons[index]
        return true
    }

    @objc public func disableItem(_ item: PillButtonBarItem) {
        guard let index = indexOfButtonWithItem(item) else {
            return
        }

        buttons[index].isEnabled = false
    }

    @objc public func disableItem(atIndex index: Int) {
        if index < 0 || index >= buttons.count {
            return
        }

        buttons[index].isEnabled = false
    }

    @objc public func enableItem(_ item: PillButtonBarItem) {
        guard let index = indexOfButtonWithItem(item) else {
            return
        }

        buttons[index].isEnabled = true
    }

    @objc public func enableItem(atIndex index: Int) {
        if index < 0 || index >= buttons.count {
            return
        }

        buttons[index].isEnabled = true
    }

    public typealias TokenType = PillButtonBarTokens

    @objc public weak var barDelegate: PillButtonBarDelegate?

    @objc public var centerAligned: Bool = false {
        didSet {
            adjustAlignment()
        }
    }

    @objc public var items: [PillButtonBarItem]? {
        didSet {
            clearButtons()

            if let items = items {
                addButtonsWithItems(items)
            }

            setNeedsLayout()
            needsButtonSizeReconfiguration = true
        }
    }

    @objc public let pillButtonStyle: PillButtonStyle

    @objc public var pillButtonOverrideTokens: PillButtonTokens?

    /// If set to nil, the previously selected item will be deselected and there won't be any items selected
    @objc public var selectedItem: PillButtonBarItem? {
        get {
            return selectedButton?.pillBarItem
        }
        set {
            if let item = newValue, let index = indexOfButtonWithItem(item) {
                selectedButton = buttons[index]
            }
        }
    }


    var state: PillButtonBar { self }
    var tokens: PillButtonBarTokens = .init()
    var overrideTokens: PillButtonBarTokens? {
        didSet {
            updatePillButtonBarTokens()
        }
    }

    private var buttonExtraSidePadding: CGFloat = 0.0

    private var buttons = [PillButton]()

    private var lastKnownScrollFrameWidth: CGFloat = 0.0

    private var needsButtonSizeReconfiguration: Bool = false

    private var selectedButton: PillButton? {
        willSet {
            selectedButton?.isSelected = false
        }

        didSet {
            if let button = selectedButton {
                button.isSelected = true
            }
        }
    }

    private lazy var stackView: UIStackView = initStackView()

    private func initStackView() -> UIStackView {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = pillButtonBarTokens.minButtonsSpacing
        return view
    }

    private func addButtonsWithItems(_ items: [PillButtonBarItem]) {
        for (index, item) in items.enumerated() {
            let button = createButtonWithItem(item)
            buttons.append(button)
            stackView.addArrangedSubview(button)

            var shouldAddAccessibilityHint: Bool = true
            if #available(iOS 14.6, *) {
                // in case pillbuttonbar is used as .tabbar, adding our own index would be repetitive
                // However, iOS 14.0 - 14.5 `.tabBar` accessibilityTrait does not read out the index automatically
                shouldAddAccessibilityHint = !self.accessibilityTraits.contains(.tabBar)
            }

            if shouldAddAccessibilityHint {
                button.accessibilityHint = String.localizedStringWithFormat("Accessibility.MSPillButtonBar.Hint".localized, index + 1, items.count)
            }

            if let buttonOverrideTokens = pillButtonOverrideTokens {
                button.overrideTokens = buttonOverrideTokens
            }
        }
    }

    private func adjustAlignment() {
        leadingConstraint?.isActive = !centerAligned
        trailingConstraint?.isActive = !centerAligned
        centerConstraint?.isActive = centerAligned

        contentInset.left = centerAligned ? 0.0 : pillButtonBarTokens.sideInset
        contentInset.right = contentInset.left
        scrollToOrigin()
    }

    ///  If necessary, adjusts the spacing and padding of the first few visible buttons in the scroll frame so that the portion
    ///  of the last button visible clearly indicates that there are more buttons that can be scrolled into the view.
    ///
    ///  Buttons in the scroll view are of variable widths. When the initial list of buttons is displayed horizontally, it is uncertain
    ///  when the list will be cut off at the trailing edge. We must optimize it so that the last button shown has an appropriate
    ///  portion of it visible and there's a clear indication that the view is scrollable. To achieve this, this function calculates
    ///  a new spacing and padding that will shift the last visible button farther in the view.
    private func adjustButtonsForCurrentScrollFrame() {
        var visibleWidth = frame.width - (pillButtonBarTokens.minButtonsSpacing + pillButtonBarTokens.minButtonVisibleWidth)
        var visibleButtonsWidth: CGFloat = pillButtonBarTokens.sideInset
        var visibleButtonCount = 0
        for button in buttons {
            button.layoutIfNeeded()
            visibleButtonsWidth += button.frame.width
            visibleButtonCount += 1
            if visibleButtonsWidth > visibleWidth {
                break
            }

            visibleButtonsWidth += pillButtonBarTokens.minButtonsSpacing
        }

        if visibleButtonCount == buttons.count {
            // If the last visible button is the last button, not need to account for space in a next button
            visibleWidth += pillButtonBarTokens.minButtonVisibleWidth
        }

        if visibleButtonsWidth <= visibleWidth {
            // No enough buttons to fill the scroll frame
            return
        }

        let optimalVisibleButtonWidth = frame.width + pillButtonBarTokens.minButtonVisibleWidth
        let totalAdjustment = optimalVisibleButtonWidth - visibleButtonsWidth
        if totalAdjustment < 0.0 {
            return
        }

        let numberOfButtonsToAdjust = visibleButtonCount - 1
        let adjustedSpace = adjustButtonsSpacing(totalSpace: totalAdjustment, numberOfButtons: numberOfButtonsToAdjust)
        let reminderToAdjust = totalAdjustment - adjustedSpace
        if reminderToAdjust > 0 {
            adjustButtonsSidePadding(totalPadding: reminderToAdjust, numberOfButtons: numberOfButtonsToAdjust)
        }
    }

    /// Increases the left and right content inset of all the buttons, so that the sum of the extra space added in the first numberOfButtons
    /// buttons accounts for the totalAdjustment needed.
    /// - Parameter totalPadding: The total padding needed before the first numberOfButtons buttons
    /// - Parameter numberOfButtons: The number of buttons that should allocate the totalPadding change
    private func adjustButtonsSidePadding(totalPadding: CGFloat, numberOfButtons: Int) {
        let buttonEdges = (numberOfButtons * 2) + 1
        buttonExtraSidePadding = ceil(totalPadding / CGFloat(buttonEdges))
        for button in buttons {
            button.layoutIfNeeded()
            button.contentEdgeInsets.right += buttonExtraSidePadding
            button.contentEdgeInsets.left += buttonExtraSidePadding
            button.layoutIfNeeded()
        }
    }

    /// Attempts to increase the spacing between all buttons, so that the sum of the extra space added before on the first numberOfButtons
    /// buttons accounts for the totalAdjustment needed. If the spacing needed for all the buttons is larger than the maxium spacing
    /// allowed, the maxium spacing will be used.
    /// - Parameter totalSpace: The total spacing needed before the first numberOfButtons buttons
    /// - Parameter numberOfButtons: The number of buttons that should allocate the totalSpace change
    /// - Returns: The total space adjusted before the first numberOfButtons buttons
    private func adjustButtonsSpacing(totalSpace: CGFloat, numberOfButtons: Int) -> CGFloat {
        if numberOfButtons == 0 {
            return 0.0
        }

        let spacingAdjustment = ceil((totalSpace) / CGFloat(numberOfButtons))
        let newSpacing = min(pillButtonBarTokens.maxButtonsSpacing, pillButtonBarTokens.minButtonsSpacing + spacingAdjustment)
        let spacingChange = newSpacing - stackView.spacing
        stackView.spacing = newSpacing
        return spacingChange * CGFloat(numberOfButtons)
    }

    private func clearButtons() {
        selectedButton = nil
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
    }

    private func createButtonWithItem(_ item: PillButtonBarItem) -> PillButton {
        let button = PillButton(pillBarItem: item, style: pillButtonStyle)
        button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        return button
    }

    private func ensureMinimumButtonWidth() {
        for button in buttons {
            button.layoutIfNeeded()
            let buttonWidth = button.frame.width
            if buttonWidth > 0, buttonWidth < pillButtonBarTokens.minButtonWidth {
                let extraInset = floor((pillButtonBarTokens.minButtonWidth - button.frame.width) / 2)
                button.contentEdgeInsets.left += extraInset
                button.contentEdgeInsets.right = button.contentEdgeInsets.left
                button.layoutIfNeeded()
            }
        }
    }

    private func indexOfButtonWithItem(_ item: PillButtonBarItem) -> Int? {
        for (index, button) in buttons.enumerated() {
            if button.pillBarItem == item {
                return index
            }
        }

        return nil
    }

    private func recreateButtons() {
        let selectedItem = selectedButton?.pillBarItem
        selectedButton = nil

        let currentItems = items
        items = nil
        items = currentItems

        if let selectedItem = selectedItem {
            selectItem(selectedItem)
        }
    }

    private func setupScrollView() {
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        addInteraction(UILargeContentViewerInteraction())
    }

    private func setupStackView() {
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            stackView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingConstraint = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        centerConstraint = stackView.centerXAnchor.constraint(equalTo: centerXAnchor)

        heightConstraint = heightAnchor.constraint(equalToConstant: pillButtonBarTokens.minHeight)
        heightConstraint?.isActive = true

        adjustAlignment()
    }

    /// If the button is not fully visible in the scroll frame, scrolls the view by an offset large enough so that
    /// both the button and a peek of its following button become visible.
    private func scrollButtonToVisible(_ button: PillButton) {
        let buttonFrame = button.convert(button.bounds, to: self)
        let buttonLeftPosition = buttonFrame.origin.x
        let buttonRightPosition = buttonLeftPosition + button.frame.size.width
        let viewLeadingPosition = bounds.origin.x
        let viewTrailingPosition = viewLeadingPosition + frame.size.width

        let extraScrollWidth = pillButtonBarTokens.minButtonVisibleWidth + stackView.spacing + buttonExtraSidePadding
        var offSet = contentOffset.x
        if buttonLeftPosition < viewLeadingPosition {
            offSet = buttonLeftPosition - extraScrollWidth
            offSet = max(offSet, -pillButtonBarTokens.sideInset)
        } else if buttonRightPosition > viewTrailingPosition {
            let maxOffsetX = contentSize.width - frame.size.width + pillButtonBarTokens.sideInset
            offSet = buttonRightPosition - frame.size.width + extraScrollWidth
            offSet = min(offSet, maxOffsetX)
        }

        if offSet != contentOffset.x {
            setContentOffset(CGPoint(x: offSet, y: contentOffset.y), animated: true)
        }
    }

    private func scrollToOrigin(animated: Bool = false) {
        let originX: CGFloat = centerAligned ? 0.0 : -contentInset.left
        setContentOffset(CGPoint(x: originX, y: contentOffset.y), animated: animated)
    }

    @objc private func selectButton(_ button: PillButton) {
        selectedButton = button
        scrollButtonToVisible(button)
        if let index = buttons.firstIndex(of: button) {
            barDelegate?.pillBar?(self, didSelectItem: button.pillBarItem, atIndex: index)
        }
    }

    private func updateHeightConstraint() {
        var maxHeight: CGFloat = pillButtonBarTokens.minHeight
        buttons.forEach { maxHeight = max(maxHeight, $0.frame.size.height) }
        if let heightConstraint = heightConstraint, maxHeight != heightConstraint.constant {
            heightConstraint.constant = maxHeight
        }
    }

    private func updatePillButtonBarTokens() {
        let tokens = TokenResolver.tokens(for: self, fluentTheme: fluentTheme)
        self.tokens = tokens
    }

    private lazy var pillButtonBarTokens = MSFPillButtonBarTokens()
    
    private var leadingConstraint: NSLayoutConstraint?

    private var centerConstraint: NSLayoutConstraint?

    private var heightConstraint: NSLayoutConstraint?

    private var trailingConstraint: NSLayoutConstraint?
}

// MARK: PillButtonBar UIPointerInteractionDelegate

extension PillButtonBar: UIPointerInteractionDelegate {
    public func pointerInteraction(_ interaction: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        var region: UIPointerRegion?

        for (index, button) in buttons.enumerated() {
            if button.isEnabled {
                var frame = button.frame
                frame = stackView.convert(frame, to: self)

                if frame.contains(request.location) {
                    region = UIPointerRegion(rect: frame, identifier: index)
                    break
                }
            }
        }

        return region
    }

    public func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        guard let superview = window, let index = region.identifier as? Int, index < buttons.count else {
            return nil
        }

        let pillButton = buttons[index]
        let pillButtonFrame = stackView.convert(pillButton.frame, to: superview)
        let target = UIPreviewTarget(container: superview, center: CGPoint(x: pillButtonFrame.midX, y: pillButtonFrame.midY))
        let preview = UITargetedPreview(view: pillButton, parameters: UIPreviewParameters(), target: target)
        let pointerEffect = UIPointerEffect.lift(preview)

        return UIPointerStyle(effect: pointerEffect, shape: nil)
    }
}

// MARK: PillButtonBarDelegate

@objc(MSFPillButtonBarDelegate)
public protocol PillButtonBarDelegate {
    /// Called after the button representing the item is tapped in the UI.
    @objc optional func pillBar(_ pillBar: PillButtonBar, didSelectItem item: PillButtonBarItem, atIndex index: Int)
}
