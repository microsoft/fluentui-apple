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

    init(style: @escaping () -> MSFCardNudgeStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .accentColor:
                return .dynamicColor {
                    theme.aliasTokens.brandColors[.shade20]
                }

            case .accentIconSize:
                return .float {
                    GlobalTokens.iconSize(.xxSmall)
                }

            case .accentPadding:
                return .float {
                    GlobalTokens.spacing(.xxSmall)
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

            case .buttonInnerPaddingHorizontal:
                return .float {
                    GlobalTokens.spacing(.small)
                }

            case .circleRadius:
                return .float {
                    GlobalTokens.borderRadius(.circle)
                }

            case .circleSize:
                return .float {
                    GlobalTokens.iconSize(.xxLarge)
                }

            case .cornerRadius:
                return .float {
                    GlobalTokens.borderRadius(.xLarge)
                }

            case .horizontalPadding:
                return .float {
                    GlobalTokens.spacing(.medium)
                }

            case .iconSize:
                return .float {
                    GlobalTokens.iconSize(.xSmall)
                }

            case .interTextVerticalPadding:
                return .float {
                    GlobalTokens.spacing(.xxxSmall)
                }

            case .mainContentVerticalPadding:
                return .float {
                    GlobalTokens.spacing(.small)
                }

            case .minimumHeight:
                return .float {
                    56
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

            case .verticalPadding:
                return .float {
                    GlobalTokens.spacing(.xSmall)
                }
            }
        }
    }

    // Required state value
    var style: () -> MSFCardNudgeStyle
}
