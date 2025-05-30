//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Extending `FluentTheme` to implement this protocol allows for platform-specific implementation of token values.
public protocol PlatformThemeProviding {

    /// Returns the platform-appropriate value for a given `ColorToken`.
    /// - Parameters:
    ///   - token: The `ColorToken` whose color should be provided.
    /// - Returns: The color value for this token. If the token is not supported on the platform, a fallback value will be returned.
    static func platformColorValue(_ token: FluentTheme.ColorToken) -> DynamicColor
}
