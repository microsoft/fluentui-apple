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

        /// Defines the color of the border around the button.
        case borderColor

        /// Defines the color of the background of the button.
        case backgroundColor

        /// Defines the color of the icon of the button.
        case iconColor

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
                        return theme.globalTokens.borderRadius[.large]
                    case .large:
                        return theme.globalTokens.borderRadius[.xLarge]
                    }
                }

            case .borderSize:
                return .float {
                    switch style() {
                    case .primary, .ghost, .accentFloating, .subtleFloating:
                        return theme.globalTokens.borderSize[.none]
                    case .secondary:
                        return theme.globalTokens.borderSize[.thin]
                    }
                }

            case .iconSize:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return theme.globalTokens.iconSize[.xSmall]
                        case .medium,
                                .large:
                            return theme.globalTokens.iconSize[.small]
                        }
                    case .accentFloating, .subtleFloating:
                        return theme.globalTokens.iconSize[.medium]
                    }
                }

            case .interspace:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return theme.globalTokens.spacing[.xxSmall]
                        case .medium, .large:
                            return theme.globalTokens.spacing[.xSmall]
                        }
                    case .accentFloating, .subtleFloating:
                        return theme.globalTokens.spacing[.xSmall]
                    }
                }

            case .horizontalPadding:
                return .float {
                    switch style() {
                    case .primary, .secondary, .ghost:
                        switch size() {
                        case .small:
                            return theme.globalTokens.spacing[.xSmall]
                        case .medium:
                            return theme.globalTokens.spacing[.small]
                        case .large:
                            return theme.globalTokens.spacing[.large]
                        }
                    case .accentFloating:
                        switch size() {
                        case .small, .medium:
                            return theme.globalTokens.spacing[.small]
                        case .large:
                            return theme.globalTokens.spacing[.medium]
                        }
                    case .subtleFloating:
                        switch size() {
                        case .small, .medium:
                            return theme.globalTokens.spacing[.small]
                        case .large:
                            return theme.globalTokens.spacing[.medium]
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
                return .float { theme.globalTokens.iconSize[.medium] }

            case .textAdditionalHorizontalPadding:
                return .float {
                    switch size() {
                    case .small, .medium:
                        return theme.globalTokens.spacing[.xSmall]
                    case .large:
                        return theme.globalTokens.spacing[.xxSmall]
                    }
                }

            case .textColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primary, .accentFloating:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.neutralInverted],
                            hover: theme.aliasTokens.foregroundColors[.neutralInverted],
                            pressed: theme.aliasTokens.foregroundColors[.neutralInverted],
                            selected: theme.aliasTokens.foregroundColors[.neutralInverted],
                            disabled: theme.aliasTokens.foregroundColors[.neutralInverted]
                        )
                    case .subtleFloating:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.neutral3],
                            hover: theme.aliasTokens.foregroundColors[.neutral3],
                            pressed: theme.aliasTokens.foregroundColors[.neutral3],
                            selected: theme.aliasTokens.foregroundColors[.brandRest],
                            disabled: theme.aliasTokens.foregroundColors[.neutralDisabled]
                        )
                    case .secondary, .ghost:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.brandRest],
                            hover: theme.aliasTokens.foregroundColors[.brandHover],
                            pressed: theme.aliasTokens.foregroundColors[.brandPressed],
                            selected: theme.aliasTokens.foregroundColors[.brandSelected],
                            disabled: theme.aliasTokens.foregroundColors[.brandDisabled]
                        )
                    }
                }

            case .borderColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primary:
                        return .init(
                            rest: theme.aliasTokens.backgroundColors[.brandRest],
                            hover: theme.aliasTokens.backgroundColors[.brandHover],
                            pressed: theme.aliasTokens.backgroundColors[.brandPressed],
                            selected: theme.aliasTokens.backgroundColors[.brandSelected],
                            disabled: theme.aliasTokens.backgroundColors[.brandDisabled]
                        )
                    case .secondary, .accentFloating, .subtleFloating:
                        return .init(
                            rest: theme.aliasTokens.backgroundColors[.brandRest],
                            hover: theme.aliasTokens.backgroundColors[.brandHover],
                            pressed: theme.aliasTokens.backgroundColors[.brandPressed],
                            selected: theme.aliasTokens.backgroundColors[.brandSelected],
                            disabled: theme.aliasTokens.backgroundColors[.brandDisabled]
                        )
                    case .ghost:
                        return .init(
                            rest: DynamicColor(light: ColorValue.clear),
                            hover: DynamicColor(light: ColorValue.clear),
                            pressed: DynamicColor(light: ColorValue.clear),
                            selected: DynamicColor(light: ColorValue.clear),
                            disabled: DynamicColor(light: ColorValue.clear)
                        )
                    }
                }

            case .backgroundColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primary, .accentFloating:
                        return .init(
                            rest: theme.aliasTokens.backgroundColors[.brandRest],
                            hover: theme.aliasTokens.backgroundColors[.brandHover],
                            pressed: theme.aliasTokens.backgroundColors[.brandPressed],
                            selected: theme.aliasTokens.backgroundColors[.brandSelected],
                            disabled: theme.aliasTokens.backgroundColors[.brandDisabled]
                        )
                    case .secondary, .ghost:
                        return .init(
                            rest: DynamicColor(light: ColorValue.clear),
                            hover: DynamicColor(light: ColorValue.clear),
                            pressed: DynamicColor(light: ColorValue.clear),
                            selected: DynamicColor(light: ColorValue.clear),
                            disabled: DynamicColor(light: ColorValue.clear)
                        )
                    case .subtleFloating:
                        return .init(
                            rest: theme.aliasTokens.backgroundColors[.neutral1],
                            hover: theme.aliasTokens.backgroundColors[.neutral1],
                            pressed: theme.aliasTokens.backgroundColors[.neutral5],
                            selected: theme.aliasTokens.backgroundColors[.neutral1],
                            disabled: theme.aliasTokens.backgroundColors[.neutral1]
                        )
                    }
                }

            case .iconColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primary, .accentFloating:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.neutralInverted],
                            hover: theme.aliasTokens.foregroundColors[.neutralInverted],
                            pressed: theme.aliasTokens.foregroundColors[.neutralInverted],
                            selected: theme.aliasTokens.foregroundColors[.neutralInverted],
                            disabled: theme.aliasTokens.foregroundColors[.neutralInverted]
                        )
                    case .secondary, .ghost:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.brandRest],
                            hover: theme.aliasTokens.foregroundColors[.brandHover],
                            pressed: theme.aliasTokens.foregroundColors[.brandPressed],
                            selected: theme.aliasTokens.foregroundColors[.brandSelected],
                            disabled: theme.aliasTokens.foregroundColors[.brandDisabled]
                        )
                    case .subtleFloating:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.neutral3],
                            hover: theme.aliasTokens.foregroundColors[.neutral3],
                            pressed: theme.aliasTokens.foregroundColors[.neutral3],
                            selected: theme.aliasTokens.foregroundColors[.brandRest],
                            disabled: theme.aliasTokens.foregroundColors[.neutralDisabled]
                        )
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
