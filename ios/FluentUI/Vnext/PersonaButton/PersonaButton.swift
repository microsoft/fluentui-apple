//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaButtonState` contains PersonaButton properties in addition to a subset of the MSFAvatarState protocol.
///
/// - `buttonSize`: specifies whether to use small or large avatars
/// - `onTapAction`: provides tap gesture for PersonaButton
/// - `avatarBackgroundColor`: background color for the persona image
/// - `avatarForegroundColor`: foreground color for the persona image
/// - `hasPointerInteraction`: indicates whether the image should interact with pointer hover (iPadOS 13.4+ only)
/// - `hasRingInnerGap`: indicates whether there is a gap between the ring and the image
/// - `image`: image to display for persona
/// - `imageBasedRingColor`: image to use as a backdrop for the ring
/// - `isOutOfOffice`: indicates whether to show out of office status
/// - `isRingVisible`: indicates if the status ring should be visible
/// - `isTransparent`: indicates if the avatar should be drawn with transparency
/// - `presence`: enum that describes persence status for the persona
/// - `primaryText`: primary text to be displayed under the persona image (e.g. first name)
/// - `ringColor`: color to draw the status ring, if one is visible
/// - `secondaryText`: secondary text to be displayed under the persona image (e.g. last name or email address)
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
class MSFPersonaButtonStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaButtonState {
    @Published var buttonSize: MSFPersonaButtonSize
    @Published var onTapAction: (() -> Void)?

    let avatarState: MSFAvatarStateImpl
    let tokens: MSFPersonaButtonTokens
    var personaData: PersonaData?

    var avatarBackgroundColor: UIColor? {
        get {
            return avatarState.backgroundColor
        }
        set {
            avatarState.backgroundColor = newValue
        }
    }

    var avatarForegroundColor: UIColor? {
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

    init(size: MSFPersonaButtonSize, avatarState: MSFAvatarStateImpl) {
        self.buttonSize = size
        self.avatarState = avatarState
        self.tokens = MSFPersonaButtonTokens(size: size)

        super.init()
    }

    convenience init(size: MSFPersonaButtonSize) {
        let avatarState = MSFAvatarStateImpl(style: .default, size: size.avatarSize)
        self.init(size: size, avatarState: avatarState)
    }

    convenience init(size: MSFPersonaButtonSize, personaData: PersonaData) {
        let avatarState = MSFAvatarStateImpl(style: .default, size: size.avatarSize, personaData: personaData)
        self.init(size: size, avatarState: avatarState)

        self.personaData = personaData
    }
}

public struct PersonaButton: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaButtonTokens
    @ObservedObject var state: MSFPersonaButtonStateImpl
    @ObservedObject var avatarState: MSFAvatarStateImpl

    public init(size: MSFPersonaButtonSize) {
        let state = MSFPersonaButtonStateImpl(size: size)
        self.avatarState = state.avatarState
        self.state = state
        self.tokens = state.tokens
    }

    internal init(state: MSFPersonaButtonStateImpl) {
        self.avatarState = state.avatarState
        self.state = state
        self.tokens = state.tokens
    }

    @ViewBuilder
    private var personaText: some View {
        Group {
            Text(state.primaryText ?? "")
                .lineLimit(1)
                .frame(maxWidth: tokens.labelWidth, alignment: .center)
                .scalableFont(font: tokens.labelFont)
                .foregroundColor(Color(tokens.labelColor))
            if state.buttonSize.shouldShowSubtitle {
                Text(state.secondaryText ?? "")
                    .lineLimit(1)
                    .frame(maxWidth: tokens.labelWidth, alignment: .center)
                    .scalableFont(font: tokens.sublabelFont)
                    .foregroundColor(Color(tokens.sublabelColor))
            }
        }
    }

    @ViewBuilder
    private var avatarView: some View {
        AvatarView(avatarState)
            .padding(.top, tokens.padding)
            .padding(.bottom, tokens.avatarInterspace)
            .padding(.horizontal, tokens.padding)
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
