//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class TwoLineTitleViewTokenSet: ControlTokenSet<TwoLineTitleViewTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case subtitleColor
        case subtitleFont
        case titleColor
        case titleFont
    }

    init(style: @escaping () -> TwoLineTitleView.Style) {
        super.init { [style] token, theme in
            switch token {
            case .subtitleColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark)
                    case .system:
                        return theme.color(.foreground2)
                    }
                }
            case .subtitleFont:
                return .uiFont {
                    theme.typography(.caption1)
                }
            case .titleColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    case .system:
                        return theme.color(.foreground1)
                    }
                }
            case .titleFont:
                return .uiFont {
                    theme.typography(.body1Strong)
                }
            }
        }
    }
}
