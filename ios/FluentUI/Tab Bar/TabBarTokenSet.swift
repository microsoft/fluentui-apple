//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TabBar`.
public class TabBarTokenSet: ControlTokenSet<TabBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The height of the `TabBar` when in portrait view on a phone
        case phonePortraitHeight

        /// The height of the `TabBar` when in landscape view on a phone
        case phoneLandscapeHeight

        /// The height of the `TabBar` when on a non-phone device
        case padHeight

        /// Defines the background color of the  of the `TabBarItem` when selected.
        case tabBarItemSelectedColor

        /// Defines the background color of the  of the `TabBarItem` when not selected.
        case tabBarItemUnselectedColor

        /// Font info for the title label when in portrait view
        case tabBarItemTitleLabelFontPortrait

        /// Font info for the title label when in landscape view
        case tabBarItemTitleLabelFontLandscape

    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .phonePortraitHeight:
            return .float { 48.0 }

        case .phoneLandscapeHeight:
            return .float { 40.0 }

        case .padHeight:
            return .float { 48.0 }

        case .tabBarItemSelectedColor:
            return .dynamicColor {
                assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                return self.aliasTokens.foregroundColors[.neutral1]
            }

        case .tabBarItemUnselectedColor:
            return .dynamicColor {
                assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                return self.aliasTokens.foregroundColors[.neutral1]
            }

        case .tabBarItemTitleLabelFontPortrait:
            return .fontInfo {
                assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                return self.aliasTokens.typography[.body1]
            }

        case .tabBarItemTitleLabelFontLandscape:
            return .fontInfo {
                assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                return self.aliasTokens.typography[.body1]
            }
        }
    }
}
