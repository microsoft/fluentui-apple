//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Design token set for the `ActivityIndicator` control.
open class HeadsUpDisplayTokens: ControlTokens {

    /// The color of the squared background of the Heads-up Display.
    open var backgroundColor: DynamicColor { DynamicColor(light: ColorValue(r: 0.129, g: 0.129, b: 0.129, a: 0.9),
                                                          dark: ColorValue(r: 0.188, g: 0.188, b: 0.188, a: 1)) }

    /// The color of the contents presented by the Heads-up Display.
    open var foregroundColor: DynamicColor { DynamicColor(light: ColorValue(0xFFFFFF),
                                                          dark: ColorValue(r: 0.882, g: 0.882, b: 0.882, a: 1),
                                                          darkHighContrast: ColorValue(0xFFFFFF)) }

    /// The corner radius of the squared background of the Heads-up Display.
    open var cornerRadius: CGFloat {
        return globalTokens.borderRadius[.medium]
    }

    /// The distance between the label and image contents from the left and right edges of the squared background of the Heads-up Display.
    open var horizontalPadding: CGFloat {
        return globalTokens.spacing[.small]
    }

    /// The distance between the label and image contents from the top and bottom edges of the squared background of the Heads-up Display.
    open var verticalPadding: CGFloat {
        return globalTokens.spacing[.large]
    }

    /// The minimum value for the side of the squared background of the Heads-up Display.
    open var minSize: CGFloat {
        return 100
    }

    /// The maximum value for the side of the squared background of the Heads-up Display.
    open var maxSize: CGFloat {
        return 192
    }
}
