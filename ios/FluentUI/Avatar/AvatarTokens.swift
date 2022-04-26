//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `Avatar` control.
open class AvatarTokens: ControlTokens {
    // MARK: - Design Tokens

    /// The size of the content of the `Avatar`.
    open var avatarSize: CGFloat {
        switch size {
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
    }

    /// The radius of the corners of the `Avatar`.
    open var borderRadius: CGFloat {
        switch style {
        case .default, .accent, .outlined, .outlinedPrimary, .overflow:
            return globalTokens.spacing[.none]
        case .group:
            switch size {
            case .xsmall:
                return globalTokens.borderRadius[.small]
            case .small, .medium:
                return globalTokens.borderRadius[.medium]
            case .large, .xlarge:
                return globalTokens.borderRadius[.large]
            case .xxlarge:
                return globalTokens.borderRadius[.xLarge]
            }
        }
    }

    /// The font used for text in the `Avatar`
    open var textFont: FontInfo {
        switch size {
        case .xsmall:
            return .init(size: 9, weight: globalTokens.fontWeight[.regular])
        case .small:
            return aliasTokens.typography[.caption2]
        case .medium:
            return aliasTokens.typography[.caption1]
        case .large:
            return aliasTokens.typography[.body2]
        case .xlarge:
            return .init(size: globalTokens.fontSize[.size500], weight: globalTokens.fontWeight[.regular])
        case .xxlarge:
            return .init(size: globalTokens.fontSize[.size700], weight: globalTokens.fontWeight[.semibold])
        }
    }

    /// The default color of the ring around the `Avatar`.
    open var ringDefaultColor: DynamicColor {
        switch style {
        case .default, .group:
            return globalTokens.brandColors[.tint10]
        case .accent:
            return globalTokens.brandColors[.shade10]
        case .outlined, .overflow:
            return aliasTokens.backgroundColors[.neutralDisabled]
        case .outlinedPrimary:
            return .init(light: globalTokens.brandColors[.tint10].light, dark: globalTokens.neutralColors[.grey78])
        }
    }

    /// The color of the gap between the ring and `Avatar`.
    open var ringGapColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// The thickness of the ring around the `Avatar`.
    open var ringThickness: CGFloat {
        switch size {
        case .xsmall, .small:
            return globalTokens.borderSize[.thin]
        case .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }

    /// The gap between the `Avatar` and its ring.
    open var ringInnerGap: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }

    /// The gap around the ring around the `Avatar`.
    open var ringOuterGap: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }

    /// The size of the presence icon.
    open var presenceIconSize: CGFloat {
        switch size {
        case .xsmall:
            return 0
        case .small, .medium:
            return globalTokens.iconSize[.xxxSmall]
        case .large, .xlarge:
            return globalTokens.iconSize[.xxSmall]
        case .xxlarge:
            return globalTokens.iconSize[.small]
        }
    }

    /// The thickness of the outline around the presence icon.
    open var presenceIconOutlineThickness: CGFloat {
        switch size {
        case .xsmall:
            return globalTokens.borderSize[.none]
        case .small, .medium, .large, .xlarge, .xxlarge:
            return globalTokens.borderSize[.thick]
        }
    }

