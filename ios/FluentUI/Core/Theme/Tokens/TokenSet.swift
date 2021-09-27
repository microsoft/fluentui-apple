//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Template for all token sets, both global and alias. This ensures a unified return type for any given token set.
protocol TokenSet {
    associatedtype TokenType
    var value: TokenType { get }
}
