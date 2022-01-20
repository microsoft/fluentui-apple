//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that define the appearance of a `PersonaButton`.
@objc public protocol MSFPersonaButtonState {
    /// Specifies whether to use small or large avatars.
    var buttonSize: MSFPersonaButtonSize { get set }

    /// Handles tap events for the persona button.
    var onTapAction: (() -> Void)? { get set }

    /// Indicates whether the image should interact with pointer hover.
    var hasPointerInteraction: Bool { get set }

    /// Indicates whether there is a gap between the ring and the image.
    var hasRingInnerGap: Bool { get set }

    /// Indicates if the avatar should be drawn with transparency.
    var isTransparent: Bool { get set }

    /// Background color for the persona image.
    var avatarBackgroundColor: UIColor? { get set }

    /// Foreground color for the persona image.
    var avatarForegroundColor: UIColor? { get set }

    /// Iimage to display for persona.
    var image: UIImage? { get set }

    /// Image to use as a backdrop for the ring.
    var imageBasedRingColor: UIImage? { get set }

    /// Indicates whether to show out of office status.
    var isOutOfOffice: Bool { get set }

    /// Indicates if the status ring should be visible.
    var isRingVisible: Bool { get set }

    /// Enum that describes persence status for the persona.
    var presence: MSFAvatarPresence { get set }

    /// Primary text to be displayed under the persona image (e.g. first name).
    var primaryText: String? { get set }

    /// Color to draw the status ring, if one is visible.
    var ringColor: UIColor? { get set }

    /// Secondary text to be displayed under the persona image (e.g. last name or email address).
    var secondaryText: String? { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: PersonaButtonTokens? { get set }
}

/// View that represents a persona button.
public struct PersonaButton: View, TokenizedControlInternal {
    /// Creates a new `PersonaButton` instance.
    /// - Parameters:
    ///   - size: The` MSFPersonaButtonSize` value used by the `PersonaButton`.
    public init(size: MSFPersonaButtonSize) {
        let state = MSFPersonaButtonStateImpl(size: size)
        self.state = state
    }

    public var body: some View {
        let action = state.onTapAction ?? {}
        SwiftUI.Button(action: action) {
            VStack(spacing: 0) {
                avatarView
                personaText
                Spacer(minLength: tokens.verticalPadding)
            }
        }
        .frame(minWidth: adjustedWidth, maxWidth: adjustedWidth, minHeight: 0, maxHeight: .infinity)
        .background(Color(dynamicColor: tokens.backgroundColor))
        .resolveTokens(self)
        .resolveTokenModifier(self, value: state.buttonSize)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
    @ObservedObject var state: MSFPersonaButtonStateImpl
    var tokens: PersonaButtonTokens { state.tokens }

    init(state: MSFPersonaButtonStateImpl, action: (() -> Void)?) {
        state.onTapAction = action
        self.state = state
    }

    @ViewBuilder
    private var personaText: some View {
        Group {
            Text(state.primaryText ?? "")
                .lineLimit(1)
                .frame(alignment: .center)
                .font(.fluent(tokens.labelFont))
                .foregroundColor(Color(dynamicColor: tokens.labelColor))
            if state.buttonSize.shouldShowSubtitle {
                Text(state.secondaryText ?? "")
                    .lineLimit(1)
                    .frame(alignment: .center)
                    .font(.fluent(tokens.sublabelFont))
                    .foregroundColor(Color(dynamicColor: tokens.sublabelColor))
            }
        }
        .padding(.horizontal, tokens.horizontalTextPadding)
    }

    @ViewBuilder
    private var avatarView: some View {
        Avatar(state.avatarState)
            .padding(.top, tokens.verticalPadding)
            .padding(.bottom, tokens.avatarInterspace)
    }

    /// Width of the button is conditional on the current size category
    private var adjustedWidth: CGFloat {
        let accessibilityAdjustments: [ ContentSizeCategory: [ MSFPersonaButtonSize: CGFloat] ] = [
            .accessibilityMedium: [ .large: 4, .small: 0 ],
            .accessibilityLarge: [ .large: 20, .small: 12 ],
            .accessibilityExtraLarge: [ .large: 36, .small: 32 ],
            .accessibilityExtraExtraLarge: [ .large: 56, .small: 38 ],
            .accessibilityExtraExtraExtraLarge: [ .large: 80, .small: 68 ]
        ]

        return state.avatarState.size.size + (2 * tokens.horizontalAvatarPadding) + (accessibilityAdjustments[sizeCategory]?[state.buttonSize] ?? 0)
    }
}

/// Properties that make up PersonaButton content
class MSFPersonaButtonStateImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFPersonaButtonState {
    /// Creates and initializes a `MSFPersonaButtonStateImpl`
    /// - Parameters:
    ///   - size: The size of the persona button
    init(size: MSFPersonaButtonSize) {
        self.buttonSize = size
        self.avatarState = MSFAvatarStateImpl(style: .default, size: size.avatarSize)
        self.tokens = PersonaButtonTokens(size: size)
        super.init()
    }

    @Published var buttonSize: MSFPersonaButtonSize
    @Published var onTapAction: (() -> Void)?
    @Published var tokens: PersonaButtonTokens
    @Published var overrideTokens: PersonaButtonTokens?
    var defaultTokens: PersonaButtonTokens { .init(size: buttonSize) }

    let avatarState: MSFAvatarStateImpl
    let id = UUID()

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
}
