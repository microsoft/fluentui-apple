//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSNavigationBar

/// UINavigationBar subclass, with a content view that contains various custom UIElements
/// Contains the MSNavigationTitleView class and handles passing animatable progress through
/// Custom UI can be hidden if desired
@objcMembers
open class MSNavigationBar: UINavigationBar {
    @objc(MSNavigationBarStyle)
    public enum Style: Int {
        case `default`
        case primary
        case system

        var backgroundColor: UIColor {
            switch self {
            case .primary, .default:
                return MSColors.Navigation.Primary.background
            case .system:
                return MSColors.Navigation.System.background
            }
        }

        var tintColor: UIColor {
            switch self {
            case .primary, .default:
                return MSColors.Navigation.Primary.tint
            case .system:
                return MSColors.Navigation.System.tint
            }
        }

        var titleColor: UIColor {
            switch self {
            case .primary, .default:
                return MSColors.Navigation.Primary.title
            case .system:
                return MSColors.Navigation.System.title
            }
        }
    }

    /// Describes the sizing behavior of navigation bar elements (title, avatar, bar height)
    @objc(MSNavigationBarElementSize)
    public enum ElementSize: Int {
        case automatic, contracted, expanded
    }

    @objc(MSNavigationBarShadow)
    public enum Shadow: Int {
        case automatic
        case alwaysHidden
    }

    static let expansionContractionAnimationDuration: TimeInterval = 0.1 // the interval over which the expansion/contraction animations occur

    private static var defaultStyle: Style = .primary

    private struct Constants {
        static let normalContentHeight: CGFloat = 44
        static let expandedContentHeight: CGFloat = 50
        static let expandedContentHeightDifference: CGFloat = expandedContentHeight - normalContentHeight

        static let contentLeadingMargin: CGFloat = 8
        static let contentTrailingMargin: CGFloat = 6

        static let obscuringAnimationDuration: TimeInterval = 0.12
        static let revealingAnimationDuration: TimeInterval = 0.25
    }

    /// An object that conforms to the `MSAvatar` protocol and provides text and an optional image for display as an `MSAvatarView` next to the large title. Only displayed if `showsLargeTitle` is true on the current navigation item.
    open var avatar: MSAvatar? {
        didSet {
            titleView.avatar = avatar
        }
    }

    /// A string to optionally customize the accessibility label of the large title's avatar
    open var avatarCustomAccessibilityLabel: String? {
        didSet {
            titleView.avatarCustomAccessibilityLabel = avatarCustomAccessibilityLabel
        }
    }

    /// An element size to describe the behavior of large title's avatar. If `.automatic`, avatar will resize when `expand(animated:)` and `contract(animated:)` are called.
    open var avatarSize: ElementSize = .automatic {
        didSet {
            titleView.avatarSize = avatarSize
            updateBarHeight()
        }
    }

    /// An element size to describe the behavior of the navigation bar's expanded height. Set automatically when the values of `avatarSize` and `titleSize` are changed. The bar will lock to expanded size if either element is set to `.expanded`, lock to contracted if both elements are `.contracted`, and stay automatic in any other case.
    open private(set) var barHeight: ElementSize = .automatic {
        didSet {
            guard barHeight != oldValue else {
                return
            }
            switch barHeight {
            case .automatic:
                return
            case .contracted:
                contract(true)
            case .expanded:
                expand(true)
            }
        }
    }

    /// An element size to describe the behavior of the navigation bar's large title. If `.automatic`, the title label will resize when `expand(animated:)` and `contract(animated:)` are called.
    open var titleSize: ElementSize = .automatic {
        didSet {
            titleView.titleSize = titleSize
            updateBarHeight()
        }
    }

    /// An optional closure to be called when the avatar view is tapped, if it is present.
    open var onAvatarTapped: (() -> Void)? {
        didSet {
            titleView.onAvatarTapped = onAvatarTapped
        }
    }

    open override var center: CGPoint {
        get { return super.center }
        set {
            var newValue = newValue
            // Workaround for iOS bug: when nav bar is hidden and device is rotated, the hidden nav bar get pushed up by additional 20px (status bar height) and when nav bar gets shown it animates from too far position leaving a 20px gap that shows window background (black by default) - this will then also affect nav bar hiding animation.
            newValue.y = max(-height / 2, newValue.y)
            super.center = newValue
        }
    }

    var style: Style = defaultStyle {
        didSet {
            setColorsForStyle()
        }
    }

    var titleView = MSLargeTitleView() {
        willSet {
            titleView.removeFromSuperview()
        }
        didSet {
            contentStackView.insertArrangedSubview(titleView, at: 0)
            titleView.setContentHuggingPriority(.high, for: .horizontal)
            titleView.setContentCompressionResistancePriority(.high, for: .horizontal)
        }
    }

    let backgroundView = UIView() //used for coloration
    //used to cover the navigationbar during animated transitions between VCs
    private let contentStackView = ContentStackView() //used to contain the various custom UI Elements
    private let rightBarButtonItemsStackView = UIStackView()
    private let leftBarButtonItemsStackView = UIStackView()
    private let spacerView = UIView() //defines the space between the left and right barbuttonitems stack

