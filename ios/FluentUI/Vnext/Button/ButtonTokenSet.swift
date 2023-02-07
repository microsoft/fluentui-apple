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
                        return GlobalTokens.borderRadius(.large)
                    case .large:
                        return GlobalTokens.borderRadius(.xLarge)
                    }
                }

            case .borderSize:
                return .float {
                    switch style() {
                    case .primary, .ghost, .accentFloating, .subtleFloating:
                        return GlobalTokens.borderSize(.none)
                    case .secondary:
                        return GlobalTokens.borderSize(.thin)
                    }
                }

            case .iconSize:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return GlobalTokens.iconSize(.xSmall)
                        case .medium,
                                .large:
                            return GlobalTokens.iconSize(.small)
                        }
                    case .accentFloating, .subtleFloating:
                        return GlobalTokens.iconSize(.medium)
                    }
                }

            case .interspace:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return GlobalTokens.spacing(.xxSmall)
                        case .medium, .large:
                            return GlobalTokens.spacing(.xSmall)
                        }
                    case .accentFloating, .subtleFloating:
                        return GlobalTokens.spacing(.xSmall)
                    }
                }

            case .horizontalPadding:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return GlobalTokens.spacing(.xSmall)
                        case .medium:
                            return GlobalTokens.spacing(.small)
                        case .large:
                            return GlobalTokens.spacing(.large)
                        }
                    case .accentFloating:
                        switch size() {
                        case .small, .medium:
                            return GlobalTokens.spacing(.small)
                        case .large:
                            return GlobalTokens.spacing(.medium)
                        }
                    case .subtleFloating:
                        switch size() {
                        case .small, .medium:
                            return GlobalTokens.spacing(.small)
                        case .large:
                            return GlobalTokens.spacing(.medium)
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
                return .float { GlobalTokens.iconSize(.medium) }

            case .textAdditionalHorizontalPadding:
                return .float {
                    switch size() {
                    case .small, .medium:
                        return GlobalTokens.spacing(.xSmall)
                    case .large:
                        return GlobalTokens.spacing(.xxSmall)
                    }
                }

            case .textColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    }
                }

            case .textColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandHover]
                    }
                }

            case .textColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandPressed]
                    }
                }

            case .textColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandSelected]
                    }
                }

            case .textColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutralDisabled]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandDisabled]
                    }
                }

            case .borderColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.brandRest]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }

            case .borderColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.brandHover]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .borderColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.brandPressed]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .borderColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.brandSelected]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .borderColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary, .secondary, .accentFloating, .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.brandDisabled]
                    case .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }

            case .backgroundColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.backgroundColors[.brandRest]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.neutral1]
                    }
                }

            case .backgroundColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.backgroundColors[.brandHover]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.neutral1]
                    }
                }

            case .backgroundColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.backgroundColors[.brandPressed]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.neutral5]
                    }
                }

            case .backgroundColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.backgroundColors[.brandSelected]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.neutral1]
                    }
                }

            case .backgroundColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.backgroundColors[.brandDisabled]
                    case .secondary, .ghost:
                        return DynamicColor(light: ColorValue.clear)
                    case .subtleFloating:
                        return theme.aliasTokens.backgroundColors[.neutral1]
                    }
                }

            case .iconColor:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    }
                }

            case .iconColorHover:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandHover]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    }
                }

            case .iconColorPressed:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandPressed]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    }
                }

            case .iconColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandSelected]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    }
                }

            case .iconColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary, .accentFloating:
                        return theme.aliasTokens.foregroundColors[.neutralInverted]
                    case .secondary, .ghost:
                        return theme.aliasTokens.foregroundColors[.brandDisabled]
                    case .subtleFloating:
                        return theme.aliasTokens.foregroundColors[.neutralDisabled]
                    }
                }

            case .restShadow:
                return .shadowInfo { theme.aliasTokens.elevation[.interactiveElevation1Rest] }

            case .pressedShadow:
                return .shadowInfo { theme.aliasTokens.elevation[.interactiveElevation1Pressed] }

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
