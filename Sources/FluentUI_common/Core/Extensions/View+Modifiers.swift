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

