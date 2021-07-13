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
        let avatarTokens = MSFAvatarTokens(style: .default, size: size)

        switch style {
        case .stack:
            appearanceProxy = currentTheme.MSFAvatarGroupStackTokens
        case .pile:
            appearanceProxy = currentTheme.MSFAvatarGroupTokens
        }

        switch size {
        case .xsmall:
            interspace = appearanceProxy.interspace.xSmall
        case .small:
            interspace = appearanceProxy.interspace.small
        case .medium:
            interspace = appearanceProxy.interspace.medium
        case .large:
            interspace = appearanceProxy.interspace.large
        case .xlarge:
            interspace = appearanceProxy.interspace.xlarge
        case .xxlarge:
            interspace = appearanceProxy.interspace.xxlarge
        }

        ringInnerGap = avatarTokens.ringInnerGap
        ringThickness = avatarTokens.ringThickness
        ringOuterGap = avatarTokens.ringOuterGap
    }
}
