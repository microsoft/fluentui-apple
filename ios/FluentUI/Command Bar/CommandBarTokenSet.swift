//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `CommandBar` control.
public class CommandBarTokenSet: ControlTokenSet<CommandBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the Command Bar.
        case backgroundColor

        /// The border radius for each group of item(s) inside the Command Bar.
        case groupBorderRadius

        /// The background color of a single Command Bar Item.
        case itemBackgroundColor

        /// The background color of a fixed Command Bar Item.
        case itemFixedIconColor

        /// The icon color of a Command Bar Item.
        case itemIconColor
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral1] }

            case .groupBorderRadius:
                return .float { GlobalTokens.borderRadius(.xLarge) }

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
            }
        }
    }
}

// MARK: - Constants

extension CommandBarTokenSet {
    /// The spacing between each Command Bar Group.
    static let groupInterspace: CGFloat = GlobalTokens.spacing(.medium)

    /// The spacing between each Command Bar Item.
    static let itemInterspace: CGFloat = GlobalTokens.spacing(.xxxSmall)

    /// The buffer spacing left/right of each Command Bar Group.
    static let leftRightBuffer: CGFloat = GlobalTokens.spacing(.xxxSmall)
}
