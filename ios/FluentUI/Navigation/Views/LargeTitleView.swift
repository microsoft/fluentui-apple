//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: LargeTitleView

/// Large Header and custom profile button container
class LargeTitleView: UIView {
    enum Style: Int {
        case light, dark
    }

    private struct Constants {
        static let horizontalSpacing: CGFloat = 10

        static let compactAvatarSize: AvatarSize = .small
        static let avatarSize: AvatarSize = .medium

        static let compactTitleFont: UIFont = Fonts.title1
        static let titleFont: UIFont = Fonts.largeTitle
    }

    var avatar: Avatar? {
        didSet {
            updateProfileButtonVisibility()
            [avatarView, smallMorphingAvatarView].forEach { $0?.setup(avatar: avatar) }
        }
    }

    var avatarSize: NavigationBar.ElementSize = .automatic {
        didSet {
            switch avatarSize {
            case .automatic:
                return
            case .contracted:
                avatarView?.avatarSize = Constants.compactAvatarSize
            case .expanded:
                avatarView?.avatarSize = Constants.avatarSize
            }
        }
    }

    var avatarCustomAccessibilityLabel: String? {
        didSet {
            [avatarView, smallMorphingAvatarView].forEach { $0?.customAccessibilityLabel = avatarCustomAccessibilityLabel }
        }
    }

    var avatarOverrideFallbackImageStyle: AvatarFallbackImageStyle? {
        didSet {
            if let fallbackStyle = avatarOverrideFallbackImageStyle {
                updateProfileButtonVisibility()
                [avatarView, smallMorphingAvatarView].forEach { $0?.setup(fallbackStyle: fallbackStyle) }
            }
        }
    }

    var style: Style = .light {
        didSet {
            titleButton.setTitleColor(colorForStyle, for: .normal)
            [avatarView, smallMorphingAvatarView].forEach { $0?.preferredFallbackImageStyle = style == .light ? .primaryFilled : .onAccentFilled }
        }
    }

    var titleSize: NavigationBar.ElementSize = .automatic {
        didSet {
            switch titleSize {
            case .automatic:
                return
            case .contracted:
                titleButton.titleLabel?.font = Constants.compactTitleFont
            case .expanded:
                titleButton.titleLabel?.font = Constants.titleFont
            }
        }
    }

    var onAvatarTapped: (() -> Void)? { // called in response to a tap on the MSAvatarView
        didSet {
            updateAvatarViewPointerInteraction()
        }
    }

    public func visibleAvatarView() -> UIView? {
        if !showsProfileButton {
            return nil
        }

        if smallMorphingAvatarView?.alpha != 0 {
            return smallMorphingAvatarView
        }

        return avatarView
    }

    private var colorForStyle: UIColor {
        switch style {
        case .light:
            return Colors.Navigation.Primary.title
        case .dark:
            return Colors.Navigation.System.title
        }
    }

    private var avatarView: ProfileView? // circular view displaying the profile information
    // an AvatarView instance that is permanently constrained to the smaller size
    // this view will have its transform property animated to match the normal avatar view
    // this is done to allow for simulate animation of the non-animatable UILabel within MSAvatarView
    // see documentation at MSLargeTitleView.morphSmallAvatarView(expanding:) for more information
    private var smallMorphingAvatarView: ProfileView?
    private var smallMorphingAvatarViewAnimator: UIViewPropertyAnimator? // responsible for animating the transform of smallMorphingAvatarView
    private var smallAnimatorRunningObserver: NSKeyValueObservation? // observes the running property, done to accomplish a "completion" for a pausesOnCompletion = YES animator

    private let titleButton = UIButton() // button used to display the title of the current navigation item

    private let contentStackView = UIStackView() // containing stack view

    private let tapGesture = UITapGestureRecognizer() // tap used to trigger expansion. Applied to entire navigation bar

    private var showsProfileButton: Bool = true { // whether to display the customizable profile button
        didSet {
            avatarView?.isHidden = !showsProfileButton
            smallMorphingAvatarView?.isHidden = !showsProfileButton
        }
    }

    private var hasLeftBarButtonItems: Bool = false {
        didSet {
            updateProfileButtonVisibility()
        }
    }

    private var respondsToTaps: Bool = true // whether to respond to the various tap gestures/actions that are incorproated into the navigation bar

    override init(frame: CGRect) {
        super.init(frame: frame)
        initBase()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBase()
    }

    /// Base function for initialization
    private func initBase() {
        setupLayout()
        setupAnimations()
        setupAccessibility()
    }

    // MARK: - Base Construction Methods

