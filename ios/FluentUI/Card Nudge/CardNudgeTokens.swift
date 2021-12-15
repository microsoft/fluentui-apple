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
    /// Creates an instance of `CardNudgeTokens`.
    convenience public init(style: MSFCardNudgeStyle) {
        self.init(style: style,
                  accentColor: nil,
                  accentIconSize: nil,
                  accentPadding: nil,
                  backgroundColor: nil,
                  buttonBackgroundColor: nil,
                  buttonInnerPaddingHorizontal: nil,
                  circleRadius: nil,
                  circleSize: nil,
                  cornerRadius: nil,
                  horizontalPadding: nil,
                  iconSize: nil,
                  interTextVerticalPadding: nil,
                  mainContentVerticalPadding: nil,
                  minimumHeight: nil,
                  outlineColor: nil,
                  outlineWidth: nil,
                  subtitleTextColor: nil,
                  textColor: nil,
                  verticalPadding: nil
        )
    }

    /// Creates an instance of `CardNudgeTokens` with optional token value overrides.
    public init(style: MSFCardNudgeStyle,
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
                verticalPadding: CGFloat? = nil) {

        self.style = style
        super.init()

        // Optional overrides
        if let accentColor = accentColor {
            self.accentColor = accentColor
        }
        if let accentIconSize = accentIconSize {
            self.accentIconSize = accentIconSize
        }
        if let accentPadding = accentPadding {
            self.accentPadding = accentPadding
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let buttonBackgroundColor = buttonBackgroundColor {
            self.buttonBackgroundColor = buttonBackgroundColor
        }
        if let buttonInnerPaddingHorizontal = buttonInnerPaddingHorizontal {
            self.buttonInnerPaddingHorizontal = buttonInnerPaddingHorizontal
        }
        if let circleRadius = circleRadius {
            self.circleRadius = circleRadius
        }
        if let circleSize = circleSize {
            self.circleSize = circleSize
        }
        if let cornerRadius = cornerRadius {
            self.cornerRadius = cornerRadius
        }
        if let horizontalPadding = horizontalPadding {
            self.horizontalPadding = horizontalPadding
        }
        if let iconSize = iconSize {
            self.iconSize = iconSize
        }
        if let interTextVerticalPadding = interTextVerticalPadding {
            self.interTextVerticalPadding = interTextVerticalPadding
        }
        if let mainContentVerticalPadding = mainContentVerticalPadding {
            self.mainContentVerticalPadding = mainContentVerticalPadding
        }
        if let minimumHeight = minimumHeight {
            self.minimumHeight = minimumHeight
        }
        if let outlineColor = outlineColor {
            self.outlineColor = outlineColor
        }
        if let outlineWidth = outlineWidth {
            self.outlineWidth = outlineWidth
        }
        if let subtitleTextColor = subtitleTextColor {
            self.subtitleTextColor = subtitleTextColor
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let verticalPadding = verticalPadding {
            self.verticalPadding = verticalPadding
        }
    }

    // Required state value
    let style: MSFCardNudgeStyle

    // MARK: - Design Tokens

    lazy var accentColor: ColorSet = globalTokens.brandColors[.shade20]

    lazy var accentIconSize: CGFloat = globalTokens.iconSize[.xxSmall]

    lazy var accentPadding: CGFloat = globalTokens.spacing[.xxSmall]

    lazy var backgroundColor: ColorSet = {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.backgroundColors[.neutral1]
        }
    }()

    lazy var buttonBackgroundColor: ColorSet = globalTokens.brandColors[.tint30]

    lazy var buttonInnerPaddingHorizontal: CGFloat = globalTokens.spacing[.small]

    lazy var circleRadius: CGFloat = globalTokens.borderRadius[.circle]

    lazy var circleSize: CGFloat = globalTokens.iconSize[.xxLarge]

    lazy var cornerRadius: CGFloat = globalTokens.borderRadius[.xLarge]

    lazy var horizontalPadding: CGFloat = globalTokens.spacing[.medium]

    lazy var iconSize: CGFloat = globalTokens.iconSize[.xSmall]

    lazy var interTextVerticalPadding: CGFloat = globalTokens.spacing[.xxxSmall]

    lazy var mainContentVerticalPadding: CGFloat = globalTokens.spacing[.small]

    lazy var minimumHeight: CGFloat = 56.0

    lazy var outlineColor: ColorSet = {
        switch style {
        case .standard:
            return aliasTokens.backgroundColors[.neutral2]
        case .outline:
            return aliasTokens.strokeColors[.neutral1]
        }
    }()

    lazy var outlineWidth: CGFloat = globalTokens.borderSize[.thin]

    lazy var subtitleTextColor: ColorSet = aliasTokens.foregroundColors[.neutral3]

    lazy var textColor: ColorSet = {
        switch style {
        case .standard:
            return aliasTokens.foregroundColors[.neutral1]
        case .outline:
            return globalTokens.brandColors[.shade20]
        }
    }()

    lazy var verticalPadding: CGFloat = globalTokens.spacing[.xSmall]
}
