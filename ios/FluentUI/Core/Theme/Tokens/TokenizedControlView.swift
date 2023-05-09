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
