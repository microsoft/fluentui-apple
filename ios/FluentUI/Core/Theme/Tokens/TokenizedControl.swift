//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl: View {
    associatedtype TokenType: ControlTokens

    /// Modifier function that updates the design tokens for a given control.
    func customTokens(_ tokens: TokenType) -> Self

    /// Generates an instance of this control's default tokens.
    static func defaultTokens() -> TokenType
}
