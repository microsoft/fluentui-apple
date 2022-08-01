//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import CoreGraphics // for CGFloat
import Combine

/// Base class for all Fluent control tokenization.
public class ControlTokenSet<T: TokenSetKey>: ObservableObject {
    required public init() {}

    /// Allows us to index into this token set using square brackets.
    ///
    /// We can use square brackets to both read and write into this `TokenSet`. For example:
    /// ```
    /// let value = tokenSet[.primary]   // exercises the `get`
    /// tokenSet[.secondary] = newValue  // exercises the `set`
    /// ```
    public subscript(token: T) -> ControlTokenValue {
        get {
            if let value = valueOverrides?[token] {
                return value
            } else if let value = fluentTheme.tokens(for: type(of: self))?[token] {
                return value
            }
            return defaultValue(token)
        }
        set(value) {
            if valueOverrides == nil {
                valueOverrides = [:]
            }
            valueOverrides?[token] = value
        }
    }

    /// Removes a stored override for a given token value.
    ///
    /// - Parameter token: The token value whose override should be removed.
    public func removeOverride(_ token: T) {
        valueOverrides?[token] = nil
    }

    public var globalTokens: GlobalTokens { fluentTheme.globalTokens }
    public var aliasTokens: AliasTokens { fluentTheme.aliasTokens }

    /// Returns the default values for a given `ControlTokenSet`.
    ///
    /// This method should be overridden by specific subclasses to return the appropriate default values for this control.
    ///
    /// - Parameter token: The token for which to return a default value.
    ///
    /// - Returns: The default value for a given token value.
    func defaultValue(_ token: T) -> ControlTokenValue {
        preconditionFailure("Override defaultValue in your ControlTokenSet")
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

    @Published var fluentTheme: FluentTheme = FluentTheme.shared

    @Published private var valueOverrides: [T: ControlTokenValue]?
}

/// Union-type enumeration of all possible token values to be stored by a `ControlTokenSet`.
public enum ControlTokenValue {
    case float(() -> CGFloat)
    case dynamicColor(() -> DynamicColor)
    case fontInfo(() -> FontInfo)
    case shadowInfo(() -> ShadowInfo)
    case buttonDynamicColors(() -> ButtonDynamicColors)
    case pillButtonDynamicColors(() -> PillButtonDynamicColors)

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
            return DynamicColor(light: ColorValue(0xE3008C))
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
            let defaultColor = DynamicColor(light: ColorValue(0xE3008C))
            return ShadowInfo(colorOne: defaultColor,
                              blurOne: 10.0,
                              xOne: 10.0,
                              yOne: 10.0,
                              colorTwo: defaultColor,
                              blurTwo: 10.0,
                              xTwo: 10.0,
                              yTwo: 10.0)
        }
    }

    public var buttonDynamicColors: ButtonDynamicColors {
        if case .buttonDynamicColors(let buttonDynamicColors) = self {
            return buttonDynamicColors()
        } else {
            assertionFailure("Cannot convert token to ButtonDynamicColors: \(self)")
            let defaultColor = DynamicColor(light: ColorValue(0xE3008C))
            return ButtonDynamicColors(rest: defaultColor,
                                       hover: defaultColor,
                                       pressed: defaultColor,
                                       selected: defaultColor,
                                       disabled: defaultColor)
        }
    }

    public var pillButtonDynamicColors: PillButtonDynamicColors {
        if case .pillButtonDynamicColors(let pillButtonDynamicColors) = self {
            return pillButtonDynamicColors()
        } else {
            assertionFailure("Cannot convert token to PillButtonDynamicColors: \(self)")
            let defaultColor = DynamicColor(light: ColorValue(0xE3008C))
            return PillButtonDynamicColors(rest: defaultColor,
                                           selected: defaultColor,
                                           disabled: defaultColor,
                                           selectedDisabled: defaultColor)
        }
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
        case .buttonDynamicColors(let buttonDynamicColors):
            return "ControlTokenValue.buttonDynamicColors (\(buttonDynamicColors())"
        case .pillButtonDynamicColors(let pillButtonDynamicColors):
            return "ControlTokenValue.pillButtonDynamicColors (\(pillButtonDynamicColors()))"
        }
    }
}
#endif // DEBUG
