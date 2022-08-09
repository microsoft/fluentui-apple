//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `AvatarGroup` control
public class AvatarGroupTokenSet: ControlTokenSet<AvatarGroupTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// CGFloat that defines the space between  the `Avatar` controls hosted by the `AvatarGroup`.
        case interspace
    }

    init(style: @escaping () -> MSFAvatarGroupStyle,
         size: @escaping () -> MSFAvatarSize) {
        self.style = style
        self.size = size
        super.init { [style, size] token, theme in
            return .float {
                switch token {
                case .interspace:
                    switch style() {
                    case .stack:
                        switch size() {
                        case .xsmall, .small:
                            return -theme.globalTokens.spacing[.xxxSmall]
                        case .medium:
                            return -theme.globalTokens.spacing[.xxSmall]
                        case .large:
                            return -theme.globalTokens.spacing[.xSmall]
                        case .xlarge, .xxlarge:
                            return -theme.globalTokens.spacing[.small]
                        }

                    case .pile:
                        switch size() {
                        case .xsmall, .small:
                            return theme.globalTokens.spacing[.xxSmall]
                        case .medium, .large, .xlarge, .xxlarge:
                            return theme.globalTokens.spacing[.xSmall]
                        }
                    }
                }
            }
        }
    }

    /// Defines the style of the `Avatar` controls in the `AvatarGroup`.
    var style: () -> MSFAvatarGroupStyle

    /// Defines the size of the `Avatar` controls in the `AvatarGroup`.
    var size: () -> MSFAvatarSize
}
