//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// SwiftUI-specific extension to `TokenizedControl`.
public protocol TokenizedControlOverridable: TokenizedControl {
    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these overridden tokens applied.
    func overrideTokens(_ overrideTokens: [TokenSetKeyType: ControlTokenValue]?) -> Self
}

/// Internal union of `TokenizedControlOverridable` and `TokenizedControlInternal` protocols.
internal protocol TokenizedControlView: TokenizedControlOverridable, TokenizedControlInternal {}

/// Common base type alias for all `state` objects.
typealias ControlState = NSObject & ObservableObject & Identifiable

// MARK: - Extensions

// swiftlint:disable extension_access_modifier
extension TokenizedControlView {
    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter overrideTokens: The tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these overridden tokens applied.
    public func overrideTokens(_ overrideTokens: [TokenSetKeyType: ControlTokenValue]?) -> Self {
        overrideTokens?.forEach({ (key, value) in
            self.tokenSet[key] = value
        })
        return self
    }
}
// swiftlint:enable extension_access_modifier

extension View {
    /// Applies a given `FluentTheme` and `configuration` to  the control's token set.
    ///
    /// Use the `configuration` function to set additional properties on the `tokenSet` as needed. For example, some
    /// controls may need different tokens back for different sized components, so this callback should be used as an
    /// opportunity to perform that configuration on `tokenSet`.
    ///
    /// - Parameter tokenSet: The control's `ControlTokenSet` that should be updated.
    /// - Parameter fluentTheme: The current `FluentTheme` for the given rendering context.
    ///
    /// - Returns: The rendered view after applying updates.
    func fluentTokens<TokenSetType: Hashable>(_ tokenSet: ControlTokenSet<TokenSetType>,
                                              _ fluentTheme: FluentTheme) -> some View {
        return self
            .onChange(of: fluentTheme) { newTheme in
                tokenSet.update(newTheme)
            }
    }
}
