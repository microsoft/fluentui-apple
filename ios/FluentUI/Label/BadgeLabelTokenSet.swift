//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum BadgeLabelToken: Int, TokenSetKey {
    /// The background color of the BadgeLabel.
    case backgroundColor

    /// The text color of the BadgeLabel.
    case textColor
}

/// Design token set for the `BadgeLabel` control.
class BadgeLabelTokenSet: ControlTokenSet<BadgeLabelToken> {
    init(style: @escaping () -> BadgeLabelStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .textColor:
                return .uiColor {
                    switch style() {
                    case .onPrimary:
                        return UIColor(light: theme.color(.brandForeground1).light,
                                       dark: GlobalTokens.neutralColor(.white))
                    case .system:
                        return GlobalTokens.neutralColor(.white)
                    case .brand:
                        return theme.color(.foregroundOnColor)
                    }
                }
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .onPrimary:
                        return UIColor(light: GlobalTokens.neutralColor(.white),
                                       dark: theme.color(.brandBackground1).dark)
                    case .system:
                        return theme.color(.dangerBackground2)
                    case .brand:
                        return theme.color(.brandBackground1)
                    }
                }
            }
        }
    }

    /// Defines the style of the BadgeLabel.
    var style: () -> BadgeLabelStyle
}
