//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct FluentButtonStyle: SwiftUI.ButtonStyle {
    private let tokenSet: ButtonTokenSet
    let style: ButtonStyle
    let size: ButtonSizeCategory

    @Environment(\.isEnabled) var isEnabled: Bool
    @Environment(\.isFocused) var isFocused: Bool

    public init(style: ButtonStyle, size: ButtonSizeCategory) {
        self.style = style
        self.size = size
        self.tokenSet = ButtonTokenSet(style: { style }, size: { size })
    }

    public func makeBody(configuration: Configuration) -> some View {
        // TODO: Apply padding, font, shadow based on style
        let colors: Colors = colors(for: configuration)
        let cornerRadius: CGFloat = tokenSet[.cornerRadius].float
        return configuration
            .label
            .foregroundStyle(colors.foreground)
            .padding()
            .background(colors.background.clipShape(RoundedRectangle(cornerRadius: cornerRadius)))
            .overlay {
                if colors.border != .clear {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(style: .init(lineWidth: tokenSet[.borderWidth].float))
                        .foregroundStyle(colors.border)
                }
            }
    }

    private func colors(for config: Configuration) -> Colors {
        if !isEnabled {
            Colors(
                background: tokenSet[.backgroundDisabledColor].color,
                foreground: tokenSet[.foregroundDisabledColor].color,
                border: tokenSet[.borderDisabledColor].color
            )
        } else if config.isPressed {
            Colors(
                background: tokenSet[.backgroundPressedColor].color,
                foreground: tokenSet[.foregroundPressedColor].color,
                border: tokenSet[.borderPressedColor].color
            )
        } else if isFocused {
            Colors(
                background: tokenSet[.backgroundFocusedColor].color,
                foreground: tokenSet[.foregroundColor].color,
                border: tokenSet[.borderFocusedColor].color
            )
        } else {
            Colors(
                background: tokenSet[.backgroundColor].color,
                foreground: tokenSet[.foregroundColor].color,
                border: tokenSet[.borderColor].color
            )
        }
    }

    private struct Colors {
        let background: Color
        let foreground: Color
        let border: Color
    }
}

extension ControlTokenValue {
  var color: Color {
    Color(uiColor: uiColor)
  }
}
