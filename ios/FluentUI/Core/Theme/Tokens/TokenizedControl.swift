//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a struct or object that maintains a control's token state.
protocol TokenizedState {
    associatedtype TokenType: ControlTokens
    var tokens: TokenType { get set }
}

/// Defines a control with customizable design tokens.
public protocol TokenizedControl: View {
    associatedtype TokenType: ControlTokens

    /// Modifier function that updates the design tokens for a given control.
    func customTokens(_ tokens: TokenType) -> Self
}
