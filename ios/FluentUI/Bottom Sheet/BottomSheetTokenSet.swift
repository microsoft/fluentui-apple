//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum BottomSheetToken: Int, TokenSetKey {
    /// Defines the background color of the `BottomSheetController`.
    case backgroundColor

    /// Defines the corner radius of the `BottomSheetController`.
    case cornerRadius

    /// Defines the color of the resizing handle of the `BottomSheetController`.
    case resizingHandleMarkColor

    /// Defines the shadows used by the `BottomSheetController`.
    case shadow
}

public class BottomSheetTokenSet: ControlTokenSet<BottomSheetToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { UIColor(light: theme.color(.background2).light,
                                          dark: theme.color(.background2).dark)
                }
            case .cornerRadius:
                return .float { GlobalTokens.corner(.radius120) }
            case .resizingHandleMarkColor:
                return .uiColor { theme.color(.strokeAccessible) }
            case .shadow:
                return .shadowInfo { theme.shadow(.shadow28) }
            }
        }
    }
}
