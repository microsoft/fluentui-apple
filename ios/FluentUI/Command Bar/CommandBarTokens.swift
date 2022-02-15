//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `CommandBar` control.
public class CommandBarTokens: ControlTokens {
    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    open var groupBorderRadius: CGFloat { globalTokens.borderRadius[.xLarge] }

    open var groupInterspace: CGFloat { globalTokens.spacing[.medium] }

    open var itemBackgroundColor: ButtonDynamicColors { .init(rest: aliasTokens.backgroundColors[.neutral4],
                                                              hover: DynamicColor(light: aliasTokens.backgroundColors[.neutral5].light,
                                                                                  dark: aliasTokens.strokeColors[.neutral2].dark),
                                                              pressed: DynamicColor(light: aliasTokens.backgroundColors[.neutralDisabled].light,
                                                                                    dark: aliasTokens.backgroundColors[.neutral5].dark),
                                                              selected: aliasTokens.backgroundColors[.brandRest],
                                                              disabled: aliasTokens.strokeColors[.neutral1]) }

    open var itemFixedIconColor: DynamicColor { .init(light: aliasTokens.foregroundColors[.neutral1].light,
                                                      dark: aliasTokens.foregroundColors[.neutral3].dark) }

    open var itemIconColor: ButtonDynamicColors { .init(rest: aliasTokens.foregroundColors[.neutral1],
                                                        hover: aliasTokens.foregroundColors[.neutral1],
                                                        pressed: aliasTokens.foregroundColors[.neutral1],
                                                        selected: aliasTokens.foregroundColors[.neutralInverted],
                                                        disabled: aliasTokens.foregroundColors[.neutralDisabled]) }

    open var itemInterspace: CGFloat { globalTokens.spacing[.xxxSmall] }
}
