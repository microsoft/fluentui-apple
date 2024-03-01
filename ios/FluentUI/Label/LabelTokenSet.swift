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
    case white
    case primary
    case error

    func uiColor(fluentTheme: FluentTheme) -> UIColor {
        switch self {
        case .regular:
            return fluentTheme.color(.foreground1)
        case .secondary:
            return fluentTheme.color(.foreground2)
        case .white:
            return fluentTheme.color(.foregroundLightStatic)
        case .primary:
            return fluentTheme.color(Compatibility.isDeviceIdiomVision() ? .foreground1 : .brandForeground1)
        case .error:
            return fluentTheme.color(.dangerForeground2)
        }
    }
}

public enum LabelToken: Int, TokenSetKey {
    case font
    case textColor
}

public class LabelTokenSet: ControlTokenSet<LabelToken> {
    convenience init(textStyle: @escaping () -> FluentTheme.TypographyToken,
                     colorStyle: @escaping () -> TextColorStyle) {
        self.init(textStyle: textStyle, colorForTheme: { colorStyle().uiColor(fluentTheme: $0) })
    }

    init(textStyle: @escaping () -> FluentTheme.TypographyToken,
         colorForTheme: @escaping (FluentTheme) -> UIColor) {
        self.textStyle = textStyle
        self.colorForTheme = colorForTheme
        super.init { [colorForTheme] token, theme in
            switch token {
            case .font:
                return .uiFont {
                    return theme.typography(textStyle())
                }
            case .textColor:
                return .uiColor {
                    return colorForTheme(theme)
                }
            }
        }
    }

    /// Defines the text typography style of the label.
    var textStyle: () -> FluentTheme.TypographyToken
    /// Defines the text color style of the label for a given theme.
    var colorForTheme: (FluentTheme) -> UIColor
}