    /// The color of the outline around the presence.
    open var presenceOutlineColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// The color for the background calculated using a hash of the strings.
    open var backgroundCalculatedColorOptions: [DynamicColor] {
        return [.init(light: globalTokens.sharedColors[.darkRed][.tint40], dark: globalTokens.sharedColors[.darkRed][.shade30]),
                .init(light: globalTokens.sharedColors[.cranberry][.tint40], dark: globalTokens.sharedColors[.cranberry][.shade30]),
                .init(light: globalTokens.sharedColors[.red][.tint40], dark: globalTokens.sharedColors[.red][.shade30]),
                .init(light: globalTokens.sharedColors[.pumpkin][.tint40], dark: globalTokens.sharedColors[.pumpkin][.shade30]),
                .init(light: globalTokens.sharedColors[.peach][.tint40], dark: globalTokens.sharedColors[.peach][.shade30]),
                .init(light: globalTokens.sharedColors[.marigold][.tint40], dark: globalTokens.sharedColors[.marigold][.shade30]),
                .init(light: globalTokens.sharedColors[.gold][.tint40], dark: globalTokens.sharedColors[.gold][.shade30]),
                .init(light: globalTokens.sharedColors[.brass][.tint40], dark: globalTokens.sharedColors[.brass][.shade30]),
                .init(light: globalTokens.sharedColors[.brown][.tint40], dark: globalTokens.sharedColors[.brown][.shade30]),
                .init(light: globalTokens.sharedColors[.forest][.tint40], dark: globalTokens.sharedColors[.forest][.shade30]),
                .init(light: globalTokens.sharedColors[.seafoam][.tint40], dark: globalTokens.sharedColors[.seafoam][.shade30]),
                .init(light: globalTokens.sharedColors[.darkGreen][.tint40], dark: globalTokens.sharedColors[.darkGreen][.shade30]),
                .init(light: globalTokens.sharedColors[.lightTeal][.tint40], dark: globalTokens.sharedColors[.lightTeal][.shade30]),
                .init(light: globalTokens.sharedColors[.teal][.tint40], dark: globalTokens.sharedColors[.teal][.shade30]),
                .init(light: globalTokens.sharedColors[.steel][.tint40], dark: globalTokens.sharedColors[.steel][.shade30]),
                .init(light: globalTokens.sharedColors[.blue][.tint40], dark: globalTokens.sharedColors[.blue][.shade30]),
                .init(light: globalTokens.sharedColors[.royalBlue][.tint40], dark: globalTokens.sharedColors[.royalBlue][.shade30]),
                .init(light: globalTokens.sharedColors[.cornflower][.tint40], dark: globalTokens.sharedColors[.cornflower][.shade30]),
                .init(light: globalTokens.sharedColors[.navy][.tint40], dark: globalTokens.sharedColors[.navy][.shade30]),
                .init(light: globalTokens.sharedColors[.lavender][.tint40], dark: globalTokens.sharedColors[.lavender][.shade30]),
                .init(light: globalTokens.sharedColors[.purple][.tint40], dark: globalTokens.sharedColors[.purple][.shade30]),
                .init(light: globalTokens.sharedColors[.grape][.tint40], dark: globalTokens.sharedColors[.grape][.shade30]),
                .init(light: globalTokens.sharedColors[.lilac][.tint40], dark: globalTokens.sharedColors[.lilac][.shade30]),
                .init(light: globalTokens.sharedColors[.pink][.tint40], dark: globalTokens.sharedColors[.pink][.shade30]),
                .init(light: globalTokens.sharedColors[.magenta][.tint40], dark: globalTokens.sharedColors[.magenta][.shade30]),
                .init(light: globalTokens.sharedColors[.plum][.tint40], dark: globalTokens.sharedColors[.plum][.shade30]),
                .init(light: globalTokens.sharedColors[.beige][.tint40], dark: globalTokens.sharedColors[.beige][.shade30]),
                .init(light: globalTokens.sharedColors[.mink][.tint40], dark: globalTokens.sharedColors[.mink][.shade30]),
                .init(light: globalTokens.sharedColors[.platinum][.tint40], dark: globalTokens.sharedColors[.platinum][.shade30]),
                .init(light: globalTokens.sharedColors[.anchor][.tint40], dark: globalTokens.sharedColors[.anchor][.shade30])]
    }

