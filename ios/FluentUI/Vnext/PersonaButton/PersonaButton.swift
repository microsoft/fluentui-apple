//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaButtonState` contains PersonaButton properties in addition to a subset of the MSFAvatarState protocol.
///
/// `onTapAction` provides tap gesture for PersonaButton.
///
@objc public protocol MSFPersonaButtonState {
    var buttonSize: MSFPersonaButtonSize { get set }
    var onTapAction: (() -> Void)? { get set }

    var avatarBackgroundColor: UIColor? { get set }
    var avatarForegroundColor: UIColor? { get set }
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
    @Published var buttonSize: MSFPersonaButtonSize
    @Published var onTapAction: (() -> Void)?

    let tokens: MSFPersonaButtonTokens

    var avatarBackgroundColor: UIColor? {
        get {
            return avatarState.backgroundColor
        }
        set {
            avatarState.backgroundColor = newValue
            objectWillChange.send()
        }
    }

    var avatarForegroundColor: UIColor? {
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
        self.buttonSize = size
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
    @ObservedObject var avatarState: MSFAvatarStateImpl

    @State private var buttonMaxWidth: CGFloat?

    public init(size: MSFPersonaButtonSize) {
        let avatarState = MSFAvatarStateImpl(style: .default, size: size.avatarSize)
        let state = MSFPersonaButtonViewStateImpl(size: size, avatarState: avatarState)
        self.avatarState = avatarState
        self.state = state
        self.tokens = state.tokens
    }

    private var personaText: some View {
        Group {
            Text(state.primaryText ?? "")
                .frame(maxWidth: .infinity, alignment: .center)
                .scalableFont(font: tokens.labelFont)
                .foregroundColor(Color(tokens.labelColor))
            if state.buttonSize.shouldShowSubtitle {
                Text(state.secondaryText ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .scalableFont(font: tokens.sublabelFont)
                    .foregroundColor(Color(tokens.sublabelColor))
            }
        }
        .frame(width: buttonMaxWidth)
    }

    private var avatarView: some View {
        AvatarView(avatarState)
            .padding(.top, tokens.padding)
            .padding(.bottom, tokens.avatarInterspace)
            .padding(.horizontal, tokens.padding)
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: ButtonWidthPreferenceKey.self,
                    value: geometry.size.width
                )
            })
            .onPreferenceChange(ButtonWidthPreferenceKey.self) {
                buttonMaxWidth = $0 - tokens.padding
            }
    }

    public var body: some View {
        let action = state.onTapAction ?? {}
        Button(action: action) {
            VStack(spacing: 0) {
                avatarView
                personaText
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

private extension PersonaButton {
    struct ButtonWidthPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat,
                           nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

/// UIKit wrapper that exposes the SwiftUI PersonaButton implementation
@objc open class MSFPersonaButtonView: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaButtonState {
        return self.personaButton.state
    }

    @objc public init(size: MSFPersonaButtonSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaButton = PersonaButton(size: size)
        hostingController = UIHostingController(rootView: AnyView(personaButton
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaButton in
                                                                        personaButton.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaButton: PersonaButton!
}
