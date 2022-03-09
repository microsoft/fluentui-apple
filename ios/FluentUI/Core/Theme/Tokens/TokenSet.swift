//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Template for all token sets, both global and alias. This ensures a unified return type for any given token set.
public final class TokenSet<T: Hashable & CaseIterable, V> {

    /// Allows us to index into this token set using square brackets.
    ///
    /// We can use square brackets to both read and write into this `TokenSet`. For example:
    /// ```
    /// let value = tokenSet[.primary]   // exercises the `get`
    /// tokenSet[.secondary] = newValue  // exercises the `set`
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
    /// The `defaultValues` closure being passed in is expected to take the form of a static switch statement, like so:
    /// ```
    /// switch token {
    /// case firstCase:
    ///     return someValue
    /// case secondCase:
    ///     return someOtherValue
    /// // ... et cetera
    /// }
    /// ```
    /// This provides fast, predictable access to default token values without requiring (A) separate public properties for
    /// each value, or (B) unnecessary value storage in memory.
    ///
    /// - Parameter defaultValues: A closure that provides default values for this token set.
    init(_ defaultValues: @escaping ((_ token: T) -> V)) {
        self.defaultValues = defaultValues
    }

    private var defaultValues: ((_ token: T) -> V)
    private var valueOverrides: [T: V]?
}
