//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TabBar`.
public class TabBarTokenSet: ControlTokenSet<TabBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the background color of the  of the `TabBarItem` when selected.
        case tabBarItemSelectedColor

        /// Defines the background color of the  of the `TabBarItem` when not selected.
        case tabBarItemUnselectedColor

        /// Font info for the title label when in portrait view
        case tabBarItemTitleLabelFontPortrait

        /// Font info for the title label when in landscape view
        case tabBarItemTitleLabelFontLandscape

    }

    init() {
        super.init { token, theme in
            switch token {
            case .tabBarItemSelectedColor:
                return .dynamicColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.colors[.foreground1]
                }

            case .tabBarItemUnselectedColor:
                return .dynamicColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.colors[.foreground1]
                }

            case .tabBarItemTitleLabelFontPortrait:
                return .fontInfo {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.typography[.body1]
                }

            case .tabBarItemTitleLabelFontLandscape:
                return .fontInfo {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.typography[.body1]
                }
            }
        }
    }
}

extension TabBarTokenSet {
    /// The height of the `TabBar` when in portrait view on a phone
    static let phonePortraitHeight: CGFloat = 48.0

    /// The height of the `TabBar` when in landscape view on a phone
    static let phoneLandscapeHeight: CGFloat = 40.0

    /// The height of the `TabBar` when on a non-phone device
    static let padHeight: CGFloat = 48.0
}
