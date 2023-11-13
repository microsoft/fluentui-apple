//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public enum AvatarToken: Int, TokenSetKey {
    /// The radius of the corners of the `Avatar`.
    case borderRadius

    /// The font used for text in the `Avatar`
    case textFont

    /// The default color of the ring around the `Avatar`.
    case ringDefaultColor

    /// The color of the gap between the ring and `Avatar`.
    case ringGapColor

    /// The thickness of the ring around the `Avatar`.
    case ringThickness

    /// The gap between the `Avatar` and its ring.
    case ringInnerGap

    /// The gap around the ring around the `Avatar`.
    case ringOuterGap

    /// The thickness of the outline around the presence/activity.
    case borderThickness

    /// The color of the border around the presence/activity.
    case borderColor

    /// The foreground color of the activity.
    case activityForegroundColor

    /// The background color of the activity.
    case activityBackgroundColor

    /// The default color of the background of the `Avatar`.
    case backgroundDefaultColor

    /// The default color of the foreground of the `Avatar`
    case foregroundDefaultColor
}

/// Design token set for the `Avatar` control.
public class AvatarTokenSet: ControlTokenSet<AvatarToken> {
    init(style: @escaping () -> MSFAvatarStyle,
         size: @escaping () -> MSFAvatarSize) {
        self.style = style
        self.size = size
        super.init { [style, size] token, theme in
            switch token {
            case .borderRadius:
                return .float({
                    switch style() {
                    case .default, .accent, .outlined, .outlinedPrimary, .overflow:
                        return GlobalTokens.corner(.radiusNone)
                    case .group:
                        switch size() {
                        case .size16, .size20:
                            return GlobalTokens.corner(.radius20)
                        case .size24, .size32:
                            return GlobalTokens.corner(.radius40)
                        case .size40, .size56:
                            return GlobalTokens.corner(.radius80)
                        case .size72:
                            return GlobalTokens.corner(.radius120)
                        }
                    }
                })

            case .textFont:
                return .uiFont({
                    switch size() {
                    case .size16, .size20:
                        return .systemFont(ofSize: 9, weight: .regular)
                    case .size24:
                        return theme.typography(.caption2, adjustsForContentSizeCategory: false)
                    case .size32:
                        return theme.typography(.caption1, adjustsForContentSizeCategory: false)
                    case .size40:
                        return theme.typography(.body2, adjustsForContentSizeCategory: false)
                    case .size56:
                        return .systemFont(ofSize: GlobalTokens.fontSize(.size500), weight: .regular)
                    case .size72:
                        return .systemFont(ofSize: GlobalTokens.fontSize(.size700), weight: .semibold)
                    }
                })

            case .ringDefaultColor:
                return .uiColor({
                    switch style() {
                    case .default, .group, .accent, .outlinedPrimary:
                        return theme.color(.brandStroke1)
                    case .outlined, .overflow:
                        return theme.color(.strokeAccessible)
                    }
                })

            case .ringGapColor:
                return .uiColor({
                    theme.color(.background1)
                })

            case .ringThickness:
                return .float({
                    switch size() {
                    case .size16, .size20, .size24:
                        return GlobalTokens.stroke(.width10)
                    case .size32, .size40, .size56:
                        return GlobalTokens.stroke(.width20)
                    case .size72:
                        return GlobalTokens.stroke(.width40)
                    }
                })

            case .ringInnerGap:
                return .float({
                    switch size() {
                    case .size16, .size20, .size24, .size32, .size40, .size56:
                        return GlobalTokens.stroke(.width20)
                    case .size72:
                        return GlobalTokens.stroke(.width40)
                    }
                })

            case .ringOuterGap:
                return .float({
                    switch size() {
                    case .size16, .size20, .size24, .size32, .size40, .size56:
                        return GlobalTokens.stroke(.width20)
                    case .size72:
                        return GlobalTokens.stroke(.width40)
                    }
                })

            case .borderThickness:
                return .float({
                    switch size() {
                    case .size16:
                        return GlobalTokens.stroke(.widthNone)
                    case .size20, .size24, .size32, .size40, .size56, .size72:
                        return GlobalTokens.stroke(.width20)
                    }
                })

            case .borderColor:
                return .uiColor({
                    theme.color(.background1)
                })

            case .activityForegroundColor:
                return .uiColor({
                    theme.color(.foreground1)
                })

            case .activityBackgroundColor:
                return .uiColor({
                    theme.color(.background5)
                })

            case .backgroundDefaultColor:
                return .uiColor({
                    switch style() {
                    case .default, .group:
                        return theme.color(.background1)
                    case .accent:
                        return theme.color(.brandBackground1)
                    case .outlined, .overflow:
                        return theme.color(.background5)
                    case .outlinedPrimary:
                        return theme.color(.brandBackgroundTint)
                    }
                })

            case .foregroundDefaultColor:
                return .uiColor({
                    switch style() {
                    case .default, .group:
                        return theme.color(.brandForeground1)
                    case .accent:
                        return theme.color(.foregroundOnColor)
                    case .outlined, .overflow:
                        return theme.color(.foreground2)
                    case .outlinedPrimary:
                        return theme.color(.brandForegroundTint)
                    }
                })
            }
        }
    }

