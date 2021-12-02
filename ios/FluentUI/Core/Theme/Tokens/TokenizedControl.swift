//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl: View {
    associatedtype TokenType: ControlTokens

    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The custom tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these custom tokens applied.
    func customTokens(_ tokens: TokenType) -> Self
}
