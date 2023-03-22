//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class SearchBarTokenSet: ControlTokenSet<SearchBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case backgroundColor
        case cancelButtonColor
        case clearIconColor
        case placeholderColor
        case activeSearchIconColor
        case inactiveSearchIconColor
        case textColor
        case tintColor
        case progressSpinnerColor
        case searchTextFieldCornerRadius
        case font
    }

    init(style: @escaping () -> SearchBar.Style) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.background5)
                    case .lightContent:
                        return UIColor(light: theme.color(.brandBackground2).light,
                                       dark: theme.color(.background5).dark)
                    }
                })
            case .cancelButtonColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground1)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                })
            case .clearIconColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground2)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark)
                    }
                })
            case .placeholderColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground3)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .activeSearchIconColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground1)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                })
            case .inactiveSearchIconColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground3)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .textColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground1)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                })
            case .tintColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground3)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .progressSpinnerColor:
                return .uiColor({
                    switch style() {
                    case .darkContent:
                        return theme.color(.foreground3)
                    case .lightContent:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .searchTextFieldCornerRadius:
                return .float({ 10.0 })
            case .font:
                return .uiFont({ theme.typography(.body1) })
            }
        }
    }

    var style: () -> SearchBar.Style
}

extension SearchBarTokenSet {
    static let searchTextFieldBackgroundHeight: CGFloat = 36.0
    static let searchIconImageViewDimension: CGFloat = 20
    static let searchIconInset: CGFloat = 10.0
    static let searchTextFieldLeadingInset: CGFloat = 10.0
    static let searchTextFieldVerticalInset: CGFloat = 2
    static let searchTextFieldInteractionMinWidth: CGFloat = 50
    static let clearButtonLeadingInset: CGFloat = 10
    static let clearButtonWidth: CGFloat = 8 + 16 + 8   // padding + image + padding
    static let clearButtonTrailingInset: CGFloat = 10
    static let cancelButtonLeadingInset: CGFloat = 8.0
    static var searchIconInsettedWidth: CGFloat {
        searchIconImageViewDimension + searchIconInset
    }
    static var clearButtonInsettedWidth: CGFloat {
        clearButtonLeadingInset + clearButtonWidth + clearButtonTrailingInset
    }
}
