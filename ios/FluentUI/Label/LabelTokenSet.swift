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

    init(style: @escaping () -> AliasTokens.TypographyTokens,
         colorStyle: @escaping () -> TextColorStyle) {
        self.style = style
        self.colorStyle = colorStyle
        super.init { [colorStyle] token, theme in
            switch token {
            case .font:
                return .fontInfo {
                    return theme.aliasTokens.typography[style()]
                }
            case .textColor:
                return .dynamicColor {
                    switch colorStyle() {
                    case .regular:
                        return theme.aliasTokens.colors[.foreground1]
                    case .secondary:
                        return theme.aliasTokens.colors[.foreground2]
                    case .white:
                        return DynamicColor(light: GlobalTokens.neutralColors(.white))
                    case .primary:
                        return theme.aliasTokens.colors[.brandForeground1]
                    case .error:
                        return theme.aliasTokens.colors[.dangerForeground2]
                    }
                }
            }
        }
    }

    /// Defines the text typography style of the label.
    var style: () -> AliasTokens.TypographyTokens
    /// Defines the text color style of the label.
    var colorStyle: () -> TextColorStyle
}