    private var showsLargeTitle: Bool = true {
        didSet {
            if showsLargeTitle == oldValue {
                return
            }
            updateAccessibilityElements()
            updateViewsForLargeTitlePresentation(for: topItem)
        }
    }

    //whether all bar button items are grouped on the right side
    private var allBarButtonItemsRightAligned: Bool = true

    private var leftBarButtonItemsObserver: NSKeyValueObservation?
    private var rightBarButtonItemsObserver: NSKeyValueObservation?
    private var titleObserver: NSKeyValueObservation?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initBase()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBase()
    }

    /// Custom base initializer, used regardless of entry point
    /// Sets up the custom interface
    private func initBase() {
        clipsToBounds = true

        contain(view: backgroundView)

        setupContentStackView()
        contentStackView.isLayoutMarginsRelativeArrangement = true
        updateContentStackViewMargins(forExpandedContent: true)

        //titleView
        contentStackView.addArrangedSubview(titleView)
        titleView.setContentHuggingPriority(.high, for: .horizontal)
        titleView.setContentCompressionResistancePriority(.high, for: .horizontal)

        //leftBarButtonItemsStackView (ignored for now, TASK: 729995)
//        contentStackView.addArrangedSubview(leftBarButtonItemsStackView)

        //spacerView
        contentStackView.addArrangedSubview(spacerView)
        spacerView.backgroundColor = .clear
        spacerView.setContentHuggingPriority(.low, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.low, for: .horizontal)

        //rightBarButtonItemsStackView
        contentStackView.addArrangedSubview(rightBarButtonItemsStackView)
        rightBarButtonItemsStackView.setContentHuggingPriority(.medium, for: .horizontal)
        rightBarButtonItemsStackView.setContentCompressionResistancePriority(.medium, for: .horizontal)

        updateViewsForLargeTitlePresentation(for: topItem)

        setColorsForStyle()

        isTranslucent = false

        updateAccessibilityElements()
    }

    // Manually contains the content stack view with lower priority constraints in order to avoid invalid simultaneous constraints when nav bar is hidden.
    private func setupContentStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        let identifierHeader = String(describing: type(of: contentStackView))

        let leading = contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        leading.identifier = identifierHeader + "_containmentLeading"

        let trailing = contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.identifier = identifierHeader + "_containmentTrailing"
        trailing.priority = .defaultHigh

        let top = contentStackView.topAnchor.constraint(equalTo: topAnchor)
        top.identifier = identifierHeader + "_containmentTop"

        let bottom = contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.identifier = identifierHeader + "_containmentBottom"
        bottom.priority = .defaultHigh

        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    private func updateContentStackViewMargins(forExpandedContent contentIsExpanded: Bool) {
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constants.contentLeadingMargin,
            bottom: contentIsExpanded ? -Constants.expandedContentHeightDifference : 0,
            trailing: Constants.contentTrailingMargin
        )
    }

    private func updateBarHeight() {
        if avatarSize == .expanded || titleSize == .expanded {
            barHeight = .expanded
        } else if avatarSize == .contracted && titleSize == .contracted {
            barHeight = .contracted
        } else {
            barHeight = .automatic
        }
    }

    /// Guarantees that the custom UI remains on top of the subview stack
    /// Fetches the current navigation item and triggers a UI update
    open override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(backgroundView)
        bringSubviewToFront(contentStackView)
        updateAccessibilityElements()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // contentStackView's content extends its bounds outside of navigation bar bounds
        return super.point(inside: point, with: event) ||
            contentStackView.point(inside: convert(point, to: contentStackView), with: event)
    }

    private func setColorsForStyle() {
        let backgroundColor = style.backgroundColor
        switch style {
        case .primary, .default:
            titleView.style = .light
        case .system:
            titleView.style = .dark
        }
        backgroundView.backgroundColor = backgroundColor
        barTintColor = backgroundColor
        tintColor = style.tintColor
        if var titleTextAttributes = titleTextAttributes {
            titleTextAttributes[NSAttributedString.Key.foregroundColor] = style.titleColor
            self.titleTextAttributes = titleTextAttributes
        } else {
            titleTextAttributes = [NSAttributedString.Key.foregroundColor: style.titleColor]
        }
    }

    // MARK: - UINavigationItem & UIBarButtonItem Handling Methods

    func update(with navigationItem: UINavigationItem) {
        style = actualStyle(for: navigationItem)

        showsLargeTitle = navigationItem.usesLargeTitle
        updateShadow(for: navigationItem)

        titleView.update(with: navigationItem)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if allBarButtonItemsRightAligned {
            let items = navigationItem.leftBarButtonItems + navigationItem.rightBarButtonItems?.reversed()
            refresh(barButtonStack: leftBarButtonItemsStackView, with: nil)
            refresh(barButtonStack: rightBarButtonItemsStackView, with: items)
        } else {
            refresh(barButtonStack: leftBarButtonItemsStackView, with: navigationItem.leftBarButtonItems)
            refresh(barButtonStack: rightBarButtonItemsStackView, with: navigationItem.rightBarButtonItems?.reversed())
        }

        // Force layout to avoid animation
        layoutIfNeeded()

        leftBarButtonItemsObserver = navigationItem.observe(\UINavigationItem.leftBarButtonItems) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        rightBarButtonItemsObserver = navigationItem.observe(\UINavigationItem.rightBarButtonItems) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
        titleObserver = navigationItem.observe(\UINavigationItem.title) { [unowned self] item, _ in
            self.navigationItemDidUpdate(item)
        }
    }

    func actualStyle(for navigationItem: UINavigationItem) -> Style {
        if navigationItem.navigationBarStyle != .default {
            return navigationItem.navigationBarStyle
        }
        if let items = items?.prefix(while: { $0 != navigationItem }),
            let item = items.last(where: { $0.navigationBarStyle != .default }) {
            return item.navigationBarStyle
        }
        return MSNavigationBar.defaultStyle
    }

    private func refresh(barButtonStack: UIStackView, with items: [UIBarButtonItem]?) {
        barButtonStack.removeAllSubviews()
        items?.forEach { item in
            barButtonStack.addArrangedSubview(item.createButton())
        }
    }

    private func navigationItemDidUpdate(_ navigationItem: UINavigationItem) {
        if navigationItem == topItem {
            update(with: navigationItem)
        }
    }

    // MARK: - Obscurant Handling & Show/Hide Animation Methods

    func obscureContent(animated: Bool) {
        if contentStackView.alpha == 1 {
            if animated {
                UIView.animate(withDuration: Constants.obscuringAnimationDuration) {
                    self.contentStackView.alpha = 0
                }
            } else {
                contentStackView.alpha = 0
            }
        }
    }

    func revealContent(animated: Bool) {
        if contentStackView.alpha == 0 {
            if animated {
                UIView.animate(withDuration: Constants.revealingAnimationDuration) {
                    self.contentStackView.alpha = 1
                }
            } else {
                contentStackView.alpha = 1
            }
        }
    }

    private func updateViewsForLargeTitlePresentation(for navigationItem: UINavigationItem?) {
        if showsLargeTitle {
            backgroundView.safelyShow()
            contentStackView.safelyShow()
        } else {
            backgroundView.safelyHide()
            contentStackView.safelyHide()
        }
        updateShadow(for: navigationItem)
    }

    private func updateShadow(for navigationItem: UINavigationItem?) {
        if needsShadow(for: navigationItem) {
            shadowImage = nil
            // Forcing layout to update size of shadow image view otherwise it stays with 0 height
            setNeedsLayout()
            subviews.forEach { $0.setNeedsLayout() }
        } else {
            shadowImage = UIImage()
        }
    }

    private func needsShadow(for navigationItem: UINavigationItem?) -> Bool {
        switch navigationItem?.navigationBarShadow ?? .automatic {
        case .automatic:
            return !showsLargeTitle && style == .system && navigationItem?.accessoryView == nil
        case .alwaysHidden:
            return false
        }
    }

    /// Coordinates expansions between the MSShyHeaderController, the navBar's TitleView, and the nav bar itself
    ///
    /// - Parameter animated: to animate the expansion or not
    func expand(_ animated: Bool) {
        titleView.expand(animated: animated)

        guard barHeight != .contracted else {
            return
        }
        let updateLayout = {
            self.updateContentStackViewMargins(forExpandedContent: true)
        }
        if animated {
            UIView.animate(withDuration: MSNavigationBar.expansionContractionAnimationDuration) {
                updateLayout()
                self.contentStackView.layoutIfNeeded()
            }
        } else {
            updateLayout()
        }
    }

    /// Coordinates contractions between the MSShyHeaderController, the navBar's TitleView, and the nav bar itself
    ///
    /// - Parameter animated: to animate the contraction or not
    func contract(_ animated: Bool) {
        guard traitCollection.verticalSizeClass != .compact else {
            return
        }

        titleView.contract(animated: animated)

        guard barHeight != .expanded else {
            return
        }
        let updateLayout = {
            self.updateContentStackViewMargins(forExpandedContent: false)
        }
        if animated {
            UIView.animate(withDuration: MSNavigationBar.expansionContractionAnimationDuration) {
                updateLayout()
                self.contentStackView.layoutIfNeeded()
            }
        } else {
            updateLayout()
        }
    }

    // MARK: - Accessibility Overrides

    private func updateAccessibilityElements() {
        if showsLargeTitle {
            accessibilityElements = contentStackView.arrangedSubviews
        } else {
            accessibilityElements = nil
        }
    }
}

// MARK: - ContentStackView

/// UIStackView subclass that extends its touch area outside of its bounds to cover content that is laid out outside of stack view bounds due to negative content margins.
private class ContentStackView: UIStackView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) {
            return true
        }
        let contentBounds = bounds.inset(by: layoutMargins)
        return contentBounds.contains(point)
    }
}
