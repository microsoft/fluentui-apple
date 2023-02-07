//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import CoreGraphics // for CGFloat
import Combine

/// Base class for all Fluent control tokenization.
public class ControlTokenSet<T: TokenSetKey>: ObservableObject {
    /// Allows us to index into this token set using square brackets.
    ///
    /// We can use square brackets to both read and write into this `TokenSet`. For example:
    /// ```
    /// let value = tokenSet[.primary]   // exercises the `get`
    /// tokenSet[.secondary] = newValue  // exercises the `set`
    /// ```
    public subscript(token: T) -> ControlTokenValue {
        get {
            if let value = overrideValue(forToken: token) {
                return value
            } else if let value = defaults?(token, self.fluentTheme) {
                return value
            } else {
                preconditionFailure()
            }
        }
        set(value) {
            setOverrideValue(value, forToken: token)
        }
    }

    /// Removes a stored override for a given token value.
    ///
    /// - Parameter token: The token value whose override should be removed.
    public func removeOverride(_ token: T) {
        valueOverrides?[token] = nil
    }

    /// Convenience method to replace all overrides with a new set of values.
    ///
    /// Any value present in `overrideTokens` will be set onto this control. All other values will be
    /// removed from this control. If overrideTokens is `nil`, then all current overrides will be removed.
    ///
    /// - Parameter overrideTokens: The set of tokens to set as custom, or `nil` to remove all overrides.
    public func replaceAllOverrides(with overrideTokens: [T: ControlTokenValue]?) {
        T.allCases.forEach { token in
            if let value = overrideTokens?[token] {
                self[token] = value
            } else {
                self.removeOverride(token)
            }
        }
    }

    /// Initialize the `ControlTokenSet` with an escaping callback for fetching default values.
    init(_ defaults: @escaping (_ token: T, _ theme: FluentTheme) -> ControlTokenValue) {
        self.defaults = defaults
    }

    /// Prepares this token set by installing the current `FluentTheme` if it has changed.
    ///
    /// - Parameter fluentTheme: The current `FluentTheme` for the control's environment.
    func update(_ fluentTheme: FluentTheme) {
        if fluentTheme != self.fluentTheme {
            self.fluentTheme = fluentTheme
        }
    }

    /// Simplifies the process of observing changes to this token set.
    ///
    /// - Parameter receiveValue: A callback to be invoked after the token set has completed updating.
    ///
    /// - Returns: An `AnyCancellable` to track this observation.
    func sinkChanges(receiveValue: @escaping () -> Void) -> AnyCancellable {
        return self.objectWillChange.sink { [receiveValue] in
            // Values will be updated on the next run loop iteration.
            DispatchQueue.main.async {
                receiveValue()
            }
        }
    }

    // Internal accessor and setter functions for the override dictionary

    func overrideValue(forToken token: T) -> ControlTokenValue? {
        if let value = valueOverrides?[token] {
            return value
        } else if let value = fluentTheme.tokens(for: type(of: self))?[token] {
            return value
        }
        return nil
    }

    func setOverrideValue(_ value: ControlTokenValue?, forToken token: T) {
        if valueOverrides == nil {
            valueOverrides = [:]
        }
        valueOverrides?[token] = value
    }

    /// The current `FluentTheme` associated with this `ControlTokenSet`.
    @Published var fluentTheme: FluentTheme = FluentTheme.shared

    /// Access to raw overrides for the `ControlTokenSet`.
    @Published private var valueOverrides: [T: ControlTokenValue]?

    /// Reference to the default value lookup function for this control.
    private var defaults: ((_ token: T, _ theme: FluentTheme) -> ControlTokenValue)?
}

/// Union-type enumeration of all possible token values to be stored by a `ControlTokenSet`.
public enum ControlTokenValue {
    case float(() -> CGFloat)
    case dynamicColor(() -> DynamicColor)
    case fontInfo(() -> FontInfo)
    case shadowInfo(() -> ShadowInfo)

    public var float: CGFloat {
        if case .float(let float) = self {
            return float()
        } else {
            assertionFailure("Cannot convert token to CGFloat: \(self)")
            return 0.0
        }
    }

    public var dynamicColor: DynamicColor {
        if case .dynamicColor(let dynamicColor) = self {
            return dynamicColor()
        } else {
            assertionFailure("Cannot convert token to DynamicColor: \(self)")
            return fallbackColor
        }
    }

    public var fontInfo: FontInfo {
        if case .fontInfo(let fontInfo) = self {
            return fontInfo()
        } else {
            assertionFailure("Cannot convert token to FontInfo: \(self)")
            return FontInfo(size: 0.0)
        }
    }

    public var shadowInfo: ShadowInfo {
        if case .shadowInfo(let shadowInfo) = self {
            return shadowInfo()
        } else {
            assertionFailure("Cannot convert token to ShadowInfo: \(self)")
            return ShadowInfo(colorOne: fallbackColor,
                              blurOne: 10.0,
                              xOne: 10.0,
                              yOne: 10.0,
                              colorTwo: fallbackColor,
                              blurTwo: 10.0,
                              xTwo: 10.0,
                              yTwo: 10.0)
        }
    }

    // MARK: - Helpers

    private var fallbackColor: DynamicColor {
#if DEBUG
        // Use our global "Hot Pink" in debug builds, to help identify unintentional conversions.
        return DynamicColor(light: ColorValue(0xE3008C))
#else
        return DynamicColor(light: ColorValue(0x000000))
#endif
    }
}

#if DEBUG
extension ControlTokenValue: CustomStringConvertible {
    /// Handy debug-only description for logging these values.
    public var description: String {
        switch self {
        case .float(let float):
            return "ControlTokenValue.float (\(float())"
        case .dynamicColor(let dynamicColor):
            return "ControlTokenValue.dynamicColor (\(dynamicColor())"
        case .fontInfo(let fontInfo):
            return "ControlTokenValue.fontInfo (\(fontInfo())"
        case .shadowInfo(let shadowInfo):
            return "ControlTokenValue.shadowInfo (\(shadowInfo())"
        }
    }
}
#endif // DEBUG
