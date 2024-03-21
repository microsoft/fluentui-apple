//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct FluentButtonStyle: SwiftUI.ButtonStyle {
    let tokenSet: ButtonTokenSet
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
        let colors: Colors = colors(for: configuration)
        let cornerRadius: CGFloat = tokenSet[.cornerRadius].float
        let shadowInfo = tokenSet[!isEnabled || isFocused || configuration.isPressed ? .shadowPressed : .shadowRest].shadowInfo

        @ViewBuilder var backgroundView: some View {
            if style.isFloating {
                colors.background.clipShape(Capsule())
            } else {
                colors.background.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }

        @ViewBuilder var overlayView: some View {
            if colors.border != .clear {
                if style.isFloating {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(style: .init(lineWidth: tokenSet[.borderWidth].float))
                        .foregroundStyle(colors.border)
                } else {
                    Capsule()
                        .stroke(style: .init(lineWidth: tokenSet[.borderWidth].float))
                        .foregroundStyle(colors.border)
                }
            }
        }

        return configuration
            .label
            .font(tokenSet[.titleFont].font)
            .foregroundStyle(colors.foreground)
            .padding(EdgeInsets(directionalEdgeInsets))
            .frame(minHeight: minContainerHeight)
            .background(backgroundView)
            .overlay { overlayView }
            .applyShadow(shadowInfo: shadowInfo)
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

protocol CustomizableButton {
    var tokenSet: ButtonTokenSet { get }
    var style: ButtonStyle { get }
    var size: ButtonSizeCategory { get }
}

extension FluentButtonStyle: CustomizableButton {}

extension CustomizableButton {
    var directionalEdgeInsets: NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(
            top: .zero,
            leading: horizontalPadding,
            bottom: .zero,
            trailing: style.isFloating ? fabAlternativePadding : horizontalPadding
        )
    }

    var horizontalPadding: CGFloat {
        if style.isFloating {
            switch size {
            case .large:
                return GlobalTokens.spacing(.size160)
            case .medium, .small:
                return GlobalTokens.spacing(.size120)
            }
        } else {
            switch size {
            case .large:
                return GlobalTokens.spacing(.size200)
            case .medium:
                return GlobalTokens.spacing(.size120)
            case .small:
                return GlobalTokens.spacing(.size80)
            }
        }
    }

    var fabAlternativePadding: CGFloat {
        switch size {
        case .large:
            return GlobalTokens.spacing(.size200)
        case .medium, .small:
            return GlobalTokens.spacing(.size160)
        }
    }

    var minContainerHeight: CGFloat {
        if style.isFloating {
            switch size {
            case .large:
                return 56
            case .medium, .small:
                return 48
            }
        } else {
            switch size {
            case .large:
                return 52
            case .medium:
                return 40
            case .small:
                return 28
            }
        }
    }
}

extension ControlTokenValue {
    var color: Color { Color(uiColor: uiColor) }

    var font: Font { Font(uiFont) }
}
