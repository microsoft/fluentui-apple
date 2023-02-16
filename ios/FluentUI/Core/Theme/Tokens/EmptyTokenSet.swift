//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

// MARK: TokenSet
public class EmptyTokenSet: ControlTokenSet<EmptyTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case none
    }
    init() {
        super.init { _, _ in
            preconditionFailure("Should not fetch values")
        }
    }
}
