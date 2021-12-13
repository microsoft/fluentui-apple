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
        tokens._accentColorOverride = accentColor
        tokens._accentIconSizeOverride = accentIconSize
        tokens._accentPaddingOverride = accentPadding
        tokens._backgroundColorOverride = backgroundColor
        tokens._buttonBackgroundColorOverride = buttonBackgroundColor
        tokens._buttonInnerPaddingHorizontalOverride = buttonInnerPaddingHorizontal
        tokens._circleRadiusOverride = circleRadius
        tokens._circleSizeOverride = circleSize
        tokens._cornerRadiusOverride = cornerRadius
        tokens._horizontalPaddingOverride = horizontalPadding
        tokens._iconSizeOverride = iconSize
        tokens._interTextVerticalPaddingOverride = interTextVerticalPadding
        tokens._mainContentVerticalPaddingOverride = mainContentVerticalPadding
        tokens._minimumHeightOverride = minimumHeight
        tokens._outlineColorOverride = outlineColor
        tokens._outlineWidthOverride = outlineWidth
        tokens._subtitleTextColorOverride = subtitleTextColor
        tokens._textColorOverride = textColor
        tokens._verticalPaddingOverride = verticalPadding

        return tokens
    }

    fileprivate var _accentColorOverride: ColorSet?
    var accentColor: ColorSet { _accentColorOverride ?? globalTokens.brandColors[.shade20] }

    fileprivate var _accentIconSizeOverride: CGFloat?
    var accentIconSize: CGFloat { _accentIconSizeOverride ?? globalTokens.iconSize[.xxSmall] }

    fileprivate var _accentPaddingOverride: CGFloat?
    var accentPadding: CGFloat { _accentPaddingOverride ?? globalTokens.spacing[.xxSmall] }

    fileprivate var _backgroundColorOverride: ColorSet?
    var backgroundColor: ColorSet { _backgroundColorOverride ?? aliasTokens.backgroundColors[.neutral2] }

    fileprivate var _buttonBackgroundColorOverride: ColorSet?
    var buttonBackgroundColor: ColorSet { _buttonBackgroundColorOverride ?? globalTokens.brandColors[.tint30] }

    fileprivate var _buttonInnerPaddingHorizontalOverride: CGFloat?
    var buttonInnerPaddingHorizontal: CGFloat { _buttonInnerPaddingHorizontalOverride ?? globalTokens.spacing[.small] }

    fileprivate var _circleRadiusOverride: CGFloat?
    var circleRadius: CGFloat { _circleRadiusOverride ?? globalTokens.borderRadius[.circle] }

    fileprivate var _circleSizeOverride: CGFloat?
    var circleSize: CGFloat { _circleSizeOverride ?? globalTokens.iconSize[.xxLarge] }

    fileprivate var _cornerRadiusOverride: CGFloat?
    var cornerRadius: CGFloat { _cornerRadiusOverride ?? globalTokens.borderRadius[.xLarge] }

    fileprivate var _horizontalPaddingOverride: CGFloat?
    var horizontalPadding: CGFloat { _horizontalPaddingOverride ?? globalTokens.spacing[.medium] }

    fileprivate var _iconSizeOverride: CGFloat?
    var iconSize: CGFloat { _iconSizeOverride ?? globalTokens.iconSize[.xSmall] }

    fileprivate var _interTextVerticalPaddingOverride: CGFloat?
    var interTextVerticalPadding: CGFloat { _interTextVerticalPaddingOverride ?? globalTokens.spacing[.xxxSmall] }

    fileprivate var _mainContentVerticalPaddingOverride: CGFloat?
    var mainContentVerticalPadding: CGFloat { _mainContentVerticalPaddingOverride ?? globalTokens.spacing[.small] }

    fileprivate var _minimumHeightOverride: CGFloat?
    var minimumHeight: CGFloat { _minimumHeightOverride ?? 56.0 }

    fileprivate var _outlineColorOverride: ColorSet?
    var outlineColor: ColorSet { _outlineColorOverride ?? aliasTokens.backgroundColors[.neutral2] }

    fileprivate var _outlineWidthOverride: CGFloat?
    var outlineWidth: CGFloat { _outlineWidthOverride ?? globalTokens.borderSize[.thin] }

    fileprivate var _subtitleTextColorOverride: ColorSet?
    var subtitleTextColor: ColorSet { _subtitleTextColorOverride ?? aliasTokens.foregroundColors[.neutral3] }

    fileprivate var _textColorOverride: ColorSet?
    var textColor: ColorSet { _textColorOverride ?? aliasTokens.foregroundColors[.neutral1] }

    fileprivate var _verticalPaddingOverride: CGFloat?
    var verticalPadding: CGFloat { _verticalPaddingOverride ?? globalTokens.spacing[.xSmall] }
}

class OutlineCardNudgeTokens: CardNudgeTokens {
    // Token overrides
    override var backgroundColor: ColorSet { _backgroundColorOverride ?? aliasTokens.backgroundColors[.neutral1] }
    override var outlineColor: ColorSet { _outlineColorOverride ?? aliasTokens.strokeColors[.neutral1] }
    override var textColor: ColorSet { _textColorOverride ?? globalTokens.brandColors[.shade20] }
}
