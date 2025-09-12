//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import AppKit

public extension GlobalTokens {

    // MARK: - BrandColor

    @objc(colorForBrandColorToken:)
    static func brandColor(_ token: BrandColorToken) -> NSColor {
        return NSColor(GlobalTokens.brandSwiftUIColor(token))
    }

    // MARK: - NeutralColor

    @objc(colorForNeutralColorToken:)
    static func neutralColor(_ token: NeutralColorToken) -> NSColor {
        return NSColor(GlobalTokens.neutralSwiftUIColor(token))
    }

    // MARK: - SharedColor

    @objc(colorForSharedColorSet:token:)
    static func sharedColor(_ sharedColor: SharedColorSet, _ token: SharedColorToken) -> NSColor {
        return NSColor(GlobalTokens.sharedSwiftUIColor(sharedColor, token))
    }
}
