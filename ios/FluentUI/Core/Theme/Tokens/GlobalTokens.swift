//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics

/// Global Tokens represent a unified set of constants to be used by Fluent UI.

public class GlobalTokens {

    // MARK: - BrandColors

    public class BrandColors: TokenSet<BrandColors.Tokens, ColorSet> {
        public enum Tokens: CaseIterable {
            case primary
            case shade10
            case shade20
            case shade30
            case tint10
            case tint20
            case tint30
            case tint40
        }
    }
    lazy public var brandColors: BrandColors = .init([
        .primary: ColorSet(light: 0x0078D4, dark: 0x0086F0),
        .shade10: ColorSet(light: 0x106EBE, dark: 0x1890F1),
        .shade20: ColorSet(light: 0x005A9E, dark: 0x3AA0F3),
        .shade30: ColorSet(light: 0x004578, dark: 0x6CB8F6),
        .tint10: ColorSet(light: 0x2B88D8, dark: 0x0074D3),
        .tint20: ColorSet(light: 0xC7E0F4, dark: 0x004F90),
        .tint30: ColorSet(light: 0xDEECF9, dark: 0x002848),
        .tint40: ColorSet(light: 0xEFF6FC, dark: 0x001526)
    ])

    // MARK: - NeutralColors

    public class NeutralColors: TokenSet<NeutralColors.Tokens, ColorValue> {
        public enum Tokens: CaseIterable {
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
    }
    lazy public var neutralColors: NeutralColors = .init([
        .black: 0x000000,
        .grey2: 0x050505,
        .grey4: 0x0A0A0A,
        .grey6: 0x0F0F0F,
        .grey8: 0x141414,
        .grey10: 0x1A1A1A,
        .grey12: 0x1F1F1F,
        .grey14: 0x242424,
        .grey16: 0x292929,
        .grey18: 0x2E2E2E,
        .grey20: 0x333333,
        .grey22: 0x383838,
        .grey24: 0x3D3D3D,
        .grey26: 0x424242,
        .grey28: 0x474747,
        .grey30: 0x4D4D4D,
        .grey32: 0x525252,
        .grey34: 0x575757,
        .grey36: 0x5C5C5C,
        .grey38: 0x616161,
        .grey40: 0x666666,
        .grey42: 0x6B6B6B,
        .grey44: 0x707070,
        .grey46: 0x757575,
        .grey48: 0x7A7A7A,
        .grey50: 0x808080,
        .grey52: 0x858585,
        .grey54: 0x8A8A8A,
        .grey56: 0x8F8F8F,
        .grey58: 0x949494,
        .grey60: 0x999999,
        .grey62: 0x9E9E9E,
        .grey64: 0xA3A3A3,
        .grey66: 0xA8A8A8,
        .grey68: 0xADADAD,
        .grey70: 0xB3B3B3,
        .grey72: 0xB8B8B8,
        .grey74: 0xBDBDBD,
        .grey76: 0xC2C2C2,
        .grey78: 0xC7C7C7,
        .grey80: 0xCCCCCC,
        .grey82: 0xD1D1D1,
        .grey84: 0xD6D6D6,
        .grey86: 0xDBDBDB,
        .grey88: 0xE0E0E0,
        .grey90: 0xE6E6E6,
        .grey92: 0xEBEBEB,
        .grey94: 0xF0F0F0,
        .grey96: 0xF5F5F5,
        .grey98: 0xFAFAFA,
        .white: 0xFFFFFF
    ])

    // MARK: - IconSize

    public class IconSize: TokenSet<IconSize.Tokens, CGFloat> {
        public enum Tokens: CaseIterable {
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
    }
    lazy public var iconSize: IconSize = .init([
        .xxxSmall: 10,
        .xxSmall: 12,
        .xSmall: 16,
        .small: 20,
        .medium: 24,
        .large: 28,
        .xLarge: 36,
        .xxLarge: 40,
        .xxxLarge: 48
    ])

    // MARK: - Spacing

    public class Spacing: TokenSet<Spacing.Tokens, CGFloat> {
        public enum Tokens: CaseIterable {
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
    }
    lazy public var spacing: Spacing = .init([
        .none: 0,
        .xxxSmall: 2,
        .xxSmall: 4,
        .xSmall: 8,
        .small: 12,
        .medium: 16,
        .large: 20,
        .xLarge: 24,
        .xxLarge: 36,
        .xxxLarge: 48,
        .xxxxLarge: 72
    ])

    // MARK: - BorderRadius

    public class BorderRadius: TokenSet<BorderRadius.Tokens, CGFloat> {
        public enum Tokens: CaseIterable {
            case none
            case small
            case medium
            case large
            case xLarge
            case circle
        }
    }
    lazy public var borderRadius: BorderRadius = .init([
        .none: 0,
        .small: 2,
        .medium: 4,
        .large: 8,
        .xLarge: 12,
        .circle: 9999
    ])

    // MARK: - BorderSize

    public class BorderSize: TokenSet<BorderSize.Tokens, CGFloat> {
        public enum Tokens: CaseIterable {
            case none
            case thin
            case thick
            case thicker
            case thickest
        }
    }
    lazy public var borderSize: BorderSize = .init([
        .none: 0,
        .thin: 1,
        .thick: 2,
        .thicker: 4,
        .thickest: 6
    ])

    // MARK: Initialization

    static let shared = GlobalTokens()
}
