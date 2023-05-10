//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TextColorStyle

@objc (MSFTextColorStyle)
public enum TextColorStyle: Int, CaseIterable {
    case regular
    case secondary
    case secondaryOnColor
    case white
    case primary
    case error

    func uiColor(fluentTheme: FluentTheme) -> UIColor {
        switch self {
        case .regular:
            return fluentTheme.color(.foreground1)
        case .secondary:
            return fluentTheme.color(.foreground2)
        case .secondaryOnColor:
            return UIColor(light: fluentTheme.color(.foregroundOnColor),
                           dark: fluentTheme.color(.foreground2))
        case .white:
            return fluentTheme.color(.foregroundLightStatic)
        case .primary:
            return fluentTheme.color(.brandForeground1)
        case .error:
            return fluentTheme.color(.dangerForeground2)
        }
    }
}

public class LabelTokenSet: ControlTokenSet<LabelTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case font
        case textColor
    }

    init(textStyle: @escaping () -> FluentTheme.TypographyToken,
         colorStyle: @escaping () -> TextColorStyle) {
        self.textStyle = textStyle
        self.colorStyle = colorStyle
        super.init { [colorStyle] token, theme in
            switch token {
            case .font:
                return .uiFont {
                    return theme.typography(textStyle())
                }
            case .textColor:
                return .uiColor {
                    colorStyle().uiColor(fluentTheme: theme)
                }
            }
        }
    }

    /// Defines the text typography style of the label.
    var textStyle: () -> FluentTheme.TypographyToken
    /// Defines the text color style of the label.
    var colorStyle: () -> TextColorStyle
}
