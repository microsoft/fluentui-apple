//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Extending `FluentTheme` to implement this protocol allows for platform-specific implementation of token values.
public protocol PlatformThemeProviding {

    /// Returns the platform-appropriate override for a given `ColorToken`.
    /// - Parameters:
    ///   - token: The `ColorToken` whose color should be provided.
    ///   - defaultColor: The default value for the given `ColorToken`.
    /// - Returns: The overridden value, or `nil` if no override is needed.
    static func platformColorValue(_ token: FluentTheme.ColorToken, defaultColor: DynamicColor) -> DynamicColor?
}
