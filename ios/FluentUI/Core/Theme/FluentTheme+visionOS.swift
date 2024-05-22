//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

#if os(visionOS)
extension FluentTheme {
    static func defaultColor_visionOS(_ token: FluentTheme.ColorToken) -> DynamicColor {
        let visionColorDark: Color

        // Apply overrides as needed. Note that visionOS only supports one mode, so there's no
        // need to provide multiple values (e.g. light + dark, elevated, etc).
        switch token {
        case .foreground1:
            visionColorDark = .white
        case .foreground2:
            visionColorDark = .white
        case .foreground3:
            visionColorDark = .white
        case .foregroundDisabled1:
            visionColorDark = .white.opacity(0.8)
        case .foregroundOnColor:
            visionColorDark = .white
        case .background1:
            visionColorDark = .clear
        case .background1Pressed:
            visionColorDark = .white.opacity(0.1)
        case .background2:
            visionColorDark = .black.opacity(0.1)
        case .background2Pressed:
            visionColorDark = .clear
        case .background3:
            visionColorDark = .black.opacity(0.1)
        case .background4:
            visionColorDark = .clear
        case .background5:
            visionColorDark = .black.opacity(0.2)
        case .background5Pressed:
            visionColorDark = .black.opacity(0.1)
        case .backgroundCanvas:
            visionColorDark = .clear
        case .stroke1:
            visionColorDark = .white.opacity(0.4)
        case .stroke2:
            visionColorDark = .white.opacity(0.5)
        case .dangerForeground2:
            visionColorDark = GlobalTokens.sharedSwiftUIColor(.red, .primary)

        default:
            // Return the standard iOS color by default.
            return defaultColor(token)
        }

        // Otherwise, use the override for `dark` and fall back to the default for `light`.
        return DynamicColor(light: defaultColor(token).light, dark: visionColorDark)
    }
}
#endif
