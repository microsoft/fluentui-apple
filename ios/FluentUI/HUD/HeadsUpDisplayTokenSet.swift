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
                return .uiColor {
                    return theme.color(.backgroundDarkStatic)
                }

            case .cornerRadius:
                return .float {
                    return GlobalTokens.corner(.radius40)
                }

            case .activityIndicatorColor:
                return .uiColor {
                    return UIColor(light: GlobalTokens.neutralColor(.grey56),
                                   dark: GlobalTokens.neutralColor(.grey72))
                }

            case .labelColor:
                return .uiColor {
                    return theme.color(.foregroundLightStatic)
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
    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.size120)

    /// The distance between the label and image contents from the top and bottom edges of the squared background of the Heads-up display.
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.size200)

    /// The distance between the top of the hud panel and the activity indicator
    static let topPadding: CGFloat = GlobalTokens.spacing(.size200)

    /// The distance between the bottom of the hud panel and the label
    static let bottomPadding: CGFloat = GlobalTokens.spacing(.size160)

    /// The minimum value for the side of the squared background of the Heads-up display.
    static let minSize: CGFloat = 100

    /// The maximum value for the side of the squared background of the Heads-up display.
    static let maxSize: CGFloat = 192

}
