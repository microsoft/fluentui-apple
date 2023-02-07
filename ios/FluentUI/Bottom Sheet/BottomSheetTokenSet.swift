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
                return .dynamicColor { theme.aliasTokens.colors[.background2]
                }
            case .cornerRadius:
                return .float { GlobalTokens.corner(.radius120) }
            case .shadow:
                return .shadowInfo { theme.aliasTokens.shadow[.shadow28] }
            }
        }
    }
}
