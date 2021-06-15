//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaButtonState` contains PersonaButton properties in addition to a subset of the MSFAvatarState protocol.
///
/// `onTapAction` provides tap gesture for PersonaButton.
///
@objc public protocol MSFPersonaButtonState: MSFAvatarState {
    var badgeSize: MSFPersonaButtonSize { get set }
    var onTapAction: (() -> Void)? { get set }

    var backgroundColor: UIColor? { get set }
    var foregroundColor: UIColor? { get set }
    var hasPointerInteraction: Bool { get set }
    var hasRingInnerGap: Bool { get set }
    var image: UIImage? { get set }
    var imageBasedRingColor: UIImage? { get set }
    var isOutOfOffice: Bool { get set }
    var isRingVisible: Bool { get set }
    var isTransparent: Bool { get set }
    var presence: MSFAvatarPresence { get set }
    var primaryText: String? { get set }
    var ringColor: UIColor? { get set }
    var secondaryText: String? { get set }
}

/// Properties that make up PersonaButton content
class MSFPersonaButtonViewStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaButtonState {
    @Published var badgeSize: MSFPersonaButtonSize
    @Published var onTapAction: (() -> Void)?

    let tokens: MSFPersonaButtonTokens

    var backgroundColor: UIColor? {
        get {
            return avatarState.backgroundColor
        }
        set {
            avatarState.backgroundColor = newValue
            objectWillChange.send()
        }
    }

    var foregroundColor: UIColor? {
        get {
            return avatarState.foregroundColor
        }
        set {
            avatarState.foregroundColor = newValue
            objectWillChange.send()
        }
    }

    var hasPointerInteraction: Bool {
        get {
            return avatarState.hasPointerInteraction
        }
        set {
            avatarState.hasPointerInteraction = newValue
            objectWillChange.send()
        }
    }

    var hasRingInnerGap: Bool {
        get {
            return avatarState.hasRingInnerGap
        }
        set {
            avatarState.hasRingInnerGap = newValue
            objectWillChange.send()
        }
    }

    var image: UIImage? {
        get {
            return avatarState.image
        }
        set {
            avatarState.image = newValue
            objectWillChange.send()
        }
    }

    var imageBasedRingColor: UIImage? {
        get {
            return avatarState.imageBasedRingColor
        }
        set {
            avatarState.imageBasedRingColor = newValue
            objectWillChange.send()
        }
    }

    var isOutOfOffice: Bool {
        get {
            return avatarState.isOutOfOffice
        }
        set {
            avatarState.isOutOfOffice = newValue
            objectWillChange.send()
        }
    }

    var isRingVisible: Bool {
        get {
            return avatarState.isRingVisible
        }
        set {
            avatarState.isRingVisible = newValue
            objectWillChange.send()
        }
    }

    var isTransparent: Bool {
        get {
            return avatarState.isTransparent
        }
        set {
            avatarState.isTransparent = newValue
            objectWillChange.send()
        }
    }

    var presence: MSFAvatarPresence {
        get {
            return avatarState.presence
        }
        set {
            avatarState.presence = newValue
            objectWillChange.send()
        }
    }

    var primaryText: String? {
        get {
            return avatarState.primaryText
        }
        set {
            avatarState.primaryText = newValue
            objectWillChange.send()
        }
    }

    var ringColor: UIColor? {
        get {
            return avatarState.ringColor
        }
        set {
            avatarState.ringColor = newValue
            objectWillChange.send()
        }
    }

    var secondaryText: String? {
        get {
            return avatarState.secondaryText
        }
        set {
            avatarState.secondaryText = newValue
            objectWillChange.send()
        }
    }

    var size: MSFAvatarSize {
        get {
            return avatarState.size
        }
        set {
            avatarState.size = newValue
            objectWillChange.send()
        }
    }

    var style: MSFAvatarStyle {
        get {
            return avatarState.style
        }
        set {
            avatarState.style = newValue
            objectWillChange.send()
        }
    }

    init(size: MSFPersonaButtonSize, avatarState: MSFAvatarState) {
        self.badgeSize = size
        self.avatarState = avatarState
        self.tokens = MSFPersonaButtonTokens(size: size)

        super.init()
    }

    private var avatarState: MSFAvatarState
}

public struct PersonaButton: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaButtonTokens
    @ObservedObject var state: MSFPersonaButtonViewStateImpl
    let avatarView: AvatarView

    public init(size: MSFPersonaButtonSize) {
        self.avatarView = AvatarView(style: .default, size: size.avatarSize)

        let state = MSFPersonaButtonViewStateImpl(size: size, avatarState: avatarView.state)
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
        .background(Color(tokens.backgroundColor))
        .frame(minHeight: 0, maxHeight: .infinity)
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}

/// UIKit wrapper that exposes the SwiftUI PersonaButton implementation
@objc open class MSFPersonaButtonView: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaButtonState {
        return self.personaBadge.state
    }

    @objc public init(size: MSFPersonaButtonSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaBadge = PersonaButton(size: size)
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

    private var personaBadge: PersonaButton!
}