    // Constructs various constants based on initial conditions
    // Applies constants via autolayout to constructed views
    // Also constructs gesture recognizers
    private func setupLayout() {
        // contentStackView layout
        contentStackView.spacing = Constants.horizontalSpacing
        contentStackView.alignment = .center
        contain(view: contentStackView, withInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))

        // default avatar view setup
        let preferredFallbackImageStyle: AvatarFallbackImageStyle = style == .light ? .primaryFilled : .onAccentFilled
        let avatarView = ProfileView(avatarSize: Constants.avatarSize, preferredFallbackImageStyle: preferredFallbackImageStyle)
        avatarView.setup(avatar: avatar)
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAvatarViewTapped)))
        self.avatarView = avatarView
        contentStackView.addArrangedSubview(avatarView)

        // small avatar view setup
        let smallAvatarView = ProfileView(avatarSize: Constants.compactAvatarSize, preferredFallbackImageStyle: preferredFallbackImageStyle)
        smallAvatarView.setup(avatar: avatar)
        self.smallMorphingAvatarView = smallAvatarView
        smallAvatarView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addSubview(smallAvatarView)

        smallAvatarView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor).isActive = true
        smallAvatarView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor).isActive = true

        let scale = Constants.avatarSize.size.width / Constants.compactAvatarSize.size.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        smallAvatarView.transform = transform

        // title button setup
        contentStackView.addArrangedSubview(titleButton)
        titleButton.setTitle(nil, for: .normal)
        titleButton.titleLabel?.font = Constants.titleFont
        titleButton.setTitleColor(colorForStyle, for: .normal)
        titleButton.titleLabel?.textAlignment = .left
        titleButton.contentHorizontalAlignment = .left
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleButton.addTarget(self, action: #selector(LargeTitleView.titleButtonTapped(sender:)), for: .touchUpInside)
        titleButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // tap gesture for entire titleView
        tapGesture.addTarget(self, action: #selector(LargeTitleView.handleTitleViewTapped(sender:)))
        addGestureRecognizer(tapGesture)

        if #available(iOS 13, *) {
            titleButton.showsLargeContentViewer = true
        }

        updateAvatarViewPointerInteraction()
    }

    // Declares animation closures used for title expansion/contraction
    private func setupAnimations() {
        /// construct an animator for the avatarView's transform property
        let smallMorphingAvatarViewAnimator = UIViewPropertyAnimator(duration: NavigationBar.expansionContractionAnimationDuration, curve: .linear) {
            self.smallMorphingAvatarView?.transform = CGAffineTransform.identity
        }
        smallMorphingAvatarViewAnimator.scrubsLinearly = false
        smallMorphingAvatarViewAnimator.pausesOnCompletion = true /// keeps the animator active so as to be reversable
        self.smallMorphingAvatarViewAnimator = smallMorphingAvatarViewAnimator

        /// KVO for the isRunning property to enable a "completion handler" for a pausesOnCompletion animation
        /// .initial option calls the changeHandler once upon instantiation to get us to the proper layout
        self.smallAnimatorRunningObserver = smallMorphingAvatarViewAnimator.observe(\.isRunning, options: .initial, changeHandler: { (animator, _) in
            if !animator.isRunning {
                self.smallMorphingAvatarView?.alpha = 0.0 /// hide the extra avatarView on completion of the animation
            }
        })
    }

    private func expansionAnimation() {
        if titleSize == .automatic {
            titleButton.titleLabel?.font = Constants.titleFont
        }

        if avatarSize == .automatic {
            avatarView?.avatarSize = Constants.avatarSize
        }

        contentStackView.spacing = Constants.horizontalSpacing - 1 //!!! need this otherwise animation gets broken
        contentStackView.spacing = Constants.horizontalSpacing

        layoutIfNeeded()
    }

    private func contractionAnimation() {
        if titleSize == .automatic {
            titleButton.titleLabel?.font = Constants.compactTitleFont
        }

        if avatarSize == .automatic {
            avatarView?.avatarSize = Constants.compactAvatarSize
        }

        contentStackView.spacing = Constants.horizontalSpacing - 1 //!!! need this otherwise animation gets broken
        contentStackView.spacing = Constants.horizontalSpacing

        layoutIfNeeded()
    }

    private func updateAvatarViewPointerInteraction() {
        avatarView?.hasPointerInteraction = onAvatarTapped != nil
    }

    // MARK: - UIActions

    /// Target for the tap gesture on the avatar view, as it is not a button
    ///
    /// - Parameter gesture: tap gesture on the AvatarView
    @objc private func handleAvatarViewTapped(gesture: UITapGestureRecognizer) {
        onAvatarTapped?()
    }

    /// Target for the Title Button's touchUpInside
    ///
    /// - Parameter sender: title button
    @objc private func titleButtonTapped(sender: UIButton) {
        guard respondsToTaps else {
            return
        }
        requestExpansion()
    }

    /// Target for the NavigationBar tap gesture
    ///
    /// - Parameter sender: the tap gesture
    @objc private func handleTitleViewTapped(sender: UITapGestureRecognizer) {
        guard respondsToTaps else {
            return
        }
        requestExpansion()
    }

    /// Posts a notification requesting that the navigation bar be animated into its larger state
    private func requestExpansion() {
        NotificationCenter.default.post(name: .accessoryExpansionRequested, object: self)
    }

    // MARK: - Content Update Methods

    private func updateProfileButtonVisibility() {
        showsProfileButton = !hasLeftBarButtonItems && (avatar != nil || avatarOverrideFallbackImageStyle != nil)
    }

    /// Sets the interface with the provided item's details
    ///
    /// - Parameter navigationItem: instance of UINavigationItem providing inteface information
    func update(with navigationItem: UINavigationItem) {
        hasLeftBarButtonItems = !(navigationItem.leftBarButtonItems?.isEmpty ?? true)
        titleButton.setTitle(navigationItem.title, for: .normal)
    }

    // MARK: - Expansion/Contraction Methods

    /// Calls the expansion animation block, optionally animated
    ///
    /// - Parameter animated: to animate the block or not
    func expand(animated: Bool) {
        // Exit early if neither element's size is automatic
        guard titleSize == .automatic || avatarSize == .automatic else {
            return
        }
        if animated {
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration, animations: expansionAnimation)
            morphSmallAvatarView(expanding: true)
        } else {
            expansionAnimation()
        }
    }

    /// Calls the contraction animation block, optionally animated
    ///
    /// - Parameter animated: to animate the block or not
    func contract(animated: Bool) {
        // Exit early if neither element's size is automatic
        guard titleSize == .automatic || avatarSize == .automatic else {
            return
        }
        if animated {
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration, animations: contractionAnimation)
            morphSmallAvatarView(expanding: false)
        } else {
            contractionAnimation()
        }
    }

    /// Triggers the UIViewPropertyAnimator for the SmallMorphingAvatarView
    /// Used to smoothly animate between two layouts of the internal UILabel of AvatarView
    /// Since UILabel is non-animatable, without a "view morph" the animation occurs out-of-step
    ///
    /// the smallMorphingAvatarView's transform property is manipulated via a CGAffineTransform whose scale is determined via the delta between the expanded and contracted sizes of the AvatarView
    /// the default transform expands the smallMorphingAvatarView to match the size of the default AvatarView
    /// since UIView.transform is an animatable property, this animation allows us to simulate the animation of a UILabel
    /// within the animator, the transform is set to the CGAffineTransform.identity, to return it to the smaller size
    ///
    /// Here, we expose the morphing avatar view via the alpha property, and run the animator
    /// the animator is reversed if we are expanding, as the animator's default direction is (expanded -> contracted)
    /// The animator's isRunning property is KVObserved, so as to hide the morphing view via the alpha property upon "completion" of the animation
    /// This KVO is necessary, as an animator with pausesOnCompletion == true will not call its completion block(s)
    ///
    /// - Parameter expanding: used to decide reversal of the animator
    private func morphSmallAvatarView(expanding: Bool) {
        guard avatarSize == .automatic else {
            return
        }

        smallMorphingAvatarView?.alpha = 1.0
        smallMorphingAvatarViewAnimator?.isReversed = expanding
        smallMorphingAvatarViewAnimator?.startAnimation()
    }

    // MARK: - Accessibility

    /// Updates various properties of the TitleView to properly conform to accessibility requirements
    private func setupAccessibility() {
        titleButton.accessibilityTraits = .header
    }
}

// MARK: - Notification.Name Declarations

extension NSNotification.Name {
    static let accessoryExpansionRequested = Notification.Name("microsoft.fluentui.accessoryExpansionRequested")
}

// MARK: - ProfileView

private class ProfileView: AvatarView {
    var customAccessibilityLabel: String?
    override var accessibilityLabel: String? {
        get {
            return customAccessibilityLabel ?? "Accessibility.LargeTitle.ProfileView".localized
        }
        set { }
    }
    override var accessibilityTraits: UIAccessibilityTraits { get { return .button } set { } }
}
