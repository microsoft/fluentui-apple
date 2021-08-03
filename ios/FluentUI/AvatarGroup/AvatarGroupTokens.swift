//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

class MSFAvatarGroupTokens: MSFTokensBase, ObservableObject {
    @Published public var interspace: CGFloat!
    @Published public var ringInnerGap: CGFloat!
    @Published public var ringThickness: CGFloat!
    @Published public var ringOuterGap: CGFloat!

    var style: MSFAvatarGroupStyle {
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

    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        self.style = style
        self.size = size

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType
        let avatarTokens = currentTheme.MSFAvatarTokens

        switch style {
        case .stack:
            appearanceProxy = currentTheme.MSFAvatarGroupStackTokens
        case .pile:
            appearanceProxy = currentTheme.MSFAvatarGroupTokens
        }

        switch size {
        case .xsmall:
            interspace = appearanceProxy.interspace.xSmall
            ringInnerGap = avatarTokens.ringInnerGap.xSmall
            ringThickness = avatarTokens.ringThickness.xSmall
            ringOuterGap = avatarTokens.ringOuterGap.xSmall
        case .small:
            interspace = appearanceProxy.interspace.small
            ringInnerGap = avatarTokens.ringInnerGap.small
            ringThickness = avatarTokens.ringThickness.small
            ringOuterGap = avatarTokens.ringOuterGap.small
        case .medium:
            interspace = appearanceProxy.interspace.medium
            ringInnerGap = avatarTokens.ringInnerGap.medium
            ringThickness = avatarTokens.ringThickness.medium
            ringOuterGap = avatarTokens.ringOuterGap.medium
        case .large:
            interspace = appearanceProxy.interspace.large
            ringInnerGap = avatarTokens.ringInnerGap.large
            ringThickness = avatarTokens.ringThickness.large
            ringOuterGap = avatarTokens.ringOuterGap.large
        case .xlarge:
            interspace = appearanceProxy.interspace.xlarge
            ringInnerGap = avatarTokens.ringInnerGap.xlarge
            ringThickness = avatarTokens.ringThickness.xlarge
            ringOuterGap = avatarTokens.ringOuterGap.xlarge
        case .xxlarge:
            interspace = appearanceProxy.interspace.xxlarge
            ringInnerGap = avatarTokens.ringInnerGap.xxlarge
            ringThickness = avatarTokens.ringThickness.xxlarge
            ringOuterGap = avatarTokens.ringOuterGap.xxlarge
        }
    }
}
