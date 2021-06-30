//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaCarouselState` contains PersonaCarousel properties
///
/// - `buttonSize`: returns whether the carousel will display small or large avatars
/// - `onTapAction`: provides tap gesture
@objc public protocol MSFPersonaCarouselState {
    var buttonSize: MSFPersonaButtonSize { get }
    var onTapAction: ((_ personaButtonState: MSFPersonaButtonData, _ index: Int) -> Void)? { get set }

}

/// Properties that make up PersonaGrid content
class MSFPersonaCarouselStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaCarouselState {
    let tokens: MSFPersonaButtonCarouselTokens
    let buttonSize: MSFPersonaButtonSize

    @Published var onTapAction: ((_ personaButtonState: MSFPersonaButtonData, _ index: Int) -> Void)?

    @Published var buttons: [MSFPersonaButtonStateImpl] = []

    init(size: MSFPersonaButtonSize) {
        self.buttonSize = size
        self.tokens = MSFPersonaButtonCarouselTokens(size: size)

        super.init()
    }

    // MARK: - accessors and modifiers

    var count: Int {
        return self.buttons.count
    }

    @discardableResult func add(primaryText: String?, secondaryText: String?, image: UIImage?) -> MSFPersonaButtonData {
        let persona = MSFPersonaButtonStateImpl(size: self.buttonSize)

        // Set passed-in properties
        persona.primaryText = primaryText
        persona.secondaryText = secondaryText
        persona.image = image

        self.buttons.append(persona)

        return persona
    }

    func personaButtonData(at index: Int) -> MSFPersonaButtonData? {
        guard index < self.count else {
            return nil
        }
        return self.buttons[index]
    }

    func remove(_ personaData: MSFPersonaButtonData) {
        self.buttons.removeAll { personaState in
            personaState.isEqual(personaData)
        }
    }

    func remove(at index: Int) {
        guard index < self.count else {
            fatalError("Attempting to remove item outside bounds of carousel")
        }
        self.buttons.remove(at: index)
    }
}

struct PersonaButtonCarousel: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaButtonCarouselTokens
    @ObservedObject var state: MSFPersonaCarouselStateImpl

    public init(size: MSFPersonaButtonSize) {
        let carouselState = MSFPersonaCarouselStateImpl(size: size)
        tokens = carouselState.tokens
        state = carouselState
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
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
        .background(Color(tokens.backgroundColor))
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}
