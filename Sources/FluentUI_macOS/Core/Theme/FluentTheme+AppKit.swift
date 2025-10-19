//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import AppKit
import SwiftUI

public extension FluentTheme {

    /// Returns the color value for the given token.
    ///
    /// - Parameter token: The `ColorsTokens` value to be retrieved.
    /// - Returns: A `UIColor` for the given token.
    @objc(colorForToken:)
    func nsColor(_ token: ColorToken) -> NSColor {
        let dynamicColor = dynamicColor(token)
        return NSColor(light: NSColor(dynamicColor.light),
                       dark: dynamicColor.dark.map { NSColor($0) })
    }

    /// Returns the font value for the given token.
    ///
    /// - Parameter token: The `TypographyTokens` value to be retrieved.
    /// - Parameter adjustsForContentSizeCategory: If true, the resulting font will change size according to Dynamic Type specifications.
    /// - Returns: A `UIFont` for the given token.
    @objc(typographyForToken:adjustsForContentSizeCategory:)
    func typography(_ token: TypographyToken,
                    adjustsForContentSizeCategory: Bool = true) -> NSFont {
        return NSFont.fluent(typographyInfo(token),
                             shouldScale: adjustsForContentSizeCategory)
    }
}
