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

    open var accentColor: DynamicColor { aliasTokens.brandColors[.shade20] }

    open var accentIconSize: CGFloat { GlobalTokens.iconSize(.xxSmall) }

    open var accentPadding: CGFloat { GlobalTokens.spacing(.xxSmall) }

    open var backgroundColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.backgroundColors[.neutral1]
        }
    }

    open var buttonBackgroundColor: DynamicColor { aliasTokens.brandColors[.tint30] }

    open var buttonInnerPaddingHorizontal: CGFloat { GlobalTokens.spacing(.small) }

    open var circleRadius: CGFloat { GlobalTokens.borderRadius(.circle) }

    open var circleSize: CGFloat { GlobalTokens.iconSize(.xxLarge) }

    open var cornerRadius: CGFloat { GlobalTokens.borderRadius(.xLarge) }

    open var horizontalPadding: CGFloat { GlobalTokens.spacing(.medium) }

    open var iconSize: CGFloat { GlobalTokens.iconSize(.xSmall) }

    open var interTextVerticalPadding: CGFloat { GlobalTokens.spacing(.xxxSmall) }

    open var mainContentVerticalPadding: CGFloat { GlobalTokens.spacing(.small) }

    open var minimumHeight: CGFloat { 56.0 }

    open var outlineColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.strokeColors[.neutral1]
        }
    }

    open var outlineWidth: CGFloat { GlobalTokens.borderSize(.thin) }

    open var subtitleTextColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    open var textColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.foregroundColors[.neutral1]
        case .outline:
            return aliasTokens.brandColors[.shade20]
        }
    }

    open var verticalPadding: CGFloat { GlobalTokens.spacing(.xSmall) }
}
