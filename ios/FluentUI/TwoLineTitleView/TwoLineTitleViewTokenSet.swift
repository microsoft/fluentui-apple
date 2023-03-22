//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TwoLineTitleView` control.
public class TwoLineTitleViewTokenSet: ControlTokenSet<TwoLineTitleViewTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Describes the color of the subtitle.
        case subtitleColor

        /// Describes the font used for the subtitle.
        case subtitleFont

        /// Describes the color of the title.
        case titleColor

        /// Describes the font used for the title.
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
