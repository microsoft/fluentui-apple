//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `Avatar` control.
public class AvatarTokenSet: ControlTokenSet<AvatarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
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

        /// The thickness of the outline around the presence icon.
        case presenceIconOutlineThickness

        /// The color of the outline around the presence.
        case presenceOutlineColor

        /// The default color of the background of the `Avatar`.
        case backgroundDefaultColor

        /// The default color of the foreground of the `Avatar`
        case foregroundDefaultColor
    }

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
                        return GlobalTokens.borderRadius(.none)
                    case .group:
                        switch size() {
                        case .size16, .size20:
                            return GlobalTokens.borderRadius(.small)
                        case .size24, .size32:
                            return GlobalTokens.borderRadius(.medium)
                        case .size40, .size56:
                            return GlobalTokens.borderRadius(.large)
                        case .size72:
                            return GlobalTokens.borderRadius(.xLarge)
                        }
                    }
                })

            case .textFont:
                return .fontInfo({
                    switch size() {
                    case .size16, .size20:
                        return .init(size: 9, weight: GlobalTokens.fontWeight(.regular))
                    case .size24:
                        return theme.aliasTokens.typography[.caption2]
                    case .size32:
                        return theme.aliasTokens.typography[.caption1]
                    case .size40:
                        return theme.aliasTokens.typography[.body2]
                    case .size56:
                        return .init(size: GlobalTokens.fontSize(.size500), weight: GlobalTokens.fontWeight(.regular))
                    case .size72:
                        return .init(size: GlobalTokens.fontSize(.size700), weight: GlobalTokens.fontWeight(.semibold))
                    }
                })

            case .ringDefaultColor:
                return .dynamicColor({
                    switch style() {
                    case .default, .group:
                        return theme.aliasTokens.brandColors[.tint10]
                    case .accent:
                        return theme.aliasTokens.brandColors[.shade10]
                    case .outlined, .overflow:
                        return theme.aliasTokens.backgroundColors[.neutralDisabled]
                    case .outlinedPrimary:
                        return .init(light: theme.aliasTokens.brandColors[.tint10].light, dark: GlobalTokens.neutralColors(.grey78))
                    }
                })

            case .ringGapColor:
                return .dynamicColor({
                    theme.aliasTokens.backgroundColors[.neutral1]
                })

            case .ringThickness:
                return .float({
                    switch size() {
                    case .size16, .size20, .size24:
                        return GlobalTokens.borderSize(.thin)
                    case .size32, .size40, .size56:
                        return GlobalTokens.borderSize(.thick)
                    case .size72:
                        return GlobalTokens.borderSize(.thicker)
                    }
                })

            case .ringInnerGap:
                return .float({
                    switch size() {
                    case .size16, .size20, .size24, .size32, .size40, .size56:
                        return GlobalTokens.borderSize(.thick)
                    case .size72:
                        return GlobalTokens.borderSize(.thicker)
                    }
                })

            case .ringOuterGap:
                return .float({
                    switch size() {
                    case .size16, .size20, .size24, .size32, .size40, .size56:
                        return GlobalTokens.borderSize(.thick)
                    case .size72:
                        return GlobalTokens.borderSize(.thicker)
                    }
                })

            case .presenceIconOutlineThickness:
                return .float({
                    switch size() {
                    case .size16:
                        return GlobalTokens.borderSize(.none)
                    case .size20, .size24, .size32, .size40, .size56, .size72:
                        return GlobalTokens.borderSize(.thick)
                    }
                })

            case .presenceOutlineColor:
                return .dynamicColor({
                    theme.aliasTokens.backgroundColors[.neutral1]
                })

            case .backgroundDefaultColor:
                return .dynamicColor({
                    switch style() {
                    case .default, .group:
                        return .init(light: GlobalTokens.neutralColors(.white), dark: theme.aliasTokens.brandColors[.primary].dark)
                    case .accent:
                        return theme.aliasTokens.brandColors[.primary]
                    case .outlined:
                        return .init(light: GlobalTokens.neutralColors(.grey94), dark: GlobalTokens.neutralColors(.grey26))
                    case .outlinedPrimary:
                        return .init(light: theme.aliasTokens.brandColors[.tint40].light, dark: GlobalTokens.neutralColors(.grey26))
                    case .overflow:
                        return theme.aliasTokens.backgroundColors[.neutral4]
                    }
                })

            case .foregroundDefaultColor:
                return .dynamicColor({
                    switch style() {
                    case .default, .group:
                        return .init(light: theme.aliasTokens.brandColors[.primary].light, dark: GlobalTokens.neutralColors(.black))
                    case .accent:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .outlined:
                        return .init(light: GlobalTokens.neutralColors(.grey42), dark: GlobalTokens.neutralColors(.grey78))
                    case .outlinedPrimary:
                        return .init(light: theme.aliasTokens.brandColors[.primary].light, dark: GlobalTokens.neutralColors(.grey78))
                    case .overflow:
                        return theme.aliasTokens.foregroundColors[.neutral3]
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
            return GlobalTokens.iconSize(.xxxSmall)
        case .size40, .size56:
            return GlobalTokens.iconSize(.xxSmall)
        case .size72:
            return GlobalTokens.iconSize(.small)
        }
    }
}

/// Pre-defined styles of the avatar
@objc public enum MSFAvatarStyle: Int, CaseIterable {
    case `default`
    case accent
    case group
    case outlined
    case outlinedPrimary
    case overflow
}

/// Pre-defined sizes of the avatar
@objc public enum MSFAvatarSize: Int, CaseIterable {
    case size16
    case size20
    case size24
    case size32
    case size40
    case size56
    case size72
}
