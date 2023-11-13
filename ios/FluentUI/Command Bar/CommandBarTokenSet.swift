//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum CommandBarToken: Int, TokenSetKey {
    /// The background color of the Command Bar.
    case backgroundColor

    /// The border radius for each group of item(s) inside the Command Bar.
    case groupBorderRadius

    /// The background color of a single Command Bar Item when in rest.
    case itemBackgroundColorRest

    /// The background color of a single Command Bar Item when hovered.
    case itemBackgroundColorHover

    /// The background color of a single Command Bar Item when pressed.
    case itemBackgroundColorPressed

    /// The background color of a single Command Bar Item when selected.
    case itemBackgroundColorSelected

    /// The background color of a single Command Bar Item when disabled.
    case itemBackgroundColorDisabled

    /// The icon color of a Command Bar Item when in rest.
    case itemIconColorRest

    /// The icon color of a Command Bar Item when hovered.
    case itemIconColorHover

    /// The icon color of a Command Bar Item when pressed.
    case itemIconColorPressed

    /// The icon color of a Command Bar Item when selected.
    case itemIconColorSelected

    /// The icon color of a Command Bar Item when disabled.
    case itemIconColorDisabled
}

/// Design token set for the `CommandBar` control.
public class CommandBarTokenSet: ControlTokenSet<CommandBarToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    UIColor(light: GlobalTokens.neutralColor(.grey98),
                            dark: GlobalTokens.neutralColor(.grey8))
                }

            case .groupBorderRadius:
                return .float { GlobalTokens.corner(.radius120) }

            case .itemBackgroundColorRest:
                return .uiColor { theme.color(.background5) }

            case .itemBackgroundColorHover:
                return .uiColor { theme.color(.background5) }

            case .itemBackgroundColorPressed:
                return .uiColor { theme.color(.background5Pressed) }

            case .itemBackgroundColorSelected:
                return .uiColor { theme.color(.brandBackgroundTint) }

            case .itemBackgroundColorDisabled:
                return .uiColor { theme.color(.background5) }

            case .itemIconColorRest:
                return .uiColor { theme.color(.foreground1) }

            case .itemIconColorHover:
                return .uiColor { theme.color(.foreground1) }

            case .itemIconColorPressed:
                return .uiColor { theme.color(.foreground1) }

            case .itemIconColorSelected:
                return .uiColor { theme.color(.brandForegroundTint) }

            case .itemIconColorDisabled:
                return .uiColor { theme.color(.foregroundDisabled1) }
            }
        }
    }
}

// MARK: - Constants

extension CommandBarTokenSet {
    /// The spacing between each Command Bar Group.
    static let groupInterspace: CGFloat = GlobalTokens.spacing(.size80)

    /// The spacing between each Command Bar Group for iPad.
    static let groupInterspaceWide: CGFloat = GlobalTokens.spacing(.size160)

    /// The spacing between each Command Bar Item.
    static let itemInterspace: CGFloat = GlobalTokens.spacing(.size20)

    /// The buffer spacing left/right of each Command Bar Group.
    static let leftRightBuffer: CGFloat = GlobalTokens.spacing(.size20)

    /// The gradient width of the keyboard dismiss.
    static let dismissGradientWidth: CGFloat = GlobalTokens.spacing(.size160)

    /// The edge inset values for the Command Bar.
    static let barInsets: CGFloat = GlobalTokens.spacing(.size80)

    /// The edge inset values for the Command Bar Button.
    static let buttonContentInsets = NSDirectionalEdgeInsets(top: 8.0,
                                                       leading: 10.0,
                                                       bottom: 8.0,
                                                       trailing: 10.0)
}
