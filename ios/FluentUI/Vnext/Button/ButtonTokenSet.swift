//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Pre-defined styles of the button
@objc public enum MSFButtonStyle: Int, CaseIterable {
    case primary
    case secondary
    case ghost
    /// For use with small and large sizes only
    case accentFloating
    /// For use with small and large sizes only
    case subtleFloating

    var isFloatingStyle: Bool {
        return self == .accentFloating || self == .subtleFloating
    }
}

/// Pre-defined sizes of the button
@objc public enum MSFButtonSize: Int, CaseIterable {
    case small
    case medium
    case large
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
public class ButtonTokenSet: ControlTokenSet<ButtonTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the radius of the corners of the button.
        case borderRadius

        /// Defines the thickness of the border around the button.
        case borderSize

        /// Defines the size of the icon in the button.
        case iconSize

        /// Defines the space between the icon and text in the button.
        case interspace

        /// Defines the horizontal padding around the contents of the button.
        case horizontalPadding

        /// Defines the font used for the text of the button.
        case textFont

        /// Defines the minimum height of the text of the button.
        case textMinimumHeight

        /// Defines the additional padding added when a floating style button has text.
        case textAdditionalHorizontalPadding

        /// Defines the color of the text of the button.
        case textColor

        /// Defines the color of the text of the button when hovering.
        case textColorHover

        /// Defines the color of the text of the button when pressed.
        case textColorPressed

        /// Defines the color of the text of the button when selected.
        case textColorSelected

        /// Defines the color of the text of the button when disabled.
        case textColorDisabled

        /// Defines the color of the border around the button.
        case borderColor

        /// Defines the color of the border around the button when hovering.
        case borderColorHover

        /// Defines the color of the border around the button when pressed.
        case borderColorPressed

        /// Defines the color of the border around the button when selected.
        case borderColorSelected

        /// Defines the color of the border around the button when disabled.
        case borderColorDisabled

        /// Defines the color of the background of the button.
        case backgroundColor

        /// Defines the color of the background of the button when hovering.
        case backgroundColorHover

        /// Defines the color of the background of the button when pressed.
        case backgroundColorPressed

        /// Defines the color of the background of the button when selected.
        case backgroundColorSelected

        /// Defines the color of the background of the button when disabled.
        case backgroundColorDisabled

        /// Defines the color of the icon of the button.
        case iconColor

        /// Defines the color of the icon of the button when hovering.
        case iconColorHover

        /// Defines the color of the icon of the button when pressed.
        case iconColorPressed

        /// Defines the color of the icon of the button when selected.
        case iconColorSelected

        /// Defines the color of the icon of the button when disabled.
        case iconColorDisabled

        /// Defines the shadow used when a floating button is at rest.
        case restShadow

        /// Defines the shadow used when a floating button is pressed.
        case pressedShadow

        /// Defines the minimum height of the button.
        case minHeight