    /// Defines the style of the `Avatar`.
    var style: () -> MSFAvatarStyle

    /// Defines the size of the `Avatar`.
    var size: () -> MSFAvatarSize

}

// MARK: - Constants

extension AvatarTokenSet {
    /// The size of the content of the `Avatar`.
    static func avatarSize(_ size: MSFAvatarSize) -> CGFloat {
        switch size {
        case .size16:
            return 16
        case .size20:
            return 20
        case .size24:
            return 24
        case .size32:
            return 32
        case .size40:
            return 40
        case .size56:
            return 56
        case .size72:
            return 72
        }
    }

    /// The size of the presence icon.
    static func presenceIconSize(_ size: MSFAvatarSize) -> CGFloat {
        switch size {
        case .size16:
            return 0
        case .size20, .size24, .size32:
            return GlobalTokens.icon(.size100)
        case .size40, .size56:
            return GlobalTokens.icon(.size120)
        case .size72:
            return GlobalTokens.icon(.size200)
        }
    }

    /// The border radius for the activity icon in the MSFAvatarActivityStyle `.square` style.
    static func activityIconRadius(_ size: MSFAvatarSize) -> CGFloat {
        switch size {
        case .size16, .size20, .size24, .size32, .size72:
            return 0
        case .size40, .size56:
            return GlobalTokens.corner(.radius40)
        }
    }

    /// The size of the activity icon.
    static func activityIconSize(_ size: MSFAvatarSize) -> CGFloat {
        switch size {
        case .size16, .size20, .size24, .size32, .size72:
            return 0
        case .size40:
            return GlobalTokens.icon(.size160)
        case .size56:
            return GlobalTokens.icon(.size240)
        }
    }

    /// The size of the activity icon background.
    static func activityIconBackgroundSize(_ size: MSFAvatarSize) -> CGFloat {
        switch size {
        case .size16, .size20, .size24, .size32, .size72:
            return 0
        case .size40:
            return GlobalTokens.icon(.size200)
        case .size56:
            return GlobalTokens.icon(.size280)
        }
    }
}

/// Pre-defined styles of the avatar.
@objc public enum MSFAvatarStyle: Int, CaseIterable {
    case `default`
    case accent
    case group
    case outlined
    case outlinedPrimary
    case overflow
}

/// Pre-defined sizes of the avatar.
@objc public enum MSFAvatarSize: Int, CaseIterable {
    case size16
    case size20
    case size24
    case size32
    case size40
    case size56
    case size72
}

/// Types of Avatar Activity styles.
@objc public enum MSFAvatarActivityStyle: Int, CaseIterable {
    case none
    case circle
    case square
}
