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

        /// The background color of a single Command Bar Item when in rest.
        case itemBackgroundColorRest

        /// The background color of a single Command Bar Item when hovered.
        case itemBackgroundColorHover

        /// The background color of a single Command Bar Item when pressed.
        case itemBackgroundColorPressed

        /// The background color of a single Command Bar Item when selected.
        case itemBackgroundColorSelected

        /// The background color of a single Command Bar Item when disabled.
        case itemBackgroundColorDisabled

        /// The icon color of a Command Bar Item when in rest.
        case itemIconColorRest

        /// The icon color of a Command Bar Item when hovered.
        case itemIconColorHover

        /// The icon color of a Command Bar Item when pressed.
        case itemIconColorPressed

        /// The icon color of a Command Bar Item when selected.
        case itemIconColorSelected

        /// The icon color of a Command Bar Item when disabled.
        case itemIconColorDisabled
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral1] }

            case .groupBorderRadius:
                return .float { GlobalTokens.borderRadius(.xLarge) }

            case .itemBackgroundColorRest:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral4] }

            case .itemBackgroundColorHover:
                return .dynamicColor {
                    DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral5].light,
                                 dark: theme.aliasTokens.strokeColors[.neutral2].dark)
                }

            case .itemBackgroundColorPressed:
                return .dynamicColor {
                    DynamicColor(light: theme.aliasTokens.backgroundColors[.neutralDisabled].light,
                                 dark: theme.aliasTokens.backgroundColors[.neutral5].dark)
                }

            case .itemBackgroundColorSelected:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.brandRest] }

            case .itemBackgroundColorDisabled:
                return .dynamicColor { theme.aliasTokens.strokeColors[.neutral1] }

            case .itemIconColorRest:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }

            case .itemIconColorHover:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }

            case .itemIconColorPressed:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }

            case .itemIconColorSelected:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutralInverted] }

            case .itemIconColorDisabled:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutralDisabled] }
            }
        }
    }
}

// MARK: - Constants

extension CommandBarTokenSet {
    /// The spacing between each Command Bar Group.
    static let groupInterspace: CGFloat = GlobalTokens.spacing(.xSmall)

    /// The spacing between each Command Bar Group for iPad.
    static let groupInterspaceWide: CGFloat = GlobalTokens.spacing(.medium)

    /// The spacing between each Command Bar Item.
    static let itemInterspace: CGFloat = GlobalTokens.spacing(.xxxSmall)

    /// The buffer spacing left/right of each Command Bar Group.
    static let leftRightBuffer: CGFloat = GlobalTokens.spacing(.xxxSmall)

    /// The gradient width of the keyboard dismiss.
    static let dismissGradientWidth: CGFloat = GlobalTokens.spacing(.medium)

    /// The edge inset values for the Command Bar.
    static let barInsets: CGFloat = GlobalTokens.spacing(.xSmall)

    /// The edge inset values for the Command Bar Button.
    static let buttonContentInsets = NSDirectionalEdgeInsets(top: 8.0,
                                                       leading: 10.0,
                                                       bottom: 8.0,
                                                       trailing: 10.0)
}
