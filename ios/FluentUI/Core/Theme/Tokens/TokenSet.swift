//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Template for all token sets, both global and alias. This ensures a unified return type for any given token set.
public class TokenSet<T: CaseIterable & Hashable, V> {

    /// Allows us to index into this token set using square brackets.
    ///
    /// We can use square brackets to both read and write into this `TokenSet`. For example:
    /// ```
    /// let value = tokenSet[.primary]
    /// tokenSet[.secondary] = newValue
    /// ```
    public subscript(token: T) -> V {
        get {
            guard let value = values[token] else {
                preconditionFailure("Missing value for token \(token)!")
            }
            return value
        }
        set(value) {
            values[token] = value
        }
    }

    init(_ values: [T: V]) {
        self.values = values
    }

    private var values: [T: V] = [:]
}
