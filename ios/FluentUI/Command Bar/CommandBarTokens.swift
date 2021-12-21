//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Represents the set of `DynamicColor` values for the various states of a button.
public struct ButtonDynamicColors {
    let rest: DynamicColor
    let hover: DynamicColor
    let pressed: DynamicColor
    let selected: DynamicColor
    let disabled: DynamicColor
}

/// Design token set for the `CommandBar` control.
public class CommandBarTokens: ControlTokens {
    /// Creates an instance of `CommandBarTokens`.
    convenience public override init() {
        self.init(backgroundColor: nil,
                groupBorderRadius: nil,
                groupInterspace: nil,
                itemBackgroundColor: nil,
                itemFixedIconColor: nil,
                itemIconColor: nil,
                itemInterspace: nil)
    }

    /// Creates an instance of `CommandBarTokens` with optional token value overrides.
    public init(backgroundColor: DynamicColor? = nil,
                groupBorderRadius: CGFloat? = nil,
                groupInterspace: CGFloat? = nil,
                itemBackgroundColor: ButtonDynamicColors? = nil,
                itemFixedIconColor: DynamicColor? = nil,
                itemIconColor: ButtonDynamicColors? = nil,
                itemInterspace: CGFloat? = nil) {

        super.init()

        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let groupBorderRadius = groupBorderRadius {
            self.groupBorderRadius = groupBorderRadius
        }
        if let groupInterspace = groupInterspace {
            self.groupInterspace = groupInterspace
        }
        if let itemBackgroundColor = itemBackgroundColor {
            self.itemBackgroundColor = itemBackgroundColor
        }
        if let itemFixedIconColor = itemFixedIconColor {
            self.itemFixedIconColor = itemFixedIconColor
        }
        if let itemIconColor = itemIconColor {
            self.itemIconColor = itemIconColor
        }
        if let itemInterspace = itemInterspace {
            self.itemInterspace = itemInterspace
        }
    }

    lazy var backgroundColor: DynamicColor = aliasTokens.backgroundColors[.neutral1]

    lazy var groupBorderRadius: CGFloat = globalTokens.borderRadius[.xLarge]

    lazy var groupInterspace: CGFloat = globalTokens.spacing[.medium]

    lazy var itemBackgroundColor: ButtonDynamicColors = .init(rest: aliasTokens.backgroundColors[.neutral4],
                                                              hover: DynamicColor(light: aliasTokens.backgroundColors[.neutral5].light,
                                                                                  dark: aliasTokens.strokeColors[.neutral2].dark),
                                                              pressed: DynamicColor(light: aliasTokens.backgroundColors[.neutralDisabled].light,
                                                                                    dark: aliasTokens.backgroundColors[.neutral5].dark),
                                                              selected: aliasTokens.backgroundColors[.brandRest],
                                                              disabled: aliasTokens.strokeColors[.neutral1])

    lazy var itemFixedIconColor: DynamicColor = .init(light: aliasTokens.foregroundColors[.neutral1].light,
                                                      dark: aliasTokens.foregroundColors[.neutral3].dark)

    lazy var itemIconColor: ButtonDynamicColors = .init(rest: aliasTokens.foregroundColors[.neutral1],
                                                        hover: aliasTokens.foregroundColors[.neutral1],
                                                        pressed: aliasTokens.foregroundColors[.neutral1],
                                                        selected: aliasTokens.foregroundColors[.neutralInverted],
                                                        disabled: aliasTokens.foregroundColors[.neutralDisabled])

    lazy var itemInterspace: CGFloat = globalTokens.spacing[.xxxSmall]
}
