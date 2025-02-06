//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public enum AvatarGroupToken: Int, TokenSetKey {
    /// Defines the color around the unread dot.
    case backgroundColor

    /// CGFloat that defines the space between  the `Avatar` controls hosted by the `AvatarGroup`.
    case interspace

    /// Defines the color of the unread dot.
    case unreadDotColor
}

/// Design token set for the `AvatarGroup` control
public class AvatarGroupTokenSet: ControlTokenSet<AvatarGroupToken> {
    init(style: @escaping () -> MSFAvatarGroupStyle,
         size: @escaping () -> MSFAvatarSize) {
        self.style = style
        self.size = size
        super.init { [style, size] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background1) }
            case .interspace:
                return .float {
                    switch style() {
                    case .stack:
                        switch size() {
                        case .size16, .size20, .size24:
                            return -GlobalTokens.spacing(.size20)
                        case .size32:
                            return -GlobalTokens.spacing(.size40)
                        case .size40:
                            return -GlobalTokens.spacing(.size80)
                        case .size56, .size72:
                            return -GlobalTokens.spacing(.size120)
                        }

                    case .pile:
                        switch size() {
                        case .size16, .size20, .size24:
                            return GlobalTokens.spacing(.size40)
                        case .size32, .size40, .size56, .size72:
                            return GlobalTokens.spacing(.size80)
                        }
                    }
                }
            case .unreadDotColor:
                return .uiColor { theme.color(.brandForeground1) }
            }
        }
    }

    /// Defines the style of the `Avatar` controls in the `AvatarGroup`.
    var style: () -> MSFAvatarGroupStyle

    /// Defines the size of the `Avatar` controls in the `AvatarGroup`.
    var size: () -> MSFAvatarSize
}

extension AvatarGroupTokenSet {
    /// Size of the background behind the unread dot.
    static let unreadDotStrokeWidth: CGFloat = GlobalTokens.stroke(.width20)

    /// Size of the unread dot.
    static let unreadDotSize: CGFloat = 8.0

    /// Vertical offset of the unread dot.
    static let unreadDotVerticalOffset: CGFloat = -3.0

    /// Horizontal offset of the unread dot.
    static let unreadDotHorizontalOffset: CGFloat = 7.0
}
