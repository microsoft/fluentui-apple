//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `CommandBar` control.
public class CommandBarTokenSet: ControlTokenSet<CommandBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case backgroundColor
        case groupBorderRadius
        case groupInterspace
        case itemBackgroundColor
        case itemFixedIconColor
        case itemIconColor
        case itemInterspace
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral1] }

            case .groupBorderRadius:
                return .float { theme.globalTokens.borderRadius[.xLarge] }

            case .groupInterspace:
                return .float { theme.globalTokens.spacing[.medium] }

            case .itemBackgroundColor:
                return .buttonDynamicColors {
                    ButtonDynamicColors(rest: theme.aliasTokens.backgroundColors[.neutral4],
                                        hover: DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral5].light,
                                                            dark: theme.aliasTokens.strokeColors[.neutral2].dark),
                                        pressed: DynamicColor(light: theme.aliasTokens.backgroundColors[.neutralDisabled].light,
                                                              dark: theme.aliasTokens.backgroundColors[.neutral5].dark),
                                        selected: theme.aliasTokens.backgroundColors[.brandRest],
                                        disabled: theme.aliasTokens.strokeColors[.neutral1])
                }

            case .itemFixedIconColor:
                return .dynamicColor {
                    DynamicColor(light: theme.aliasTokens.foregroundColors[.neutral1].light,
                                 dark: theme.aliasTokens.foregroundColors[.neutral3].dark)
                }

            case .itemIconColor:
                return .buttonDynamicColors {
                    ButtonDynamicColors(rest: theme.aliasTokens.foregroundColors[.neutral1],
                                        hover: theme.aliasTokens.foregroundColors[.neutral1],
                                        pressed: theme.aliasTokens.foregroundColors[.neutral1],
                                        selected: theme.aliasTokens.foregroundColors[.neutralInverted],
                                        disabled: theme.aliasTokens.foregroundColors[.neutralDisabled])
                }

            case .itemInterspace:
                return .float { theme.globalTokens.spacing[.xxxSmall] }
            }
        }
    }
}
