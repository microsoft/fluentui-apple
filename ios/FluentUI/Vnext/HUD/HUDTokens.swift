//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Design token set for the `HeadsUpDisplay` control.
public class HeadsUpDisplayTokenSet: ControlTokenSet<HeadsUpDisplayTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The color of the squared background of the Heads-up display.
        case backgroundColor

        /// The color of the contents presented by the Heads-up display.
        case foregroundColor

        /// The corner radius of the squared background of the Heads-up display.
        case cornerRadius

        /// The distance between the label and image contents from the left and right edges of the squared background of the Heads-up display.
        case horizontalPadding

        /// The distance between the label and image contents from the top and bottom edges of the squared background of the Heads-up display.
        case verticalPadding

        /// The minimum value for the side of the squared background of the Heads-up display.
        case minSize

        /// The maximum value for the side of the squared background of the Heads-up display.
        case maxSize
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .backgroundColor:
            return .dynamicColor {
                DynamicColor(light: ColorValue(r: 0.129, g: 0.129, b: 0.129, a: 0.9),
                             dark: ColorValue(r: 0.188, g: 0.188, b: 0.188, a: 1))
            }

        case .foregroundColor:
            return .dynamicColor {
                DynamicColor(light: self.globalTokens.neutralColors[.white],
                             dark: ColorValue(r: 0.882, g: 0.882, b: 0.882, a: 1),
                             darkHighContrast: self.globalTokens.neutralColors[.white])
            }

        case .cornerRadius:
            return .float {
                return self.globalTokens.borderRadius[.medium]
            }

        case .horizontalPadding:
            return .float {
                return self.globalTokens.spacing[.small]
            }

        case .verticalPadding:
            return .float {
                return self.globalTokens.spacing[.large]
            }

        case .minSize:
            return .float {
                return 100
            }

        case .maxSize:
            return .float {
                return 192
            }
        }
    }
}
