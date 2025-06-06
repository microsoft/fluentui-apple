//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public typealias FluentFontInfo = FontInfo

/// Represents the description of a font used by FluentUI components.
@objc(MSFFontInfo)
public class FontInfo: NSObject {

    /// Creates a `FontInfo` instance using the specified information.
    ///
    /// This struct simply stores information about a future font. Fluent will use this information to create the appropriate font object internally as needed.
    ///
    /// - Parameter name: An optional name for the font. If none is provided, defaults to the standard system font.
    /// - Parameter size: The point size to use for the font.
    /// - Parameter weight: The weight to use for the font. Defaults to `.regular`.
    ///
    /// - Returns: A struct containing the information needed to create a font object.
    public init(name: String? = nil,
                size: CGFloat,
                weight: Font.Weight = .regular) {
        self.name = name
        self.size = size
        self.weight = weight
    }

    /// An optional name for the font. If none is provided, defaults to the standard system font.
    public let name: String?

    /// The point size to use for the font.
    public let size: CGFloat

    /// The weight to use for the font.
    public let weight: Font.Weight

    public var textStyle: Font.TextStyle {
        // Defaults to smallest supported text style for mapping, before checking if we're bigger.
        var textStyle = Font.TextStyle.caption2
        for tuple in Self.platformFontInfoProvider.sizeTuples {
            if self.size >= tuple.size {
                textStyle = tuple.textStyle
                break
            }
        }
        return textStyle
    }

    public var matchesSystemSize: Bool {
        return Self.platformFontInfoProvider.sizeTuples.contains(where: { $0.size == size })
    }

    private static var platformFontInfoProvider: PlatformFontInfoProviding.Type {
        // We need slightly different implementations depending on how our package is loaded.
#if SWIFT_PACKAGE || COCOAPODS
        // In this case, the protocol conformance happens in a different module, so we need to
        // convert the type conditionally and fail if something goes wrong.
        guard let platformFontInfoProvider = self as? PlatformFontInfoProviding.Type else {
            preconditionFailure("FontInfo should conform to PlatformFontInfoProviding")
        }
#else
        // Otherwise, we're all in one module and thus the type conversion is guaranteed.
        let platformFontInfoProvider = self as PlatformFontInfoProviding.Type
#endif
        return platformFontInfoProvider
    }
}
