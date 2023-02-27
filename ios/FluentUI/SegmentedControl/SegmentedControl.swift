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
    /// Defines if the segments of the `SegmentedControl` are equal in width.
    @objc public var shouldSetEqualWidthForSegments: Bool = true {
        didSet {
            updateStackDistribution()
        }
    }

    /// Defines if the `SegmentedControl` will take up the full width of the screen on iPhone, or half on iPad.
    /// Scrolling will only work if this is false.
    @objc public var isFixedWidth: Bool = true {
        didSet {
            updateViewHierarchyForScrolling()
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

    // Hierarchy:
    //
    // isFixedWidth = false (adds mask and scrollView):
    // layer.mask -> gradientMaskLayer
    // scrollView
    // |--pillContainerView (used to create 16pt inset on either side)
    // |  |--stackView (fill container view, uses restTabColor)
    // |  |  |--buttons (uses restLabelColor)
    // |  |--pillMaskedContentContainerView (fill container view, uses selectedTabColor)
    // |  |  |.mask -> selectionView
    // |  |  |--pillMaskedLabels (uses selectedLabelColor)
    // |  |  |--pillMaskedImages (uses selectedLabelColor)
    //
    // isFixedWidth = true:
    // pillContainerView (used to create 16pt inset on either side)
    // |--stackView (fill container view, uses restTabColor)
    // |  |--buttons (uses restLabelColor)
    // |--pillMaskedContentContainerView (fill container view, uses selectedTabColor)
    // |  |.mask -> selectionView
    // |  |--pillMaskedLabels (uses selectedLabelColor)
    // |  |--pillMaskedImages (uses selectedLabelColor)

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
        stackView.layer.cornerCurve = .continuous

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

    private lazy var scrollViewConstraints: [NSLayoutConstraint] = {
        let safeArea = safeAreaLayoutGuide
        return [scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)]
    }()

    private var isAnimating: Bool = false

    private let gradientMaskLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }()

    private var gradientMaskColors: [CGColor] {
        let contentOffsetX = scrollView.contentOffset.x
        let leftColor = contentOffsetX <= 0 ? UIColor.black : UIColor.clear
        let rightColor = contentOffsetX >= maximumContentOffset ? UIColor.black : UIColor.clear
        // Divide the Segmented Control into 5 sections to control the length
        // of the gradient
        return [leftColor, UIColor.black, UIColor.black, UIColor.black, rightColor].map { $0.cgColor }
    }

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
        scrollView.delegate = self

        stackView.layer.cornerRadius = Constants.pillButtonCornerRadius
        pillContainerView.addSubview(stackView)
        selectionView.backgroundColor = .black
        pillContainerView.addSubview(selectionView)
        pillMaskedContentContainerView.mask = selectionView
        pillContainerView.addSubview(pillMaskedContentContainerView)
        addButtons(items: items)
        pillContainerView.addInteraction(UILargeContentViewerInteraction())
        addSubview(pillContainerView)

        updateStackDistribution()
        setupLayoutConstraints()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever overrideTokens changes.
        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.updateTokenizedValues()
        }
        updateTokenizedValues()
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
        stackView.backgroundColor = UIColor(dynamicColor: tabColor)
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
        if !isFixedWidth {
            scrollView.scrollRectToVisible(buttons[_selectedSegmentIndex].frame, animated: animated)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        stackView.layoutIfNeeded()

        // flipSubviewsForRTL only works on direct children subviews
        pillContainerView.flipSubviewsForRTL()

        flipSubviewsForRTL()
        layoutSelectionView()

        updateGradientMaskColors()
        gradientMaskLayer.frame = layer.bounds
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                   height: CGFloat.greatestFiniteMagnitude))
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 0.0
        var width: CGFloat = 0.0

        for button in buttons {
            let size = button.sizeThatFits(size)
            height = max(height, ceil(size.height))
            if !isFixedWidth {
                width += ceil(size.width)
            }
        }

        if isFixedWidth {
            if let window = window {
                let windowSafeAreaInsets = window.safeAreaInsets
                let windowWidth = window.bounds.width - windowSafeAreaInsets.left - windowSafeAreaInsets.right
                if traitCollection.userInterfaceIdiom == .pad {
                    width = max(windowWidth / 2, Constants.iPadMinimumWidth)
                } else {
                    width = windowWidth
                }
            }
        } else {
            width += (contentInset.leading + contentInset.trailing)
        }
        height += (contentInset.top + contentInset.bottom)

        return CGSize(width: min(width, size.width),
                      height: min(height, size.height))
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateGradientMaskColors()
        if isFixedWidth {
            invalidateIntrinsicContentSize()
        }
    }

    /// Used to retrieve the view from the segment at the specified index
    open func segmentView(at index: Int) -> UIView? {
        guard index <= buttons.count else {
            return nil
        }

        return buttons[index] as UIView
    }

