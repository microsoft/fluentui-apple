//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `ResizingHandleView` control.
open class ResizingHandleTokens: ControlTokens {
    /// Defines the color of the mark of the `ResizingHandle`.
    open var markColor: DynamicColor {
        // TODO: Update to aliasTokens.strokeColors[.neutral1] with Fluent 2 colors
        return DynamicColor(light: ColorValue(0x919191) /* gray400 */,
                            lightHighContrast: ColorValue(0x404040) /* gray600 */,
                            dark: ColorValue(0x6E6E6E) /* gray500 */,
                            darkHighContrast: ColorValue(0x919191) /* gray400 */)
    }
}
