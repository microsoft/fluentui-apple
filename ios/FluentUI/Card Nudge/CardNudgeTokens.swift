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
    open var accentColor: ColorSet {
        return globalTokens.brandColors[.shade20]
    }

    open var accentIconSize: CGFloat {
        return globalTokens.iconSize[.xxSmall]
    }

    open var accentPadding: CGFloat {
        return globalTokens.spacing[.xxSmall]
    }

    open var backgroundColor: ColorSet {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.backgroundColors[.neutral1]
        }
    }

    open var buttonBackgroundColor: ColorSet {
        return globalTokens.brandColors[.tint30]
    }

    open var buttonInnerPaddingHorizontal: CGFloat {
        return globalTokens.spacing[.small]
    }

    open var circleSize: CGFloat {
        return globalTokens.iconSize[.xxLarge]
    }

    open var cornerRadius: CGFloat {
        return globalTokens.borderRadius[.xLarge]
    }

    open var horizontalPadding: CGFloat {
        return globalTokens.spacing[.medium]
    }

    open var iconSize: CGFloat {
        return globalTokens.iconSize[.xSmall]
    }

    open var interTextVerticalPadding: CGFloat {
        return globalTokens.spacing[.xxxSmall]
    }

    open var mainContentVerticalPadding: CGFloat {
        return globalTokens.spacing[.small]
    }

    open var minimumHeight: CGFloat {
        return 56.0
    }

    open var outlineColor: ColorSet {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.strokeColors[.neutral1]
        }
    }

    open var outlineWidth: CGFloat {
        return globalTokens.borderSize[.thin]
    }

    open var subtitleTextColor: ColorSet {
        return aliasTokens.foregroundColors[.neutral3]
    }

    open var textColor: ColorSet {
        switch style {
        case .standard:
            return aliasTokens.foregroundColors[.neutral1]
        case .outline:
            return globalTokens.brandColors[.shade20]
        }
    }

    open var verticalPadding: CGFloat {
        return globalTokens.spacing[.xSmall]
    }

    var style: MSFCardNudgeStyle = .standard
}
