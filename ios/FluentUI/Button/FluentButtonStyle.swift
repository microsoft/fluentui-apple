//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// `ButtonStyle` which configures the `Button` according to its state and design tokens.
public struct FluentButtonStyle: SwiftUI.ButtonStyle {
    public init(style: ButtonStyle) {
        self.style = style
    }

    public func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        let isDisabled = !isEnabled
        let isFocused = isFocused
        let size = size

        let tokenSet = ButtonTokenSet(style: { style }, size: { size })
        tokenSet.replaceAllOverrides(with: tokenOverrides)
        tokenSet.update(fluentTheme)

        let cornerRadius = tokenSet[.cornerRadius].float
        let shadowToken = (isDisabled || isFocused || isPressed) ? ButtonToken.shadowPressed : ButtonToken.shadowRest
        let shadowInfo = tokenSet[shadowToken].shadowInfo

        let foregroundColor: Color
        let borderColor: Color
        let backgroundColor: Color
        if isDisabled {
            foregroundColor = Color(tokenSet[.foregroundDisabledColor].uiColor)
            borderColor = Color(tokenSet[.borderDisabledColor].uiColor)
            backgroundColor = Color(tokenSet[.backgroundDisabledColor].uiColor)
        } else if isPressed || isFocused {
            foregroundColor = Color(tokenSet[.foregroundPressedColor].uiColor)
            borderColor = Color(tokenSet[.borderPressedColor].uiColor)
            backgroundColor = Color(tokenSet[.backgroundPressedColor].uiColor)
        } else {
            foregroundColor = Color(tokenSet[.foregroundColor].uiColor)
            borderColor = Color(tokenSet[.borderColor].uiColor)
            backgroundColor = Color(tokenSet[.backgroundColor].uiColor)
        }

        @ViewBuilder var backgroundView: some View {
            if backgroundColor != Color(.clear) {
                backgroundColor.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }

        @ViewBuilder var overlayView: some View {
            if borderColor != Color(.clear) {
                contentShape
                    .stroke(style: .init(lineWidth: tokenSet[.borderWidth].float))
                    .foregroundStyle(borderColor)
            }
        }

        @ViewBuilder var contentShape: some Shape {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        }

        return configuration.label
            .font(Font(tokenSet[.titleFont].uiFont))
            .foregroundStyle(foregroundColor)
            .padding(edgeInsets)
            .frame(minHeight: ButtonTokenSet.minContainerHeight(style: style, size: size))
            .background(backgroundView)
            .overlay { overlayView }
            .applyFluentShadow(shadowInfo: shadowInfo)
            .contentShape(contentShape)
            .pointerInteraction(isEnabled)
    }

    @Environment(\.controlSize) private var controlSize: ControlSize
    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.isFocused) private var isFocused: Bool

    private let style: ButtonStyle

    private var size: ButtonSizeCategory {
        switch controlSize {
        case .mini, .small:
            return .small
        case .regular:
            return .medium
        case .large, .extraLarge:
            return .large
        @unknown default:
            assertionFailure("Unknown SwiftUI.ControlSize: \(controlSize). Reverting to .medium")
            return .medium
        }
    }

    private var edgeInsets: EdgeInsets {
        let size = size
        let horizontalPadding = ButtonTokenSet.horizontalPadding(style: style, size: size)
        let fabAlternativePadding = ButtonTokenSet.fabAlternativePadding(size)
        return EdgeInsets(
            top: .zero,
            leading: horizontalPadding,
            bottom: .zero,
            trailing: style.isFloating ? fabAlternativePadding : horizontalPadding
        )
    }

    private var tokenOverrides: [ButtonToken: ControlTokenValue]?
}

public extension FluentButtonStyle {
    /// Provide override values for various `ButtonToken` values.
    mutating func overrideTokens(_ overrides: [ButtonToken: ControlTokenValue]) {
        tokenOverrides = overrides
    }
}
