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
}

struct PersonaButtonCarousel: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaButtonCarouselTokens
    @ObservedObject var state: MSFPersonaCarouselStateImpl

    let buttonSize: MSFPersonaButtonSize

    public init(size: MSFPersonaButtonSize) {
        tokens = MSFPersonaButtonCarouselTokens(size: size)
        state = MSFPersonaCarouselStateImpl(size: size)

        buttonSize = size
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(state.buttons, id: \.self) { buttonState in
                    PersonaButton(state: buttonState) { [weak state] in
                        guard let state = state,
                              let index = state.buttons.firstIndex(of: buttonState) else {
                            return
                        }
                        state.onTapAction?(buttonState, index)
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
