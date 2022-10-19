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
        case buttonForegroundColor
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
                    theme.aliasTokens.colors[.brandForeground1]
                }

            case .backgroundColor:
                switch style() {
                case .standard:
                    return .dynamicColor {
                        theme.aliasTokens.colors[.canvasBackground]
                    }
                case .outline:
                    return .dynamicColor {
                        theme.aliasTokens.colors[.background1]
                    }
            }

            case .buttonBackgroundColor:
                return .dynamicColor {
                    theme.aliasTokens.colors[.brandBackgroundTint]
                }

            case .buttonForegroundColor:
                return .dynamicColor {
                    theme.aliasTokens.colors[.brandForegroundTint]
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
                        theme.aliasTokens.colors[.canvasBackground]
                    }
                case .outline:
                    return .dynamicColor {
                        theme.aliasTokens.colors[.stroke2]
                    }
                }

            case .outlineWidth:
                return .float {
                    GlobalTokens.borderSize(.thinner)
                }

            case .subtitleTextColor:
                return .dynamicColor {
                    theme.aliasTokens.colors[.foreground2]
                }

            case .textColor:
                return .dynamicColor {
                    theme.aliasTokens.colors[.foreground1]
                }
            }
        }
    }

    // Required state value
    var style: () -> MSFCardNudgeStyle
}

// MARK: - Constants

extension CardNudgeTokenSet {
    static let iconSize: CGFloat = GlobalTokens.iconSize(.medium)
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
