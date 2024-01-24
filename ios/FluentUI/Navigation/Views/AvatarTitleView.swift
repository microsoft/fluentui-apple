//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: AvatarTitleView

/// A helper view used by `NavigationBar` capable of displaying a large title and an avatar.
class AvatarTitleView: UIView, TokenizedControlInternal, TwoLineTitleViewDelegate {
    enum Style: Int {
        case primary
        case system
    }

    typealias TokenSetKeyType = AvatarTitleViewTokenSet.Tokens
    lazy var tokenSet: AvatarTitleViewTokenSet = .init(style: { [weak self] in
        self?.style ?? .primary
    })

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
                avatar?.state.size = TokenSetType.compactAvatarSize
            case .expanded:
                avatar?.state.size = TokenSetType.avatarSize
            }
        }
    }

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

    var style: Style = .primary {
        didSet {
            updateAppearance()
            twoLineTitleView.currentStyle = style == .primary ? .primary : .system
            let avatarStyle: MSFAvatarStyle
            if let avatarOverrideStyle {
                avatarStyle = avatarOverrideStyle
            } else {
                avatarStyle = (style == .primary) ? .default : .accent
            }
            avatar?.state.style = avatarStyle
        }
    }

    var onAvatarTapped: (() -> Void)? { // called in response to a tap on the MSFAvatar's view
        didSet {
            updateAvatarViewPointerInteraction()
            updateAvatarAccessibility()
        }
    }

    public func visibleAvatarView() -> UIView? {
        if !showsProfileButton {
            return nil
        }

        return avatar
    }

    private var avatar: MSFAvatar? // circular view displaying the profile information

    private let titleContainerView = UIView()

    private var titleStyle: NavigationBar.TitleStyle = .system {
        didSet {
            if oldValue != titleStyle {
                updateTitleContainerView()
                updateProfileButtonVisibility()
            }
        }
    }

    // TODO: Once we have an iOS 15 minimum, we can use UIButton.Configuration to eliminate the need for TwoLineTitleView here
    private let titleButton = UIButton() // button used to display the title of the current navigation item
    private let twoLineTitleView = TwoLineTitleView() // view used to display the title of the current navigation item if a subtitle exists

    private let contentStackView = UIStackView() // containing stack view

    private let tapGesture = UITapGestureRecognizer() // tap used to trigger expansion. Applied to entire navigation bar

    private var showsProfileButton: Bool = true { // whether to display the customizable profile button
        didSet {
            avatar?.isHidden = !showsProfileButton
            setupAccessibility()
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
        twoLineTitleView.delegate = self

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateAppearance()
        }
    }

    // MARK: - Theme updates

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
    }

    @objc private func updateAppearance() {
        titleButton.setTitleColor(tokenSet[.titleColor].uiColor, for: .normal)
        titleButton.titleLabel?.font = tokenSet[.largeTitleFont].uiFont

        twoLineTitleView.currentStyle = style == .primary ? .primary : .system
        twoLineTitleView.tokenSet.setOverrides(from: tokenSet, mapping: [
            .titleColor: .titleColor,
            .titleFont: .titleFont,
            .subtitleColor: .subtitleColor,
            .subtitleFont: .subtitleFont
        ])
    }

    // MARK: - Base Construction Methods

    // Constructs various constants based on initial conditions
    // Applies constants via autolayout to constructed views
    // Also constructs gesture recognizers
    private func setupLayout() {
        // contentStackView layout
        contentStackView.spacing = TokenSetType.contentStackViewSpacing
        contentStackView.alignment = .center
        contain(view: contentStackView, withInsets: UIEdgeInsets(top: 0,
                                                                 left: TokenSetType.contentStackViewHorizontalInset,
                                                                 bottom: 0,
                                                                 right: TokenSetType.contentStackViewHorizontalInset))
        // Avatar setup
        let preferredFallbackImageStyle: MSFAvatarStyle = style == .primary ? .default : .accent
        let avatar = MSFAvatar(style: preferredFallbackImageStyle,
                               size: TokenSetType.avatarSize)
        let avatarState = avatar.state
        avatarState.primaryText = personaData?.name
        avatarState.secondaryText = personaData?.email
        avatarState.image = personaData?.image

        if let color = personaData?.color {
            avatarState.backgroundColor = color
            avatarState.ringColor = color
        }

        self.avatar = avatar
        let avatarView = avatar

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAvatarViewTapped)))
        contentStackView.addArrangedSubview(avatarView)

        avatarView.centerYAnchor.constraint(equalTo: contentStackView.centerYAnchor).isActive = true

        updateTitleContainerView()
        contentStackView.addArrangedSubview(titleContainerView)

        // title button setup
        titleButton.setTitle(nil, for: .normal)
        titleButton.titleLabel?.textAlignment = .left
        titleButton.contentHorizontalAlignment = .left
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleButton.addTarget(self, action: #selector(AvatarTitleView.titleButtonTapped(sender:)), for: .touchUpInside)
        titleButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleButton.titleLabel?.lineBreakMode = .byTruncatingTail
        titleButton.titleLabel?.adjustsFontSizeToFitWidth = false

        updateAppearance()

        // tap gesture for entire titleView
        tapGesture.addTarget(self, action: #selector(AvatarTitleView.handleTitleViewTapped(sender:)))
        addGestureRecognizer(tapGesture)

        titleButton.showsLargeContentViewer = true

        updateAvatarViewPointerInteraction()
    }

    private func expansionAnimation() {
        if avatarSize == .automatic {
            avatar?.state.size = TokenSetType.avatarSize
        }

        layoutIfNeeded()
    }

    private func contractionAnimation() {
        if avatarSize == .automatic {
            avatar?.state.size = TokenSetType.compactAvatarSize
        }

        layoutIfNeeded()
    }

    private func updateAvatarViewPointerInteraction() {
        avatar?.state.hasPointerInteraction = onAvatarTapped != nil
    }

    private func updateAvatarAccessibility() {
        if let avatar = avatar {
            let accessibilityLabel = avatarAccessibilityLabel
            let avatarState = avatar.state
            avatarState.accessibilityLabel = accessibilityLabel
            avatarState.hasButtonAccessibilityTrait = onAvatarTapped != nil

            let avatarView = avatar
            avatarView.showsLargeContentViewer = true
            avatarView.largeContentTitle = accessibilityLabel
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
        showsProfileButton = titleStyle.usesLeadingAlignment && !hasLeftBarButtonItems && (personaData != nil || avatarOverrideStyle != nil)
    }

    private func updateTitleContainerView() {
        titleContainerView.removeAllSubviews()
        titleContainerView.contain(view: titleStyle == .largeLeading ? titleButton : twoLineTitleView)
    }

    /// Sets the interface with the provided item's details
    ///
    /// - Parameter navigationItem: instance of UINavigationItem providing inteface information
    func update(with navigationItem: UINavigationItem) {
        hasLeftBarButtonItems = !(navigationItem.leftBarButtonItems?.isEmpty ?? true)
        titleButton.setTitle(navigationItem.title, for: .normal)
        titleStyle = navigationItem.titleStyle
        twoLineTitleView.setup(navigationItem: navigationItem)

        // Hide the avatar if TwoLineTitleView has a leading image for both title and subtitle.
        if navigationItem.isTitleImageLeadingForTitleAndSubtitle {
            showsProfileButton = false
        } else {
            updateProfileButtonVisibility()
        }

        if navigationItem.titleAccessory == nil {
            // Use default behavior of requesting an accessory expansion
            twoLineTitleView.delegate = self
        }
    }

    // MARK: - Expansion/Contraction Methods

    /// Calls the expansion animation block, optionally animated
    ///
    /// - Parameter animated: to animate the block or not
    func expand(animated: Bool) {
        // Exit early if neither element's size is automatic
        guard avatarSize == .automatic else {
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
        guard avatarSize == .automatic else {
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

        // Sets the accessibility elements in the same order as they are laid out in the content view.
        accessibilityElements = contentStackView.arrangedSubviews.filter({ arrangedSubview in
            return !arrangedSubview.isHidden
        })
    }

    // MARK: - TwoLineTitleViewDelegate

    func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView) {
        guard respondsToTaps, twoLineTitleView == self.twoLineTitleView else {
            return
        }
        requestExpansion()
    }
}

// MARK: - Notification.Name Declarations

extension NSNotification.Name {
    static let accessoryExpansionRequested = Notification.Name("microsoft.fluentui.accessoryExpansionRequested")
}
