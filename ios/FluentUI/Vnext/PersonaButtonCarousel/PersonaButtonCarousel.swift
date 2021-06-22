//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaCarouselState` contains PersonaCarousel properties
///
/// - `buttonSize`: specifies whether to use small or large avatars
/// - `onTapAction`: provides tap gesture
@objc public protocol MSFPersonaCarouselState {
    var buttonSize: MSFPersonaButtonSize { get }
    var onTapAction: ((_ personaButtonState: MSFPersonaButtonState, _ index: Int) -> Void)? { get set }
}

/// Properties that make up PersonaGrid content
class MSFPersonaCarouselStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaCarouselState {
    let tokens: MSFPersonaButtonCarouselTokens
    let buttonSize: MSFPersonaButtonSize

    @Published var onTapAction: ((_ personaButtonState: MSFPersonaButtonState, _ index: Int) -> Void)?

    @Published var buttons: [MSFPersonaButtonStateImpl] = [] {
        didSet {
            // When the buttons array changes, any new entries need to have their action set
            // to pass through to the main callback for the carousel
            let old = Set(oldValue)
            let new = Set(buttons)
            let newElements = new.subtracting(old)

            newElements.forEach { button in
                button.onTapAction = { [weak self] in
                    guard let index = self?.buttons.firstIndex(of: button) else {
                        return
                    }
                    self?.onTapAction?(button, index)
                }
            }
        }
    }

    init(size: MSFPersonaButtonSize, buttons: [MSFPersonaButtonStateImpl] = []) {
        self.buttonSize = size
        self.tokens = MSFPersonaButtonCarouselTokens(size: size)

        super.init()

        // Update the `buttons` array after init in order to trigger the `didSet`
        self.buttons = buttons
    }
}

struct PersonaButtonCarousel: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaButtonCarouselTokens
    @ObservedObject var state: MSFPersonaCarouselStateImpl

    let buttonSize: MSFPersonaButtonSize

    public init(size: MSFPersonaButtonSize,
                personaButtons: [MSFPersonaButtonStateImpl] = []) {
        tokens = MSFPersonaButtonCarouselTokens(size: size)
        state = MSFPersonaCarouselStateImpl(size: size, buttons: personaButtons)

        buttonSize = size
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(state.buttons) { buttonState in
                    PersonaButton(state: buttonState)
                }
            }
        }
        .background(Color(tokens.backgroundColor))
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}
