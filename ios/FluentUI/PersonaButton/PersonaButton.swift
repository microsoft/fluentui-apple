//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that define the appearance of a `PersonaButton`.
@objc public protocol MSFPersonaButtonConfiguration {
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
public struct PersonaButton: View, ConfigurableTokenizedControl {
    /// Creates a new `PersonaButton` instance.
    /// - Parameters:
    ///   - size: The` MSFPersonaButtonSize` value used by the `PersonaButton`.
    public init(size: MSFPersonaButtonSize) {
        let configuration = MSFPersonaButtonConfigurationImpl(size: size)
        self.configuration = configuration
    }

    public var body: some View {
        let action = configuration.onTapAction ?? {}
        SwiftUI.Button(action: action) {
            VStack(spacing: 0) {
                avatarView
                personaText
                Spacer(minLength: tokens.verticalPadding)
            }
        }
        .frame(minWidth: adjustedWidth, maxWidth: adjustedWidth, minHeight: 0, maxHeight: .infinity)
        .background(Color(dynamicColor: tokens.backgroundColor))
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
    @ObservedObject var configuration: MSFPersonaButtonConfigurationImpl
    let defaultTokens: PersonaButtonTokens = .init()
    var tokens: PersonaButtonTokens {
        let tokens = resolvedTokens
        tokens.size = configuration.buttonSize
        return tokens
    }

    init(configuration: MSFPersonaButtonConfigurationImpl, action: (() -> Void)?) {
        configuration.onTapAction = action
        self.configuration = configuration
    }

    @ViewBuilder
    private var personaText: some View {
        Group {
            Text(configuration.primaryText ?? "")
                .lineLimit(1)
                .frame(alignment: .center)
                .font(.fluent(tokens.labelFont))
                .foregroundColor(Color(dynamicColor: tokens.labelColor))
            if configuration.buttonSize.shouldShowSubtitle {
                Text(configuration.secondaryText ?? "")
                    .lineLimit(1)
                    .frame(alignment: .center)
                    .font(.fluent(tokens.sublabelFont))
                    .foregroundColor(Color(dynamicColor: tokens.sublabelColor))
            }
        }
        .padding(.horizontal, tokens.horizontalTextPadding)
    }

    private var avatar: Avatar {
        Avatar(configuration.avatarConfiguration)
    }

    @ViewBuilder
    private var avatarView: some View {
        avatar
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

        return avatar.contentSize + (2 * tokens.horizontalAvatarPadding) + (accessibilityAdjustments[sizeCategory]?[configuration.buttonSize] ?? 0)
    }
}

/// Properties that make up PersonaButton content
class MSFPersonaButtonConfigurationImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFPersonaButtonConfiguration {
    /// Creates and initializes a `MSFPersonaButtonConfigurationImpl`
    /// - Parameters:
    ///   - size: The size of the persona button
    init(size: MSFPersonaButtonSize) {
        self.buttonSize = size
        self.avatarConfiguration = MSFAvatarConfigurationImpl(style: .default, size: size.avatarSize)

        super.init()
    }

    @Published var buttonSize: MSFPersonaButtonSize
    @Published var onTapAction: (() -> Void)?
    @Published var overrideTokens: PersonaButtonTokens?

    let avatarConfiguration: MSFAvatarConfigurationImpl
    let id = UUID()

    var avatarBackgroundColor: UIColor? {
        get {
            return avatarConfiguration.backgroundColor
        }
        set {
            avatarConfiguration.backgroundColor = newValue
        }
    }

    var avatarForegroundColor: UIColor? {
        get {
            return avatarConfiguration.foregroundColor
        }
        set {
            avatarConfiguration.foregroundColor = newValue
        }
    }

    var hasPointerInteraction: Bool {
        get {
            return avatarConfiguration.hasPointerInteraction
        }
        set {
            avatarConfiguration.hasPointerInteraction = newValue
        }
    }

    var hasRingInnerGap: Bool {
        get {
            return avatarConfiguration.hasRingInnerGap
        }
        set {
            avatarConfiguration.hasRingInnerGap = newValue
        }
    }

    var image: UIImage? {
        get {
            return avatarConfiguration.image
        }
        set {
            avatarConfiguration.image = newValue
        }
    }

    var imageBasedRingColor: UIImage? {
        get {
            return avatarConfiguration.imageBasedRingColor
        }
        set {
            avatarConfiguration.imageBasedRingColor = newValue
        }
    }

    var isOutOfOffice: Bool {
        get {
            return avatarConfiguration.isOutOfOffice
        }
        set {
            avatarConfiguration.isOutOfOffice = newValue
        }
    }

    var isRingVisible: Bool {
        get {
            return avatarConfiguration.isRingVisible
        }
        set {
            avatarConfiguration.isRingVisible = newValue
        }
    }

    var isTransparent: Bool {
        get {
            return avatarConfiguration.isTransparent
        }
        set {
            avatarConfiguration.isTransparent = newValue
        }
    }

    var presence: MSFAvatarPresence {
        get {
            return avatarConfiguration.presence
        }
        set {
            avatarConfiguration.presence = newValue
        }
    }

    var primaryText: String? {
        get {
            return avatarConfiguration.primaryText
        }
        set {
            avatarConfiguration.primaryText = newValue
        }
    }

    var ringColor: UIColor? {
        get {
            return avatarConfiguration.ringColor
        }
        set {
            avatarConfiguration.ringColor = newValue
        }
    }

    var secondaryText: String? {
        get {
            return avatarConfiguration.secondaryText
        }
        set {
            avatarConfiguration.secondaryText = newValue
        }
    }

    var size: MSFAvatarSize {
        get {
            return avatarConfiguration.size
        }
        set {
            avatarConfiguration.size = newValue
        }
    }

    var style: MSFAvatarStyle {
        get {
            return avatarConfiguration.style
        }
        set {
            avatarConfiguration.style = newValue
        }
    }
}
