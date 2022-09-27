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
public class CardNudgeTokenSet: ControlTokenSet<CardNudgeTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case accentColor
        case backgroundColor
        case buttonBackgroundColor
        case outlineColor
        case subtitleTextColor
        case textColor
        case circleRadius
        case cornerRadius
        case outlineWidth
    }

    init(style: @escaping () -> MSFCardNudgeStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .accentColor:
                return .dynamicColor {
                    theme.aliasTokens.brandColors[.shade20]
                }

            case .backgroundColor:
                switch style() {
                case .standard:
                    return .dynamicColor {
                        theme.aliasTokens.backgroundColors[.neutral2]
                    }
                case .outline:
                    return .dynamicColor {
                        theme.aliasTokens.backgroundColors[.neutral1]
                    }

                }
            case .buttonBackgroundColor:
                return .dynamicColor {
                    theme.aliasTokens.brandColors[.tint30]
                }

            case .circleRadius:
                return .float {
                    GlobalTokens.borderRadius(.circle)
                }

            case .cornerRadius:
                return .float {
                    GlobalTokens.borderRadius(.xLarge)
                }

            case .outlineColor:
                switch style() {
                case .standard:
                    return .dynamicColor {
                        theme.aliasTokens.backgroundColors[.neutral2]
                    }
                case .outline:
                    return .dynamicColor {
                        theme.aliasTokens.strokeColors[.neutral1]
                    }
                }

            case .outlineWidth:
                return .float {
                    GlobalTokens.borderSize(.thin)
                }

            case .subtitleTextColor:
                return .dynamicColor {
                    theme.aliasTokens.foregroundColors[.neutral3]
                }

            case .textColor:
                switch style() {
                case .standard:
                    return .dynamicColor {
                        theme.aliasTokens.foregroundColors[.neutral1]
                    }
                case .outline:
                    return .dynamicColor {
                        theme.aliasTokens.brandColors[.shade20]
                    }
                }
            }
        }
    }

    // Required state value
    var style: () -> MSFCardNudgeStyle
}

// MARK: - Constants

extension CardNudgeTokenSet {
    static let iconSize: CGFloat = GlobalTokens.iconSize(.xSmall)
    static let circleSize: CGFloat = GlobalTokens.iconSize(.xxLarge)
    static let accentIconSize: CGFloat = GlobalTokens.iconSize(.xxSmall)
    static let accentPadding: CGFloat = GlobalTokens.spacing(.xxSmall)

    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.medium)
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.xSmall)
    static let buttonInnerPaddingHorizontal: CGFloat = GlobalTokens.spacing(.small)
    static let interTextVerticalPadding: CGFloat = GlobalTokens.spacing(.xxxSmall)
    static let mainContentVerticalPadding: CGFloat = GlobalTokens.spacing(.small)

    static let minimumHeight: CGFloat = 56.0
}
