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
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        return .float({
            switch token {
            case .interspace:
                switch self.style() {
                case .stack:
                    switch self.size() {
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
                    switch self.size() {
                    case .xsmall, .small:
                        return self.globalTokens.spacing[.xxSmall]
                    case .medium, .large, .xlarge, .xxlarge:
                        return self.globalTokens.spacing[.xSmall]
                    }
                }
            }
        })
    }

    /// Defines the style of the `Avatar` controls in the `AvatarGroup`.
    var style: () -> MSFAvatarGroupStyle

    /// Defines the size of the `Avatar` controls in the `AvatarGroup`.
    var size: () -> MSFAvatarSize
}
