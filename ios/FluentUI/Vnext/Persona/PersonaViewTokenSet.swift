//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public class PersonaViewTokenSet: ListCellTokenSet {
    override func defaultValue(_ token: ListCellTokenSet.Tokens) -> ControlTokenValue {
        switch token {
        case .sublabelColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral1] }

        case .iconInterspace:
            return .float { self.globalTokens.spacing[.small] }

        case .labelAccessoryInterspace:
            return .float { self.globalTokens.spacing[.xxxSmall] }

        case .labelAccessorySize:
            return .float { self.globalTokens.iconSize[.xSmall] }

        case .labelFont:
            return .fontInfo { self.aliasTokens.typography[.body1Strong] }

        case .footnoteFont:
            return .fontInfo { self.aliasTokens.typography[.caption1] }

        default:
            return super.defaultValue(token)
        }
    }
}
