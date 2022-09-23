//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `ResizingHandleView` control.
public class ResizingHandleTokenSet: ControlTokenSet<ResizingHandleTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the color of the mark of the `ResizingHandle`.
        case markColor

        /// Defines the background color of the `ResizingHandle`.
        case backgroundColor
    }

    init() {
        super.init { token, _ in
            switch token {
            case .markColor:
                return .dynamicColor {
                    return DynamicColor(light: ColorValue(0x919191) /* gray400 */,
                                        lightHighContrast: ColorValue(0x404040) /* gray600 */,
                                        dark: ColorValue(0x6E6E6E) /* gray500 */,
                                        darkHighContrast: ColorValue(0x919191) /* gray400 */)
                }

            case .backgroundColor:
                return .dynamicColor {
                    DynamicColor(light: ColorValue.clear)
                }
            }
        }
    }
}