#if DEBUG
    public override var accessibilityIdentifier: String? {
        get { return "Segmented Control with \(items.count) \(isEnabled ? "enabled" : "disabled") buttons" }
        set { }
    }
#endif

    public typealias TokenSetKeyType = SegmentedControlTokenSet.Tokens
    lazy public var tokenSet: SegmentedControlTokenSet = .init(style: { [weak self] in
        return self?.style ?? .primaryPill
    })
    private var tokenSetSink: AnyCancellable?

    private let selectionChangeAnimationDuration: TimeInterval = 0.2

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
        let topAnchor: NSLayoutYAxisAnchor
        let leadingAnchor: NSLayoutXAxisAnchor
        let trailingAnchor: NSLayoutXAxisAnchor
        let bottomAnchor: NSLayoutYAxisAnchor
        if isFixedWidth {
            topAnchor = self.safeAreaLayoutGuide.topAnchor
            leadingAnchor = self.safeAreaLayoutGuide.leadingAnchor
            trailingAnchor = self.safeAreaLayoutGuide.trailingAnchor
            bottomAnchor = self.safeAreaLayoutGuide.bottomAnchor
        } else {
            topAnchor = scrollView.topAnchor
            leadingAnchor = scrollView.leadingAnchor
            trailingAnchor = scrollView.trailingAnchor
            bottomAnchor = scrollView.bottomAnchor
        }
        pillContainerViewConstraints = [
            pillContainerView.topAnchor.constraint(equalTo: topAnchor,
                                                   constant: contentInset.top),
            pillContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInset.leading),
            pillContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInset.trailing),
            pillContainerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -contentInset.bottom)
        ]
        NSLayoutConstraint.activate(pillContainerViewConstraints)
    }

    private func setupLayoutConstraints () {
        updatePillContainerConstraints()

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: pillContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: pillContainerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: pillContainerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: pillContainerView.bottomAnchor),

            pillMaskedContentContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            pillMaskedContentContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            pillMaskedContentContainerView.topAnchor.constraint(equalTo: stackView.topAnchor),
            pillMaskedContentContainerView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
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
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(fluentTheme)
    }

    private func layoutSelectionView() {
        guard selectedSegmentIndex != -1 else {
            return
        }
        let button = buttons[selectedSegmentIndex]

        selectionView.frame = button.frame
        selectionView.layer.cornerRadius = Constants.pillButtonCornerRadius
    }

    private func updateTokenizedValues() {
        updateColors()
        updateButtons()
        layoutSelectionView()
        setNeedsLayout()
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

    private func updateGradientMaskColors() {
        gradientMaskLayer.colors = gradientMaskColors
    }

    private func updateViewHierarchyForScrolling() {
        if isFixedWidth {
            scrollView.removeFromSuperview()
            pillContainerView.removeFromSuperview()
            addSubview(pillContainerView)
            layer.mask = nil

            NSLayoutConstraint.deactivate(scrollViewConstraints)
        } else {
            pillContainerView.removeFromSuperview()
            scrollView.addSubview(pillContainerView)
            addSubview(scrollView)
            layer.mask = gradientMaskLayer

            NSLayoutConstraint.activate(scrollViewConstraints)
        }
    }

    private var maximumContentOffset: CGFloat {
        return (stackView.frame.size.width + 2 * Constants.pillContainerHorizontalInset) - scrollView.frame.size.width
    }
}

// MARK: UIScrollViewDelegate
extension SegmentedControl: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateGradientMaskColors()
    }
}
