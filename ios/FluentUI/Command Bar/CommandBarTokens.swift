//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Represents the set of `ColorSet` values for the various states of a button.
public struct ButtonColorSets {
    let rest: ColorSet
    let hover: ColorSet
    let pressed: ColorSet
    let selected: ColorSet
    let disabled: ColorSet
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
    public init(backgroundColor: ColorSet? = nil,
                groupBorderRadius: CGFloat? = nil,
                groupInterspace: CGFloat? = nil,
                itemBackgroundColor: ButtonColorSets? = nil,
                itemFixedIconColor: ColorSet? = nil,
                itemIconColor: ButtonColorSets? = nil,
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

    lazy var backgroundColor: ColorSet = aliasTokens.backgroundColors[.neutral1]

    lazy var groupBorderRadius: CGFloat = globalTokens.borderRadius[.xLarge]

    lazy var groupInterspace: CGFloat = globalTokens.spacing[.medium]

    lazy var itemBackgroundColor: ButtonColorSets = .init(rest: aliasTokens.backgroundColors[.neutral4],
                                                          hover: ColorSet(light: aliasTokens.backgroundColors[.neutral5].light,
                                                                          dark: aliasTokens.strokeColors[.neutral2].dark),
                                                          pressed: ColorSet(light: aliasTokens.backgroundColors[.neutralDisabled].light,
                                                                            dark: aliasTokens.backgroundColors[.neutral5].dark),
                                                          selected: aliasTokens.backgroundColors[.brandRest],
                                                          disabled: aliasTokens.strokeColors[.neutral1])

    lazy var itemFixedIconColor: ColorSet = ColorSet(light: aliasTokens.foregroundColors[.neutral1].light,
                                                     dark: aliasTokens.foregroundColors[.neutral3].dark)

    lazy var itemIconColor: ButtonColorSets = .init(rest: aliasTokens.foregroundColors[.neutral1],
                                                    hover: aliasTokens.foregroundColors[.neutral1],
                                                    pressed: aliasTokens.foregroundColors[.neutral1],
                                                    selected: aliasTokens.foregroundColors[.neutralInverted],
                                                    disabled: aliasTokens.foregroundColors[.neutralDisabled])

    lazy var itemInterspace: CGFloat = globalTokens.spacing[.xxxSmall]
}
