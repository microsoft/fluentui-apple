//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Style to draw the `CardNudge` control.
@objc public enum MSFCardNudgeStyle: Int, CaseIterable {
    /// Drawn with a shaded background and no outline.
    case standard

    /// Drawn with a neutral background and a thin outline.
    case outline
}

class MSFCardNudgeTokens: MSFTokensBase, ObservableObject {
    @Published public var accentColor: UIColor!
    @Published public var accentIconSize: CGFloat!
    @Published public var accentPadding: CGFloat!
    @Published public var backgroundColor: UIColor!
    @Published public var buttonBackgroundColor: UIColor!
    @Published public var buttonInnerPaddingHorizontal: CGFloat!
    @Published public var buttonInnerPaddingVertical: CGFloat!
    @Published public var circleSize: CGFloat!
    @Published public var cornerRadius: CGFloat!
    @Published public var iconSize: CGFloat!
    @Published public var innerPadding: CGFloat!
    @Published public var interTextVerticalPadding: CGFloat!
    @Published public var mainContentVerticalPadding: CGFloat!
    @Published public var minimumHeight: CGFloat!
    @Published public var outerHorizontalPadding: CGFloat!
    @Published public var outerVerticalPadding: CGFloat!
    @Published public var outlineColor: UIColor!
    @Published public var outlineWidth: CGFloat!
    @Published public var subtitleTextColor: UIColor!
    @Published public var textColor: UIColor!

    var style: MSFCardNudgeStyle {
        didSet {
            if oldValue != style {
                updateForCurrentTheme()
            }
        }
    }

    init(style: MSFCardNudgeStyle) {
        self.style = style

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy: AppearanceProxyType = {
            switch style {
            case .standard:
                return currentTheme.MSFCardNudgeTokens
            case .outline:
                return currentTheme.MSFBorderedCardNudgeTokens
            }
        }()

        accentColor = appearanceProxy.accentColor
        accentIconSize = appearanceProxy.accentIconSize
        accentPadding = appearanceProxy.accentPadding
        backgroundColor = appearanceProxy.backgroundColor
        buttonBackgroundColor = appearanceProxy.buttonBackgroundColor
        buttonInnerPaddingHorizontal = appearanceProxy.buttonInnerPaddingHorizontal
        buttonInnerPaddingVertical = appearanceProxy.buttonInnerPaddingVertical
        circleSize = appearanceProxy.circleSize
        cornerRadius = appearanceProxy.cornerRadius
        iconSize = appearanceProxy.iconSize
        innerPadding = appearanceProxy.innerPadding
        interTextVerticalPadding = appearanceProxy.interTextVerticalPadding
        mainContentVerticalPadding = appearanceProxy.mainContentVerticalPadding
        minimumHeight = appearanceProxy.minimumHeight
        outerHorizontalPadding = appearanceProxy.outerHorizontalPadding
        outerVerticalPadding = appearanceProxy.outerVerticalPadding
        outlineColor = appearanceProxy.outlineColor
        outlineWidth = appearanceProxy.outlineWidth
        subtitleTextColor = appearanceProxy.subtitleTextColor
        textColor = appearanceProxy.textColor
    }
}
