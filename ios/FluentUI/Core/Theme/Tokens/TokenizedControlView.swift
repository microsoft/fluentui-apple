//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// SwiftUI-specific extension to `TokenizedControl`.
protocol TokenizedControlView: TokenizedControlInternal {
    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these overridden tokens applied.
    func overrideTokens(_ overrideTokens: TokenType?) -> Self
}

// MARK: - Extensions

extension TokenizedControlView {
    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these overridden tokens applied.
    func overrideTokens(_ overrideTokens: TokenType?) -> Self {
        tokenResolver.overrideTokens = overrideTokens
        return self
    }
}
