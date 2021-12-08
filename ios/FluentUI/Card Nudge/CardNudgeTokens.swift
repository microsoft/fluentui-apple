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
    public init(accentColor: ColorSet? = nil,
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
                verticalPadding: CGFloat? = nil) {
        super.init()
        self.accentColor.override = accentColor
        self.accentIconSize.override = accentIconSize
        self.accentPadding.override = accentPadding
        self.backgroundColor.override = backgroundColor
        self.buttonBackgroundColor.override = buttonBackgroundColor
        self.buttonInnerPaddingHorizontal.override = buttonInnerPaddingHorizontal
        self.circleRadius.override = circleRadius
        self.circleSize.override = circleSize
        self.cornerRadius.override = cornerRadius
        self.horizontalPadding.override = horizontalPadding
        self.iconSize.override = iconSize
        self.interTextVerticalPadding.override = interTextVerticalPadding
        self.mainContentVerticalPadding.override = mainContentVerticalPadding
        self.minimumHeight.override = minimumHeight
        self.outlineColor.override = outlineColor
        self.outlineWidth.override = outlineWidth
        self.subtitleTextColor.override = subtitleTextColor
        self.textColor.override = textColor
        self.verticalPadding.override = verticalPadding
    }

    lazy var accentColor: OverridableToken<ColorSet> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.brandColors[.shade20]
    }

    lazy var accentIconSize: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.iconSize[.xxSmall]
    }

    lazy var accentPadding: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.spacing[.xxSmall]
    }

    lazy var backgroundColor: OverridableToken<ColorSet> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        switch strongSelf.style {
        case .standard:
            return strongSelf.aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return strongSelf.aliasTokens.backgroundColors[.neutral1]
        }
    }

    lazy var buttonBackgroundColor: OverridableToken<ColorSet> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.brandColors[.tint30]
    }

    lazy var buttonInnerPaddingHorizontal: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.spacing[.small]
    }

    lazy var circleRadius: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.borderRadius[.circle]
    }

    lazy var circleSize: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.iconSize[.xxLarge]
    }

    lazy var cornerRadius: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.borderRadius[.xLarge]
    }

    lazy var horizontalPadding: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.spacing[.medium]
    }

    lazy var iconSize: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.iconSize[.xSmall]
    }

    lazy var interTextVerticalPadding: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.spacing[.xxxSmall]
    }

    lazy var mainContentVerticalPadding: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.spacing[.small]
    }

    lazy var minimumHeight: OverridableToken<CGFloat> = .init {
        return 56.0
    }

    lazy var outlineColor: OverridableToken<ColorSet> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        switch strongSelf.style {
        case .standard:
            return strongSelf.aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return strongSelf.aliasTokens.strokeColors[.neutral1]
        }
    }

    lazy var outlineWidth: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.borderSize[.thin]
    }

    lazy var subtitleTextColor: OverridableToken<ColorSet> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.aliasTokens.foregroundColors[.neutral3]
    }

    lazy var textColor: OverridableToken<ColorSet> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        switch strongSelf.style {
        case .standard:
            return strongSelf.aliasTokens.foregroundColors[.neutral1]
        case .outline:
            return strongSelf.globalTokens.brandColors[.shade20]
        }
    }

    lazy var verticalPadding: OverridableToken<CGFloat> = .init { [weak self] in
        guard let strongSelf = self else { preconditionFailure() }
        return strongSelf.globalTokens.spacing[.xSmall]
    }

    var style: MSFCardNudgeStyle = .standard
}
