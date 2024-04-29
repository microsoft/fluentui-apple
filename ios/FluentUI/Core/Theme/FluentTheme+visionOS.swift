//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

#if os(visionOS)
extension FluentTheme {
    static func defaultColor_visionOS(_ token: FluentTheme.ColorToken) -> UIColor {
        let visionColor: UIColor

        // Apply overrides as needed. Note that visionOS only supports one mode, so there's no
        // need to provide multiple values (e.g. light + dark, elevated, etc).
        switch token {
        case .foreground1:
            visionColor = .white
        case .foreground2:
            visionColor = .white
        case .foreground3:
            visionColor = .white
        case .foregroundDisabled1:
            visionColor = .white.withAlphaComponent(0.8)
        case .foregroundOnColor:
            visionColor = .white
        case .background1:
            visionColor = .clear
        case .background1Pressed:
            visionColor = .white.withAlphaComponent(0.1)
        case .background2:
            visionColor = .black.withAlphaComponent(0.1)
        case .background2Pressed:
            visionColor = .clear
        case .background3:
            visionColor = .black.withAlphaComponent(0.1)
        case .background4:
            visionColor = .clear
        case .background5:
            visionColor = .black.withAlphaComponent(0.2)
        case .background5Pressed:
            visionColor = .black.withAlphaComponent(0.1)
        case .backgroundCanvas:
            visionColor = .clear
        case .stroke1:
            visionColor = .white.withAlphaComponent(0.4)
        case .stroke2:
            visionColor = .white.withAlphaComponent(0.5)
        case .dangerForeground2:
            visionColor = GlobalTokens.sharedColor(.red, .primary)

        default:
            // Return the standard iOS color by default.
            visionColor = defaultColor(token)
        }

        return UIColor(light: defaultColor(token).light, dark: visionColor.dark)
    }
}
#endif
