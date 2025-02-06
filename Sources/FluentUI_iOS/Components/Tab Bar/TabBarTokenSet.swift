//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum TabBarToken: Int, TokenSetKey {
    /// Defines the background color of the `TabBarItem` when selected.
    case tabBarItemSelectedColor

    /// Defines the background color of the `TabBarItem` when not selected.
    case tabBarItemUnselectedColor

    /// Font info for the title label when in portrait view.
    case tabBarItemTitleLabelFontPortrait

    /// Font info for the title label when in landscape view.
    case tabBarItemTitleLabelFontLandscape

    /// Defines the color of the top separator.
    case separatorColor
}

/// Design token set for the `TabBar`.
public class TabBarTokenSet: ControlTokenSet<TabBarToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .tabBarItemSelectedColor:
                return .uiColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.color(.foreground1)
                }

            case .tabBarItemUnselectedColor:
                return .uiColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.color(.foreground1)
                }

            case .tabBarItemTitleLabelFontPortrait:
                return .uiFont {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.typography(.body1)
                }

            case .tabBarItemTitleLabelFontLandscape:
                return .uiFont {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.typography(.body1)
                }

            case .separatorColor:
                return .uiColor { theme.color(.stroke2) }
            }
        }
    }
}

extension TabBarTokenSet {
    /// The height of the `TabBar` when in portrait view on a phone.
    static let phonePortraitHeight: CGFloat = 48.0

    /// The height of the `TabBar` when in landscape view on a phone.
    static let phoneLandscapeHeight: CGFloat = 40.0

    /// The height of the `TabBar` when on a non-phone device.
    static let padHeight: CGFloat = 48.0
}
