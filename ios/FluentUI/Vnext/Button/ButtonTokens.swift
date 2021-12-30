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
public class ButtonTokens: ControlTokens {
    public init(style: MSFButtonStyle,
                size: MSFButtonSize) {
        self.style = style
        self.size = size

        super.init()
    }

    let style: MSFButtonStyle
    let size: MSFButtonSize

    lazy var borderRadius: CGFloat = {
        switch size {
        case .small:
            return globalTokens.borderRadius[.large]
        case .medium:
            return globalTokens.borderRadius[.large]
        case .large:
            return globalTokens.borderRadius[.xLarge]
        }
    }()

    lazy var borderSize: CGFloat = {
        switch style {
        case .secondary:
            return globalTokens.borderSize[.thin]
        default:
            return globalTokens.borderSize[.none]
        }
    }()

    lazy var iconSize: CGFloat = {
        switch size {
        case .small:
            return globalTokens.iconSize[.xSmall]
        case .medium:
            return globalTokens.iconSize[.small]
        case .large:
            return globalTokens.iconSize[.small]
        }
    }()

    lazy var interspace: CGFloat = {
        switch size {
        case .small:
            return globalTokens.spacing[.xxSmall]
        case .medium:
            return globalTokens.spacing[.xSmall]
        case .large:
            return globalTokens.spacing[.xSmall]
        }
    }()

    lazy var padding: CGFloat = {
        switch size {
        case .small:
            return globalTokens.spacing[.xSmall]
        case .medium:
            return globalTokens.spacing[.small]
        case .large:
            return globalTokens.spacing[.large]
        }
    }()

    lazy var textFont: FontInfo = {
        switch size {
        case .small:
            return aliasTokens.typography[.caption1Strong]
        case .medium:
            return aliasTokens.typography[.caption1Strong]
        case .large:
            return aliasTokens.typography[.body1Strong]
        }
    }()

    lazy var textMinimumHeight: CGFloat = globalTokens.iconSize[.medium]

    lazy var textAdditionalHorizontalPadding: CGFloat = {
        switch size {
        case .small:
            return globalTokens.spacing[.xSmall]
        case .medium:
            return globalTokens.spacing[.xSmall]
        case .large:
            return globalTokens.spacing[.xxSmall]
        }
    }()

    lazy var titleColor: ButtonDynamicColors = {
        switch style {
        case .primary:
            return .init(
                rest: aliasTokens.foregroundColors[.neutralInverted],
                hover: aliasTokens.foregroundColors[.neutralInverted],
                pressed: aliasTokens.foregroundColors[.neutralInverted],
                selected: aliasTokens.foregroundColors[.neutralInverted],
                disabled: aliasTokens.foregroundColors[.neutralInverted]
            )
        default:
            return .init(
                rest: aliasTokens.foregroundColors[.brandRest],
                hover: aliasTokens.foregroundColors[.brandHover],
                pressed: aliasTokens.foregroundColors[.brandPressed],
                selected: aliasTokens.foregroundColors[.brandSelected],
                disabled: aliasTokens.foregroundColors[.brandDisabled]
            )
        }
    }()

    lazy var borderColor: ButtonDynamicColors = {
        switch style {
        case .primary:
            return .init(
                rest: aliasTokens.backgroundColors[.brandRest],
                hover: aliasTokens.backgroundColors[.brandHover],
                pressed: aliasTokens.backgroundColors[.brandPressed],
                selected: aliasTokens.backgroundColors[.brandSelected],
                disabled: aliasTokens.backgroundColors[.brandDisabled]
            )
        case .ghost:
            return .init(
                rest: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                hover: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                pressed: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                selected: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                disabled: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0))
            )
        default:
            return .init(
                rest: aliasTokens.backgroundColors[.brandRest],
                hover: aliasTokens.backgroundColors[.brandHover],
                pressed: aliasTokens.backgroundColors[.brandPressed],
                selected: aliasTokens.backgroundColors[.brandSelected],
                disabled: aliasTokens.backgroundColors[.brandDisabled]
            )}
    }()

    lazy var backgroundColor: ButtonDynamicColors = {
        switch style {
        case .primary:
            return .init(
                rest: aliasTokens.backgroundColors[.brandRest],
                hover: aliasTokens.backgroundColors[.brandHover],
                pressed: aliasTokens.backgroundColors[.brandPressed],
                selected: aliasTokens.backgroundColors[.brandSelected],
                disabled: aliasTokens.backgroundColors[.brandDisabled])
        default:
            return .init(
                rest: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                hover: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                pressed: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                selected: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0)),
                disabled: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0))
            )
        }
    }()

    lazy var iconColor: ButtonDynamicColors = {
        switch style {
        case .primary:
            return .init(
                rest: aliasTokens.foregroundColors[.neutralInverted],
                hover: aliasTokens.foregroundColors[.neutralInverted],
                pressed: aliasTokens.foregroundColors[.neutralInverted],
                selected: aliasTokens.foregroundColors[.neutralInverted],
                disabled: aliasTokens.foregroundColors[.neutralInverted]
            )
        default:
            return .init(
                rest: aliasTokens.foregroundColors[.brandRest],
                hover: aliasTokens.foregroundColors[.brandHover],
                pressed: aliasTokens.foregroundColors[.brandPressed],
                selected: aliasTokens.foregroundColors[.brandSelected],
                disabled: aliasTokens.foregroundColors[.brandDisabled]
            )
        }
    }()

    lazy var restShadow: ShadowInfo = aliasTokens.elevation[.interactiveElevation1Rest]

    lazy var pressedShadow: ShadowInfo = aliasTokens.elevation[.interactiveElevation1Pressed]
}
