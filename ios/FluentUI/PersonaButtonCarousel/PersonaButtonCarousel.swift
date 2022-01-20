//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that define the appearance of a `PersonaButtonCarousel`.
@objc public protocol MSFPersonaCarouselState {
    /// Determines whether the carousel will display small or large avatars.
    var buttonSize: MSFPersonaButtonSize { get }

    /// Handles the event of tapping one of the `PersonaButton` items in a `PersonaButtonCarousel`.
    var onTapAction: ((_ personaButtonState: MSFPersonaCarouselButtonState, _ index: Int) -> Void)? { get set }

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
    @discardableResult func add(primaryText: String?, secondaryText: String?, image: UIImage?) -> MSFPersonaCarouselButtonState

    /// Retrieves the `PersonaButton` at a given index, or nil if the index is out of bounds.
    ///
    /// - Parameters:
    ///   - index: The index of the `PersonaButton` to retrieve
    ///
    /// - Returns: A reference to the  `PersonaButton` at the given index if one exists.
    func personaButtonState(at index: Int) -> MSFPersonaCarouselButtonState?

    /// Removes a `PersonaButton` from the carousel.
    ///
    /// - Parameters:
    ///   - personaState: The reference to a `PersonaButton` to be removed.
    func remove(_ personaState: MSFPersonaCarouselButtonState)

    /// Removes a `PersonaButton` from the carousel at the given index.
    ///
    /// - Parameters:
    ///   - index: The index at which the `PersonaButton` to be removed can be currently found.
    func remove(at index: Int)
}

/// Properties that can be used to customize the appearance of the PersonaButton in the PersonaButtonCarousel.
@objc public protocol MSFPersonaCarouselButtonState {
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
public struct PersonaButtonCarousel: View, TokenizedControlInternal {
    /// Creates a new `PersonaButtonCarousel` instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the `PersonaButtonCarousel`.
    public init(size: MSFPersonaButtonSize) {
        let carouselState = MSFPersonaCarouselStateImpl(size: size)
        state = carouselState
    }

    public var body: some View {
        SwiftUI.ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(state.buttons, id: \.self) { buttonState in
                    PersonaButton(state: buttonState) { [weak state] in
                        guard let strongState = state,
                              let index = strongState.buttons.firstIndex(of: buttonState) else {
                            return
                        }
                        strongState.onTapAction?(buttonState, index)
                    }
                }
            }
        }
        .background(Color(dynamicColor: tokens.backgroundColor))
        .resolveTokens(self)
        .resolveTokenModifier(self, value: state.buttonSize)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFPersonaCarouselStateImpl
    var tokens: PersonaButtonCarouselTokens { state.tokens }
}

/// Properties that make up PersonaButtonCarousel content
class MSFPersonaCarouselStateImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFPersonaCarouselState {
    let buttonSize: MSFPersonaButtonSize

    @Published var onTapAction: ((_ personaButtonState: MSFPersonaCarouselButtonState, _ index: Int) -> Void)?
    @Published var buttons: [MSFPersonaCarouselButtonStateImpl] = []

    @Published var tokens: PersonaButtonCarouselTokens
    @Published var overrideTokens: PersonaButtonCarouselTokens?
    var defaultTokens: PersonaButtonCarouselTokens { .init(size: buttonSize) }

    init(size: MSFPersonaButtonSize) {
        self.buttonSize = size
        self.tokens = PersonaButtonCarouselTokens(size: size)

        super.init()
    }

    // MARK: - accessors and modifiers

    var count: Int {
        return self.buttons.count
    }

    @discardableResult func add(primaryText: String?, secondaryText: String?, image: UIImage?) -> MSFPersonaCarouselButtonState {
        let persona = MSFPersonaCarouselButtonStateImpl(size: self.buttonSize)

        // Set passed-in properties
        persona.primaryText = primaryText
        persona.secondaryText = secondaryText
        persona.image = image

        self.buttons.append(persona)

        return persona
    }

    func personaButtonState(at index: Int) -> MSFPersonaCarouselButtonState? {
        guard index < self.count else {
            return nil
        }
        return self.buttons[index]
    }

    func remove(_ personaState: MSFPersonaCarouselButtonState) {
        self.buttons.removeAll { state in
            state.isEqual(personaState)
        }
    }

    func remove(at index: Int) {
        guard index < self.count else {
            fatalError("Attempting to remove item outside bounds of carousel")
        }
        self.buttons.remove(at: index)
    }
}

/// Subclass of `MSFPersonaButtonStateImpl` that explicitly conforms to `MSFPersonaCarouselButtonState`, which is
/// itself a strict subset of `MSFPersonaButtonState`.
class MSFPersonaCarouselButtonStateImpl: MSFPersonaButtonStateImpl, MSFPersonaCarouselButtonState {
    // No custom initializer is needed
}
