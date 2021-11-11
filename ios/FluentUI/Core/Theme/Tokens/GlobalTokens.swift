//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics

/// Global Tokens represent a unified set of constants to be used by Fluent UI.
public struct GlobalTokens {
    public struct Colors {
        public enum Brand: TokenSet {
            case primary
            case shade10
            case shade20
            case shade30
            case tint10
            case tint20
            case tint30
            case tint40

            public var value: ColorSet {
                switch self {
                case .primary:
                    return ColorSet(light: 0x0078D4,
                                    dark: 0x0086F0)
                case .shade10:
                    return ColorSet(light: 0x106EBE,
                                    dark: 0x1890F1)
                case .shade20:
                    return ColorSet(light: 0x005A9E,
                                    dark: 0x3AA0F3)
                case .shade30:
                    return ColorSet(light: 0x004578,
                                    dark: 0x6CB8F6)
                case .tint10:
                    return ColorSet(light: 0x2B88D8,
                                    dark: 0x0074D3)
                case .tint20:
                    return ColorSet(light: 0xC7E0F4,
                                    dark: 0x004F90)
                case .tint30:
                    return ColorSet(light: 0xDEECF9,
                                    dark: 0x002848)
                case .tint40:
                    return ColorSet(light: 0xEFF6FC,
                                    dark: 0x001526)
                }
            }
        }

        public enum Neutral: TokenSet {
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

            public var value: ColorValue {
                switch self {
                case .black:
                    return 0x000000
                case .grey2:
                    return 0x050505
                case .grey4:
                    return 0x0A0A0A
                case .grey6:
                    return 0x0F0F0F
                case .grey8:
                    return 0x141414
                case .grey10:
                    return 0x1A1A1A
                case .grey12:
                    return 0x1F1F1F
                case .grey14:
                    return 0x242424
                case .grey16:
                    return 0x292929
                case .grey18:
                    return 0x2E2E2E
                case .grey20:
                    return 0x333333
                case .grey22:
                    return 0x383838
                case .grey24:
                    return 0x3D3D3D
                case .grey26:
                    return 0x424242
                case .grey28:
                    return 0x474747
                case .grey30:
                    return 0x4D4D4D
                case .grey32:
                    return 0x525252
                case .grey34:
                    return 0x575757
                case .grey36:
                    return 0x5C5C5C
                case .grey38:
                    return 0x616161
                case .grey40:
                    return 0x666666
                case .grey42:
                    return 0x6B6B6B
                case .grey44:
                    return 0x707070
                case .grey46:
                    return 0x757575
                case .grey48:
                    return 0x7A7A7A
                case .grey50:
                    return 0x808080
                case .grey52:
                    return 0x858585
                case .grey54:
                    return 0x8A8A8A
                case .grey56:
                    return 0x8F8F8F
                case .grey58:
                    return 0x949494
                case .grey60:
                    return 0x999999
                case .grey62:
                    return 0x9E9E9E
                case .grey64:
                    return 0xA3A3A3
                case .grey66:
                    return 0xA8A8A8
                case .grey68:
                    return 0xADADAD
                case .grey70:
                    return 0xB3B3B3
                case .grey72:
                    return 0xB8B8B8
                case .grey74:
                    return 0xBDBDBD
                case .grey76:
                    return 0xC2C2C2
                case .grey78:
                    return 0xC7C7C7
                case .grey80:
                    return 0xCCCCCC
                case .grey82:
                    return 0xD1D1D1
                case .grey84:
                    return 0xD6D6D6
                case .grey86:
                    return 0xDBDBDB
                case .grey88:
                    return 0xE0E0E0
                case .grey90:
                    return 0xE6E6E6
                case .grey92:
                    return 0xEBEBEB
                case .grey94:
                    return 0xF0F0F0
                case .grey96:
                    return 0xF5F5F5
                case .grey98:
                    return 0xFAFAFA
                case .white:
                    return 0xFFFFFF
                }
            }
        }

    }

    public struct Icon {
        public enum Size: TokenSet {
            case xxxSmall
            case xxSmall
            case xSmall
            case small
            case medium
            case large
            case xLarge
            case xxLarge
            case xxxLarge

            public var value: CGFloat {
                switch self {
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
        }
    }

    public enum Spacing: TokenSet {
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

        public var value: CGFloat {
            switch self {
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
    }

    public struct Border {
        public enum Radius: TokenSet {
            case none
            case small
            case medium
            case large
            case xLarge
            case circle

            public var value: CGFloat {
                switch self {
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
        }

        public enum Size: TokenSet {
            case none
            case thin
            case thick
            case thicker
            case thickest

            public var value: CGFloat {
                switch self {
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
        }
    }
}
