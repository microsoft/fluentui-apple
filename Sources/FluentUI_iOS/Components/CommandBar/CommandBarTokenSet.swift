//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

@objc(MSFCommandBarStyle)
public enum CommandBarStyle: Int {
    /// Default style — solid background color.
    case primary

    /// Glass material background (UIGlassEffect on iOS 26+, UIBlurEffect on earlier).
    case glass
}

public enum CommandBarToken: Int, TokenSetKey {
    /// The background color of the Command Bar.
    case backgroundColor

    /// The corner radius for each Command Bar Button.
    case cornerRadius

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

    /// The font of a Command Bar Item Group label.
    case itemGroupLabelFont

    /// The shadows used by the `CommandBar`.
    case shadow

    /// The maximum width of each button in the CommandBar. When greater than 0, buttons will be constrained to this width and truncate text that exceeds it.
    case maxButtonWidth
}

/// Design token set for the `CommandBar` control.
public class CommandBarTokenSet: ControlTokenSet<CommandBarToken> {
    init(style: @escaping () -> CommandBarStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.background2)
                    case .glass:
                        return .clear
                    }
                }

            case .cornerRadius:
                return .float { GlobalTokens.corner(.radius120) }

            case .itemBackgroundColorRest:
                return .uiColor { .clear }

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

            case .itemGroupLabelFont:
                return .uiFont { theme.typography(.caption2, adjustsForContentSizeCategory: false) }

            case .shadow:
                return .shadowInfo { theme.shadow(.shadow08) }

            case .maxButtonWidth:
                return .float { 0.0 }
            }
        }
    }

    var style: () -> CommandBarStyle
}

// MARK: Constants
extension CommandBarTokenSet {
    static let glassEffectShadowColor: CGColor = UIColor.black.cgColor
    static let glassEffectShadowOpacity: Float = 0.25
    static let glassEffectShadowOffset: CGSize = CGSize(width: 0, height: -2)
    static let glassEffectShadowRadius: CGFloat = 8
}

// MARK: - Constants

extension CommandBarTokenSet {
    /// The spacing between each Command Bar Group.
    static let groupInterspace: CGFloat = GlobalTokens.spacing(.size20)

    /// The spacing between each Command Bar Group for iPad.
    static let groupInterspaceWide: CGFloat = GlobalTokens.spacing(.size160)

    /// The spacing between each Command Bar Item.
    static let itemInterspace: CGFloat = GlobalTokens.spacing(.size20)

    /// The buffer spacing left/right of each Command Bar Group.
    static let leftRightBuffer: CGFloat = GlobalTokens.spacing(.size20)

    /// The gradient width of the keyboard dismiss.
    static let dismissGradientWidth: CGFloat = GlobalTokens.spacing(.size160)

    /// The edge inset values for the Command Bar.
    static let barInsets: CGFloat = GlobalTokens.spacing(.size40)

    /// The edge inset values for the Command Bar Button.
    static let buttonContentInsets = NSDirectionalEdgeInsets(top: 8.0,
                                                       leading: 10.0,
                                                       bottom: 8.0,
                                                       trailing: 10.0)

    /// The padding between the Command Bar Button image and title.
    static let buttonImagePadding: CGFloat = GlobalTokens.spacing(.size60)

    /// The top and bottom padding for the separator between Command Bar Groups.
    static let separatorVerticalPadding: CGFloat = GlobalTokens.spacing(.size80)
}
