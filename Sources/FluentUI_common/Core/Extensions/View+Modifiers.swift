//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Applies a key and an ambient shadow on a `View`.
    /// - Parameters:
    ///   - shadowInfo: The values of the two shadows to be applied.
    /// - Returns: The modified view.
    func applyFluentShadow(shadowInfo: ShadowInfo) -> some View {
        modifier(ShadowModifier(shadowInfo: shadowInfo))
    }

    /// Backwards compatible wrapper of the iOS26+ .glassEffect modifier
    /// - On iOS 26 / macOS 26 and newer: applies `glassEffect()`.
    /// - On older OSes and unsupported platforms: applies a background with `.regularMaterial` and `shadow08`, with the exception of older macOS versions where no background is applied
    /// - Parameters:
    ///   - interactive: Whether the glass effect should be interactive.
    ///   - tint: The tint color to apply to the glass effect.
    ///   - shape: The shape to apply the glass effect to.
    /// - Returns: The modified view with the glass effect applied.
    @ViewBuilder func fluentGlassEffect<T>(
        interactive: Bool = false,
        tint: Color? = nil,
        in shape: T = Capsule()
    ) -> some View where T: Shape {
        self.modifier(
            FluentGlassEffectModifier(
                interactive: interactive,
                tint: tint,
                shape: shape
            )
        )
    }
}

/// ViewModifier that applies both shadows from a ShadowInfo
private struct ShadowModifier: ViewModifier {
    var shadowInfo: ShadowInfo

    init(shadowInfo: ShadowInfo) {
        self.shadowInfo = shadowInfo
    }

    func body(content: Content) -> some View {
        content
            .shadow(color: shadowInfo.ambientColor,
                    radius: shadowInfo.ambientBlur,
                    x: shadowInfo.xAmbient,
                    y: shadowInfo.yAmbient)
            .shadow(color: shadowInfo.keyColor,
                    radius: shadowInfo.keyBlur,
                    x: shadowInfo.xKey,
                    y: shadowInfo.yKey)
    }
}

private struct FluentGlassEffectModifier<T: Shape>: ViewModifier {
    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    let interactive: Bool
    let tint: Color?
    let shape: T

    func body(content: Content) -> some View {
        #if os(visionOS) || compiler(<6.2)
        content
            .background(.regularMaterial, in: shape)
            .applyFluentShadow(shadowInfo: fluentTheme.shadow(.shadow08))
        #elseif os(macOS)
        if #available(macOS 26, *) {
            content
                .glassEffect(.regular.interactive(interactive).tint(tint), in: shape)
        } else {
            content  // don't add any background
        }
        #else
        if #available(iOS 26, *) {
            content
                .glassEffect(.regular.interactive(interactive).tint(tint), in: shape)
        } else {
            content
                .background(.regularMaterial, in: shape)
                .applyFluentShadow(shadowInfo: fluentTheme.shadow(.shadow08))
        }
        #endif
    }
}
