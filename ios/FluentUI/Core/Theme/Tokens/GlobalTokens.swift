//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics
import SwiftUI

/// Global Tokens represent a unified set of constants to be used by Fluent UI.
public final class GlobalTokens {

    // MARK: - BrandColors

    public enum BrandColorsTokens: CaseIterable {
        case primary
        case shade10
        case shade20
        case shade30
        case tint10
        case tint20
        case tint30
        case tint40
    }
    lazy public var brandColors: TokenSet<BrandColorsTokens, DynamicColor> = .init { token in
        switch token {
        case .primary:
            return DynamicColor(light: ColorValue(0x0078D4), dark: ColorValue(0x0086F0))
        case .shade10:
            return DynamicColor(light: ColorValue(0x106EBE), dark: ColorValue(0x1890F1))
        case .shade20:
            return DynamicColor(light: ColorValue(0x005A9E), dark: ColorValue(0x3AA0F3))
        case .shade30:
            return DynamicColor(light: ColorValue(0x004578), dark: ColorValue(0x6CB8F6))
        case .tint10:
            return DynamicColor(light: ColorValue(0x2B88D8), dark: ColorValue(0x0074D3))
        case .tint20:
            return DynamicColor(light: ColorValue(0xC7E0F4), dark: ColorValue(0x004F90))
        case .tint30:
            return DynamicColor(light: ColorValue(0xDEECF9), dark: ColorValue(0x002848))
        case .tint40:
            return DynamicColor(light: ColorValue(0xEFF6FC), dark: ColorValue(0x001526))
        }
    }

    // MARK: - NeutralColors

    public enum NeutralColorsToken: CaseIterable {
        case black
        case grey2
        case grey4
        case grey6
        case grey8
        case grey10
        case grey12
        case grey14
        case grey16
        case grey18
        case grey20
        case grey22
        case grey24
        case grey26
        case grey28
        case grey30
        case grey32
        case grey34
        case grey36
        case grey38
        case grey40
        case grey42
        case grey44
        case grey46
        case grey48
        case grey50
        case grey52
        case grey54
        case grey56
        case grey58
        case grey60
        case grey62
        case grey64
        case grey66
        case grey68
        case grey70
        case grey72
        case grey74
        case grey76
        case grey78
        case grey80
        case grey82
        case grey84
        case grey86
        case grey88
        case grey90
        case grey92
        case grey94
        case grey96
        case grey98
        case white
    }
    lazy public var neutralColors: TokenSet<NeutralColorsToken, ColorValue> = .init { token in
        switch token {
        case .black:
            return ColorValue(0x000000)
        case .grey2:
            return ColorValue(0x050505)
        case .grey4:
            return ColorValue(0x0A0A0A)
        case .grey6:
            return ColorValue(0x0F0F0F)
        case .grey8:
            return ColorValue(0x141414)
        case .grey10:
            return ColorValue(0x1A1A1A)
        case .grey12:
            return ColorValue(0x1F1F1F)
        case .grey14:
            return ColorValue(0x242424)
        case .grey16:
            return ColorValue(0x292929)
        case .grey18:
            return ColorValue(0x2E2E2E)
        case .grey20:
            return ColorValue(0x333333)
        case .grey22:
            return ColorValue(0x383838)
        case .grey24:
            return ColorValue(0x3D3D3D)
        case .grey26:
            return ColorValue(0x424242)
        case .grey28:
            return ColorValue(0x474747)
        case .grey30:
            return ColorValue(0x4D4D4D)
        case .grey32:
            return ColorValue(0x525252)
        case .grey34:
            return ColorValue(0x575757)
        case .grey36:
            return ColorValue(0x5C5C5C)
        case .grey38:
            return ColorValue(0x616161)
        case .grey40:
            return ColorValue(0x666666)
        case .grey42:
            return ColorValue(0x6B6B6B)
        case .grey44:
            return ColorValue(0x707070)
        case .grey46:
            return ColorValue(0x757575)
        case .grey48:
            return ColorValue(0x7A7A7A)
        case .grey50:
            return ColorValue(0x808080)
        case .grey52:
            return ColorValue(0x858585)
        case .grey54:
            return ColorValue(0x8A8A8A)
        case .grey56:
            return ColorValue(0x8F8F8F)
        case .grey58:
            return ColorValue(0x949494)
        case .grey60:
            return ColorValue(0x999999)
        case .grey62:
            return ColorValue(0x9E9E9E)
        case .grey64:
            return ColorValue(0xA3A3A3)
        case .grey66:
            return ColorValue(0xA8A8A8)
        case .grey68:
            return ColorValue(0xADADAD)
        case .grey70:
            return ColorValue(0xB3B3B3)
        case .grey72:
            return ColorValue(0xB8B8B8)
        case .grey74:
            return ColorValue(0xBDBDBD)
        case .grey76:
            return ColorValue(0xC2C2C2)
        case .grey78:
            return ColorValue(0xC7C7C7)
        case .grey80:
            return ColorValue(0xCCCCCC)
        case .grey82:
            return ColorValue(0xD1D1D1)
        case .grey84:
            return ColorValue(0xD6D6D6)
        case .grey86:
            return ColorValue(0xDBDBDB)
        case .grey88:
            return ColorValue(0xE0E0E0)
        case .grey90:
            return ColorValue(0xE6E6E6)
        case .grey92:
            return ColorValue(0xEBEBEB)
        case .grey94:
            return ColorValue(0xF0F0F0)
        case .grey96:
            return ColorValue(0xF5F5F5)
        case .grey98:
            return ColorValue(0xFAFAFA)
        case .white:
            return ColorValue(0xFFFFFF)
        }
    }