    /// The default color of the background of the `Avatar`.
    open var backgroundDefaultColor: DynamicColor {
        switch style {
        case .default, .group:
            return .init(light: globalTokens.neutralColors[.white], dark: globalTokens.brandColors[.primary].dark)
        case .accent:
            return globalTokens.brandColors[.primary]
        case .outlined:
            return .init(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey26])
        case .outlinedPrimary:
            return .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.neutralColors[.grey26])
        case .overflow:
            return aliasTokens.backgroundColors[.neutral4]
        }
    }

    /// The color of the foreground calculated using a hash of the strings.
    open var foregroundCalculatedColorOptions: [DynamicColor] {
        return [.init(light: globalTokens.sharedColors[.darkRed][.shade30], dark: globalTokens.sharedColors[.darkRed][.tint40]),
                .init(light: globalTokens.sharedColors[.cranberry][.shade30], dark: globalTokens.sharedColors[.cranberry][.tint40]),
                .init(light: globalTokens.sharedColors[.red][.shade30], dark: globalTokens.sharedColors[.red][.tint40]),
                .init(light: globalTokens.sharedColors[.pumpkin][.shade30], dark: globalTokens.sharedColors[.pumpkin][.tint40]),
                .init(light: globalTokens.sharedColors[.peach][.shade30], dark: globalTokens.sharedColors[.peach][.tint40]),
                .init(light: globalTokens.sharedColors[.marigold][.shade30], dark: globalTokens.sharedColors[.marigold][.tint40]),
                .init(light: globalTokens.sharedColors[.gold][.shade30], dark: globalTokens.sharedColors[.gold][.tint40]),
                .init(light: globalTokens.sharedColors[.brass][.shade30], dark: globalTokens.sharedColors[.brass][.tint40]),
                .init(light: globalTokens.sharedColors[.brown][.shade30], dark: globalTokens.sharedColors[.brown][.tint40]),
                .init(light: globalTokens.sharedColors[.forest][.shade30], dark: globalTokens.sharedColors[.forest][.tint40]),
                .init(light: globalTokens.sharedColors[.seafoam][.shade30], dark: globalTokens.sharedColors[.seafoam][.tint40]),
                .init(light: globalTokens.sharedColors[.darkGreen][.shade30], dark: globalTokens.sharedColors[.darkGreen][.tint40]),
                .init(light: globalTokens.sharedColors[.lightTeal][.shade30], dark: globalTokens.sharedColors[.lightTeal][.tint40]),
                .init(light: globalTokens.sharedColors[.teal][.shade30], dark: globalTokens.sharedColors[.teal][.tint40]),
                .init(light: globalTokens.sharedColors[.steel][.shade30], dark: globalTokens.sharedColors[.steel][.tint40]),
                .init(light: globalTokens.sharedColors[.blue][.shade30], dark: globalTokens.sharedColors[.blue][.tint40]),
                .init(light: globalTokens.sharedColors[.royalBlue][.shade30], dark: globalTokens.sharedColors[.royalBlue][.tint40]),
                .init(light: globalTokens.sharedColors[.cornflower][.shade30], dark: globalTokens.sharedColors[.cornflower][.tint40]),
                .init(light: globalTokens.sharedColors[.navy][.shade30], dark: globalTokens.sharedColors[.navy][.tint40]),
                .init(light: globalTokens.sharedColors[.lavender][.shade30], dark: globalTokens.sharedColors[.lavender][.tint40]),
                .init(light: globalTokens.sharedColors[.purple][.shade30], dark: globalTokens.sharedColors[.purple][.tint40]),
                .init(light: globalTokens.sharedColors[.grape][.shade30], dark: globalTokens.sharedColors[.grape][.tint40]),
                .init(light: globalTokens.sharedColors[.lilac][.shade30], dark: globalTokens.sharedColors[.lilac][.tint40]),
                .init(light: globalTokens.sharedColors[.pink][.shade30], dark: globalTokens.sharedColors[.pink][.tint40]),
                .init(light: globalTokens.sharedColors[.magenta][.shade30], dark: globalTokens.sharedColors[.magenta][.tint40]),
                .init(light: globalTokens.sharedColors[.plum][.shade30], dark: globalTokens.sharedColors[.plum][.tint40]),
                .init(light: globalTokens.sharedColors[.beige][.shade30], dark: globalTokens.sharedColors[.beige][.tint40]),
                .init(light: globalTokens.sharedColors[.mink][.shade30], dark: globalTokens.sharedColors[.mink][.tint40]),
                .init(light: globalTokens.sharedColors[.platinum][.shade30], dark: globalTokens.sharedColors[.platinum][.tint40]),
                .init(light: globalTokens.sharedColors[.anchor][.shade30], dark: globalTokens.sharedColors[.anchor][.tint40])]
    }

    /// The default color of the foreground of the `Avatar`
    open var foregroundDefaultColor: DynamicColor {
        switch style {
        case .default, .group:
            return .init(light: globalTokens.brandColors[.primary].light, dark: globalTokens.neutralColors[.black])
        case .accent:
            return aliasTokens.foregroundColors[.neutralInverted]
        case .outlined:
            return .init(light: globalTokens.neutralColors[.grey42], dark: globalTokens.neutralColors[.grey78])
        case .outlinedPrimary:
            return .init(light: globalTokens.brandColors[.primary].light, dark: globalTokens.neutralColors[.grey78])
        case .overflow:
            return aliasTokens.foregroundColors[.neutral3]
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
