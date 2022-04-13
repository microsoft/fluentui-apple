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
open class ButtonTokens: ControlTokens {
    /// Defines the style of the button.
    public internal(set) var style: MSFButtonStyle = .primary

    /// Defines the size of the button.
    public internal(set) var size: MSFButtonSize = .small

    /// Defines the radius of the corners of the button.
    open var borderRadius: CGFloat {
        switch size {
        case .small, .medium:
            return globalTokens.borderRadius[.large]
        case .large:
            return globalTokens.borderRadius[.xLarge]
        }
    }

    /// Defines the thickness of the border around the button.
    open var borderSize: CGFloat {
        switch style {
        case .primary, .ghost, .accentFloating, .subtleFloating:
            return globalTokens.borderSize[.none]
        case .secondary:
            return globalTokens.borderSize[.thin]
        }
    }

    /// Defines the size of the icon in the button.
    open var iconSize: CGFloat {
        switch style {
        case .primary, .secondary, .ghost:
            switch size {
            case .small:
                return globalTokens.iconSize[.xSmall]
            case .medium,
                    .large:
                return globalTokens.iconSize[.small]
            }
        case .accentFloating, .subtleFloating:
            return globalTokens.iconSize[.medium]
        }
    }

    /// Defines the space between the icon and text in the button.
    open var interspace: CGFloat {
        switch style {
        case .primary, .secondary, .ghost:
            switch size {
            case .small:
                return globalTokens.spacing[.xxSmall]
            case .medium, .large:
                return globalTokens.spacing[.xSmall]
            }
        case .accentFloating, .subtleFloating:
            return globalTokens.spacing[.xSmall]
        }
    }

    /// Defines the horizontal padding around the contents of the button.
    open var padding: CGFloat {
        switch style {
        case .primary, .secondary, .ghost:
            switch size {
            case .small:
                return globalTokens.spacing[.xSmall]
            case .medium:
                return globalTokens.spacing[.small]
            case .large:
                return globalTokens.spacing[.large]
            }
        case .accentFloating:
            switch size {
            case .small, .medium:
                return globalTokens.spacing[.small]
            case .large:
                return globalTokens.spacing[.medium]
            }
        case .subtleFloating:
            switch size {
            case .small, .medium:
                return globalTokens.spacing[.small]
            case .large:
                return globalTokens.spacing[.medium]
            }
        }
    }

    /// Defines the font used for the text of the button.
    open var textFont: FontInfo {
        switch style {
        case .primary, .secondary, .ghost:
            switch size {
            case .small, .medium:
                return aliasTokens.typography[.caption1Strong]
            case .large:
                return aliasTokens.typography[.body1Strong]
            }
        case .accentFloating:
            switch size {
            case .small, .medium:
                return aliasTokens.typography[.body2Strong]
            case .large:
                return aliasTokens.typography[.body1Strong]
            }
        case .subtleFloating:
            switch size {
            case .small, .medium:
                return aliasTokens.typography[.body2Strong]
            case .large:
                return aliasTokens.typography[.body1Strong]
            }
        }
    }

    /// Defines the minimum height of the text of the button.
    open var textMinimumHeight: CGFloat { globalTokens.iconSize[.medium] }

    /// Defines the additional padding added when a floating style button has text.
    open var textAdditionalHorizontalPadding: CGFloat {
        switch size {
        case .small, .medium:
            return globalTokens.spacing[.xSmall]
        case .large:
            return globalTokens.spacing[.xxSmall]
        }
    }

    /// Defines the color of the text of the button.
    open var textColor: ButtonDynamicColors {
        switch style {
        case .primary, .accentFloating:
            return .init(
                rest: aliasTokens.foregroundColors[.neutralInverted],
                hover: aliasTokens.foregroundColors[.neutralInverted],
                pressed: aliasTokens.foregroundColors[.neutralInverted],
                selected: aliasTokens.foregroundColors[.neutralInverted],
                disabled: aliasTokens.foregroundColors[.neutralInverted]
            )
        case .subtleFloating:
            return .init(
                rest: aliasTokens.foregroundColors[.neutral3],
                hover: aliasTokens.foregroundColors[.neutral3],
                pressed: aliasTokens.foregroundColors[.neutral3],
                selected: aliasTokens.foregroundColors[.brandRest],
                disabled: aliasTokens.foregroundColors[.neutralDisabled]
            )
        case .secondary, .ghost:
            return .init(
                rest: aliasTokens.foregroundColors[.brandRest],
                hover: aliasTokens.foregroundColors[.brandHover],
                pressed: aliasTokens.foregroundColors[.brandPressed],
                selected: aliasTokens.foregroundColors[.brandSelected],
                disabled: aliasTokens.foregroundColors[.brandDisabled]
            )
        }
    }

