//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that define the appearance of a `PersonaButtonCarousel`.
@objc public protocol MSFPersonaButtonCarouselConfiguration {
    /// Determines whether the carousel will display small or large avatars.
    var buttonSize: MSFPersonaButtonSize { get }

    /// Handles the event of tapping one of the `PersonaButton` items in a `PersonaButtonCarousel`.
    var onTapAction: ((_ personaButtonConfiguration: MSFPersonaCarouselButtonConfiguration, _ index: Int) -> Void)? { get set }

    /// Number of `PersonaButton` instances in the carousel.
    var count: Int { get }

    /// Adds a `PersonaButton` to the carousel, and returns an optional reference for additional property setting.
    ///
    /// - Parameters:
    ///   - primaryText: The primary text to appear in the `PersonaButton`
    ///   - secondaryText: The secondary text to appear in the `PersonaButton`, below `primaryText`
    ///   - image: The image to use as the persona's avatar
    ///
    /// - Returns: An optional reference to the added `PersonaButton`, which can be used to set additional properties or to update later.
    @discardableResult func add(primaryText: String?, secondaryText: String?, image: UIImage?) -> MSFPersonaCarouselButtonConfiguration

    /// Retrieves the `PersonaButton` at a given index, or nil if the index is out of bounds.
    ///
    /// - Parameters:
    ///   - index: The index of the `PersonaButton` to retrieve
    ///
    /// - Returns: A reference to the  `PersonaButton` at the given index if one exists.
    func personaButtonConfiguration(at index: Int) -> MSFPersonaCarouselButtonConfiguration?

    /// Removes a `PersonaButton` from the carousel.
    ///
    /// - Parameters:
    ///   - personaConfiguration: The reference to a `PersonaButton` to be removed.
    func remove(_ personaConfiguration: MSFPersonaCarouselButtonConfiguration)

    /// Removes a `PersonaButton` from the carousel at the given index.
    ///
    /// - Parameters:
    ///   - index: The index at which the `PersonaButton` to be removed can be currently found.
    func remove(at index: Int)
}

/// Properties that can be used to customize the appearance of the PersonaButton in the PersonaButtonCarousel.
@objc public protocol MSFPersonaCarouselButtonConfiguration {
    /// Background color for the persona image
    var avatarBackgroundColor: UIColor? { get set }

    /// Foreground color for the persona image
    var avatarForegroundColor: UIColor? { get set }

    /// Iimage to display for persona
    var image: UIImage? { get set }

    /// Image to use as a backdrop for the ring
    var imageBasedRingColor: UIImage? { get set }

    /// Indicates whether to show out of office status
    var isOutOfOffice: Bool { get set }

    /// Indicates if the status ring should be visible
    var isRingVisible: Bool { get set }

    /// Enum that describes persence status for the persona
    var presence: MSFAvatarPresence { get set }

    /// Primary text to be displayed under the persona image (e.g. first name)
    var primaryText: String? { get set }

    /// Color to draw the status ring, if one is visible
    var ringColor: UIColor? { get set }

    /// Secondary text to be displayed under the persona image (e.g. last name or email address)
    var secondaryText: String? { get set }
}

/// View that represents a carousel of `PersonaButton` instances.
public struct PersonaButtonCarousel: View, ConfigurableTokenizedControl {
    /// Creates a new `PersonaButtonCarousel` instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the `PersonaButtonCarousel`.
    public init(size: MSFPersonaButtonSize) {
        let carouselConfiguration = MSFPersonaButtonCarouselConfigurationImpl(size: size)
        configuration = carouselConfiguration
    }

    public var body: some View {
        SwiftUI.ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(configuration.buttons, id: \.self) { buttonConfiguration in
                    PersonaButton(configuration: buttonConfiguration) { [weak configuration] in
                        guard let strongConfiguration = configuration,
                              let index = strongConfiguration.buttons.firstIndex(of: buttonConfiguration) else {
                            return
                        }
                        strongConfiguration.onTapAction?(buttonConfiguration, index)
                    }
                }
            }
        }
        .background(Color(dynamicColor: tokens.backgroundColor))
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var configuration: MSFPersonaButtonCarouselConfigurationImpl
    let defaultTokens: PersonaButtonCarouselTokens = .init()
    var tokens: PersonaButtonCarouselTokens {
        return resolvedTokens
    }
}

/// Properties that make up PersonaButtonCarousel content
class MSFPersonaButtonCarouselConfigurationImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFPersonaButtonCarouselConfiguration {
    let buttonSize: MSFPersonaButtonSize

    @Published var onTapAction: ((_ personaButtonConfiguration: MSFPersonaCarouselButtonConfiguration, _ index: Int) -> Void)?
    @Published var buttons: [MSFPersonaCarouselButtonConfigurationImpl] = []

    @Published var overrideTokens: PersonaButtonCarouselTokens?

    init(size: MSFPersonaButtonSize) {
        self.buttonSize = size

        super.init()
    }

    // MARK: - accessors and modifiers

    var count: Int {
        return self.buttons.count
    }

    @discardableResult func add(primaryText: String?, secondaryText: String?, image: UIImage?) -> MSFPersonaCarouselButtonConfiguration {
        let persona = MSFPersonaCarouselButtonConfigurationImpl(size: self.buttonSize)

        // Set passed-in properties
        persona.primaryText = primaryText
        persona.secondaryText = secondaryText
        persona.image = image

        self.buttons.append(persona)

        return persona
    }

    func personaButtonConfiguration(at index: Int) -> MSFPersonaCarouselButtonConfiguration? {
        guard index < self.count else {
            return nil
        }
        return self.buttons[index]
    }

    func remove(_ personaConfiguration: MSFPersonaCarouselButtonConfiguration) {
        self.buttons.removeAll { configuration in
            configuration.isEqual(personaConfiguration)
        }
    }

    func remove(at index: Int) {
        guard index < self.count else {
            fatalError("Attempting to remove item outside bounds of carousel")
        }
        self.buttons.remove(at: index)
    }
}

/// Subclass of `MSFPersonaButtonConfigurationImpl` that explicitly conforms to `MSFPersonaCarouselButtonConfiguration`, which is
/// itself a strict subset of `MSFPersonaButtonConfiguration`.
class MSFPersonaCarouselButtonConfigurationImpl: MSFPersonaButtonConfigurationImpl, MSFPersonaCarouselButtonConfiguration {
    // No custom initializer is needed
}
