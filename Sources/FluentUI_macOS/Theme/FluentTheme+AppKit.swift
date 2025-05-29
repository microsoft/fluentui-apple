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

extension FluentTheme: PlatformThemeProviding {
    public static func platformColorValue(_ token: ColorToken, defaultColor: DynamicColor) -> DynamicColor? {
        let overrideColor: DynamicColor?
        switch token {
        case .background2:
            overrideColor = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                                  dark: GlobalTokens.neutralSwiftUIColor(.grey16))
        case .background4:
            overrideColor = .init(light: GlobalTokens.neutralSwiftUIColor(.grey96),
                                  dark: GlobalTokens.neutralSwiftUIColor(.grey8))
        case .background4Hover:
            overrideColor = .init(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                                  dark: GlobalTokens.neutralSwiftUIColor(.grey12))
        case .background6:
            overrideColor = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                  dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .foreground4:
            overrideColor = .init(light: GlobalTokens.neutralSwiftUIColor(.grey44),
                                  dark: GlobalTokens.neutralSwiftUIColor(.grey60))
        case .strokeAccessible:
            overrideColor = .init(light: GlobalTokens.neutralSwiftUIColor(.grey38),
                                  dark: GlobalTokens.neutralSwiftUIColor(.grey68))
        default:
            overrideColor = nil
        }
        return overrideColor
    }
}
