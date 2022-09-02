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
                        case .xsmall, .small:
                            return -GlobalTokens.spacing(.xxxSmall)
                        case .medium:
                            return -GlobalTokens.spacing(.xxSmall)
                        case .large:
                            return -GlobalTokens.spacing(.xSmall)
                        case .xlarge, .xxlarge:
                            return -GlobalTokens.spacing(.small)
                        }

                    case .pile:
                        switch size() {
                        case .xsmall, .small:
                            return GlobalTokens.spacing(.xxSmall)
                        case .medium, .large, .xlarge, .xxlarge:
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
