//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFCardNudgeViewStyle)
public enum CardNudgeViewStyle: Int, CaseIterable {
    case standard
    case outline
}

class CardNudgeTokens: NSObject, ObservableObject {
    @Published public var accentColor: UIColor!
    @Published public var accentIconSize: CGFloat!
    @Published public var accentPadding: CGFloat!
    @Published public var backgroundBorderColor: UIColor!
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
    @Published public var subtitleTextColor: UIColor!
    @Published public var textColor: UIColor!

    var style: CardNudgeViewStyle {
        didSet {
            if oldValue != style {
                updateForCurrentTheme()
            }
        }
    }

    var window: UIWindow? {
        didSet {
            updateForCurrentTheme()
        }
    }

    init(style: CardNudgeViewStyle) {
        self.style = style

        super.init()

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    // TODO: subclass MSFTokensBase
    func updateForCurrentTheme() {
        var appearanceProxy = MSFCardNudgeTokensAppearanceProxy(window: window)

        accentColor = appearanceProxy.accentColor
        accentIconSize = appearanceProxy.accentIconSize
        accentPadding = appearanceProxy.accentPadding
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
        subtitleTextColor = appearanceProxy.subtitleTextColor

        switch style {
        case .standard:
            backgroundBorderColor = appearanceProxy.outlineColor.standard
            backgroundColor = appearanceProxy.backgroundColor.standard
            textColor = appearanceProxy.textColor.standard
        case .outline:
            backgroundBorderColor = appearanceProxy.outlineColor.outline
            backgroundColor = appearanceProxy.backgroundColor.outline
            textColor = appearanceProxy.textColor.outline
        }
    }
}

// MARK: - MSFCardNudgeTokensAppearanceProxy

// TODO: remove once real design tokens exist
private struct MSFCardNudgeTokensAppearanceProxy {
    var window: UIWindow?

    lazy var accentColor: UIColor = {
        if let window = window {
            return Colors.primaryShade20(for: window)
        } else {
            return Colors.Palette.communicationBlueShade20.color
        }
    }()
    let accentIconSize: CGFloat = 12.0
    let accentPadding: CGFloat = 4.0
    let backgroundColor: (standard: UIColor, outline: UIColor) = (standard: Colors.surfaceSecondary, outline: Colors.surfacePrimary)
    lazy var buttonBackgroundColor: UIColor = {
        if let window = window {
            return Colors.primaryTint30(for: window)

        } else {
            return Colors.Palette.communicationBlueTint30.color
        }
    }()
    let buttonInnerPaddingHorizontal: CGFloat = 12.0
    let buttonInnerPaddingVertical: CGFloat = 6.0
    let circleSize: CGFloat = 40.0
    let cornerRadius: CGFloat = 12.0
    let iconSize: CGFloat = 16.0
    let innerPadding: CGFloat = 16.0
    let interTextVerticalPadding: CGFloat = 2.0
    let mainContentVerticalPadding: CGFloat = 12.0
    let minimumHeight: CGFloat = 56.0
    let outerHorizontalPadding: CGFloat = 16.0
    let outerVerticalPadding: CGFloat = 8.0
    let outlineColor: (standard: UIColor, outline: UIColor) = (standard: UIColor.clear, outline: Colors.surfaceTertiary)
    let subtitleTextColor: UIColor = Colors.textSecondary
    lazy var textColor: (standard: UIColor, outline: UIColor) = {
        if let window = window {
            return (standard: Colors.textPrimary, outline: Colors.primaryShade20(for: window))
        } else {
            return (standard: Colors.textPrimary, outline: Colors.Palette.communicationBlueShade20.color)
        }
    }()
}
