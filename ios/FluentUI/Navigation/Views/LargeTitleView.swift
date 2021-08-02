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

        static let compactAvatarSize: MSFAvatarSize = .small
        static let avatarSize: MSFAvatarSize = .medium

        // Once we are iOS 14 minimum, we can use Fonts.largeTitle.withSize() function instead
        static let compactTitleFont = UIFont.systemFont(ofSize: 26, weight: .bold)
        static let titleFont = UIFont.systemFont(ofSize: 30, weight: .bold)
    }

    var personaData: Persona? {
        didSet {
            updateProfileButtonVisibility()

            if let avatarState = avatar?.state {
                avatarState.primaryText = personaData?.name
                avatarState.secondaryText = personaData?.email
                avatarState.image = personaData?.image
                avatarState.imageBasedRingColor = personaData?.imageBasedRingColor
                avatarState.hasRingInnerGap = personaData?.hasRingInnerGap ?? true
                avatarState.isRingVisible = personaData?.isRingVisible ?? false
                avatarState.presence = personaData?.presence ?? .none
                avatarState.isOutOfOffice = personaData?.isOutOfOffice ?? false

                let color = personaData?.color
                avatarState.backgroundColor = color
                avatarState.ringColor = color
            }
        }
    }

    var avatarSize: NavigationBar.ElementSize = .automatic {
        didSet {
            switch avatarSize {
            case .automatic:
                return
            case .contracted:
                avatar?.state.size = Constants.compactAvatarSize
            case .expanded:
                avatar?.state.size = Constants.avatarSize
            }
        }
    }

    var avatarHeightConstraint: NSLayoutConstraint?
    var avatarWidthConstraint: NSLayoutConstraint?

    var avatarAccessibilityLabel: String? {
        return avatarCustomAccessibilityLabel ?? "Accessibility.LargeTitle.ProfileView".localized
    }

    var avatarCustomAccessibilityLabel: String? {
        didSet {
            updateAvatarAccessibility()
        }
    }

    var avatarOverrideStyle: MSFAvatarStyle? {
        didSet {
            if let style = avatarOverrideStyle {
                updateProfileButtonVisibility()
                avatar?.state.style = style
            }
        }
    }

    var style: Style = .light {
        didSet {
            titleButton.setTitleColor(colorForStyle, for: .normal)
            avatar?.state.style = style == .light ? .default : .accent
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

    var onAvatarTapped: (() -> Void)? { // called in response to a tap on the MSFAvatar's view
        didSet {
            updateAvatarViewPointerInteraction()
        }
    }

    public func visibleAvatarView() -> UIView? {
        if !showsProfileButton {
            return nil
        }

        return avatar?.view
    }

    private var colorForStyle: UIColor {
        switch style {
        case .light:
            return Colors.Navigation.Primary.title
        case .dark:
            return Colors.Navigation.System.title
        }
    }

    private var avatar: MSFAvatar? // circular view displaying the profile information

    private let titleButton = UIButton() // button used to display the title of the current navigation item

    private let contentStackView = UIStackView() // containing stack view

    private let tapGesture = UITapGestureRecognizer() // tap used to trigger expansion. Applied to entire navigation bar

    private var showsProfileButton: Bool = true { // whether to display the customizable profile button
        didSet {
            avatar?.view.isHidden = !showsProfileButton
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
        contain(view: contentStackView, withInsets: UIEdgeInsets(top: 0,
                                                                 left: 8,
                                                                 bottom: 0,
                                                                 right: 8))
        // Avatar setup
        let preferredFallbackImageStyle: MSFAvatarStyle = style == .light ? .default : .accent
        let avatar = MSFAvatar(style: preferredFallbackImageStyle,
                               size: Constants.avatarSize)
        let avatarState = avatar.state
        avatarState.primaryText = personaData?.name
        avatarState.secondaryText = personaData?.email
        avatarState.image = personaData?.image

        if let color = personaData?.color {
            avatarState.backgroundColor = color
            avatarState.ringColor = color
        }

        self.avatar = avatar
        let avatarView = avatar.view

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAvatarViewTapped)))
        contentStackView.addArrangedSubview(avatarView)

        avatarView.centerYAnchor.constraint(equalTo: contentStackView.centerYAnchor).isActive = true

        let avatarHeightConstraint = NSLayoutConstraint(item: avatarView,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1,
                                                        constant: Constants.avatarSize.size)
        avatarView.addConstraint(avatarHeightConstraint)
        avatarHeightConstraint.isActive = true
        self.avatarHeightConstraint = avatarHeightConstraint

        let avatarWidthConstraint = NSLayoutConstraint(item: avatarView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1,
                                                       constant: Constants.avatarSize.size)
        avatarView.addConstraint(avatarWidthConstraint)
        avatarWidthConstraint.isActive = true
        self.avatarWidthConstraint = avatarWidthConstraint

        // title button setup
        contentStackView.addArrangedSubview(titleButton)
        titleButton.setTitle(nil, for: .normal)
        titleButton.titleLabel?.font = Constants.titleFont
        titleButton.setTitleColor(colorForStyle, for: .normal)
        titleButton.titleLabel?.textAlignment = .left
        titleButton.contentHorizontalAlignment = .left
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleButton.addTarget(self, action: #selector(LargeTitleView.titleButtonTapped(sender:)), for: .touchUpInside)
        titleButton.setContentCompressionResistancePriority(.required,
                                                            for: .horizontal)

        // tap gesture for entire titleView
        tapGesture.addTarget(self, action: #selector(LargeTitleView.handleTitleViewTapped(sender:)))
        addGestureRecognizer(tapGesture)

        titleButton.showsLargeContentViewer = true

        updateAvatarViewPointerInteraction()
    }

    private func expansionAnimation() {
        if titleSize == .automatic {
            titleButton.titleLabel?.font = Constants.titleFont
        }

        if avatarSize == .automatic {
            avatar?.state.size = Constants.avatarSize
            avatarWidthConstraint?.constant = Constants.avatarSize.size
            avatarHeightConstraint?.constant = Constants.avatarSize.size
        }

        layoutIfNeeded()
    }

    private func contractionAnimation() {
        if titleSize == .automatic {
            titleButton.titleLabel?.font = Constants.compactTitleFont
        }

        if avatarSize == .automatic {
            avatar?.state.size = Constants.compactAvatarSize
            avatarWidthConstraint?.constant = Constants.compactAvatarSize.size
            avatarHeightConstraint?.constant = Constants.compactAvatarSize.size
        }

        layoutIfNeeded()
    }

    private func updateAvatarViewPointerInteraction() {
        avatar?.state.hasPointerInteraction = onAvatarTapped != nil
    }

    private func updateAvatarAccessibility() {
        if let avatar = avatar {
            let accessibilityLabel = avatarAccessibilityLabel
            avatar.state.accessibilityLabel = accessibilityLabel

            let avatarView = avatar.view
            avatarView.showsLargeContentViewer = true
            avatarView.largeContentTitle = accessibilityLabel

            if onAvatarTapped != nil {
                avatarView.accessibilityTraits.insert(.button)
                avatarView.accessibilityTraits.remove(.image)
            } else {
                avatarView.accessibilityTraits.insert(.image)
                avatarView.accessibilityTraits.remove(.button)
            }
        }
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
        showsProfileButton = !hasLeftBarButtonItems && (personaData != nil || avatarOverrideStyle != nil)
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
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration,
                           animations: expansionAnimation)
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
            UIView.animate(withDuration: NavigationBar.expansionContractionAnimationDuration,
                           animations: contractionAnimation)
        } else {
            contractionAnimation()
        }
    }

    // MARK: - Accessibility

    /// Updates various properties of the TitleView to properly conform to accessibility requirements
    private func setupAccessibility() {
        titleButton.accessibilityTraits = .header
        updateAvatarAccessibility()
    }
}

// MARK: - Notification.Name Declarations

extension NSNotification.Name {
    static let accessoryExpansionRequested = Notification.Name("microsoft.fluentui.accessoryExpansionRequested")
}
