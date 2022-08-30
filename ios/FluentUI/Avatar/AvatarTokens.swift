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
            return GlobalTokens.spacing(.none)
        case .group:
            switch size {
            case .xsmall:
                return GlobalTokens.borderRadius(.small)
            case .small, .medium:
                return GlobalTokens.borderRadius(.medium)
            case .large, .xlarge:
                return GlobalTokens.borderRadius(.large)
            case .xxlarge:
                return GlobalTokens.borderRadius(.xLarge)
            }
        }
    }

    /// The font used for text in the `Avatar`
    open var textFont: FontInfo {
        switch size {
        case .xsmall:
            return .init(size: 9, weight: GlobalTokens.fontWeight(.regular))
        case .small:
            return aliasTokens.typography[.caption2]
        case .medium:
            return aliasTokens.typography[.caption1]
        case .large:
            return aliasTokens.typography[.body2]
        case .xlarge:
            return .init(size: GlobalTokens.fontSize(.size500), weight: GlobalTokens.fontWeight(.regular))
        case .xxlarge:
            return .init(size: GlobalTokens.fontSize(.size700), weight: GlobalTokens.fontWeight(.semibold))
        }
    }

    /// The default color of the ring around the `Avatar`.
    open var ringDefaultColor: DynamicColor {
        switch style {
        case .default, .group, .accent, .outlinedPrimary:
            return aliasTokens.colors[.brandStroke1]
        case .outlined, .overflow:
            return aliasTokens.colors[.stroke1]
        }
    }

    /// The color of the gap between the ring and `Avatar`.
    open var ringGapColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// The thickness of the ring around the `Avatar`.
    open var ringThickness: CGFloat {
        switch size {
        case .xsmall, .small:
            return GlobalTokens.borderSize(.thin)
        case .medium, .large, .xlarge:
            return GlobalTokens.borderSize(.thick)
        case .xxlarge:
            return GlobalTokens.borderSize(.thicker)
        }
    }

    /// The gap between the `Avatar` and its ring.
    open var ringInnerGap: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return GlobalTokens.borderSize(.thick)
        case .xxlarge:
            return GlobalTokens.borderSize(.thicker)
        }
    }

    /// The gap around the ring around the `Avatar`.
    open var ringOuterGap: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return GlobalTokens.borderSize(.thick)
        case .xxlarge:
            return GlobalTokens.borderSize(.thicker)
        }
    }

    /// The size of the presence icon.
    open var presenceIconSize: CGFloat {
        switch size {
        case .xsmall:
            return 0
        case .small, .medium:
            return GlobalTokens.iconSize(.xxxSmall)
        case .large, .xlarge:
            return GlobalTokens.iconSize(.xxSmall)
        case .xxlarge:
            return GlobalTokens.iconSize(.small)
        }
    }

    /// The thickness of the outline around the presence icon.
    open var presenceIconOutlineThickness: CGFloat {
        switch size {
        case .xsmall:
            return GlobalTokens.borderSize(.none)
        case .small, .medium, .large, .xlarge, .xxlarge:
            return GlobalTokens.borderSize(.thick)
        }
    }

    /// The color of the outline around the presence.
    open var presenceOutlineColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// The color for the background calculated using a hash of the strings.
    open var backgroundCalculatedColorOptions: [DynamicColor] {
        return [.init(light: GlobalTokens.sharedColors(.darkRed, .tint40), dark: GlobalTokens.sharedColors(.darkRed, .shade30)),
                .init(light: GlobalTokens.sharedColors(.cranberry, .tint40), dark: GlobalTokens.sharedColors(.cranberry, .shade30)),
                .init(light: GlobalTokens.sharedColors(.red, .tint40), dark: GlobalTokens.sharedColors(.red, .shade30)),
                .init(light: GlobalTokens.sharedColors(.pumpkin, .tint40), dark: GlobalTokens.sharedColors(.pumpkin, .shade30)),
                .init(light: GlobalTokens.sharedColors(.peach, .tint40), dark: GlobalTokens.sharedColors(.peach, .shade30)),
                .init(light: GlobalTokens.sharedColors(.marigold, .tint40), dark: GlobalTokens.sharedColors(.marigold, .shade30)),
                .init(light: GlobalTokens.sharedColors(.gold, .tint40), dark: GlobalTokens.sharedColors(.gold, .shade30)),
                .init(light: GlobalTokens.sharedColors(.brass, .tint40), dark: GlobalTokens.sharedColors(.brass, .shade30)),
                .init(light: GlobalTokens.sharedColors(.brown, .tint40), dark: GlobalTokens.sharedColors(.brown, .shade30)),
                .init(light: GlobalTokens.sharedColors(.forest, .tint40), dark: GlobalTokens.sharedColors(.forest, .shade30)),
                .init(light: GlobalTokens.sharedColors(.seafoam, .tint40), dark: GlobalTokens.sharedColors(.seafoam, .shade30)),
                .init(light: GlobalTokens.sharedColors(.darkGreen, .tint40), dark: GlobalTokens.sharedColors(.darkGreen, .shade30)),
                .init(light: GlobalTokens.sharedColors(.lightTeal, .tint40), dark: GlobalTokens.sharedColors(.lightTeal, .shade30)),
                .init(light: GlobalTokens.sharedColors(.teal, .tint40), dark: GlobalTokens.sharedColors(.teal, .shade30)),
                .init(light: GlobalTokens.sharedColors(.steel, .tint40), dark: GlobalTokens.sharedColors(.steel, .shade30)),
                .init(light: GlobalTokens.sharedColors(.blue, .tint40), dark: GlobalTokens.sharedColors(.blue, .shade30)),
                .init(light: GlobalTokens.sharedColors(.royalBlue, .tint40), dark: GlobalTokens.sharedColors(.royalBlue, .shade30)),
                .init(light: GlobalTokens.sharedColors(.cornflower, .tint40), dark: GlobalTokens.sharedColors(.cornflower, .shade30)),
                .init(light: GlobalTokens.sharedColors(.navy, .tint40), dark: GlobalTokens.sharedColors(.navy, .shade30)),
                .init(light: GlobalTokens.sharedColors(.lavender, .tint40), dark: GlobalTokens.sharedColors(.lavender, .shade30)),
                .init(light: GlobalTokens.sharedColors(.purple, .tint40), dark: GlobalTokens.sharedColors(.purple, .shade30)),
                .init(light: GlobalTokens.sharedColors(.grape, .tint40), dark: GlobalTokens.sharedColors(.grape, .shade30)),
                .init(light: GlobalTokens.sharedColors(.lilac, .tint40), dark: GlobalTokens.sharedColors(.lilac, .shade30)),
                .init(light: GlobalTokens.sharedColors(.pink, .tint40), dark: GlobalTokens.sharedColors(.pink, .shade30)),
                .init(light: GlobalTokens.sharedColors(.magenta, .tint40), dark: GlobalTokens.sharedColors(.magenta, .shade30)),
                .init(light: GlobalTokens.sharedColors(.plum, .tint40), dark: GlobalTokens.sharedColors(.plum, .shade30)),
                .init(light: GlobalTokens.sharedColors(.beige, .tint40), dark: GlobalTokens.sharedColors(.beige, .shade30)),
                .init(light: GlobalTokens.sharedColors(.mink, .tint40), dark: GlobalTokens.sharedColors(.mink, .shade30)),
                .init(light: GlobalTokens.sharedColors(.platinum, .tint40), dark: GlobalTokens.sharedColors(.platinum, .shade30)),
                .init(light: GlobalTokens.sharedColors(.anchor, .tint40), dark: GlobalTokens.sharedColors(.anchor, .shade30))]
    }

    /// The default color of the background of the `Avatar`.
    open var backgroundDefaultColor: DynamicColor {
        switch style {
        case .default, .group:
            return aliasTokens.colors[.background1]
        case .accent:
            return aliasTokens.colors[.brandBackground1]
        case .outlined, .overflow:
            return aliasTokens.colors[.background5]
        case .outlinedPrimary:
            return aliasTokens.colors[.brandBackground4]
        }
    }

    /// The color of the foreground calculated using a hash of the strings.
    open var foregroundCalculatedColorOptions: [DynamicColor] {
        return [.init(light: GlobalTokens.sharedColors(.darkRed, .shade30), dark: GlobalTokens.sharedColors(.darkRed, .tint40)),
                .init(light: GlobalTokens.sharedColors(.cranberry, .shade30), dark: GlobalTokens.sharedColors(.cranberry, .tint40)),
                .init(light: GlobalTokens.sharedColors(.red, .shade30), dark: GlobalTokens.sharedColors(.red, .tint40)),
                .init(light: GlobalTokens.sharedColors(.pumpkin, .shade30), dark: GlobalTokens.sharedColors(.pumpkin, .tint40)),
                .init(light: GlobalTokens.sharedColors(.peach, .shade30), dark: GlobalTokens.sharedColors(.peach, .tint40)),
                .init(light: GlobalTokens.sharedColors(.marigold, .shade30), dark: GlobalTokens.sharedColors(.marigold, .tint40)),
                .init(light: GlobalTokens.sharedColors(.gold, .shade30), dark: GlobalTokens.sharedColors(.gold, .tint40)),
                .init(light: GlobalTokens.sharedColors(.brass, .shade30), dark: GlobalTokens.sharedColors(.brass, .tint40)),
                .init(light: GlobalTokens.sharedColors(.brown, .shade30), dark: GlobalTokens.sharedColors(.brown, .tint40)),
                .init(light: GlobalTokens.sharedColors(.forest, .shade30), dark: GlobalTokens.sharedColors(.forest, .tint40)),
                .init(light: GlobalTokens.sharedColors(.seafoam, .shade30), dark: GlobalTokens.sharedColors(.seafoam, .tint40)),
                .init(light: GlobalTokens.sharedColors(.darkGreen, .shade30), dark: GlobalTokens.sharedColors(.darkGreen, .tint40)),
                .init(light: GlobalTokens.sharedColors(.lightTeal, .shade30), dark: GlobalTokens.sharedColors(.lightTeal, .tint40)),
                .init(light: GlobalTokens.sharedColors(.teal, .shade30), dark: GlobalTokens.sharedColors(.teal, .tint40)),
                .init(light: GlobalTokens.sharedColors(.steel, .shade30), dark: GlobalTokens.sharedColors(.steel, .tint40)),
                .init(light: GlobalTokens.sharedColors(.blue, .shade30), dark: GlobalTokens.sharedColors(.blue, .tint40)),
                .init(light: GlobalTokens.sharedColors(.royalBlue, .shade30), dark: GlobalTokens.sharedColors(.royalBlue, .tint40)),
                .init(light: GlobalTokens.sharedColors(.cornflower, .shade30), dark: GlobalTokens.sharedColors(.cornflower, .tint40)),
                .init(light: GlobalTokens.sharedColors(.navy, .shade30), dark: GlobalTokens.sharedColors(.navy, .tint40)),
                .init(light: GlobalTokens.sharedColors(.lavender, .shade30), dark: GlobalTokens.sharedColors(.lavender, .tint40)),
                .init(light: GlobalTokens.sharedColors(.purple, .shade30), dark: GlobalTokens.sharedColors(.purple, .tint40)),
                .init(light: GlobalTokens.sharedColors(.grape, .shade30), dark: GlobalTokens.sharedColors(.grape, .tint40)),
                .init(light: GlobalTokens.sharedColors(.lilac, .shade30), dark: GlobalTokens.sharedColors(.lilac, .tint40)),
                .init(light: GlobalTokens.sharedColors(.pink, .shade30), dark: GlobalTokens.sharedColors(.pink, .tint40)),
                .init(light: GlobalTokens.sharedColors(.magenta, .shade30), dark: GlobalTokens.sharedColors(.magenta, .tint40)),
                .init(light: GlobalTokens.sharedColors(.plum, .shade30), dark: GlobalTokens.sharedColors(.plum, .tint40)),
                .init(light: GlobalTokens.sharedColors(.beige, .shade30), dark: GlobalTokens.sharedColors(.beige, .tint40)),
                .init(light: GlobalTokens.sharedColors(.mink, .shade30), dark: GlobalTokens.sharedColors(.mink, .tint40)),
                .init(light: GlobalTokens.sharedColors(.platinum, .shade30), dark: GlobalTokens.sharedColors(.platinum, .tint40)),
                .init(light: GlobalTokens.sharedColors(.anchor, .shade30), dark: GlobalTokens.sharedColors(.anchor, .tint40))]
    }

    /// The default color of the foreground of the `Avatar`
    open var foregroundDefaultColor: DynamicColor {
        switch style {
        case .default, .group:
            return aliasTokens.colors[.brandForeground1]
        case .accent:
            return aliasTokens.colors[.foregroundOnColor]
        case .outlined, .overflow:
            return aliasTokens.colors[.foreground2]
        case .outlinedPrimary:
            return aliasTokens.colors[.brandForeground4]
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
