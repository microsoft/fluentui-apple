//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `Avatar` control.
public class AvatarTokenSet: ControlTokenSet<AvatarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The size of the content of the `Avatar`.
        case avatarSize

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

        /// The size of the presence icon.
        case presenceIconSize

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
            case .avatarSize:
                return .float({
                    switch size() {
                    case .xsmall:
                        return 16
                    case .small:
                        return 24
                    case .medium:
                        return 32
                    case .large:
                        return 40
                    case .xlarge:
                        return 52
                    case .xxlarge:
                        return 72
                    }
                })

            case .borderRadius:
                return .float({
                    switch style() {
                    case .default, .accent, .outlined, .outlinedPrimary, .overflow:
                        return theme.globalTokens.borderRadius[.none]
                    case .group:
                        switch size() {
                        case .xsmall:
                            return theme.globalTokens.borderRadius[.small]
                        case .small, .medium:
                            return theme.globalTokens.borderRadius[.medium]
                        case .large, .xlarge:
                            return theme.globalTokens.borderRadius[.large]
                        case .xxlarge:
                            return theme.globalTokens.borderRadius[.xLarge]
                        }
                    }
                })

            case .textFont:
                return .fontInfo({
                    switch size() {
                    case .xsmall:
                        return .init(size: 9, weight: theme.globalTokens.fontWeight[.regular])
                    case .small:
                        return theme.aliasTokens.typography[.caption2]
                    case .medium:
                        return theme.aliasTokens.typography[.caption1]
                    case .large:
                        return theme.aliasTokens.typography[.body2]
                    case .xlarge:
                        return .init(size: theme.globalTokens.fontSize[.size500], weight: theme.globalTokens.fontWeight[.regular])
                    case .xxlarge:
                        return .init(size: theme.globalTokens.fontSize[.size700], weight: theme.globalTokens.fontWeight[.semibold])
                    }
                })

            case .ringDefaultColor:
                return .dynamicColor({
                    switch style() {
                    case .default, .group:
                        return theme.globalTokens.brandColors[.tint10]
                    case .accent:
                        return theme.globalTokens.brandColors[.shade10]
                    case .outlined, .overflow:
                        return theme.aliasTokens.backgroundColors[.neutralDisabled]
                    case .outlinedPrimary:
                        return .init(light: theme.globalTokens.brandColors[.tint10].light, dark: theme.globalTokens.neutralColors[.grey78])
                    }
                })

            case .ringGapColor:
                return .dynamicColor({
                    theme.aliasTokens.backgroundColors[.neutral1]
                })

            case .ringThickness:
                return .float({
                    switch size() {
                    case .xsmall, .small:
                        return theme.globalTokens.borderSize[.thin]
                    case .medium, .large, .xlarge:
                        return theme.globalTokens.borderSize[.thick]
                    case .xxlarge:
                        return theme.globalTokens.borderSize[.thicker]
                    }
                })

            case .ringInnerGap:
                return .float({
                    switch size() {
                    case .xsmall, .small, .medium, .large, .xlarge:
                        return theme.globalTokens.borderSize[.thick]
                    case .xxlarge:
                        return theme.globalTokens.borderSize[.thicker]
                    }
                })

            case .ringOuterGap:
                return .float({
                    switch size() {
                    case .xsmall, .small, .medium, .large, .xlarge:
                        return theme.globalTokens.borderSize[.thick]
                    case .xxlarge:
                        return theme.globalTokens.borderSize[.thicker]
                    }
                })

            case .presenceIconSize:
                return .float({
                    switch size() {
                    case .xsmall:
                        return 0
                    case .small, .medium:
                        return theme.globalTokens.iconSize[.xxxSmall]
                    case .large, .xlarge:
                        return theme.globalTokens.iconSize[.xxSmall]
                    case .xxlarge:
                        return theme.globalTokens.iconSize[.small]
                    }
                })

            case .presenceIconOutlineThickness:
                return .float({
                    switch size() {
                    case .xsmall:
                        return theme.globalTokens.borderSize[.none]
                    case .small, .medium, .large, .xlarge, .xxlarge:
                        return theme.globalTokens.borderSize[.thick]
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
                        return .init(light: theme.globalTokens.neutralColors[.white], dark: theme.globalTokens.brandColors[.primary].dark)
                    case .accent:
                        return theme.globalTokens.brandColors[.primary]
                    case .outlined:
                        return .init(light: theme.globalTokens.neutralColors[.grey94], dark: theme.globalTokens.neutralColors[.grey26])
                    case .outlinedPrimary:
                        return .init(light: theme.globalTokens.brandColors[.tint40].light, dark: theme.globalTokens.neutralColors[.grey26])
                    case .overflow:
                        return theme.aliasTokens.backgroundColors[.neutral4]
                    }
                })

            case .foregroundDefaultColor:
                return .dynamicColor({
                    switch style() {
                    case .default, .group:
                        return .init(light: theme.globalTokens.brandColors[.primary].light, dark: theme.globalTokens.neutralColors[.black])
                    case .accent:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .outlined:
                        return .init(light: theme.globalTokens.neutralColors[.grey42], dark: theme.globalTokens.neutralColors[.grey78])
                    case .outlinedPrimary:
                        return .init(light: theme.globalTokens.brandColors[.primary].light, dark: theme.globalTokens.neutralColors[.grey78])
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
    case xsmall
    case small
    case medium
    case large
    case xlarge
    case xxlarge
}
