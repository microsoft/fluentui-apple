//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Extending `FluentTheme` to implement this protocol allows for platform-specific implementation of token values.
protocol PlatformThemeProviding {

    /// Returns the platform-appropriate value for a given `ColorToken`.
    /// - Parameters:
    ///   - token: The `ColorToken` whose color should be provided.
    /// - Returns: The color value for this token.
    static func platformColorValue(_ token: FluentTheme.ColorToken) -> DynamicColor

    /// Returns the platform-appropriate value for a given `TypographyToken`.
    /// - Parameters:
    ///   - token: The `TypographyToken` whose font should be provided.
    /// - Returns: The font value for this token.
    static func platformTypographyValue(_ token: FluentTheme.TypographyToken) -> FontInfo
}
