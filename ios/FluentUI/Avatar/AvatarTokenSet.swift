//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `Avatar` control.
open class AvatarTokenSet: ControlTokenSet<AvatarTokenSet.Tokens> {
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

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .avatarSize:
            return .float({
                switch self.size {
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
                switch self.style {
                case .default, .accent, .outlined, .outlinedPrimary, .overflow:
                    return self.globalTokens.borderRadius[.none]
                case .group:
                    switch self.size {
                    case .xsmall:
                        return self.globalTokens.borderRadius[.small]
                    case .small, .medium:
                        return self.globalTokens.borderRadius[.medium]
                    case .large, .xlarge:
                        return self.globalTokens.borderRadius[.large]
                    case .xxlarge:
                        return self.globalTokens.borderRadius[.xLarge]
                    }
                }
            })

        case .textFont:
            return .fontInfo({
                switch self.size {
                case .xsmall:
                    return .init(size: 9, weight: self.globalTokens.fontWeight[.regular])
                case .small:
                    return self.aliasTokens.typography[.caption2]
                case .medium:
                    return self.aliasTokens.typography[.caption1]
                case .large:
                    return self.aliasTokens.typography[.body2]
                case .xlarge:
                    return .init(size: self.globalTokens.fontSize[.size500], weight: self.globalTokens.fontWeight[.regular])
                case .xxlarge:
                    return .init(size: self.globalTokens.fontSize[.size700], weight: self.globalTokens.fontWeight[.semibold])
                }
            })

        case .ringDefaultColor:
            return .dynamicColor({
                switch self.style {
                case .default, .group:
                    return self.globalTokens.brandColors[.tint10]
                case .accent:
                    return self.globalTokens.brandColors[.shade10]
                case .outlined, .overflow:
                    return self.aliasTokens.backgroundColors[.neutralDisabled]
                case .outlinedPrimary:
                    return .init(light: self.globalTokens.brandColors[.tint10].light, dark: self.globalTokens.neutralColors[.grey78])
                }
            })

        case .ringGapColor:
            return .dynamicColor({
                self.aliasTokens.backgroundColors[.neutral1]
            })

        case .ringThickness:
            return .float({
                switch self.size {
                case .xsmall, .small:
                    return self.globalTokens.borderSize[.thin]
                case .medium, .large, .xlarge:
                    return self.globalTokens.borderSize[.thick]
                case .xxlarge:
                    return self.globalTokens.borderSize[.thicker]
                }
            })

        case .ringInnerGap:
            return .float({
                switch self.size {
                case .xsmall, .small, .medium, .large, .xlarge:
                    return self.globalTokens.borderSize[.thick]
                case .xxlarge:
                    return self.globalTokens.borderSize[.thicker]
                }
            })

        case .ringOuterGap:
            return .float({
                switch self.size {
                case .xsmall, .small, .medium, .large, .xlarge:
                    return self.globalTokens.borderSize[.thick]
                case .xxlarge:
                    return self.globalTokens.borderSize[.thicker]
                }
            })

        case .presenceIconSize:
            return .float({
                switch self.size {
                case .xsmall:
                    return 0
                case .small, .medium:
                    return self.globalTokens.iconSize[.xxxSmall]
                case .large, .xlarge:
                    return self.globalTokens.iconSize[.xxSmall]
                case .xxlarge:
                    return self.globalTokens.iconSize[.small]
                }
            })

        case .presenceIconOutlineThickness:
            return .float({
                switch self.size {
                case .xsmall:
                    return self.globalTokens.borderSize[.none]
                case .small, .medium, .large, .xlarge, .xxlarge:
                    return self.globalTokens.borderSize[.thick]
                }
            })

        case .presenceOutlineColor:
            return .dynamicColor({
                self.aliasTokens.backgroundColors[.neutral1]
            })

        case .backgroundDefaultColor:
            return .dynamicColor({
                switch self.style {
                case .default, .group:
                    return .init(light: self.globalTokens.neutralColors[.white], dark: self.globalTokens.brandColors[.primary].dark)
                case .accent:
                    return self.globalTokens.brandColors[.primary]
                case .outlined:
                    return .init(light: self.globalTokens.neutralColors[.grey94], dark: self.globalTokens.neutralColors[.grey26])
                case .outlinedPrimary:
                    return .init(light: self.globalTokens.brandColors[.tint40].light, dark: self.globalTokens.neutralColors[.grey26])
                case .overflow:
                    return self.aliasTokens.backgroundColors[.neutral4]
                }
            })

        case .foregroundDefaultColor:
            return .dynamicColor({
                switch self.style {
                case .default, .group:
                    return .init(light: self.globalTokens.brandColors[.primary].light, dark: self.globalTokens.neutralColors[.black])
                case .accent:
                    return self.aliasTokens.foregroundColors[.neutralInverted]
                case .outlined:
                    return .init(light: self.globalTokens.neutralColors[.grey42], dark: self.globalTokens.neutralColors[.grey78])
                case .outlinedPrimary:
                    return .init(light: self.globalTokens.brandColors[.primary].light, dark: self.globalTokens.neutralColors[.grey78])
                case .overflow:
                    return self.aliasTokens.foregroundColors[.neutral3]
                }
            })
        }
    }

    /// Defines the style of the `Avatar`.
    public internal(set) var style: MSFAvatarStyle = .default

    /// Defines the size of the `Avatar`.
    public internal(set) var size: MSFAvatarSize = .large
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
