//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

#if os(visionOS)
extension FluentTheme {
    static func defaultColor_visionOS(_ token: FluentTheme.ColorToken) -> UIColor {
        // Apply overrides as needed. Note that visionOS only supports one mode, so there's no
        // need to provide multiple values (e.g. light + dark, elevated, etc).
        switch token {
        case .foreground1:
            return .white
        case .foreground2:
            return .white
        case .foreground3:
            return .white
        case .foregroundDisabled1:
            return .white.withAlphaComponent(0.8)
        case .foregroundOnColor:
            return .white
        case .background1:
            return .clear
        case .background1Pressed:
            return .white.withAlphaComponent(0.1)
        case .background2:
            return .black.withAlphaComponent(0.1)
        case .background2Pressed:
            return .clear
        case .background3:
            return .black.withAlphaComponent(0.1)
        case .background4:
            return .clear
        case .background5:
            return .black.withAlphaComponent(0.2)
        case .background5Pressed:
            return .black.withAlphaComponent(0.1)
        case .backgroundCanvas:
            return .clear
        case .stroke1:
            return .white.withAlphaComponent(0.4)
        case .stroke2:
            return .white.withAlphaComponent(0.5)
        case .dangerForeground2:
            return GlobalTokens.sharedColor(.red, .primary)

        default:
            // Return the standard iOS color by default.
            return defaultColor(token)
        }
    }
}
#endif
