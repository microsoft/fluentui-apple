//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Design token set for the `ActivityIndicator` control.
open class HeadsUpDisplayTokens: ControlTokens {

    /// The color of the squared background of the Heads-up display.
    open var backgroundColor: DynamicColor { DynamicColor(light: ColorValue(r: 0.129, g: 0.129, b: 0.129, a: 0.9),
                                                          dark: ColorValue(r: 0.188, g: 0.188, b: 0.188, a: 1)) }

    /// The color of the contents presented by the Heads-up display.
    open var foregroundColor: DynamicColor { DynamicColor(light: GlobalTokens.neutralColors(.white),
                                                          dark: ColorValue(r: 0.882, g: 0.882, b: 0.882, a: 1),
                                                          darkHighContrast: GlobalTokens.neutralColors(.white)) }

    /// The corner radius of the squared background of the Heads-up display.
    open var cornerRadius: CGFloat {
        return GlobalTokens.borderRadius(.medium)
    }

    /// The distance between the label and image contents from the left and right edges of the squared background of the Heads-up display.
    open var horizontalPadding: CGFloat {
        return GlobalTokens.spacing(.small)
    }

    /// The distance between the label and image contents from the top and bottom edges of the squared background of the Heads-up display.
    open var verticalPadding: CGFloat {
        return GlobalTokens.spacing(.large)
    }

    /// The minimum value for the side of the squared background of the Heads-up display.
    open var minSize: CGFloat {
        return 100
    }

    /// The maximum value for the side of the squared background of the Heads-up display.
    open var maxSize: CGFloat {
        return 192
    }
}
