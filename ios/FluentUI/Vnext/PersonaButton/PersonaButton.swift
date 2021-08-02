//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaButtonAppearance` contains properties to customize the appearance and interaction of a `PersonaButton`.
///
/// - `buttonSize`: specifies whether to use small or large avatars
/// - `onTapAction`: provides tap gesture for PersonaButton
/// - `hasPointerInteraction`: indicates whether the image should interact with pointer hover (iPadOS 13.4+ only)
/// - `hasRingInnerGap`: indicates whether there is a gap between the ring and the image
/// - `isTransparent`: indicates if the avatar should be drawn with transparency
@objc public protocol MSFPersonaButtonAppearance {
    var buttonSize: MSFPersonaButtonSize { get set }
    var onTapAction: (() -> Void)? { get set }

    var hasPointerInteraction: Bool { get set }
    var hasRingInnerGap: Bool { get set }
    var isTransparent: Bool { get set }
}

/// `MSFPersonaButtonData` contains properties to customize the data of a `PersonaButton`.
///
/// - `avatarBackgroundColor`: background color for the persona image
/// - `avatarForegroundColor`: foreground color for the persona image
/// - `image`: image to display for persona
/// - `imageBasedRingColor`: image to use as a backdrop for the ring
/// - `isOutOfOffice`: indicates whether to show out of office status
/// - `isRingVisible`: indicates if the status ring should be visible
/// - `presence`: enum that describes persence status for the persona
/// - `primaryText`: primary text to be displayed under the persona image (e.g. first name)
/// - `ringColor`: color to draw the status ring, if one is visible
/// - `secondaryText`: secondary text to be displayed under the persona image (e.g. last name or email address)
@objc public protocol MSFPersonaButtonData {
    var avatarBackgroundColor: UIColor? { get set }
    var avatarForegroundColor: UIColor? { get set }
    var image: UIImage? { get set }
    var imageBasedRingColor: UIImage? { get set }
    var isOutOfOffice: Bool { get set }
    var isRingVisible: Bool { get set }
    var presence: MSFAvatarPresence { get set }
    var primaryText: String? { get set }
    var ringColor: UIColor? { get set }
    var secondaryText: String? { get set }
}

/// Properties that make up PersonaButton content
class MSFPersonaButtonStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaButtonAppearance, MSFPersonaButtonData {
    @Published var buttonSize: MSFPersonaButtonSize
    @Published var onTapAction: (() -> Void)?

    let avatarState: MSFAvatarStateImpl
    let tokens: MSFPersonaButtonTokens
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
}

public struct PersonaButton: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
    @ObservedObject var tokens: MSFPersonaButtonTokens
    @ObservedObject var state: MSFPersonaButtonStateImpl

    public init(size: MSFPersonaButtonSize) {
        let state = MSFPersonaButtonStateImpl(size: size)
        self.state = state
        self.tokens = state.tokens
    }

    internal init(state: MSFPersonaButtonStateImpl, action: (() -> Void)?) {
        state.onTapAction = action
        self.state = state
        self.tokens = state.tokens
    }

    @ViewBuilder
    private var personaText: some View {
        Group {
            Text(state.primaryText ?? "")
                .lineLimit(1)
                .frame(alignment: .center)
                .scalableFont(font: tokens.labelFont)
                .foregroundColor(Color(tokens.labelColor))
            if state.buttonSize.shouldShowSubtitle {
                Text(state.secondaryText ?? "")
                    .lineLimit(1)
                    .frame(alignment: .center)
                    .scalableFont(font: tokens.sublabelFont)
                    .foregroundColor(Color(tokens.sublabelColor))
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

    public var body: some View {
        let action = state.onTapAction ?? {}
        Button(action: action) {
            VStack(spacing: 0) {
                avatarView
                personaText
                Spacer(minLength: tokens.verticalPadding)
            }
        }
        .frame(minWidth: adjustedWidth, maxWidth: adjustedWidth, minHeight: 0, maxHeight: .infinity)
        .background(Color(tokens.backgroundColor))
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}
