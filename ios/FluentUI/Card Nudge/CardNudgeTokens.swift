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
open class CardNudgeTokens: ControlTokens {
    // Required state value
    public internal(set) var style: MSFCardNudgeStyle = .standard

    // MARK: - Design Tokens

    open var accentColor: DynamicColor { globalTokens.brandColors[.shade20] }

    open var accentIconSize: CGFloat { globalTokens.iconSize[.xxSmall] }

    open var accentPadding: CGFloat { globalTokens.spacing[.xxSmall] }

    open var backgroundColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.backgroundColors[.neutral1]
        }
    }

    open var buttonBackgroundColor: DynamicColor { globalTokens.brandColors[.tint30] }

    open var buttonInnerPaddingHorizontal: CGFloat { globalTokens.spacing[.small] }

    open var circleRadius: CGFloat { globalTokens.borderRadius[.circle] }

    open var circleSize: CGFloat { globalTokens.iconSize[.xxLarge] }

    open var cornerRadius: CGFloat { globalTokens.borderRadius[.xLarge] }

    open var horizontalPadding: CGFloat { globalTokens.spacing[.medium] }

    open var iconSize: CGFloat { globalTokens.iconSize[.xSmall] }

    open var interTextVerticalPadding: CGFloat { globalTokens.spacing[.xxxSmall] }

    open var mainContentVerticalPadding: CGFloat { globalTokens.spacing[.small] }

    open var minimumHeight: CGFloat { 56.0 }

    open var outlineColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.strokeColors[.neutral1]
        }
    }

    open var outlineWidth: CGFloat { globalTokens.borderSize[.thin] }

    open var subtitleTextColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    open var textColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.foregroundColors[.neutral1]
        case .outline:
            return globalTokens.brandColors[.shade20]
        }
    }

    open var verticalPadding: CGFloat { globalTokens.spacing[.xSmall] }
}
