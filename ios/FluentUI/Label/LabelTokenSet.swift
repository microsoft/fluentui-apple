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
                return .font {
                    return theme.typography(textStyle())
                }
            case .textColor:
                return .color {
                    switch colorStyle() {
                    case .regular:
                        return theme.color(.foreground1)
                    case .secondary:
                        return theme.color(.foreground2)
                    case .white:
                        return theme.color(.foregroundLightStatic)
                    case .primary:
                        return theme.color(.brandForeground1)
                    case .error:
                        return theme.color(.dangerForeground2)
                    }
                }
            }
        }
    }

    /// Defines the text typography style of the label.
    var textStyle: () -> FluentTheme.TypographyToken
    /// Defines the text color style of the label.
    var colorStyle: () -> TextColorStyle
}
