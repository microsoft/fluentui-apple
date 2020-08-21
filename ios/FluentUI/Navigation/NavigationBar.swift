//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Navigation Colors
public extension Colors {
    struct Navigation {
        public struct System {
            public static var background: UIColor = NavigationBar.background
            public static var tint: UIColor = NavigationBar.tint
            public static var title: UIColor = NavigationBar.title
        }
        public struct Primary {
            public static var tint = UIColor(light: textOnAccent, dark: System.tint)
            public static var title = UIColor(light: textOnAccent, dark: System.title)
        }
    }
}

// MARK: - NavigationBar

@available(*, deprecated, renamed: "NavigationBar")
public typealias MSNavigationBar = NavigationBar

/// UINavigationBar subclass, with a content view that contains various custom UIElements
/// Contains the MSNavigationTitleView class and handles passing animatable progress through
/// Custom UI can be hidden if desired
@objc(MSFNavigationBar)
open class NavigationBar: UINavigationBar {
    /// If the style is `.custom`, UINavigationItem's `navigationBarColor` is used for all the subviews' backgroundColor
    @objc(MSFNavigationBarStyle)
    public enum Style: Int {
        case `default`
        case primary
        case system
        case custom

        var tintColor: UIColor {
            switch self {
            case .primary, .default, .custom:
                return Colors.Navigation.Primary.tint
            case .system:
                return Colors.Navigation.System.tint
            }
        }

        var titleColor: UIColor {
            switch self {
            case .primary, .default, .custom:
                return Colors.Navigation.Primary.title
            case .system:
                return Colors.Navigation.System.title
            }
        }

        func backgroundColor(for window: UIWindow, customColor: UIColor?) -> UIColor {
            switch self {
            case .primary, .default:
                return defaultBackgroundColor(for: window)
            case .system:
                return Colors.Navigation.System.background
            case .custom:
                return customColor ?? defaultBackgroundColor(for: window)
            }
        }

        func defaultBackgroundColor(for window: UIWindow) -> UIColor {
            return UIColor(light: Colors.primary(for: window), dark: Colors.Navigation.System.background)
        }
    }

    /// Describes the sizing behavior of navigation bar elements (title, avatar, bar height)
    @objc(MSFNavigationBarElementSize)
    public enum ElementSize: Int {
        case automatic, contracted, expanded
    }

    @objc(MSFNavigationBarShadow)
    public enum Shadow: Int {
        case automatic
        case alwaysHidden
    }

    static let expansionContractionAnimationDuration: TimeInterval = 0.1 // the interval over which the expansion/contraction animations occur

    private static var defaultStyle: Style = .primary

    private struct Constants {
        static let systemHeight: CGFloat = 44
        static let normalContentHeight: CGFloat = 44
        static let expandedContentHeight: CGFloat = 48

        static let leftBarButtonItemLeadingMargin: CGFloat = 8
        static let rightBarButtonItemHorizontalPadding: CGFloat = 10

        static let contentLeadingMargin: CGFloat = 8
        static let contentTrailingMargin: CGFloat = 6

        static let obscuringAnimationDuration: TimeInterval = 0.12
        static let revealingAnimationDuration: TimeInterval = 0.25
    }

    /// An object that conforms to the `MSAvatar` protocol and provides text and an optional image for display as an `MSAvatarView` next to the large title. Only displayed if `showsLargeTitle` is true on the current navigation item. If avatar is nil, it won't show the avatar view.
    @objc open var avatar: Avatar? {
        didSet {
            titleView.avatar = avatar
        }
    }

    /// A string to optionally customize the accessibility label of the large title's avatar
    @objc open var avatarCustomAccessibilityLabel: String? {
        didSet {
            titleView.avatarCustomAccessibilityLabel = avatarCustomAccessibilityLabel
        }
    }

