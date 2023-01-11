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
                return .dynamicColor { DynamicColor(light: GlobalTokens.neutralColors(.white),
                                                    dark: GlobalTokens.neutralColors(.black))
                }
            case .cornerRadius:
                return .float { GlobalTokens.borderRadius(.xLarge) }
            case .shadow:
                return .shadowInfo { theme.aliasTokens.shadow[.shadow28] }
            }
        }
    }
}
