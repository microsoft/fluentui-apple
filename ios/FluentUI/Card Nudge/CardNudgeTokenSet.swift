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
public final class CardNudgeTokenSet: ControlTokenSet<CardNudgeTokenSet.Tokens> {
    // Required state value
    var style: MSFCardNudgeStyle = .standard

    public enum Tokens: TokenSetKey {
        case accentColor
        case backgroundColor
        case buttonBackgroundColor
        case outlineColor
        case subtitleTextColor
        case textColor
        case accentIconSize
        case accentPadding
        case buttonInnerPaddingHorizontal
        case circleRadius
        case circleSize
        case cornerRadius
        case horizontalPadding
        case iconSize
        case interTextVerticalPadding
        case mainContentVerticalPadding
        case minimumHeight
        case outlineWidth
        case verticalPadding
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .accentColor:
            return .dynamicColor({ self.globalTokens.brandColors[.shade20] })
        case .accentIconSize:
            return .float({ self.globalTokens.iconSize[.xxSmall] })
        case .accentPadding:
            return .float({ self.globalTokens.spacing[.xxSmall] })
        case .backgroundColor:
            switch style {
            case .standard:
                return .dynamicColor({ self.aliasTokens.backgroundColors[.neutral2] })
            case .outline:
                return .dynamicColor({ self.aliasTokens.backgroundColors[.neutral1] })
            }
        case .buttonBackgroundColor:
            return .dynamicColor({ self.globalTokens.brandColors[.tint30] })
        case .buttonInnerPaddingHorizontal:
            return .float({ self.globalTokens.spacing[.small] })
        case .circleRadius:
            return .float({ self.globalTokens.borderRadius[.circle] })
        case .circleSize:
            return .float({ self.globalTokens.iconSize[.xxLarge] })
        case .cornerRadius:
            return .float({ self.globalTokens.borderRadius[.xLarge] })
        case .horizontalPadding:
            return .float({ self.globalTokens.spacing[.medium] })
        case .iconSize:
            return .float({ self.globalTokens.iconSize[.xSmall] })
        case .interTextVerticalPadding:
            return .float({ self.globalTokens.spacing[.xxxSmall] })
        case .mainContentVerticalPadding:
            return .float({ self.globalTokens.spacing[.small] })
        case .minimumHeight:
            return .float({ 56 })
        case .outlineColor:
            switch style {
            case .standard:
                return .dynamicColor({ self.aliasTokens.backgroundColors[.neutral2] })
            case .outline:
                return .dynamicColor({ self.aliasTokens.strokeColors[.neutral1] })
            }
        case .outlineWidth:
            return .float({ self.globalTokens.borderSize[.thin] })
        case .subtitleTextColor:
            return .dynamicColor({ self.aliasTokens.foregroundColors[.neutral3] })
        case .textColor:
            switch style {
            case .standard:
                return .dynamicColor({ self.aliasTokens.foregroundColors[.neutral1] })
            case .outline:
                return .dynamicColor({ self.globalTokens.brandColors[.shade20] })
            }
        case .verticalPadding:
            return .float({ self.globalTokens.spacing[.xSmall] })
        }
    }
}
