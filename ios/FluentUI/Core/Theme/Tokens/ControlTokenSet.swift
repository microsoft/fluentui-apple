//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import CoreGraphics // for CGFloat

/// Base class for all Fluent control tokenization.
open class ControlTokenSet<T: TokenSetKey>: ObservableObject {
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

    /// Prepares this token set by installing the current `FluentTheme` and then allowing the control to perform
    /// additional configuration (e.g. setting `style` or `size` properties) by invoking the `configuration` callback.
    ///
    /// - Parameter fluentTheme: The current `FluentTheme` for the control's environment.
    /// - Parameter configuration: An optional callback for the control to perform additional configuration.
    func update(_ fluentTheme: FluentTheme,
                _ configuration: (() -> Void)? = nil) {
        if fluentTheme != self.fluentTheme {
            self.fluentTheme = fluentTheme
        }

        if let configuration = configuration {
            configuration()
        }
    }

    @Published var fluentTheme: FluentTheme = FluentTheme.shared

    @Published private var valueOverrides: [T: ControlTokenValue]?
}

public enum ControlTokenValue {
    case float(() -> CGFloat)
    case dynamicColor(() -> DynamicColor)
    case fontInfo(() -> FontInfo)
    case shadowInfo(() -> ShadowInfo)

    var float: CGFloat {
        if case .float(let float) = self {
            return float()
        } else {
            assertionFailure("Cannot convert token to CGFloat: \(self)")
            return 0.0
        }
    }

    var dynamicColor: DynamicColor {
        if case .dynamicColor(let dynamicColor) = self {
            return dynamicColor()
        } else {
            assertionFailure("Cannot convert token to DynamicColor: \(self)")
            return DynamicColor(light: ColorValue(0xE3008C))
        }
    }

    var fontInfo: FontInfo {
        if case .fontInfo(let fontInfo) = self {
            return fontInfo()
        } else {
            assertionFailure("Cannot convert token to FontInfo: \(self)")
            return FontInfo(size: 0.0)
        }
    }

    var shadowInfo: ShadowInfo {
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
}

#if DEBUG
extension ControlTokenValue: CustomStringConvertible {
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