    /// An element size to describe the behavior of large title's avatar. If `.automatic`, avatar will resize when `expand(animated:)` and `contract(animated:)` are called.
    @objc open var avatarSize: ElementSize = .automatic {
        didSet {
            updateElementSizes()
        }
    }

    /// An element size to describe the behavior of the navigation bar's expanded height. Set automatically when the values of `avatarSize` and `titleSize` are changed. The bar will lock to expanded size if either element is set to `.expanded`, lock to contracted if both elements are `.contracted`, and stay automatic in any other case.
    @objc open private(set) dynamic var barHeight: ElementSize = .automatic {
        didSet {
            guard barHeight != oldValue else {
                return
            }

            let originalIsExpanded = isExpanded

            switch barHeight {
            case .automatic:
                if isExpanded {
                    expand(true)
                } else {
                    contract(true)
                }
            case .contracted:
                contract(true)
            case .expanded:
                expand(true)
            }

            isExpanded = originalIsExpanded
        }
    }

    /// An element size to describe the behavior of the navigation bar's large title. If `.automatic`, the title label will resize when `expand(animated:)` and `contract(animated:)` are called.
    @objc open var titleSize: ElementSize = .automatic {
        didSet {
            updateElementSizes()
        }
    }

    /// An optional closure to be called when the avatar view is tapped, if it is present.
    @objc open var onAvatarTapped: (() -> Void)? {
        didSet {
            titleView.onAvatarTapped = onAvatarTapped
        }
    }

    open override var center: CGPoint {
        get { return super.center }
        set {
            var newValue = newValue
            // Workaround for iOS bug: when nav bar is hidden and device is rotated, the hidden nav bar get pushed up by additional 20px (status bar height) and when nav bar gets shown it animates from too far position leaving a 20px gap that shows window background (black by default) - this will then also affect nav bar hiding animation.
            newValue.y = max(-frame.height / 2, newValue.y)
            super.center = newValue
        }
    }

    var titleView = LargeTitleView() {
        willSet {
            titleView.removeFromSuperview()
        }
        didSet {
            contentStackView.insertArrangedSubview(titleView, at: 0)
            titleView.setContentHuggingPriority(.required, for: .horizontal)
            titleView.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }

    private(set) var style: Style = defaultStyle

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

    private var leftBarButtonItemsObserver: NSKeyValueObservation?
    private var rightBarButtonItemsObserver: NSKeyValueObservation?
    private var titleObserver: NSKeyValueObservation?
    private var navigationBarColorObserver: NSKeyValueObservation?

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initBase()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
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
        if #available(iOS 13, *) {
            contentStackView.addInteraction(UILargeContentViewerInteraction())
        }

        //leftBarButtonItemsStackView: layout priorities are slightly lower to make sure titleView has the highest priority in horizontal spacing
        contentStackView.addArrangedSubview(leftBarButtonItemsStackView)
        leftBarButtonItemsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        leftBarButtonItemsStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        //titleView
        contentStackView.addArrangedSubview(titleView)
        titleView.setContentHuggingPriority(.required, for: .horizontal)
        titleView.setContentCompressionResistancePriority(.required, for: .horizontal)

