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

open class CardNudgeTokens: ControlTokens {
    open var accentColor: ColorSet {
        return brandColors.shade20
    }

    open var accentIconSize: CGFloat {
        return GlobalTokens.Icon.Size.xxSmall.value
    }

    open var accentPadding: CGFloat {
        return GlobalTokens.Spacing.xxSmall.value
    }

    open var backgroundColor: ColorSet {
        switch style {
        case .standard:
            return AliasTokens.Colors.Background.neutral2.value
        case .outline:
            return AliasTokens.Colors.Background.neutral1.value
        }
    }

    open var buttonBackgroundColor: ColorSet {
        return brandColors.tint30
    }

    open var buttonInnerPaddingHorizontal: CGFloat {
        return GlobalTokens.Spacing.small.value
    }

    open var circleSize: CGFloat {
        return GlobalTokens.Icon.Size.xxLarge.value
    }

    open var cornerRadius: CGFloat {
        return GlobalTokens.Border.Radius.xLarge.value
    }

    open var horizontalPadding: CGFloat {
        return GlobalTokens.Spacing.medium.value
    }

    open var iconSize: CGFloat {
        return GlobalTokens.Icon.Size.xSmall.value
    }

    open var interTextVerticalPadding: CGFloat {
        return GlobalTokens.Spacing.xxxSmall.value
    }

    open var mainContentVerticalPadding: CGFloat {
        return GlobalTokens.Spacing.small.value
    }

    open var minimumHeight: CGFloat {
        return 56.0
    }

    open var outlineColor: ColorSet {
        switch style {
        case .standard:
            return AliasTokens.Colors.Background.neutral2.value
        case .outline:
            return AliasTokens.Colors.Stroke.neutral1.value
        }
    }

    open var outlineWidth: CGFloat {
        return GlobalTokens.Border.Size.thin.value
    }

    open var subtitleTextColor: ColorSet {
        return AliasTokens.Colors.Foreground.neutral3.value
    }

    open var textColor: ColorSet {
        switch style {
        case .standard:
            return AliasTokens.Colors.Foreground.neutral1.value
        case .outline:
            return brandColors.shade20
        }
    }

    open var verticalPadding: CGFloat {
        return GlobalTokens.Spacing.xSmall.value
    }

    // MARK: - Style

    private(set) var style: MSFCardNudgeStyle = .standard
    func style(_ style: MSFCardNudgeStyle) -> CardNudgeTokens {
        self.style = style
        return self
    }
}
