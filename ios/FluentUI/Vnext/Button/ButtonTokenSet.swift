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
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .borderRadius:
            return .float {
                switch self.size() {
                case .small, .medium:
                    return self.globalTokens.borderRadius[.large]
                case .large:
                    return self.globalTokens.borderRadius[.xLarge]
                }
            }

        case .borderSize:
            return .float {
                switch self.style() {
                case .primary, .ghost, .accentFloating, .subtleFloating:
                    return self.globalTokens.borderSize[.none]
                case .secondary:
                    return self.globalTokens.borderSize[.thin]
                }
            }

        case .iconSize:
            return .float {
                switch self.style() {
                case .primary, .secondary, .ghost:
                    switch self.size() {
                    case .small:
                        return self.globalTokens.iconSize[.xSmall]
                    case .medium,
                            .large:
                        return self.globalTokens.iconSize[.small]
                    }
                case .accentFloating, .subtleFloating:
                    return self.globalTokens.iconSize[.medium]
                }
            }

        case .interspace:
            return .float {
                switch self.style() {
                case .primary, .secondary, .ghost:
                    switch self.size() {
                    case .small:
                        return self.globalTokens.spacing[.xxSmall]
                    case .medium, .large:
                        return self.globalTokens.spacing[.xSmall]
                    }
                case .accentFloating, .subtleFloating:
                    return self.globalTokens.spacing[.xSmall]
                }
            }

        case .horizontalPadding:
            return .float {
                switch self.style() {
                case .primary, .secondary, .ghost:
                    switch self.size() {
                    case .small:
                        return self.globalTokens.spacing[.xSmall]
                    case .medium:
                        return self.globalTokens.spacing[.small]
                    case .large:
                        return self.globalTokens.spacing[.large]
                    }
                case .accentFloating:
                    switch self.size() {
                    case .small, .medium:
                        return self.globalTokens.spacing[.small]
                    case .large:
                        return self.globalTokens.spacing[.medium]
                    }
                case .subtleFloating:
                    switch self.size() {
                    case .small, .medium:
                        return self.globalTokens.spacing[.small]
                    case .large:
                        return self.globalTokens.spacing[.medium]
                    }
                }
            }

        case .textFont:
            return .fontInfo {
                switch self.style() {
                case .primary, .secondary, .ghost:
                    switch self.size() {
                    case .small, .medium:
                        return self.aliasTokens.typography[.caption1Strong]
                    case .large:
                        return self.aliasTokens.typography[.body1Strong]
                    }
                case .accentFloating:
                    switch self.size() {
                    case .small, .medium:
                        return self.aliasTokens.typography[.body2Strong]
                    case .large:
                        return self.aliasTokens.typography[.body1Strong]
                    }
                case .subtleFloating:
                    switch self.size() {
                    case .small, .medium:
                        return self.aliasTokens.typography[.body2Strong]
                    case .large:
                        return self.aliasTokens.typography[.body1Strong]
                    }
                }
            }

        case .textMinimumHeight:
            return .float { self.globalTokens.iconSize[.medium] }

        case .textAdditionalHorizontalPadding:
            return .float {
                switch self.size() {
                case .small, .medium:
                    return self.globalTokens.spacing[.xSmall]
                case .large:
                    return self.globalTokens.spacing[.xxSmall]
                }
            }

        case .textColor:
            return .buttonDynamicColors {
                switch self.style() {
                case .primary, .accentFloating:
                    return .init(
                        rest: self.aliasTokens.foregroundColors[.neutralInverted],
                        hover: self.aliasTokens.foregroundColors[.neutralInverted],
                        pressed: self.aliasTokens.foregroundColors[.neutralInverted],
                        selected: self.aliasTokens.foregroundColors[.neutralInverted],
                        disabled: self.aliasTokens.foregroundColors[.neutralInverted]
                    )
                case .subtleFloating:
                    return .init(
                        rest: self.aliasTokens.foregroundColors[.neutral3],
                        hover: self.aliasTokens.foregroundColors[.neutral3],
                        pressed: self.aliasTokens.foregroundColors[.neutral3],
                        selected: self.aliasTokens.foregroundColors[.brandRest],
                        disabled: self.aliasTokens.foregroundColors[.neutralDisabled]
                    )
                case .secondary, .ghost:
                    return .init(
                        rest: self.aliasTokens.foregroundColors[.brandRest],
                        hover: self.aliasTokens.foregroundColors[.brandHover],
                        pressed: self.aliasTokens.foregroundColors[.brandPressed],
                        selected: self.aliasTokens.foregroundColors[.brandSelected],
                        disabled: self.aliasTokens.foregroundColors[.brandDisabled]
                    )
                }
            }

        case .borderColor:
            return .buttonDynamicColors {
                switch self.style() {
                case .primary:
                    return .init(
                        rest: self.aliasTokens.backgroundColors[.brandRest],
                        hover: self.aliasTokens.backgroundColors[.brandHover],
                        pressed: self.aliasTokens.backgroundColors[.brandPressed],
                        selected: self.aliasTokens.backgroundColors[.brandSelected],
                        disabled: self.aliasTokens.backgroundColors[.brandDisabled]
                    )
                case .secondary, .accentFloating, .subtleFloating:
                    return .init(
                        rest: self.aliasTokens.backgroundColors[.brandRest],
                        hover: self.aliasTokens.backgroundColors[.brandHover],
                        pressed: self.aliasTokens.backgroundColors[.brandPressed],
                        selected: self.aliasTokens.backgroundColors[.brandSelected],
                        disabled: self.aliasTokens.backgroundColors[.brandDisabled]
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
                switch self.style() {
                case .primary, .accentFloating:
                    return .init(
                        rest: self.aliasTokens.backgroundColors[.brandRest],
                        hover: self.aliasTokens.backgroundColors[.brandHover],
                        pressed: self.aliasTokens.backgroundColors[.brandPressed],
                        selected: self.aliasTokens.backgroundColors[.brandSelected],
                        disabled: self.aliasTokens.backgroundColors[.brandDisabled]
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
                        rest: self.aliasTokens.backgroundColors[.neutral1],
                        hover: self.aliasTokens.backgroundColors[.neutral1],
                        pressed: self.aliasTokens.backgroundColors[.neutral5],
                        selected: self.aliasTokens.backgroundColors[.neutral1],
                        disabled: self.aliasTokens.backgroundColors[.neutral1]
                    )
                }
            }

        case .iconColor:
            return .buttonDynamicColors {
                switch self.style() {
                case .primary, .accentFloating:
                    return .init(
                        rest: self.aliasTokens.foregroundColors[.neutralInverted],
                        hover: self.aliasTokens.foregroundColors[.neutralInverted],
                        pressed: self.aliasTokens.foregroundColors[.neutralInverted],
                        selected: self.aliasTokens.foregroundColors[.neutralInverted],
                        disabled: self.aliasTokens.foregroundColors[.neutralInverted]
                    )
                case .secondary, .ghost:
                    return .init(
                        rest: self.aliasTokens.foregroundColors[.brandRest],
                        hover: self.aliasTokens.foregroundColors[.brandHover],
                        pressed: self.aliasTokens.foregroundColors[.brandPressed],
                        selected: self.aliasTokens.foregroundColors[.brandSelected],
                        disabled: self.aliasTokens.foregroundColors[.brandDisabled]
                    )
                case .subtleFloating:
                    return .init(
                        rest: self.aliasTokens.foregroundColors[.neutral3],
                        hover: self.aliasTokens.foregroundColors[.neutral3],
                        pressed: self.aliasTokens.foregroundColors[.neutral3],
                        selected: self.aliasTokens.foregroundColors[.brandRest],
                        disabled: self.aliasTokens.foregroundColors[.neutralDisabled]
                    )
                }
            }

        case .restShadow:
            return .shadowInfo { self.aliasTokens.elevation[.interactiveElevation1Rest] }

        case .pressedShadow:
            return .shadowInfo { self.aliasTokens.elevation[.interactiveElevation1Pressed] }

        case .minHeight:
            return .float {
                switch self.style() {
                case .primary, .secondary, .ghost:
                    switch self.size() {
                    case .small:
                        return 28
                    case .medium:
                        return 40
                    case .large:
                        return 52
                    }
                case .accentFloating, .subtleFloating:
                    switch self.size() {
                    case .small, .medium:
                        return 48
                    case .large:
                        return 56
                    }
                }
            }

        case .minVerticalPadding:
            return .float {
                switch self.size() {
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

    /// Defines the style of the button.
    var style: () -> MSFButtonStyle

    /// Defines the size of the button.
    var size: () -> MSFButtonSize
}