        /// Defines the minimum vertical padding around the content of the button.
        case minVerticalPadding
    }

    init(style: @escaping () -> MSFButtonStyle,
         size: @escaping () -> MSFButtonSize) {
        self.style = style
        self.size = size
        super.init { [style, size] token, theme in
            switch token {
            case .borderRadius:
                return .float {
                    switch size() {
                    case .small, .medium:
                        return GlobalTokens.corner(.radius80)
                    case .large:
                        return GlobalTokens.corner(.radius120)
                    }
                }

            case .borderSize:
                return .float {
                    switch style() {
                    case .primary, .ghost, .accentFloating, .subtleFloating:
                        return GlobalTokens.stroke(.widthNone)
                    case .secondary:
                        return GlobalTokens.stroke(.width10)
                    }
                }

            case .iconSize:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return GlobalTokens.icon(.size160)
                        case .medium,
                                .large:
                            return GlobalTokens.icon(.size200)
                        }
                    case .accentFloating, .subtleFloating:
                        return GlobalTokens.icon(.size240)
                    }
                }

            case .interspace:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return GlobalTokens.spacing(.size40)
                        case .medium, .large:
                            return GlobalTokens.spacing(.size80)
                        }
                    case .accentFloating, .subtleFloating:
                        return GlobalTokens.spacing(.size80)
                    }
                }

            case .horizontalPadding:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return GlobalTokens.spacing(.size80)
                        case .medium:
                            return GlobalTokens.spacing(.size120)
                        case .large:
                            return GlobalTokens.spacing(.size200)
                        }
                    case .accentFloating:
                        switch size() {
                        case .small, .medium:
                            return GlobalTokens.spacing(.size120)
                        case .large:
                            return GlobalTokens.spacing(.size160)
                        }
                    case .subtleFloating:
                        switch size() {
                        case .small, .medium:
                            return GlobalTokens.spacing(.size120)
                        case .large:
                            return GlobalTokens.spacing(.size160)
                        }
                    }
                }

            case .textFont:
                return .fontInfo {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small, .medium:
                            return theme.aliasTokens.typography[.caption1Strong]
                        case .large:
                            return theme.aliasTokens.typography[.body1Strong]
                        }
                    case .accentFloating:
                        switch size() {
                        case .small, .medium:
                            return theme.aliasTokens.typography[.body2Strong]
                        case .large:
                            return theme.aliasTokens.typography[.body1Strong]
                        }
                    case .subtleFloating:
                        switch size() {
                        case .small, .medium:
                            return theme.aliasTokens.typography[.body2Strong]
                        case .large:
                            return theme.aliasTokens.typography[.body1Strong]
                        }
                    }
                }

            case .textMinimumHeight:
                return .float { GlobalTokens.icon(.size240) }

            case .textAdditionalHorizontalPadding:
                return .float {
                    switch size() {
                    case .small, .medium:
                        return GlobalTokens.spacing(.size80)
                    case .large:
                        return GlobalTokens.spacing(.size40)
                    }
                }

            case .textColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }

            case .textColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }

            case .textColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1Pressed]
                    }
                }

            case .textColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }

            case .textColorDisabled:
                return .dynamicColor { theme.aliasTokens.colors[.foregroundDisabled1] }

            case .borderColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.colors[.brandForeground1]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }

            case .borderColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.colors[.brandStroke1]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .borderColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.colors[.brandStroke1Pressed]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .borderColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.colors[.brandStroke1]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .borderColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.colors[.foregroundDisabled1]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }

            case .backgroundColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.brandBackground1]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.background1]
                    }
                }

            case .backgroundColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.brandBackground1]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.background1]
                    }
                }

            case .backgroundColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.brandBackground1Pressed]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.background1Pressed]
                    }
                }

            case .backgroundColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.brandBackground1Pressed]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.background1Pressed]
                    }
                }

            case .backgroundColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.backgroundDisabled]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.background1]
                    }
                }

            case .iconColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }

            case .iconColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }

            case .iconColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1Pressed]
                    }
                }

            case .iconColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .subtleFloating:
                        return theme.aliasTokens.colors[.foreground2]
                    case .secondary, .ghost:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }

            case .iconColorDisabled:
                return .dynamicColor { theme.aliasTokens.colors[.foregroundDisabled1] }

            case .restShadow:
                return .shadowInfo { theme.aliasTokens.shadow[.shadow08] }

            case .pressedShadow:
                return .shadowInfo { theme.aliasTokens.shadow[.shadow02] }

            case .minHeight:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return 28
                        case .medium:
                            return 40
                        case .large:
                            return 52
                        }
                    case .accentFloating, .subtleFloating:
                        switch size() {
                        case .small, .medium:
                            return 48
                        case .large:
                            return 56
                        }
                    }
                }

            case .minVerticalPadding:
                return .float {
                    switch size() {
                    case .small:
                        return 5
                    case .medium:
                        return 10
                    case .large:
                        return 15
                    }
                }
            }
        }
    }

    /// Defines the style of the button.
    var style: () -> MSFButtonStyle

    /// Defines the size of the button.
    var size: () -> MSFButtonSize
}
