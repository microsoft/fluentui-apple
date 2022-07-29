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

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .backgroundColor:
            return .dynamicColor { self.aliasTokens.backgroundColors[.neutral1] }

        case .groupBorderRadius:
            return .float { self.globalTokens.borderRadius[.xLarge] }

        case .groupInterspace:
            return .float { self.globalTokens.spacing[.medium] }

        case .itemBackgroundColor:
            return .buttonDynamicColors {
                ButtonDynamicColors(rest:self.aliasTokens.backgroundColors[.neutral4],
                                    hover: DynamicColor(light: self.aliasTokens.backgroundColors[.neutral5].light,
                                                        dark: self.aliasTokens.strokeColors[.neutral2].dark),
                                    pressed: DynamicColor(light: self.aliasTokens.backgroundColors[.neutralDisabled].light,
                                                          dark: self.aliasTokens.backgroundColors[.neutral5].dark),
                                    selected: self.aliasTokens.backgroundColors[.brandRest],
                                    disabled: self.aliasTokens.strokeColors[.neutral1]) }

        case .itemFixedIconColor:
            return .dynamicColor {
                DynamicColor(light: self.aliasTokens.foregroundColors[.neutral1].light,
                             dark: self.aliasTokens.foregroundColors[.neutral3].dark) }

        case .itemIconColor:
            return .buttonDynamicColors {
                ButtonDynamicColors(rest: self.aliasTokens.foregroundColors[.neutral1],
                                    hover: self.aliasTokens.foregroundColors[.neutral1],
                                    pressed: self.aliasTokens.foregroundColors[.neutral1],
                                    selected: self.aliasTokens.foregroundColors[.neutralInverted],
                                    disabled: self.aliasTokens.foregroundColors[.neutralDisabled]) }

        case .itemInterspace:
            return .float { self.globalTokens.spacing[.xxxSmall] }
        }
    }
}
