//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum SearchBarToken: Int, TokenSetKey {
    /// The background color of the SearchBar
    case backgroundColor

    /// The background color of the cancel button
    case cancelButtonColor

    /// The background color of the clear icon
    case clearIconColor

    /// The color of the placeholder text
    case placeholderColor

    /// The color of the search icon when the user is typing
    case activeSearchIconColor

    /// The color of the search icon when the user isn't typing
    case inactiveSearchIconColor

    /// The color of the user's input text in the SearchBar
    case textColor

    /// The color of the search text field's cursor
    case searchCursorColor

    /// The color of the progress spinner
    case progressSpinnerColor

    /// The corner radius of the search text field
    case searchTextFieldCornerRadius

    /// The font used for the placeholder text, search input text and cancel button text
    case font
}

/// Design token set for the `SearchBar` control.
public class SearchBarTokenSet: ControlTokenSet<SearchBarToken> {
    init(style: @escaping () -> SearchBar.Style) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor({
                    switch style() {
                    case .onCanvas:
                        return theme.color(.background3)
                    case .darkContent, .onSystemNavigationBar:
                        return theme.color(.background5)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.brandBackground2).light,
                                       dark: theme.color(.background5).dark)
                    }
                })
            case .cancelButtonColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground1)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                })
            case .clearIconColor:
                return .uiColor({
                    switch style() {
                    case .onCanvas:
                        return theme.color(.foreground2)
                    case .darkContent, .onSystemNavigationBar:
                        return theme.color(.foreground3)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .placeholderColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground2)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark)
                    }
                })
            case .activeSearchIconColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground1)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                })
            case .inactiveSearchIconColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground3)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .textColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground1)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                })
            case .searchCursorColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground3)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .progressSpinnerColor:
                return .uiColor({
                    switch style() {
                    case .darkContent, .onCanvas, .onSystemNavigationBar:
                        return theme.color(.foreground3)
                    case .lightContent, .onBrandNavigationBar:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground3).dark)
                    }
                })
            case .searchTextFieldCornerRadius:
                return .float({ Compatibility.isDeviceIdiomVision() ? SearchBarTokenSet.searchTextFieldBackgroundHeight / 2 : 10.0 })
            case .font:
                return .uiFont({ theme.typography(.body1) })
            }
        }
    }

    var style: () -> SearchBar.Style
}

// MARK: Constants

extension SearchBarTokenSet {
    static let searchTextFieldBackgroundHeight: CGFloat = Compatibility.isDeviceIdiomVision() ? 44 : GlobalTokens.spacing(.size360)
    static let searchIconImageViewDimension: CGFloat = GlobalTokens.spacing(.size200)
    static let searchIconInset: CGFloat = GlobalTokens.spacing(.size100)
    static let searchTextFieldLeadingInset: CGFloat = GlobalTokens.spacing(.size100)
    static let searchTextFieldVerticalInset: CGFloat = GlobalTokens.spacing(.size20)
    static let searchTextFieldInteractionMinWidth: CGFloat = 50.0
    static let clearButtonLeadingInset: CGFloat = GlobalTokens.spacing(.size100)
    static let clearButtonWidth: CGFloat = GlobalTokens.spacing(.size80) + GlobalTokens.spacing(.size160) + GlobalTokens.spacing(.size80)   // padding + image + padding
    static let clearButtonTrailingInset: CGFloat = GlobalTokens.spacing(.size100)
    static let cancelButtonLeadingInset: CGFloat = GlobalTokens.spacing(.size80)
    static var searchIconInsettedWidth: CGFloat {
        searchIconImageViewDimension + searchIconInset
    }
    static var clearButtonInsettedWidth: CGFloat {
        clearButtonLeadingInset + clearButtonWidth + clearButtonTrailingInset
    }
    static let defaultStyle: SearchBar.Style = .onBrandNavigationBar
    static let cancelButtonShowHideAnimationDuration: TimeInterval = 0.25
    static let navigationBarTransitionHidingDelay: TimeInterval = 0.5
}

// MARK: SearchBar.Style

public extension SearchBar {
    @objc(MSFSearchBarStyle)
    enum Style: Int {
        @available(*, deprecated, message: "lightContent is now deprecated. Please use onBrandNavigationBar.")
        case lightContent
        @available(*, deprecated, message: "darkContent is now deprecated. Please use onSystemNavigationBar.")
        case darkContent
        case onCanvas
        case onSystemNavigationBar
        case onBrandNavigationBar
    }
}
