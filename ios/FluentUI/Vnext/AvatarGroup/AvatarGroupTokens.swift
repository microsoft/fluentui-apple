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

        switch style {
        case .stack:
            appearanceProxy = currentTheme.MSFAvatarGroupStackTokens
        case .pile:
            appearanceProxy = currentTheme.MSFAvatarGroupTokens
        }

        switch size {
        case .xsmall:
            interspace = appearanceProxy.interspace.xSmall
            ringInnerGap = appearanceProxy.ringInnerGap.xSmall
            ringThickness = appearanceProxy.ringThickness.xSmall
            ringOuterGap = appearanceProxy.ringOuterGap.xSmall
        case .small:
            interspace = appearanceProxy.interspace.small
            ringInnerGap = appearanceProxy.ringInnerGap.small
            ringThickness = appearanceProxy.ringThickness.small
            ringOuterGap = appearanceProxy.ringOuterGap.small
        case .medium:
            interspace = appearanceProxy.interspace.medium
            ringInnerGap = appearanceProxy.ringInnerGap.medium
            ringThickness = appearanceProxy.ringThickness.medium
            ringOuterGap = appearanceProxy.ringOuterGap.medium
        case .large:
            interspace = appearanceProxy.interspace.large
            ringInnerGap = appearanceProxy.ringInnerGap.large
            ringThickness = appearanceProxy.ringThickness.large
            ringOuterGap = appearanceProxy.ringOuterGap.large
        case .xlarge:
            interspace = appearanceProxy.interspace.xlarge
            ringInnerGap = appearanceProxy.ringInnerGap.xlarge
            ringThickness = appearanceProxy.ringThickness.xlarge
            ringOuterGap = appearanceProxy.ringOuterGap.xlarge
        case .xxlarge:
            interspace = appearanceProxy.interspace.xxlarge
            ringInnerGap = appearanceProxy.ringInnerGap.xxlarge
            ringThickness = appearanceProxy.ringThickness.xxlarge
            ringOuterGap = appearanceProxy.ringOuterGap.xxlarge
        }
    }
}
