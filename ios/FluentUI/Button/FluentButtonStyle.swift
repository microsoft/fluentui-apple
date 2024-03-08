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
        self.tokenSet = ButtonTokenSet(style: { style }, size: { size })
    }

    public func makeBody(configuration: Configuration) -> some View {
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
                foregroundColor.clipShape(Capsule())
            } else {
                backgroundColor.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }

        @ViewBuilder var overlayView: some View {
            if borderColor != .clear {
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

        // TODO: why are floating buttons filled with the wrong color?
        return configuration.label
            .font(Font(tokenSet[.titleFont].uiFont))
            .foregroundStyle(foregroundColor)
            .padding(edgeInsets)
            .frame(minHeight: ButtonTokenSet.minContainerHeight(style: style, size: size))
            .background(backgroundView)
            .overlay { overlayView }
            .applyShadow(shadowInfo: shadowInfo)
    }

    @ObservedObject private var tokenSet: ButtonTokenSet

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

//    @Environment(\.isEnabled) var isEnabled: Bool
//    @Environment(\.isFocused) var isFocused: Bool
//    @ObservedObject var tokenSet: ButtonTokenSet
//
//    var text: String?
//    var image: Image?
//    var style: FluentUI.ButtonStyle
//    var sizeCategory: FluentUI.ButtonSizeCategory
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        let isPressed = configuration.isPressed
//        let isDisabled = !isEnabled
//        let isFocused = isFocused
//        let isFloatingStyle = style.isFloating
//        let shouldUsePressedShadow = isDisabled || isPressed
//        let verticalPadding = tokenSet[.minVerticalPadding].float
//        let horizontalPadding = ButtonTokenSet.horizontalPadding(style: style, size: sizeCategory)
//        let foregroundColor: Color
//        let borderColor: Color
//        let backgroundColor: Color
//        if isDisabled {
//            foregroundColor = Color(tokenSet[.foregroundDisabledColor].uiColor)
//            borderColor = Color(tokenSet[.borderDisabledColor].uiColor)
//            backgroundColor = Color(tokenSet[.backgroundDisabledColor].uiColor)
//        } else if isPressed || isFocused {
//            foregroundColor = Color(tokenSet[.foregroundPressedColor].uiColor)
//            borderColor = Color(tokenSet[.borderPressedColor].uiColor)
//            backgroundColor = Color(tokenSet[.backgroundPressedColor].uiColor)
//        } else {
//            foregroundColor = Color(tokenSet[.foregroundColor].uiColor)
//            borderColor = Color(tokenSet[.borderColor].uiColor)
//            backgroundColor = Color(tokenSet[.backgroundColor].uiColor)
//        }
//
//        @ViewBuilder
//        var buttonContent: some View {
//            HStack(spacing: tokenSet[.interspace].float) {
//                if let image {
//                    image
//                        .resizable()
//                        .foregroundColor(foregroundColor)
//                        .frame(width: tokenSet[.iconSize].float, height: tokenSet[.iconSize].float, alignment: .center)
//                }
//                if let text {
//                    Text(text)
//                        .multilineTextAlignment(.center)
//                        .font(.init(tokenSet[.textFont].uiFont))
//                        .frame(minHeight: isFloatingStyle ? tokenSet[.textMinimumHeight].float : nil)
//                }
//            }
//            .padding(EdgeInsets(top: verticalPadding,
//                                leading: horizontalPadding,
//                                bottom: verticalPadding,
//                                trailing: horizontalPadding))
//            .modifyIf(isFloatingStyle && !(text?.isEmpty ?? true), { view in
//                view.padding(.horizontal, tokenSet[.textAdditionalHorizontalPadding].float )
//            })
//            .frame(maxWidth: .infinity, minHeight: tokenSet[.minHeight].float, maxHeight: .infinity)
//            .foregroundColor(foregroundColor)
//        }
//
//        @ViewBuilder
//        var buttonBackground: some View {
//            if tokenSet[.borderWidth].float > 0 {
//                buttonContent.background(
//                    RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
//                        .strokeBorder(lineWidth: tokenSet[.borderWidth].float, antialiased: false)
//                        .foregroundColor(borderColor)
//                        .contentShape(Rectangle()))
//            } else {
//                buttonContent.background(
//                    RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
//                        .fill(backgroundColor))
//            }
//        }
//
//        let shadowInfo = (shouldUsePressedShadow ? tokenSet[.shadowPressed] : tokenSet[.shadowRest]).shadowInfo
//
//        @ViewBuilder
//        var button: some View {
//            if isFloatingStyle {
//                buttonBackground
//                    .clipShape(Capsule())
//                    .applyShadow(shadowInfo: shadowInfo)
//                    .contentShape(Capsule())
//            } else {
//                buttonBackground
//                    .contentShape(RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float))
//            }
//        }
//
//        return button
//            .pointerInteraction(isEnabled)
//    }
//
}
