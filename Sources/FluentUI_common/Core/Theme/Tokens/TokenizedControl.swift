//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl {
    /// The type of tokens associated with this `TokenizedControl`.
    associatedtype TokenSetKeyType: TokenSetKey
    associatedtype TokenSetType: ControlTokenSet<Self.TokenSetKeyType>

    /// The set of tokens associated with this `TokenizedControl`.
    var tokenSet: TokenSetType { get }
}
