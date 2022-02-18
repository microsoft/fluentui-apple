//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

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
            return FluentUIThemeManager.S.MSFAvatarTokens.size.xSmall
        case .small:
            return FluentUIThemeManager.S.MSFAvatarTokens.size.small
        case .medium:
            return FluentUIThemeManager.S.MSFAvatarTokens.size.medium
        case .large:
            return FluentUIThemeManager.S.MSFAvatarTokens.size.large
        case .xlarge:
            return FluentUIThemeManager.S.MSFAvatarTokens.size.xlarge
        case .xxlarge:
            return FluentUIThemeManager.S.MSFAvatarTokens.size.xxlarge
        }
    }
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
class MSFAvatarTokens: MSFTokensBase, ObservableObject {
    @Published public var avatarSize: CGFloat!
    @Published public var borderRadius: CGFloat!
    @Published public var textFont: UIFont!

    @Published public var ringDefaultColor: UIColor!
    @Published public var ringGapColor: UIColor!
    @Published public var ringThickness: CGFloat!
    @Published public var ringInnerGap: CGFloat!
    @Published public var ringOuterGap: CGFloat!

    @Published public var presenceIconSize: CGFloat!
    @Published public var presenceIconOutlineThickness: CGFloat!
    @Published public var presenceOutlineColor: UIColor!

    @Published public var backgroundCalculatedColorOptions: [UIColor]!
    @Published public var backgroundDefaultColor: UIColor!
    @Published public var foregroundCalculatedColorOptions: [UIColor]!
    @Published public var foregroundDefaultColor: UIColor!

    var style: MSFAvatarStyle {
        didSet {
            if oldValue != style {
                updateForCurrentTheme()
            }
        }
    }

    var size: MSFAvatarSize {
        didSet {
            if oldValue != size {
                updateForCurrentTheme()
            }
        }
    }

    init(style: MSFAvatarStyle,
         size: MSFAvatarSize) {
        self.style = style
        self.size = size

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType

        switch style {
        case .default:
            appearanceProxy = currentTheme.MSFAvatarTokens
        case .accent:
            appearanceProxy = currentTheme.MSFAccentAvatarTokens
        case .outlined:
            appearanceProxy = currentTheme.MSFOutlinedAvatarTokens
        case .outlinedPrimary:
            appearanceProxy = currentTheme.MSFOutlinedPrimaryAvatarTokens
        case .overflow:
            appearanceProxy = currentTheme.MSFOverflowAvatarTokens
        case .group:
            appearanceProxy = currentTheme.MSFGroupAvatarTokens
        }

        ringDefaultColor = appearanceProxy.ringDefaultColor
        ringGapColor = appearanceProxy.ringGapColor
        presenceOutlineColor = appearanceProxy.presenceIconOutlineColor
        backgroundDefaultColor = appearanceProxy.backgroundDefaultColor
        backgroundCalculatedColorOptions = appearanceProxy.textCalculatedBackgroundColors
        foregroundDefaultColor = appearanceProxy.foregroundDefaultColor
        foregroundCalculatedColorOptions = appearanceProxy.textCalculatedForegroundColors

        switch size {
        case .xsmall:
            avatarSize = appearanceProxy.size.xSmall
            borderRadius = appearanceProxy.borderRadius.xSmall
            ringThickness = appearanceProxy.ringThickness.xSmall
            ringInnerGap = appearanceProxy.ringInnerGap.xSmall
            ringOuterGap = appearanceProxy.ringOuterGap.xSmall
            presenceIconSize = appearanceProxy.presenceIconSize.xSmall
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.xSmall
            textFont = appearanceProxy.textFont.xSmall
        case .small:
            avatarSize = appearanceProxy.size.small
            borderRadius = appearanceProxy.borderRadius.small
            ringThickness = appearanceProxy.ringThickness.small
            ringInnerGap = appearanceProxy.ringInnerGap.small
            ringOuterGap = appearanceProxy.ringOuterGap.small
            presenceIconSize = appearanceProxy.presenceIconSize.small
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.small
            textFont = appearanceProxy.textFont.small
        case .medium:
            avatarSize = appearanceProxy.size.medium
            borderRadius = appearanceProxy.borderRadius.medium
            ringThickness = appearanceProxy.ringThickness.medium
            ringInnerGap = appearanceProxy.ringInnerGap.medium
            ringOuterGap = appearanceProxy.ringOuterGap.medium
            presenceIconSize = appearanceProxy.presenceIconSize.medium
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.medium
            textFont = appearanceProxy.textFont.medium
        case .large:
            avatarSize = appearanceProxy.size.large
            borderRadius = appearanceProxy.borderRadius.large
            ringThickness = appearanceProxy.ringThickness.large
            ringInnerGap = appearanceProxy.ringInnerGap.large
            ringOuterGap = appearanceProxy.ringOuterGap.large
            presenceIconSize = appearanceProxy.presenceIconSize.large
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.large
            textFont = appearanceProxy.textFont.large
        case .xlarge:
            avatarSize = appearanceProxy.size.xlarge
            borderRadius = appearanceProxy.borderRadius.xlarge
            ringThickness = appearanceProxy.ringThickness.xlarge
            ringInnerGap = appearanceProxy.ringInnerGap.xlarge
            ringOuterGap = appearanceProxy.ringOuterGap.xlarge
            presenceIconSize = appearanceProxy.presenceIconSize.xlarge
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.xlarge
            textFont = appearanceProxy.textFont.xlarge
        case .xxlarge:
            avatarSize = appearanceProxy.size.xxlarge
            borderRadius = appearanceProxy.borderRadius.xxlarge
            ringThickness = appearanceProxy.ringThickness.xxlarge
            ringInnerGap = appearanceProxy.ringInnerGap.xxlarge
            ringOuterGap = appearanceProxy.ringOuterGap.xxlarge
            presenceIconSize = appearanceProxy.presenceIconSize.xxlarge
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.xxlarge
            textFont = appearanceProxy.textFont.xxlarge
        }
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }
}

/// Design token set for the `Avatar` control.
open class AvatarTokens: ControlTokens {

    /// Defines the style of the `Avatar`.
    public internal(set) var style: MSFAvatarStyle = .default

    /// Defines the size of the `Avatar`.
    public internal(set) var size: MSFAvatarSize = .large

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
            // this was $Icon.accentColor, but we don't seem to have that. icon.accent color was just black and white, though
            return .init(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.black])
        case .outlined:
            return .init(light: globalTokens.neutralColors[.grey42], dark: globalTokens.neutralColors[.grey78])
        case .outlinedPrimary:
            return .init(light: globalTokens.brandColors[.primary].light, dark: globalTokens.neutralColors[.grey78])
        case .overflow:
            return aliasTokens.foregroundColors[.neutral3]
        }
    }
}
