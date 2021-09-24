//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct AliasTokens {
    enum Background: TokenSet {
        case neutral1
        case neutral2
        case neutral3

        var value: ColorValueSet {
            return ColorValueSet(light: 0xFFFFFF,
                                 dark: 0x000000)
        }
    }

    enum Color: TokenSet {
        case neutralForeground1
        case neutralForeground2

        var value: ColorValueSet {
            switch self {
            case .neutralForeground1:
                return ColorValueSet(light: GlobalTokens.Color.Neutral.grey14.value,
                                     lightHighContrast: GlobalTokens.Color.Neutral.black.value,
                                     dark: GlobalTokens.Color.Neutral.white.value,
                                     darkHighContrast: GlobalTokens.Color.Neutral.white.value,
                                     darkElevated: GlobalTokens.Color.Neutral.white.value)
            case .neutralForeground2:
                return ColorValueSet(light: GlobalTokens.Color.Neutral.grey26.value)
            }
        }
    }
    enum Font: TokenSet {
        case body
        case caption1
        case footnote
        case headline
        case subheadline

        var value: Font {
            switch self {
            case .body:
                return Font.body
            case .caption1:
                return Font.caption1
            case .footnote:
                return Font.footnote
            case .headline:
                return Font.headline
            case .subheadline:
                return Font.subheadline
            }
        }
    }

    enum Shadow: TokenSet {
        case clear
        case opacity12
        case opacity14
        case opacity20
        case opacity24
        case opacity28
        case opacity40
        case opacity48
        case opacity60
        case opaque

        var value: Int {
            switch self {
            case .clear:
                return 0x00
            case .opacity12:
                return 0x1F
            case .opacity14:
                return 0x24
            case .opacity20:
                return 0x33
            case .opacity24:
                return 0x3D
            case .opacity28:
                return 0x47
            case .opacity40:
                return 0x66
            case .opacity48:
                return 0x7A
            case .opacity60:
                return 0x99
            case .opaque:
                return 0xFF
            }
        }
    }
}
