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
        return size.size
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
    // We seem to have some odd font choices
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
        // will sync and update once these are checked in
        return [.init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark),
                .init(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.shade30].dark)]
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
        // will sync and update once these are checked in
        return [.init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark),
                .init(light: globalTokens.brandColors[.shade30].light, dark: globalTokens.brandColors[.tint40].dark)]
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

    var size: CGFloat {
        switch self {
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
}