    // MARK: - FontSize
    public enum FontSizeToken: CaseIterable {
        case size100
        case size200
        case size300
        case size400
        case size500
        case size600
        case size700
        case size800
        case size900
    }
    lazy public var fontSize: TokenSet<FontSizeToken, CGFloat> = .init { token in
        switch token {
        case .size100:
            return 12.0
        case .size200:
            return 13.0
        case .size300:
            return 15.0
        case .size400:
            return 17.0
        case .size500:
            return 20.0
        case .size600:
            return 22.0
        case .size700:
            return 28.0
        case .size800:
            return 34.0
        case .size900:
            return 60.0
        }
    }

    // MARK: - FontWeight

    public enum FontWeightToken: CaseIterable {
        case regular
        case medium
        case semibold
        case bold
    }
    lazy public var fontWeight: TokenSet<FontWeightToken, Font.Weight> = .init { token in
        switch token {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        }
    }

    // MARK: - IconSize

    public enum IconSizeToken: CaseIterable {
        case xxxSmall
        case xxSmall
        case xSmall
        case small
        case medium
        case large
        case xLarge
        case xxLarge
        case xxxLarge
    }
    lazy public var iconSize: TokenSet<IconSizeToken, CGFloat> = .init { token in
        switch token {
        case .xxxSmall:
            return 10
        case .xxSmall:
            return 12
        case .xSmall:
            return 16
        case .small:
            return 20
        case .medium:
            return 24
        case .large:
            return 28
        case .xLarge:
            return 36
        case .xxLarge:
            return 40
        case .xxxLarge:
            return 48
        }
    }

    // MARK: - Spacing

    public enum SpacingToken: CaseIterable {
        case none
        case xxxSmall
        case xxSmall
        case xSmall
        case small
        case medium
        case large
        case xLarge
        case xxLarge
        case xxxLarge
        case xxxxLarge
    }
    lazy public var spacing: TokenSet<SpacingToken, CGFloat> = .init { token in
        switch token {
        case .none:
            return 0
        case .xxxSmall:
            return 2
        case .xxSmall:
            return 4
        case .xSmall:
            return 8
        case .small:
            return 12
        case .medium:
            return 16
        case .large:
            return 20
        case .xLarge:
            return 24
        case .xxLarge:
            return 36
        case .xxxLarge:
            return 48
        case .xxxxLarge:
            return 72
        }
    }

    // MARK: - BorderRadius

    public enum BorderRadiusToken: CaseIterable {
        case none
        case small
        case medium
        case large
        case xLarge
        case circle
    }
    lazy public var borderRadius: TokenSet<BorderRadiusToken, CGFloat> = .init { token in
        switch token {
        case .none:
            return 0
        case .small:
            return 2
        case .medium:
            return 4
        case .large:
            return 8
        case .xLarge:
            return 12
        case .circle:
            return 9999
        }
    }

    // MARK: - BorderSize

    public enum BorderSizeToken: CaseIterable {
        case none
        case thin
        case thick
        case thicker
        case thickest
    }
    lazy public var borderSize: TokenSet<BorderSizeToken, CGFloat> = .init { token in
        switch token {
        case .none:
            return 0
        case .thin:
            return 1
        case .thick:
            return 2
        case .thicker:
            return 4
        case .thickest:
            return 6
        }
    }

    // MARK: Initialization

    public init() {}
}
