//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class BottomSheetTokenSet: ControlTokenSet<BottomSheetTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case backgroundColor
        case cornerRadius
        case shadow
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { DynamicColor(light: theme.color(.background2).light,
                                                    dark: theme.color(.background2).dark)
                }
            case .cornerRadius:
                return .float { GlobalTokens.corner(.radius120) }
            case .shadow:
                return .shadowInfo { theme.shadow(.shadow28) }
            }
        }
    }
}
