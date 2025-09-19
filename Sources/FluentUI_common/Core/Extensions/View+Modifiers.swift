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

    /// Abstracts away differences in pre-iOS 17 `onChange(of:perform:)` versus post-iOS 17 `onChange(of:_:)`.
    ///
    /// This function will be removed once FluentUI moves to iOS 17 as a minimum target.
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action when the specified value changes.
    @available(*, deprecated, message: "Please use the native onChange(of:_:) method instead.")
    func onChange_iOS17<V>(of value: V, _ action: @escaping (V) -> Void) -> some View where V: Equatable {
        return self.onChange(of: value) { _, newValue in
            return action(newValue)
        }
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