        //spacerView
        contentStackView.addArrangedSubview(spacerView)
        spacerView.backgroundColor = .clear
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        //rightBarButtonItemsStackView: layout priorities are slightly lower to make sure titleView has the highest priority in horizontal spacing
        contentStackView.addArrangedSubview(rightBarButtonItemsStackView)
        rightBarButtonItemsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightBarButtonItemsStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        updateViewsForLargeTitlePresentation(for: topItem)
        updateColors(for: topItem)

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
        let contentHeight = contentIsExpanded ? Constants.expandedContentHeight : Constants.normalContentHeight
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constants.contentLeadingMargin,
            bottom: -(contentHeight - Constants.systemHeight),
            trailing: Constants.contentTrailingMargin
        )
    }

    /// Guarantees that the custom UI remains on top of the subview stack
    /// Fetches the current navigation item and triggers a UI update
    open override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(backgroundView)
        bringSubviewToFront(contentStackView)
        updateAccessibilityElements()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateColors(for: topItem)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // contentStackView's content extends its bounds outside of navigation bar bounds
        return super.point(inside: point, with: event) ||
            contentStackView.point(inside: convert(point, to: contentStackView), with: event)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass {
            updateElementSizes()
            updateContentStackViewMargins(forExpandedContent: contentIsExpanded)

            // change bar button image size depending on device rotation
            if showsLargeTitle, let navigationItem = topItem {
                updateBarButtonItems(with: navigationItem)
            }
        }
    }

    /// Override the avatarView with fallbackImageStyle rather than using avatar data
    /// - Parameter fallbackImageStyle: image style used in  avatarView
    @objc open func overrideAvatar(with fallbackImageStyle: AvatarFallbackImageStyle) {
        titleView.avatarOverrideFallbackImageStyle = fallbackImageStyle
    }

    // MARK: Element size handling

    private var currentAvatarSize: ElementSize {
        if traitCollection.verticalSizeClass == .compact {
            return .contracted
        }
        return avatarSize
    }
    private var currentTitleSize: ElementSize {
        if traitCollection.verticalSizeClass == .compact {
            return .contracted
        }
        return titleSize
    }
    private var currentBarHeight: ElementSize {
        if currentAvatarSize == .expanded || currentTitleSize == .expanded {
            return .expanded
        } else if currentAvatarSize == .contracted && currentTitleSize == .contracted {
            return .contracted
        } else {
            return .automatic
        }
    }

    private var contentIsExpanded: Bool {
        return barHeight == .automatic ? isExpanded : barHeight == .expanded
    }

    private func updateElementSizes() {
        titleView.avatarSize = currentAvatarSize
        titleView.titleSize = currentTitleSize
        barHeight = currentBarHeight
    }

    // MARK: UINavigationItem & UIBarButtonItem handling

    func updateColors(for navigationItem: UINavigationItem?) {
        if let window = window {
            let color = navigationItem?.navigationBarColor(for: window)

            switch style {
            case .primary, .default, .custom:
                titleView.style = .light
            case .system:
                titleView.style = .dark
            }

            barTintColor = color
            backgroundView.backgroundColor = color
            tintColor = style.tintColor
            if var titleTextAttributes = titleTextAttributes {
                titleTextAttributes[NSAttributedString.Key.foregroundColor] = style.titleColor
                self.titleTextAttributes = titleTextAttributes
            } else {
                titleTextAttributes = [NSAttributedString.Key.foregroundColor: style.titleColor]
            }

            navigationBarColorObserver = navigationItem?.observe(\.customNavigationBarColor) { [unowned self] navigationItem, _ in
                // Unlike title or barButtonItems that depends on the topItem, navigation bar color can be set from the parentViewController's navigationItem
                self.updateColors(for: navigationItem)
            }
        }
    }

    func update(with navigationItem: UINavigationItem) {
        let (actualStyle, actualItem) = actualStyleAndItem(for: navigationItem)
        style = actualStyle
        updateColors(for: actualItem)
        showsLargeTitle = navigationItem.usesLargeTitle
        updateShadow(for: navigationItem)

        titleView.update(with: navigationItem)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        updateBarButtonItems(with: navigationItem)

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

    func actualStyleAndItem(for navigationItem: UINavigationItem) -> (style: Style, item: UINavigationItem) {
        if navigationItem.navigationBarStyle != .default {
            return (navigationItem.navigationBarStyle, navigationItem)
        }
        if let items = items?.prefix(while: { $0 != navigationItem }),
            let item = items.last(where: { $0.navigationBarStyle != .default }) {
            return (item.navigationBarStyle, item)
        }
        return (NavigationBar.defaultStyle, navigationItem)
    }

    private func createBarButtonItemButton(with item: UIBarButtonItem, isLeftItem: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.isEnabled = item.isEnabled
        if isLeftItem {
            let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: isRTL ? 0 : Constants.leftBarButtonItemLeadingMargin, bottom: 0, right: isRTL ? Constants.leftBarButtonItemLeadingMargin : 0)
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Constants.rightBarButtonItemHorizontalPadding, bottom: 0, right: Constants.rightBarButtonItemHorizontalPadding)
        }

        button.tag = item.tag
        button.tintColor = item.tintColor
        button.titleLabel?.font = item.titleTextAttributes(for: .normal)?[.font] as? UIFont

        var portraitImage = item.image
        if portraitImage?.renderingMode == .automatic {
            portraitImage = portraitImage?.withRenderingMode(.alwaysTemplate)
        }
        var landscapeImage = item.landscapeImagePhone ?? portraitImage
        if landscapeImage?.renderingMode == .automatic {
            landscapeImage = landscapeImage?.withRenderingMode(.alwaysTemplate)
        }

        button.setImage(traitCollection.verticalSizeClass == .regular ? portraitImage : landscapeImage, for: .normal)
        button.setTitle(item.title, for: .normal)

        if let action = item.action {
            button.addTarget(item.target, action: action, for: .touchUpInside)
        }

        button.accessibilityIdentifier = item.accessibilityIdentifier
        button.accessibilityLabel = item.accessibilityLabel
        button.accessibilityHint = item.accessibilityHint
        if #available(iOS 13, *) {
            button.showsLargeContentViewer = true
            if let customLargeContentSizeImage = item.largeContentSizeImage {
                button.largeContentImage = customLargeContentSizeImage
            }

            if item.title == nil {
                button.largeContentTitle = item.accessibilityLabel
            }
        }
        return button
    }

    private func updateBarButtonItems(with navigationItem: UINavigationItem) {
        // only one left bar button item is support for large title view
        if let leftBarButtonItem = navigationItem.leftBarButtonItem {
            leftBarButtonItemsStackView.isHidden = false
            refresh(barButtonStack: leftBarButtonItemsStackView, with: [leftBarButtonItem], isLeftItem: true)
        } else {
            leftBarButtonItemsStackView.isHidden = true
        }
        refresh(barButtonStack: rightBarButtonItemsStackView, with: navigationItem.rightBarButtonItems?.reversed(), isLeftItem: false)
    }

    private func refresh(barButtonStack: UIStackView, with items: [UIBarButtonItem]?, isLeftItem: Bool) {
        barButtonStack.removeAllSubviews()
        items?.forEach { item in
            barButtonStack.addArrangedSubview(createBarButtonItemButton(with: item, isLeftItem: isLeftItem))
        }
    }

    private func navigationItemDidUpdate(_ navigationItem: UINavigationItem) {
        if navigationItem == topItem {
            update(with: navigationItem)
        }
    }

    // MARK: Obscurant handling

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

    // MARK: Large/Normal Title handling

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

    // MARK: Content expansion/contraction

    private var isExpanded: Bool = true

    func expand(_ animated: Bool) {
        isExpanded = true

        titleView.expand(animated: animated)

        guard barHeight != .contracted else {
            return
        }
        let updateLayout = {
            self.updateContentStackViewMargins(forExpandedContent: true)
        }
        if animated {
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration) {
                updateLayout()
                self.contentStackView.layoutIfNeeded()
            }
        } else {
            updateLayout()
        }
    }

    func contract(_ animated: Bool) {
        isExpanded = false

        titleView.contract(animated: animated)

        guard barHeight != .expanded else {
            return
        }
        let updateLayout = {
            self.updateContentStackViewMargins(forExpandedContent: false)
        }
        if animated {
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration) {
                updateLayout()
                self.contentStackView.layoutIfNeeded()
            }
        } else {
            updateLayout()
        }
    }

    // MARK: Accessibility

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
