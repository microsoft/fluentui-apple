//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Base class for all Fluent control tokenization.
public class ControlTokens: NSObject {
    var globalTokens: GlobalTokens = GlobalTokens.shared
    var aliasTokens: AliasTokens = AliasTokens.shared

    // Represents a token value with an optional override.
    struct OverridableToken<T> {
        let base: () -> T
        var override: T?

        var value: T {
            if let override = override {
                return override
            }
            return base()
        }
    }
}
