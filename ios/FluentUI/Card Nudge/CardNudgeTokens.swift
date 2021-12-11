//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Style to draw the `CardNudge` control.
@objc public enum MSFCardNudgeStyle: Int, CaseIterable {
    /// Drawn with a shaded background and no outline.
    case standard

    /// Drawn with a neutral background and a thin outline.
    case outline
}

/// Design token set for the `CardNudge` control.
public class CardNudgeTokens: ControlTokens {
    /// Creates an instance of `CardNudgeTokens` with optional token value overrides.
    public static func create(style: MSFCardNudgeStyle,
                              accentColor: ColorSet? = nil,
                              accentIconSize: CGFloat? = nil,
                              accentPadding: CGFloat? = nil,
                              backgroundColor: ColorSet? = nil,
                              buttonBackgroundColor: ColorSet? = nil,
                              buttonInnerPaddingHorizontal: CGFloat? = nil,
                              circleRadius: CGFloat? = nil,
                              circleSize: CGFloat? = nil,
                              cornerRadius: CGFloat? = nil,
                              horizontalPadding: CGFloat? = nil,
                              iconSize: CGFloat? = nil,
                              interTextVerticalPadding: CGFloat? = nil,
                              mainContentVerticalPadding: CGFloat? = nil,
                              minimumHeight: CGFloat? = nil,
                              outlineColor: ColorSet? = nil,
                              outlineWidth: CGFloat? = nil,
                              subtitleTextColor: ColorSet? = nil,
                              textColor: ColorSet? = nil,
                              verticalPadding: CGFloat? = nil) -> CardNudgeTokens {

        let tokens: CardNudgeTokens
        switch style {
        case .standard:
            tokens = CardNudgeTokens()
        case .outline:
            tokens = OutlineCardNudgeTokens()
        }

        // Optional overrides
        if let accentColor = accentColor {
            tokens.accentColor = accentColor
        }
        if let accentIconSize = accentIconSize {
            tokens.accentIconSize = accentIconSize
        }
        if let accentPadding = accentPadding {
            tokens.accentPadding = accentPadding
        }
        if let backgroundColor = backgroundColor {
            tokens.backgroundColor = backgroundColor
        }
        if let buttonBackgroundColor = buttonBackgroundColor {
            tokens.buttonBackgroundColor = buttonBackgroundColor
        }
        if let buttonInnerPaddingHorizontal = buttonInnerPaddingHorizontal {
            tokens.buttonInnerPaddingHorizontal = buttonInnerPaddingHorizontal
        }
        if let circleRadius = circleRadius {
            tokens.circleRadius = circleRadius
        }
        if let circleSize = circleSize {
            tokens.circleSize = circleSize
        }
        if let cornerRadius = cornerRadius {
            tokens.cornerRadius = cornerRadius
        }
        if let horizontalPadding = horizontalPadding {
            tokens.horizontalPadding = horizontalPadding
        }
        if let iconSize = iconSize {
            tokens.iconSize = iconSize
        }
        if let interTextVerticalPadding = interTextVerticalPadding {
            tokens.interTextVerticalPadding = interTextVerticalPadding
        }
        if let mainContentVerticalPadding = mainContentVerticalPadding {
            tokens.mainContentVerticalPadding = mainContentVerticalPadding
        }
        if let minimumHeight = minimumHeight {
            tokens.minimumHeight = minimumHeight
        }
        if let outlineColor = outlineColor {
            tokens.outlineColor = outlineColor
        }
        if let outlineWidth = outlineWidth {
            tokens.outlineWidth = outlineWidth
        }
        if let subtitleTextColor = subtitleTextColor {
            tokens.subtitleTextColor = subtitleTextColor
        }
        if let textColor = textColor {
            tokens.textColor = textColor
        }
        if let verticalPadding = verticalPadding {
            tokens.verticalPadding = verticalPadding
        }

        return tokens
    }

    fileprivate override init() {
        super.init()
    }

    lazy fileprivate(set) var accentColor: ColorSet = globalTokens.brandColors[.shade20]
    lazy fileprivate(set) var accentIconSize: CGFloat = globalTokens.iconSize[.xxSmall]
    lazy fileprivate(set) var accentPadding: CGFloat = globalTokens.spacing[.xxSmall]
    lazy fileprivate(set) var backgroundColor: ColorSet = aliasTokens.backgroundColors[.neutral2]
    lazy fileprivate(set) var buttonBackgroundColor: ColorSet = globalTokens.brandColors[.tint30]
    lazy fileprivate(set) var buttonInnerPaddingHorizontal: CGFloat = globalTokens.spacing[.small]
    lazy fileprivate(set) var circleRadius: CGFloat = globalTokens.borderRadius[.circle]
    lazy fileprivate(set) var circleSize: CGFloat = globalTokens.iconSize[.xxLarge]
    lazy fileprivate(set) var cornerRadius: CGFloat = globalTokens.borderRadius[.xLarge]
    lazy fileprivate(set) var horizontalPadding: CGFloat = globalTokens.spacing[.medium]
    lazy fileprivate(set) var iconSize: CGFloat = globalTokens.iconSize[.xSmall]
    lazy fileprivate(set) var interTextVerticalPadding: CGFloat = globalTokens.spacing[.xxxSmall]
    lazy fileprivate(set) var mainContentVerticalPadding: CGFloat = globalTokens.spacing[.small]
    lazy fileprivate(set) var minimumHeight: CGFloat = 56.0
    lazy fileprivate(set) var outlineColor: ColorSet = aliasTokens.backgroundColors[.neutral2]
    lazy fileprivate(set) var outlineWidth: CGFloat = globalTokens.borderSize[.thin]
    lazy fileprivate(set) var subtitleTextColor: ColorSet = aliasTokens.foregroundColors[.neutral3]
    lazy fileprivate(set) var textColor: ColorSet = aliasTokens.foregroundColors[.neutral1]
    lazy fileprivate(set) var verticalPadding: CGFloat = globalTokens.spacing[.xSmall]
}

class OutlineCardNudgeTokens: CardNudgeTokens {
    fileprivate override init() {
        super.init()

        // Token overrides
        backgroundColor = aliasTokens.backgroundColors[.neutral1]
        outlineColor = aliasTokens.strokeColors[.neutral1]
        textColor = globalTokens.brandColors[.shade20]
    }
}
