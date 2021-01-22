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
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
public class MSFAvatarTokens: MSFTokensBase, ObservableObject {
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
    @Published public var foregroundDefaultColor: UIColor!
    @Published public var textColor: UIColor!

    public var style: MSFAvatarStyle {
        didSet {
            if oldValue != style {
                updateForCurrentTheme()
            }
        }
    }

    public var size: MSFAvatarSize {
        didSet {
            if oldValue != size {
                updateForCurrentTheme()
            }
        }
    }

    public init(style: MSFAvatarStyle,
                size: MSFAvatarSize) {
        self.style = style
        self.size = size

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
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
        textColor = appearanceProxy.textColor

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
