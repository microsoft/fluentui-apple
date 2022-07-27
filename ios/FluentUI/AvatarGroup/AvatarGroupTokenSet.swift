//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `AvatarGroup` control
open class AvatarGroupTokenSet: ControlTokenSet<AvatarGroupTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// CGFloat that defines the space between  the `Avatar` controls hosted by the `AvatarGroup`.
        case interspace
    }

    /// Defines the style of the `Avatar` controls in the `AvatarGroup`.
    public internal(set) var style: MSFAvatarGroupStyle = .stack

    /// Defines the size of the `Avatar` controls in the `AvatarGroup`.
    public internal(set) var size: MSFAvatarSize = .large

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        return .float({
            switch token {
            case .interspace:
                switch self.style {
                case .stack:
                    switch self.size {
                    case .xsmall, .small:
                        return -self.globalTokens.spacing[.xxxSmall]
                    case .medium:
                        return -self.globalTokens.spacing[.xxSmall]
                    case .large:
                        return -self.globalTokens.spacing[.xSmall]
                    case .xlarge, .xxlarge:
                        return -self.globalTokens.spacing[.small]
                    }

                case .pile:
                    switch self.size {
                    case .xsmall, .small:
                        return self.globalTokens.spacing[.xxSmall]
                    case .medium, .large, .xlarge, .xxlarge:
                        return self.globalTokens.spacing[.xSmall]
                    }
                }
            }
        })
    }
}
