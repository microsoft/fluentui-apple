//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct AliasTokens {
    struct Colors {
        enum Foreground: TokenSet {
            case neutral1
            case neutral2
            case neutral3

            var value: ColorSet {
                switch self {
                case .neutral1:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey14.value,
                                    lightHighContrast: GlobalTokens.Colors.Neutral.black.value,
                                    dark: GlobalTokens.Colors.Neutral.white.value,
                                    darkHighContrast: GlobalTokens.Colors.Neutral.white.value)
                case .neutral2:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey26.value,
                                    lightHighContrast: GlobalTokens.Colors.Neutral.black.value,
                                    dark: GlobalTokens.Colors.Neutral.grey84.value,
                                    darkHighContrast: GlobalTokens.Colors.Neutral.white.value)
                case .neutral3:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey38.value,
                                    lightHighContrast: GlobalTokens.Colors.Neutral.grey14.value,
                                    dark: GlobalTokens.Colors.Neutral.grey68.value,
                                    darkHighContrast: GlobalTokens.Colors.Neutral.grey84.value)
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
                    return ColorSet(light: GlobalTokens.Colors.Neutral.white.value,
                                    dark: GlobalTokens.Colors.Neutral.black.value,
                                    darkElevated: GlobalTokens.Colors.Neutral.grey4.value)
                case .neutral2:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey98.value,
                                    dark: GlobalTokens.Colors.Neutral.grey4.value,
                                    darkElevated: GlobalTokens.Colors.Neutral.grey8.value)
                case .neutral3:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey96.value,
                                    dark: GlobalTokens.Colors.Neutral.grey8.value,
                                    darkElevated: GlobalTokens.Colors.Neutral.grey12.value)
                }
            }
        }

        enum Stroke: TokenSet {
            case neutral1
            case neutral2

            var value: ColorSet {
                switch self {
                case .neutral1:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey94.value,
                                    lightHighContrast: GlobalTokens.Colors.Neutral.grey38.value,
                                    dark: GlobalTokens.Colors.Neutral.grey24.value,
                                    darkHighContrast: GlobalTokens.Colors.Neutral.grey68.value,
                                    darkElevated: GlobalTokens.Colors.Neutral.grey32.value)
                case .neutral2:
                    return ColorSet(light: GlobalTokens.Colors.Neutral.grey88.value,
                                    lightHighContrast: GlobalTokens.Colors.Neutral.grey38.value,
                                    dark: GlobalTokens.Colors.Neutral.grey32.value,
                                    darkHighContrast: GlobalTokens.Colors.Neutral.grey68.value,
                                    darkElevated: GlobalTokens.Colors.Neutral.grey36.value)
                }
            }
        }
    }
}
