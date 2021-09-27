//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct AliasTokens {
    struct Color {
        enum Foreground: TokenSet {
            case neutral1
            case neutral2

            var value: ColorSet {
                switch self {
                case .neutral1:
                    return ColorSet(light: GlobalTokens.Color.Neutral.grey14.value,
                                    lightHighContrast: GlobalTokens.Color.Neutral.black.value,
                                    dark: GlobalTokens.Color.Neutral.white.value,
                                    darkHighContrast: GlobalTokens.Color.Neutral.white.value)
                case .neutral2:
                    return ColorSet(light: GlobalTokens.Color.Neutral.grey26.value,
                                    lightHighContrast: GlobalTokens.Color.Neutral.black.value,
                                    dark: GlobalTokens.Color.Neutral.grey84.value,
                                    darkHighContrast: GlobalTokens.Color.Neutral.white.value)
                }
            }
        }

        enum Background: TokenSet {
            case neutral1
            case neutral2
            case neutral3

            var value: ColorSet {
                switch self {
                case .neutral1:
                    return ColorSet(light: GlobalTokens.Color.Neutral.white.value,
                                    dark: GlobalTokens.Color.Neutral.black.value,
                                    darkElevated: GlobalTokens.Color.Neutral.grey4.value)
                case .neutral2:
                    return ColorSet(light: GlobalTokens.Color.Neutral.grey98.value,
                                    dark: GlobalTokens.Color.Neutral.grey4.value,
                                    darkElevated: GlobalTokens.Color.Neutral.grey8.value)
                case .neutral3:
                    return ColorSet(light: GlobalTokens.Color.Neutral.grey96.value,
                                    dark: GlobalTokens.Color.Neutral.grey8.value,
                                    darkElevated: GlobalTokens.Color.Neutral.grey12.value)
                }
            }
        }

        enum Stroke: TokenSet {
            case neutral1
            case neutral2

            var value: ColorSet {
                switch self {
                case .neutral1:
                    return ColorSet(light: GlobalTokens.Color.Neutral.grey94.value,
                                    lightHighContrast: GlobalTokens.Color.Neutral.grey38.value,
                                    dark: GlobalTokens.Color.Neutral.grey24.value,
                                    darkHighContrast: GlobalTokens.Color.Neutral.grey68.value,
                                    darkElevated: GlobalTokens.Color.Neutral.grey32.value)
                case .neutral2:
                    return ColorSet(light: GlobalTokens.Color.Neutral.grey88.value,
                                    lightHighContrast: GlobalTokens.Color.Neutral.grey38.value,
                                    dark: GlobalTokens.Color.Neutral.grey32.value,
                                    darkHighContrast: GlobalTokens.Color.Neutral.grey68.value,
                                    darkElevated: GlobalTokens.Color.Neutral.grey36.value)
                }
            }
        }
    }
}
