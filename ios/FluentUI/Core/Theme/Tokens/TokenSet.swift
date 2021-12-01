//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Template for all token sets, both global and alias. This ensures a unified return type for any given token set.
public final class TokenSet<T: Hashable, V> {

    /// Allows us to index into this token set using square brackets.
    ///
    /// We can use square brackets to both read and write into this `TokenSet`. For example:
    /// ```
    /// let value = tokenSet[.primary]
    /// tokenSet[.secondary] = newValue
    /// ```
    public subscript(token: T) -> V {
        get {
            if let value = valueOverrides?[token] {
                return value
            }
            return defaultValues(token)
        }
        set(value) {
            if valueOverrides == nil {
                valueOverrides = [:]
            }
            valueOverrides?[token] = value
        }
    }

    /// Initializes this token set with a callback to fetch its default values as needed.
    ///
    /// - Parameter defaultValues: The closure that can be used to lazily fetch default token values as needed.
    init(_ defaultValues: @escaping ((_ token: T) -> V)) {
        self.defaultValues = defaultValues
    }

    private var defaultValues: ((_ token: T) -> V)
    private var valueOverrides: [T: V]?
}