    /// Defines the color of the border around the button.
    open var borderColor: ButtonDynamicColors {
        switch style {
        case .primary:
            return .init(
                rest: aliasTokens.backgroundColors[.brandRest],
                hover: aliasTokens.backgroundColors[.brandHover],
                pressed: aliasTokens.backgroundColors[.brandPressed],
                selected: aliasTokens.backgroundColors[.brandSelected],
                disabled: aliasTokens.backgroundColors[.brandDisabled]
            )
        case .secondary, .accentFloating, .subtleFloating:
            return .init(
                rest: aliasTokens.backgroundColors[.brandRest],
                hover: aliasTokens.backgroundColors[.brandHover],
                pressed: aliasTokens.backgroundColors[.brandPressed],
                selected: aliasTokens.backgroundColors[.brandSelected],
                disabled: aliasTokens.backgroundColors[.brandDisabled]
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

    /// Defines the color of the background of the button.
    open var backgroundColor: ButtonDynamicColors {
        switch style {
        case .primary, .accentFloating:
            return .init(
                rest: aliasTokens.backgroundColors[.brandRest],
                hover: aliasTokens.backgroundColors[.brandHover],
                pressed: aliasTokens.backgroundColors[.brandPressed],
                selected: aliasTokens.backgroundColors[.brandSelected],
                disabled: aliasTokens.backgroundColors[.brandDisabled]
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
                rest: aliasTokens.backgroundColors[.neutral1],
                hover: aliasTokens.backgroundColors[.neutral1],
                pressed: aliasTokens.backgroundColors[.neutral5],
                selected: aliasTokens.backgroundColors[.neutral1],
                disabled: aliasTokens.backgroundColors[.neutral1]
            )
        }
    }

    /// Defines the color of the icon of the button.
    open var iconColor: ButtonDynamicColors {
        switch style {
        case .primary, .accentFloating:
            return .init(
                rest: aliasTokens.foregroundColors[.neutralInverted],
                hover: aliasTokens.foregroundColors[.neutralInverted],
                pressed: aliasTokens.foregroundColors[.neutralInverted],
                selected: aliasTokens.foregroundColors[.neutralInverted],
                disabled: aliasTokens.foregroundColors[.neutralInverted]
            )
        case .secondary, .ghost:
            return .init(
                rest: aliasTokens.foregroundColors[.brandRest],
                hover: aliasTokens.foregroundColors[.brandHover],
                pressed: aliasTokens.foregroundColors[.brandPressed],
                selected: aliasTokens.foregroundColors[.brandSelected],
                disabled: aliasTokens.foregroundColors[.brandDisabled]
            )
        case .subtleFloating:
            return .init(
                rest: aliasTokens.foregroundColors[.neutral3],
                hover: aliasTokens.foregroundColors[.neutral3],
                pressed: aliasTokens.foregroundColors[.neutral3],
                selected: aliasTokens.foregroundColors[.brandRest],
                disabled: aliasTokens.foregroundColors[.neutralDisabled]
            )
        }
    }

    /// Defines the shadow used when a floating button is at rest.
    open var restShadow: ShadowInfo { aliasTokens.elevation[.interactiveElevation1Rest] }

    /// Defines the shadow used when a floating button is pressed.
    open var pressedShadow: ShadowInfo { aliasTokens.elevation[.interactiveElevation1Pressed] }

    /// Defiens the minimum height of the button.
    open var minHeight: CGFloat {
        switch style {
        case .primary, .secondary, .ghost:
            switch size {
            case .small:
                return 28
            case .medium:
                return 40
            case .large:
                return 52
            }
        case .accentFloating, .subtleFloating:
            switch size {
            case .small, .medium:
                return 48
            case .large:
                return 56
            }
        }
    }

    /// Defines the minimum vertical padding around the content of the button.
    open var minVerticalPadding: CGFloat {
        switch size {
        case .small:
            return 5
        case .medium:
            return 10
        case .large:
            return 15
        }
    }
}
