//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaBadgeState` contains PersonaBadge properties in addition to a subset of the MSFAvatarState protocol.
///
/// `onTapAction` provides tap gesture for PersonaBadge.
///
@objc public protocol MSFPersonaBadgeState: MSFAvatarState {
    var badgeSize: MSFPersonaBadgeSize { get set }

    var onTapAction: (() -> Void)? { get set }
}

/// Properties that make up PersonaBadge content
class MSFPersonaBadgeViewStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaBadgeState {
    let tokens: MSFPersonaBadgeTokens

    public var onTapAction: (() -> Void)?
    private var avatarState: MSFAvatarState

    // Changes here can cause a re-layout
    @Published var badgeSize: MSFPersonaBadgeSize

    var backgroundColor: UIColor? {
        get {
            return avatarState.backgroundColor
        }

        set {
            avatarState.backgroundColor = newValue
        }
    }

    var foregroundColor: UIColor? {
        get {
            return avatarState.foregroundColor
        }

        set {
            avatarState.foregroundColor = newValue
        }
    }

    var hasPointerInteraction: Bool {
        get {
            return avatarState.hasPointerInteraction
        }

        set {
            avatarState.hasPointerInteraction = newValue
        }
    }

    var hasRingInnerGap: Bool {
        get {
            return avatarState.hasRingInnerGap
        }

        set {
            avatarState.hasRingInnerGap = newValue
        }
    }

    var image: UIImage? {
        get {
            return avatarState.image
        }

        set {
            avatarState.image = newValue
        }
    }

    var imageBasedRingColor: UIImage? {
        get {
            return avatarState.imageBasedRingColor
        }

        set {
            avatarState.imageBasedRingColor = newValue
        }
    }

    var isOutOfOffice: Bool {
        get {
            return avatarState.isOutOfOffice
        }

        set {
            avatarState.isOutOfOffice = newValue
        }
    }

    var isRingVisible: Bool {
        get {
            return avatarState.isRingVisible
        }

        set {
            avatarState.isRingVisible = newValue
        }
    }

    var isTransparent: Bool {
        get {
            return avatarState.isTransparent
        }

        set {
            avatarState.isTransparent = newValue
        }
    }

    var presence: MSFAvatarPresence {
        get {
            return avatarState.presence
        }

        set {
            avatarState.presence = newValue
        }
    }

    var primaryText: String? {
        get {
            return avatarState.primaryText
        }

        set {
            avatarState.primaryText = newValue
        }
    }

    var ringColor: UIColor? {
        get {
            return avatarState.ringColor
        }

        set {
            avatarState.ringColor = newValue
        }
    }

    var secondaryText: String? {
        get {
            return avatarState.secondaryText
        }

        set {
            avatarState.secondaryText = newValue
        }
    }

    var size: MSFAvatarSize {
        get {
            return avatarState.size
        }

        set {
            avatarState.size = newValue
        }
    }

    var style: MSFAvatarStyle {
        get {
            return avatarState.style
        }

        set {
            avatarState.style = newValue
        }
    }

    init(size: MSFPersonaBadgeSize, avatarState: MSFAvatarState) {
        self.badgeSize = size
        self.avatarState = avatarState
        self.tokens = MSFPersonaBadgeTokens(size: size)

        super.init()
    }
}

public struct PersonaBadge: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaBadgeTokens
    @ObservedObject var state: MSFPersonaBadgeViewStateImpl
    let avatarView: AvatarView

    public init(size: MSFPersonaBadgeSize) {
        self.avatarView = AvatarView(style: .default, size: size.avatarSize)

        let state = MSFPersonaBadgeViewStateImpl(size: size, avatarState: avatarView.state)
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let action = state.onTapAction ?? {}
        Button(action: action) {
            VStack(spacing: 0) {
                avatarView
                    .padding(.top, tokens.padding)
                    .padding(.bottom, tokens.avatarInterspace)
                    .padding(.horizontal, tokens.padding)
                Text(state.primaryText ?? "")
                    .scalableFont(font: tokens.labelFont)
                    .foregroundColor(Color(tokens.labelColor))
                if state.badgeSize.canShowSubtitle {
                    Text(state.secondaryText ?? "")
                        .scalableFont(font: tokens.sublabelFont)
                        .foregroundColor(Color(tokens.sublabelColor))
                }
                Spacer(minLength: tokens.padding)
            }
        }
        .background(Color(tokens.appearanceProxy.backgroundColor))
        .frame(minHeight: 0, maxHeight: .infinity)
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}

/// UIKit wrapper that exposes the SwiftUI PersonaBadge implementation
@objc open class MSFPersonaBadgeView: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaBadgeState {
        return self.personaBadge.state
    }

    @objc public init(size: MSFPersonaBadgeSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaBadge = PersonaBadge(size: size)
        hostingController = UIHostingController(rootView: AnyView(personaBadge
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaBadge in
                                                                        personaBadge.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaBadge: PersonaBadge!
}
