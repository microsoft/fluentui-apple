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
    /// Creates an instance of `ButtonTokens`.
    public init(style: MSFButtonStyle,
                size: MSFButtonSize) {
        self.style = style
        self.size = size

        super.init()
    }

    /// Creates an instance of `ButtonTokens` with optional token value overrides.
    convenience public init(style: MSFButtonStyle,
                            size: MSFButtonSize,
                            borderRadius: CGFloat? = nil,
                            borderSize: CGFloat? = nil,
                            iconSize: CGFloat? = nil,
                            interspace: CGFloat? = nil,
                            padding: CGFloat? = nil,
                            textFont: FontInfo? = nil,
                            textMinimumHeight: CGFloat? = nil,
                            textAdditionalHorizontalPadding: CGFloat? = nil,
                            textColor: ButtonDynamicColors? = nil,
                            borderColor: ButtonDynamicColors? = nil,
                            backgroundColor: ButtonDynamicColors? = nil,
                            iconColor: ButtonDynamicColors? = nil,
                            restShadow: ShadowInfo? = nil,
                            pressedShadow: ShadowInfo? = nil) {
        self.init(style: style, size: size)

        // Optional overrides
        if let borderRadius = borderRadius {
            self.borderRadius = borderRadius
        }
        if let borderSize = borderSize {
            self.borderSize = borderSize
        }
        if let iconSize = iconSize {
            self.iconSize = iconSize
        }
        if let interspace = interspace {
            self.interspace = interspace
        }
        if let padding = padding {
            self.padding = padding
        }
        if let textFont = textFont {
            self.textFont = textFont
        }
        if let textMinimumHeight = textMinimumHeight {
            self.textMinimumHeight = textMinimumHeight
        }
        if let textAdditionalHorizontalPadding = textAdditionalHorizontalPadding {
            self.textAdditionalHorizontalPadding = textAdditionalHorizontalPadding
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let borderColor = borderColor {
            self.borderColor = borderColor
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let iconColor = iconColor {
            self.iconColor = iconColor
        }
        if let restShadow = restShadow {
            self.restShadow = restShadow
        }
        if let pressedShadow = pressedShadow {
            self.pressedShadow = pressedShadow
        }
    }

    let style: MSFButtonStyle
    let size: MSFButtonSize

    lazy var borderRadius: CGFloat = {
        switch size {
        case .small, .medium:
            return globalTokens.borderRadius[.large]
        case .large:
            return globalTokens.borderRadius[.xLarge]
        }
    }()

    lazy var borderSize: CGFloat = {
        switch style {
        case .primary, .ghost, .accentFloating, .subtleFloating:
            return globalTokens.borderSize[.none]
        case .secondary:
            return globalTokens.borderSize[.thin]
        }
    }()

    lazy var iconSize: CGFloat = {
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
    }()

    lazy var interspace: CGFloat = {
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
    }()

    lazy var padding: CGFloat = {
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
    }()

    lazy var textFont: FontInfo = {
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
    }()

    lazy var textMinimumHeight: CGFloat = globalTokens.iconSize[.medium]

    lazy var textAdditionalHorizontalPadding: CGFloat = {
        switch size {
        case .small, .medium:
            return globalTokens.spacing[.xSmall]
        case .large:
            return globalTokens.spacing[.xxSmall]
        }
    }()

    lazy var textColor: ButtonDynamicColors = {
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
    }()

    lazy var backgroundColor: ButtonDynamicColors = {
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
    }()

    lazy var iconColor: ButtonDynamicColors = {
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
    }()

    lazy var restShadow: ShadowInfo = aliasTokens.elevation[.interactiveElevation1Rest]

    lazy var pressedShadow: ShadowInfo = aliasTokens.elevation[.interactiveElevation1Pressed]
}
