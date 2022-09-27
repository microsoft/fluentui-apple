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

        /// The color of the activity indicator presented by the Heads-up display.
        case activityIndicatorColor

        /// The color of the label presented by the Heads-up display.
        case labelColor
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    DynamicColor(light: ColorValue(r: 0.129, g: 0.129, b: 0.129, a: 0.9),
                                 dark: ColorValue(r: 0.188, g: 0.188, b: 0.188, a: 1))
                }

            case .foregroundColor:
                return .dynamicColor {
                    DynamicColor(light: GlobalTokens.neutralColors(.white),
                                 dark: ColorValue(r: 0.882, g: 0.882, b: 0.882, a: 1),
                                 darkHighContrast: GlobalTokens.neutralColors(.white))
                }

            case .cornerRadius:
                return .float {
                    return GlobalTokens.borderRadius(.medium)
                }

            case .activityIndicatorColor:
                return .dynamicColor {
                    return theme.aliasTokens.colors[.foreground2]
                }

            case .labelColor:
                return .dynamicColor {
                    return theme.aliasTokens.colors[.foregroundInverted1]
                }
            }
        }
    }

}

// MARK: - Constants

extension HeadsUpDisplayTokenSet {
    static let presentationScaleFactorDefault: CGFloat = 1
    static let opacityPresented: Double = 1.0
    static let opacityDismissed: Double = 0.0

    /// The distance between the label and image contents from the left and right edges of the squared background of the Heads-up display.
    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.small)

    /// The distance between the label and image contents from the top and bottom edges of the squared background of the Heads-up display.
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.large)

    /// The distance between the top of the hud panel and the activity indicator
    static let topPadding: CGFloat = GlobalTokens.spacing(.large)

    /// The distance between the bottom of the hud panel and the label
    static let bottomPadding: CGFloat = GlobalTokens.spacing(.medium)

    /// The minimum value for the side of the squared background of the Heads-up display.
    static let minSize: CGFloat = 100

    /// The maximum value for the side of the squared background of the Heads-up display.
    static let maxSize: CGFloat = 192

}
