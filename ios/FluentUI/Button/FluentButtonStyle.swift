//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// ButtonStyle which configures the Button View according to its state and design tokens.
public struct FluentButtonStyle: SwiftUI.ButtonStyle {
    public init(style: ButtonStyle, size: ButtonSizeCategory) {
        self.style = style
        self.size = size
    }

    public func makeBody(configuration: Configuration) -> some View {
        let tokenSet = ButtonTokenSet(style: { style }, size: { size })
        tokenSet.update(fluentTheme)

        let isPressed = configuration.isPressed
        let isDisabled = !isEnabled
        let isFocused = isFocused

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
            if isFloatingStyle {
                backgroundColor.clipShape(Capsule())
            } else {
                backgroundColor.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }

        @ViewBuilder var overlayView: some View {
            if borderColor != Color(.clear) {
                if isFloatingStyle {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(style: .init(lineWidth: tokenSet[.borderWidth].float))
                        .foregroundStyle(borderColor)
                } else {
                    Capsule()
                        .stroke(style: .init(lineWidth: tokenSet[.borderWidth].float))
                        .foregroundStyle(borderColor)
                }
            }
        }

        return configuration.label
            .font(Font(tokenSet[.titleFont].uiFont))
            .foregroundStyle(foregroundColor)
            .padding(edgeInsets)
            .frame(minHeight: ButtonTokenSet.minContainerHeight(style: style, size: size))
            .background(backgroundView)
            .overlay { overlayView }
            .applyShadow(shadowInfo: shadowInfo)
            .pointerInteraction(isEnabled)
    }

    private let style: ButtonStyle
    private let size: ButtonSizeCategory

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.isFocused) private var isFocused: Bool

    private var edgeInsets: EdgeInsets {
        let horizontalPadding = ButtonTokenSet.horizontalPadding(style: style, size: size)
        let fabAlternativePadding = ButtonTokenSet.fabAlternativePadding(size)
        return EdgeInsets(
            top: .zero,
            leading: horizontalPadding,
            bottom: .zero,
            trailing: style.isFloating ? fabAlternativePadding : horizontalPadding
        )
    }

    private var isFloatingStyle: Bool { style.isFloating }
}
