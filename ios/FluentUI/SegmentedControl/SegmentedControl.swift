//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit
import Combine

// MARK: SegmentedControl
/// A styled segmented control that should be used instead of UISegmentedControl. It is designed to flex the button width proportionally to the control's width.
@objc(MSFSegmentedControl)
open class SegmentedControl: UIView, TokenizedControlInternal {
    private struct Constants {
        static let selectionBarHeight: CGFloat = 1.5
        static let pillContainerHorizontalInset: CGFloat = 16
        static let pillButtonCornerRadius: CGFloat = 16
        static let iPadMinimumWidth: CGFloat = 375
    }

    open var isEnabled: Bool = true {
        didSet {
            for button in buttons {
                button.isEnabled = isEnabled
            }
            updateColors()
        }
    }

    @objc public var isAnimated: Bool = true
    @objc public var numberOfSegments: Int { return items.count }
    @objc public var shouldSetEqualWidthForSegments: Bool = true {
        didSet {
            updateStackDistribution()
            updatePillContainerConstraints()
        }
    }

    /// only used for pill style segment control. It is used to define the inset of the pillContainerView
    @objc public var contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.pillContainerHorizontalInset, bottom: 0, trailing: Constants.pillContainerHorizontalInset) {
        didSet {
            guard oldValue != contentInset else {
                return
            }
            updatePillContainerConstraints()

            invalidateIntrinsicContentSize()
        }
    }
    /// The closure for the action to be called when a segment is selected.
    /// When called, the selected item and its index will be passed in to the closure.
    @objc public var onSelectAction: ((SegmentItem, Int) -> Void)?
    @objc public var selectedSegmentIndex: Int {
        get { return _selectedSegmentIndex }
        set { selectSegment(at: newValue, animated: false) }
    }

    private var _selectedSegmentIndex: Int = -1

    private var items = [SegmentItem]()
    internal var style: SegmentedControlStyle {
        didSet {
            updateColors()
        }
    }

    // Hierarchy for pill styles:
    //
    // pillContainerView (used to create 16pt inset on either side)
    // |--backgroundView (fill container view, uses restTabColor)
    // |--buttons (uses restLabelColor)
    // |--pillMaskedLabelsContainerView (fill container view, uses selectedTabColor)
    // |  |.mask -> selectionView
    // |  |--pillMaskedLabels (uses selectedLabelColor)
    // |  |--pillMaskedImages (uses selectedLabelColor)

    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private var buttons = [SegmentPillButton]()
    private let selectionView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous

        return view
    }()
    private let pillContainerView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let pillMaskedContentContainerView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()
    private var pillMaskedLabels = [UILabel?]()
    private var pillMaskedImages = [UIImageView?]()
    private var pillContainerViewConstraints: [NSLayoutConstraint] = []
    private lazy var leftFadeLayer: CAGradientLayer = {
        let leftFadeLayer = CAGradientLayer(layer: layer)
        leftFadeLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        leftFadeLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let baseColor = UIColor.white
        leftFadeLayer.colors = [baseColor.cgColor, baseColor.withAlphaComponent(0).cgColor]
        return leftFadeLayer
    }()
    private lazy var rightFadeLayer: CAGradientLayer = {
        let rightFadeLayer = CAGradientLayer(layer: layer)
        rightFadeLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        rightFadeLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        let baseColor = UIColor.white
        rightFadeLayer.colors = [baseColor.cgColor, baseColor.withAlphaComponent(0).cgColor]
        return rightFadeLayer
    }()

    private var isAnimating: Bool = false

    public convenience init() {
        self.init(items: [])
    }

    /// Initializes a segmented control with the specified titles.
    ///
    /// - Parameter items: An array of Segmented Items representing the segments for this control.
    /// - Parameter style: A style used for rendering of the control.
    @objc public init(items: [SegmentItem], style: SegmentedControlStyle = .primaryPill) {
        self.style = style

        super.init(frame: .zero)

        backgroundView.layer.cornerRadius = Constants.pillButtonCornerRadius
        pillContainerView.addSubview(backgroundView)
        pillContainerView.addSubview(stackView)
        selectionView.backgroundColor = .black
        pillContainerView.addSubview(selectionView)
        pillMaskedContentContainerView.mask = selectionView
        pillContainerView.addSubview(pillMaskedContentContainerView)
        addButtons(items: items)
        pillContainerView.addInteraction(UILargeContentViewerInteraction())
        scrollView.addSubview(pillContainerView)
        addSubview(scrollView)

        updateStackDistribution()
        setupLayoutConstraints()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever overrideTokens changes.
        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.updateColors()
            self?.updateButtons()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public func updateColors() {
        let tabColor: DynamicColor
        let selectedTabColor: DynamicColor
        let selectedContentColor: UIColor
        if isEnabled {
            tabColor = tokenSet[.restTabColor].dynamicColor
            selectedTabColor = tokenSet[.selectedTabColor].dynamicColor
            selectedContentColor = UIColor(dynamicColor: tokenSet[.selectedLabelColor].dynamicColor)
        } else {
            tabColor = tokenSet[.disabledTabColor].dynamicColor
            selectedTabColor = tokenSet[.disabledSelectedTabColor].dynamicColor
            selectedContentColor = UIColor(dynamicColor: tokenSet[.disabledSelectedLabelColor].dynamicColor)
        }
        backgroundView.backgroundColor = UIColor(dynamicColor: tabColor)
        pillMaskedContentContainerView.backgroundColor = UIColor(dynamicColor: selectedTabColor)
        for maskedLabel in pillMaskedLabels {
            guard let maskedLabel = maskedLabel else {
                continue
            }
            maskedLabel.textColor = selectedContentColor
        }
        for maskedImage in pillMaskedImages {
            guard let maskedImage = maskedImage else {
                continue
            }
            maskedImage.tintColor = selectedContentColor
        }
    }

    /// Insert new segment at index with the specified title. If a segment exists at that index, it will be inserted before and will therefore take its index.
    ///
    /// - Parameters:
    ///   - item: The item of the newly created segment
    ///   - index: The index at which to insert the newly created segment
    @objc open func insertSegment(_ item: SegmentItem, at index: Int) {
        items.insert(item, at: index)

        let button = createPillButton(withItem: item)
        stackView.addArrangedSubview(button)
        addMaskedContent(over: button, at: index, hasImage: item.image != nil)
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
        if let maskedLabel = pillMaskedLabels.remove(at: index) {
            maskedLabel.removeFromSuperview()
        }
        if let maskedImage = pillMaskedLabels.remove(at: index) {
            maskedImage.removeFromSuperview()
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
        precondition(index >= 0 && index < buttons.count,
                     "SegmentedControl > try to selected segment index with invalid index: \(index)")

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
            UIView.animate(withDuration: selectionChangeAnimationDuration,
                           delay: 0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
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

        stackView.layoutIfNeeded()

        // flipSubviewsForRTL only works on direct children subviews
        pillContainerView.flipSubviewsForRTL()

        flipSubviewsForRTL()
        layoutSelectionView()

        layer.addSublayer(leftFadeLayer)
        var leftLayerFrame = layer.bounds
        leftLayerFrame.size.width = 50
        leftLayerFrame.size.height = intrinsicContentSize.height
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        leftFadeLayer.frame = leftLayerFrame
        CATransaction.commit()

        layer.addSublayer(rightFadeLayer)
        var rightLayerFrame = layer.bounds
        rightLayerFrame.origin.x = rightLayerFrame.size.width - 50
        rightLayerFrame.size.width = 50
        rightLayerFrame.size.height = intrinsicContentSize.height
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        rightFadeLayer.frame = rightLayerFrame
        CATransaction.commit()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                   height: CGFloat.greatestFiniteMagnitude))
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        invalidateIntrinsicContentSize()
        layoutSubviews()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = window else {
            return CGSize.zero
        }
        var height: CGFloat = 0.0
        var width: CGFloat = 0.0

        for button in buttons {
            let size = button.sizeThatFits(size)
            height = max(height, ceil(size.height))
            if !shouldSetEqualWidthForSegments {
                width += ceil(size.width)
            }
        }

        let windowSafeAreaInsets = window.safeAreaInsets
        let windowWidth = window.bounds.width - windowSafeAreaInsets.left - windowSafeAreaInsets.right
        if shouldSetEqualWidthForSegments {
            if traitCollection.userInterfaceIdiom == .pad {
                width = max(windowWidth / 2, Constants.iPadMinimumWidth)
            } else {
                width = windowWidth
            }
        } else {
            width += (contentInset.leading + contentInset.trailing)
        }
        height += (contentInset.top + contentInset.bottom)

        let finalWidth = min(min(width, windowWidth), size.width)
        let finalHeight = min(height, size.height)
        return CGSize(width: finalWidth,
                      height: finalHeight)
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()

        tokenSet.update(fluentTheme)
        updateColors()
        updateButtons()
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

    public typealias TokenSetKeyType = SegmentedControlTokenSet.Tokens
    lazy public var tokenSet: SegmentedControlTokenSet = .init(style: { self.style })
    var tokenSetSink: AnyCancellable?

    var selectionChangeAnimationDuration: TimeInterval { return 0.2 }

    private func updateButtons() {
        let contentColor = isEnabled ? UIColor(dynamicColor: tokenSet[.restLabelColor].dynamicColor) : UIColor(dynamicColor: tokenSet[.disabledLabelColor].dynamicColor)
        for (index, button) in buttons.enumerated() {
            button.updateTokenizedValues()
            button.setTitleColor(contentColor, for: .normal)
            button.tintColor = contentColor
            pillMaskedLabels[index]?.font = button.titleLabel?.font
        }
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

    private func createPillButton(withItem item: SegmentItem) -> SegmentPillButton {
        let button = SegmentPillButton(withItem: item, tokenSet: tokenSet)
        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        return button
    }

    private func addMaskedContent(over button: SegmentPillButton, at index: Int, hasImage: Bool) {
        let unmaskedContent: UIView
        let maskedContent: UIView
        let maskedImageView: UIImageView?
        let maskedLabel: UILabel?
        if hasImage {
            guard let buttonImageView = button.imageView else {
                return
            }
            let imageView = UIImageView(image: button.image(for: .normal))
            maskedImageView = imageView
            maskedLabel = nil
            maskedContent = imageView as UIView
            unmaskedContent = buttonImageView as UIView
        } else {
            guard let buttonLabel = button.titleLabel else {
                return
            }
            let label = UILabel()
            label.text = button.currentTitle
            label.font = buttonLabel.font
            maskedImageView = nil
            maskedLabel = label
            maskedContent = label as UIView
            unmaskedContent = buttonLabel as UIView
        }
        maskedContent.translatesAutoresizingMaskIntoConstraints = false
        maskedContent.isAccessibilityElement = false
        pillMaskedContentContainerView.addSubview(maskedContent)
        pillMaskedLabels.insert(maskedLabel, at: index)
        pillMaskedImages.insert(maskedImageView, at: index)
        let constraints = [
            unmaskedContent.leadingAnchor.constraint(equalTo: maskedContent.leadingAnchor),
            unmaskedContent.trailingAnchor.constraint(equalTo: maskedContent.trailingAnchor),
            unmaskedContent.topAnchor.constraint(equalTo: maskedContent.topAnchor),
            unmaskedContent.bottomAnchor.constraint(equalTo: maskedContent.bottomAnchor)
        ]

        if #available(iOS 15.0, *) {
            button.updateMaskedContentConstraints = {
                unmaskedContent.removeConstraints(constraints)
                NSLayoutConstraint.activate(constraints)
            }
        } else {
            NSLayoutConstraint.activate(constraints)
        }
    }

    @objc private func handleButtonTap(_ sender: SegmentPillButton) {
        guard let index = buttons.firstIndex(of: sender), selectedSegmentIndex != index  else {
            return
        }

        selectSegment(at: index, animated: isAnimated)
        if let onSelectAction = onSelectAction {
            onSelectAction(items[index], index)
        }
    }

    private func updatePillContainerConstraints() {
        NSLayoutConstraint.deactivate(pillContainerViewConstraints)
        let leadingAnchor: NSLayoutXAxisAnchor
        let trailingAnchor: NSLayoutXAxisAnchor
        if shouldSetEqualWidthForSegments {
            leadingAnchor = self.safeAreaLayoutGuide.leadingAnchor
            trailingAnchor = self.safeAreaLayoutGuide.trailingAnchor
        } else {
            leadingAnchor = scrollView.leadingAnchor
            trailingAnchor = scrollView.trailingAnchor
        }
        pillContainerViewConstraints = [
            pillContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                                   constant: contentInset.top),
            pillContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInset.leading),
            pillContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInset.trailing),
            pillContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                   constant: -contentInset.bottom)
        ]
        NSLayoutConstraint.activate(pillContainerViewConstraints)
    }

    private func setupLayoutConstraints () {
        updatePillContainerConstraints()
        let safeArea = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            backgroundView.leadingAnchor.constraint(equalTo: pillContainerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: pillContainerView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: pillContainerView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: pillContainerView.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: pillContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: pillContainerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: pillContainerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: pillContainerView.bottomAnchor),

            pillMaskedContentContainerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            pillMaskedContentContainerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            pillMaskedContentContainerView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            pillMaskedContentContainerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
    }

    private func updateButton(at index: Int, isSelected: Bool) {
        guard index <= buttons.count else {
            return
        }

        let button = buttons[index]
        button.isSelected = isSelected
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        tokenSet.update(window.fluentTheme)
        updateColors()
        updateButtons()
    }

    private func layoutSelectionView() {
        guard selectedSegmentIndex != -1 else {
            return
        }
        let button = buttons[selectedSegmentIndex]

        selectionView.frame = button.frame
        selectionView.layer.cornerRadius = Constants.pillButtonCornerRadius
    }

    private func updateAccessibilityHints() {
        for (index, button) in buttons.enumerated() {
            button.accessibilityHint = String.localizedStringWithFormat("Accessibility.MSPillButtonBar.Hint".localized,
                                                                        index + 1, items.count)
        }
    }

    private func updateStackDistribution() {
        stackView.distribution = shouldSetEqualWidthForSegments ? .fillEqually : .fillProportionally
    }
}
