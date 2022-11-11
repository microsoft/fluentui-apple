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
        super.init { [style, size] token, _ in
            return .float {
                switch token {
                case .interspace:
                    switch style() {
                    case .stack:
                        switch size() {
                        case .size16, .size20, .size24:
                            return -GlobalTokens.spacing(.xxxSmall)
                        case .size32:
                            return -GlobalTokens.spacing(.xxSmall)
                        case .size40:
                            return -GlobalTokens.spacing(.xSmall)
                        case .size56, .size72:
                            return -GlobalTokens.spacing(.small)
                        }

                    case .pile:
                        switch size() {
                        case .size16, .size20, .size24:
                            return GlobalTokens.spacing(.xxSmall)
                        case .size32, .size40, .size56, .size72:
                            return GlobalTokens.spacing(.xSmall)
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
