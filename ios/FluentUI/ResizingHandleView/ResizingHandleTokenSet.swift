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
        super.init { token, theme in
            switch token {
            case .markColor:
                return .uiColor {
                    return UIColor(dynamicColor: theme.aliasTokens.colors[.strokeAccessible])
                }

            case .backgroundColor:
                return .uiColor {
                    return .clear
                }
            }
        }
    }
}

extension ResizingHandleTokenSet {
    static let markSize = CGSize(width: 36, height: 4)
    static let markCornerRadius: CGFloat = 2
}
