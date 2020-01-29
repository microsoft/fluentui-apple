//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSSegmentedControl

/// A styled segmented control that should be used instead of UISegmentedControl. It is designed to flex the button width proportionally to the control's width.
open class MSSegmentedControl: UIControl {
    private struct Constants {
        static let selectionBarHeight: CGFloat = 1.5
        static let selectionBarAnimationDuration: TimeInterval = 0.12
    }

    open override var isEnabled: Bool {
        didSet {
            for button in buttons {
                button.isEnabled = isEnabled
            }
            updateSelectionBarViewColor()
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
    private var buttons = [MSSegmentedControlButton]()
    private let selectionBarView = UIView()
    private let bottomSeparator = MSSeparator()
    private var isAnimating: Bool = false

    public convenience init() {
        self.init(items: [])
    }

    /// Initializes a segmented control with the specified titles.
    ///
    /// - Parameter items: An array of title strings representing the segments for this control.
    @objc public init(items: [String]) {
        super.init(frame: .zero)

        backgroundColor = MSColors.SegmentedControl.background
        setupButtons(titles: items)
        updateSelectionBarViewColor()
        addSubview(bottomSeparator)
        addSubview(selectionBarView)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }

    /// Select segment at index
    /// Warning: when called, handlers on UIControlEvents.ValueChanged are not called
    ///
    /// - Parameters:
    ///   - index: The index of the segment to set as selected
    ///   - animated: Whether or not to animate the change in selected segment
    @objc open func selectSegment(at index: Int, animated: Bool) {
        precondition(index >= 0 && index < buttons.count, "MSSegmentedControl > try to selected segment index with invalid index: \(index)")

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
            UIView.animate(withDuration: Constants.selectionBarAnimationDuration, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.layoutSelectionBarView()
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
            rightOffset = UIScreen.main.roundToDevicePixels(CGFloat(index + 1) / CGFloat(buttons.count) * width)
            button.frame = CGRect(x: leftOffset, y: 0, width: rightOffset - leftOffset, height: height)
            leftOffset = rightOffset
        }

        bottomSeparator.frame = CGRect(x: 0, y: height - bottomSeparator.height, width: width, height: bottomSeparator.height)

        layoutSelectionBarView()

        flipSubviewsForRTL()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.max)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxButtonHeight: CGFloat = 0.0
        var maxButtonWidth: CGFloat = 0.0

        for button in buttons {
            let size = button.sizeThatFits(size)

            maxButtonHeight = max(maxButtonHeight, UIScreen.main.roundToDevicePixels(size.height))
            maxButtonWidth = max(maxButtonWidth, UIScreen.main.roundToDevicePixels(size.width))
        }

        let fittingSize = CGSize(width: maxButtonWidth * CGFloat(buttons.count), height: maxButtonHeight)

        return CGSize(width: min(fittingSize.width, size.width), height: min(fittingSize.height, size.height))
    }

    private func setupButtons(titles: [String]) {
        // Create buttons
        for (index, title) in titles.enumerated() {
            insertSegment(withTitle: title, at: index)
        }

        // Select first button
        if !titles.isEmpty {
            selectSegment(at: 0, animated: false)
        }
    }

    private func createButton(withTitle title: String) -> MSSegmentedControlButton {
        let button = MSSegmentedControlButton()
        button.setTitle(title, for: .normal)
        button.accessibilityLabel = title
        button.accessibilityHint = String(format: "Accessibility.Segmented.Button.Hint".localized, title)
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        return button
    }

    @objc private func handleButtonTap(_ sender: MSSegmentedControlButton) {
        if let index = buttons.firstIndex(of: sender), selectedSegmentIndex != index {
            selectSegment(at: index, animated: isAnimated)
            sendActions(for: .valueChanged)
        }
    }

    private func updateButton(at index: Int, isSelected: Bool) {
        guard index <= buttons.count else {
            return
        }

        let button = buttons[index]
        button.isSelected = isSelected
    }

    private func layoutSelectionBarView() {
        guard selectedSegmentIndex != -1 else {
            return
        }
        let button = buttons[selectedSegmentIndex]

        selectionBarView.frame = CGRect(
            x: button.left,
            y: button.bottom - Constants.selectionBarHeight,
            width: button.width,
            height: Constants.selectionBarHeight)
    }

    private func updateSelectionBarViewColor() {
        selectionBarView.backgroundColor = isEnabled ? MSColors.SegmentedControl.selectionBarNormal : MSColors.SegmentedControl.selectionBarDisabled
    }
}

// MARK: - MSSegmentedControlButton

private class MSSegmentedControlButton: UIButton {
    struct Constants {
        static let contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 13, right: 12)
        static let titleFontStyle: MSTextStyle = .subhead
    }

    init() {
        super.init(frame: .zero)

        contentEdgeInsets = Constants.contentEdgeInsets
        titleLabel?.font = Constants.titleFontStyle.font
        titleLabel?.lineBreakMode = .byTruncatingTail
        setTitleColor(MSColors.SegmentedControl.buttonTextNormal, for: .normal)
        setTitleColor(MSColors.SegmentedControl.buttonTextSelected, for: .selected)
        setTitleColor(MSColors.SegmentedControl.buttonTextDisabled, for: .disabled)
        setTitleColor(MSColors.SegmentedControl.buttonTextSelectedAndDisabled, for: [.selected, .disabled])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
