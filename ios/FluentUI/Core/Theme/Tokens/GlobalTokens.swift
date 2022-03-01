//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

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

    // MARK: - SharedColors

    public enum SharedColorSets: CaseIterable {
        case darkRed
        case burgundy
        case cranberry
        case red
        case darkOrange
        case bronze
        case pumpkin
        case orange
        case peach
        case marigold
        case yellow
        case gold
        case brass
        case brown
        case darkBrown
        case lime
        case forest
        case seafoam
        case lightGreen
        case green
        case darkGreen
        case lightTeal
        case teal
        case darkTeal
        case cyan
        case steel
        case lightBlue
        case blue
        case royalBlue
        case darkBlue
        case cornflower
        case navy
        case lavender
        case purple
        case darkPurple
        case orchid
        case grape
        case berry
        case lilac
        case pink
        case hotPink
        case magenta
        case plum
        case beige
        case mink
        case silver
        case platinum
        case anchor
        case charcoal
    }

    public enum SharedColorsTokens: CaseIterable {
        case shade50
        case shade40
        case shade30
        case shade20
        case shade10
        case primary
        case tint10
        case tint20
        case tint30
        case tint40
        case tint50
        case tint60
    }

    lazy public var sharedColors: TokenSet<SharedColorSets, TokenSet<SharedColorsTokens, ColorValue>> = .init { sharedColor in
        switch sharedColor {
        case .anchor:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x394146)
                case .shade10:
                    return ColorValue(0x333A3F)
                case .shade20:
                    return ColorValue(0x2B3135)
                case .shade30:
                    return ColorValue(0x202427)
                case .shade40:
                    return ColorValue(0x111315)
                case .shade50:
                    return ColorValue(0x090A0B)
                case .tint10:
                    return ColorValue(0x4D565C)
                case .tint20:
                    return ColorValue(0x626C72)
                case .tint30:
                    return ColorValue(0x808A90)
                case .tint40:
                    return ColorValue(0xBCC3C7)
                case .tint50:
                    return ColorValue(0xDBDFE1)
                case .tint60:
                    return ColorValue(0xF6F7F8)
                }
            }
        case .beige:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x7A7574)
                case .shade10:
                    return ColorValue(0x6E6968)
                case .shade20:
                    return ColorValue(0x5D5958)
                case .shade30:
                    return ColorValue(0x444241)
                case .shade40:
                    return ColorValue(0x252323)
                case .shade50:
                    return ColorValue(0x141313)
                case .tint10:
                    return ColorValue(0x8A8584)
                case .tint20:
                    return ColorValue(0x9A9594)
                case .tint30:
                    return ColorValue(0xAFABAA)
                case .tint40:
                    return ColorValue(0xD7D4D4)
                case .tint50:
                    return ColorValue(0xEAE8E8)
                case .tint60:
                    return ColorValue(0xFAF9F9)
                }
            }
        case .berry:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xC239B3)
                case .shade10:
                    return ColorValue(0xAF33A1)
                case .shade20:
                    return ColorValue(0x932B88)
                case .shade30:
                    return ColorValue(0x6D2064)
                case .shade40:
                    return ColorValue(0x3A1136)
                case .shade50:
                    return ColorValue(0x1F091D)
                case .tint10:
                    return ColorValue(0xC94CBC)
                case .tint20:
                    return ColorValue(0xD161C4)
                case .tint30:
                    return ColorValue(0xDA7ED0)
                case .tint40:
                    return ColorValue(0xEDBBE7)
                case .tint50:
                    return ColorValue(0xF5DAF2)
                case .tint60:
                    return ColorValue(0xFDF5FC)
                }
            }
        case .blue:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x0078D4)
                case .shade10:
                    return ColorValue(0x006CBF)
                case .shade20:
                    return ColorValue(0x005BA1)
                case .shade30:
                    return ColorValue(0x004377)
                case .shade40:
                    return ColorValue(0x002440)
                case .shade50:
                    return ColorValue(0x001322)
                case .tint10:
                    return ColorValue(0x1A86D9)
                case .tint20:
                    return ColorValue(0x3595DE)
                case .tint30:
                    return ColorValue(0x5CAAE5)
                case .tint40:
                    return ColorValue(0xA9D3F2)
                case .tint50:
                    return ColorValue(0xD0E7F8)
                case .tint60:
                    return ColorValue(0xF3F9FD)
                }
            }
        case .brass:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x986F0B)
                case .shade10:
                    return ColorValue(0x89640A)
                case .shade20:
                    return ColorValue(0x745408)
                case .shade30:
                    return ColorValue(0x553E06)
                case .shade40:
                    return ColorValue(0x2E2103)
                case .shade50:
                    return ColorValue(0x181202)
                case .tint10:
                    return ColorValue(0xA47D1E)
                case .tint20:
                    return ColorValue(0xB18C34)
                case .tint30:
                    return ColorValue(0xC1A256)
                case .tint40:
                    return ColorValue(0xE0CEA2)
                case .tint50:
                    return ColorValue(0xEFE4CB)
                case .tint60:
                    return ColorValue(0xFBF8F2)
                }
            }
        case .bronze:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xA74109)
                case .shade10:
                    return ColorValue(0x963A08)
                case .shade20:
                    return ColorValue(0x7F3107)
                case .shade30:
                    return ColorValue(0x5E2405)
                case .shade40:
                    return ColorValue(0x321303)
                case .shade50:
                    return ColorValue(0x1B0A01)
                case .tint10:
                    return ColorValue(0xB2521E)
                case .tint20:
                    return ColorValue(0xBC6535)
                case .tint30:
                    return ColorValue(0xCA8057)
                case .tint40:
                    return ColorValue(0xE5BBA4)
                case .tint50:
                    return ColorValue(0xF1D9CC)
                case .tint60:
                    return ColorValue(0xFBF5F2)
                }
            }
        case .brown:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x8E562E)
                case .shade10:
                    return ColorValue(0x804D29)
                case .shade20:
                    return ColorValue(0x6C4123)
                case .shade30:
                    return ColorValue(0x50301A)
                case .shade40:
                    return ColorValue(0x2B1A0E)
                case .shade50:
                    return ColorValue(0x170E07)
                case .tint10:
                    return ColorValue(0x9C663F)
                case .tint20:
                    return ColorValue(0xA97652)
                case .tint30:
                    return ColorValue(0xBB8F6F)
                case .tint40:
                    return ColorValue(0xDDC3B0)
                case .tint50:
                    return ColorValue(0xEDDED3)
                case .tint60:
                    return ColorValue(0xFAF7F4)
                }
            }
        case .burgundy:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xA4262C)
                case .shade10:
                    return ColorValue(0x942228)
                case .shade20:
                    return ColorValue(0x7D1D21)
                case .shade30:
                    return ColorValue(0x5C1519)
                case .shade40:
                    return ColorValue(0x310B0D)
                case .shade50:
                    return ColorValue(0x1A0607)
                case .tint10:
                    return ColorValue(0xAF393E)
                case .tint20:
                    return ColorValue(0xBA4D52)
                case .tint30:
                    return ColorValue(0xC86C70)
                case .tint40:
                    return ColorValue(0xE4AFB2)
                case .tint50:
                    return ColorValue(0xF0D3D4)
                case .tint60:
                    return ColorValue(0xFBF4F4)
                }
            }
        case .charcoal:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x393939)
                case .shade10:
                    return ColorValue(0x333333)
                case .shade20:
                    return ColorValue(0x2B2B2B)
                case .shade30:
                    return ColorValue(0x202020)
                case .shade40:
                    return ColorValue(0x111111)
                case .shade50:
                    return ColorValue(0x090909)
                case .tint10:
                    return ColorValue(0x515151)
                case .tint20:
                    return ColorValue(0x686868)
                case .tint30:
                    return ColorValue(0x888888)
                case .tint40:
                    return ColorValue(0xC4C4C4)
                case .tint50:
                    return ColorValue(0xDFDFDF)
                case .tint60:
                    return ColorValue(0xF7F7F7)
                }
            }
        case .cornflower:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x4F6BED)
                case .shade10:
                    return ColorValue(0x4760D5)
                case .shade20:
                    return ColorValue(0x3C51B4)
                case .shade30:
                    return ColorValue(0x2C3C85)
                case .shade40:
                    return ColorValue(0x182047)
                case .shade50:
                    return ColorValue(0x0D1126)
                case .tint10:
                    return ColorValue(0x637CEF)
                case .tint20:
                    return ColorValue(0x778DF1)
                case .tint30:
                    return ColorValue(0x93A4F4)
                case .tint40:
                    return ColorValue(0xC8D1FA)
                case .tint50:
                    return ColorValue(0xE1E6FC)
                case .tint60:
                    return ColorValue(0xF7F9FE)
                }
            }
        case .cranberry:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xC50F1F)
                case .shade10:
                    return ColorValue(0xB10E1C)
                case .shade20:
                    return ColorValue(0x960B18)
                case .shade30:
                    return ColorValue(0x6E0811)
                case .shade40:
                    return ColorValue(0x3B0509)
                case .shade50:
                    return ColorValue(0x200205)
                case .tint10:
                    return ColorValue(0xCC2635)
                case .tint20:
                    return ColorValue(0xD33F4C)
                case .tint30:
                    return ColorValue(0xDC626D)
                case .tint40:
                    return ColorValue(0xEEACB2)
                case .tint50:
                    return ColorValue(0xF6D1D5)
                case .tint60:
                    return ColorValue(0xFDF3F4)
                }
            }
        case .cyan:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x0099BC)
                case .shade10:
                    return ColorValue(0x008AA9)
                case .shade20:
                    return ColorValue(0x00748F)
                case .shade30:
                    return ColorValue(0x005669)
                case .shade40:
                    return ColorValue(0x002E38)
                case .shade50:
                    return ColorValue(0x00181E)
                case .tint10:
                    return ColorValue(0x18A4C4)
                case .tint20:
                    return ColorValue(0x31AFCC)
                case .tint30:
                    return ColorValue(0x56BFD7)
                case .tint40:
                    return ColorValue(0xA4DEEB)
                case .tint50:
                    return ColorValue(0xCDEDF4)
                case .tint60:
                    return ColorValue(0xF2FAFC)
                }
            }
        case .darkBlue:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x003966)
                case .shade10:
                    return ColorValue(0x00335C)
                case .shade20:
                    return ColorValue(0x002B4E)
                case .shade30:
                    return ColorValue(0x002039)
                case .shade40:
                    return ColorValue(0x00111F)
                case .shade50:
                    return ColorValue(0x000910)
                case .tint10:
                    return ColorValue(0x0E4A78)
                case .tint20:
                    return ColorValue(0x215C8B)
                case .tint30:
                    return ColorValue(0x4178A3)
                case .tint40:
                    return ColorValue(0x92B5D1)
                case .tint50:
                    return ColorValue(0xC2D6E7)
                case .tint60:
                    return ColorValue(0xEFF4F9)
                }
            }
        case .darkBrown:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x4D291C)
                case .shade10:
                    return ColorValue(0x452519)
                case .shade20:
                    return ColorValue(0x3A1F15)
                case .shade30:
                    return ColorValue(0x2B1710)
                case .shade40:
                    return ColorValue(0x170C08)
                case .shade50:
                    return ColorValue(0x0C0704)
                case .tint10:
                    return ColorValue(0x623A2B)
                case .tint20:
                    return ColorValue(0x784D3E)
                case .tint30:
                    return ColorValue(0x946B5C)
                case .tint40:
                    return ColorValue(0xCAADA3)
                case .tint50:
                    return ColorValue(0xE3D2CB)
                case .tint60:
                    return ColorValue(0xF8F3F2)
                }
            }
        case .darkGreen:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x0B6A0B)
                case .shade10:
                    return ColorValue(0x0A5F0A)
                case .shade20:
                    return ColorValue(0x085108)
                case .shade30:
                    return ColorValue(0x063B06)
                case .shade40:
                    return ColorValue(0x032003)
                case .shade50:
                    return ColorValue(0x021102)
                case .tint10:
                    return ColorValue(0x1A7C1A)
                case .tint20:
                    return ColorValue(0x2D8E2D)
                case .tint30:
                    return ColorValue(0x4DA64D)
                case .tint40:
                    return ColorValue(0x9AD29A)
                case .tint50:
                    return ColorValue(0xC6E7C6)
                case .tint60:
                    return ColorValue(0xF0F9F0)
                }
            }
        case .darkOrange:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xDA3B01)
                case .shade10:
                    return ColorValue(0xC43501)
                case .shade20:
                    return ColorValue(0xA62D01)
                case .shade30:
                    return ColorValue(0x7A2101)
                case .shade40:
                    return ColorValue(0x411200)
                case .shade50:
                    return ColorValue(0x230900)
                case .tint10:
                    return ColorValue(0xDE501C)
                case .tint20:
                    return ColorValue(0xE36537)
                case .tint30:
                    return ColorValue(0xE9835E)
                case .tint40:
                    return ColorValue(0xF4BFAB)
                case .tint50:
                    return ColorValue(0xF9DCD1)
                case .tint60:
                    return ColorValue(0xFDF6F3)
                }
            }
        case .darkPurple:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x401B6C)
                case .shade10:
                    return ColorValue(0x3A1861)
                case .shade20:
                    return ColorValue(0x311552)
                case .shade30:
                    return ColorValue(0x240F3C)
                case .shade40:
                    return ColorValue(0x130820)
                case .shade50:
                    return ColorValue(0x0A0411)
                case .tint10:
                    return ColorValue(0x512B7E)
                case .tint20:
                    return ColorValue(0x633E8F)
                case .tint30:
                    return ColorValue(0x7E5CA7)
                case .tint40:
                    return ColorValue(0xB9A3D3)
                case .tint50:
                    return ColorValue(0xD8CCE7)
                case .tint60:
                    return ColorValue(0xF5F2F9)
                }
            }
        case .darkRed:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x750B1C)
                case .shade10:
                    return ColorValue(0x690A19)
                case .shade20:
                    return ColorValue(0x590815)
                case .shade30:
                    return ColorValue(0x420610)
                case .shade40:
                    return ColorValue(0x230308)
                case .shade50:
                    return ColorValue(0x130204)
                case .tint10:
                    return ColorValue(0x861B2C)
                case .tint20:
                    return ColorValue(0x962F3F)
                case .tint30:
                    return ColorValue(0xAC4F5E)
                case .tint40:
                    return ColorValue(0xD69CA5)
                case .tint50:
                    return ColorValue(0xE9C7CD)
                case .tint60:
                    return ColorValue(0xF9F0F2)
                }
            }
        case .darkTeal:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x006666)
                case .shade10:
                    return ColorValue(0x005C5C)
                case .shade20:
                    return ColorValue(0x004E4E)
                case .shade30:
                    return ColorValue(0x003939)
                case .shade40:
                    return ColorValue(0x001F1F)
                case .shade50:
                    return ColorValue(0x001010)
                case .tint10:
                    return ColorValue(0x0E7878)
                case .tint20:
                    return ColorValue(0x218B8B)
                case .tint30:
                    return ColorValue(0x41A3A3)
                case .tint40:
                    return ColorValue(0x92D1D1)
                case .tint50:
                    return ColorValue(0xC2E7E7)
                case .tint60:
                    return ColorValue(0xEFF9F9)
                }
            }
        case .forest:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x498205)
                case .shade10:
                    return ColorValue(0x427505)
                case .shade20:
                    return ColorValue(0x376304)
                case .shade30:
                    return ColorValue(0x294903)
                case .shade40:
                    return ColorValue(0x162702)
                case .shade50:
                    return ColorValue(0x0C1501)
                case .tint10:
                    return ColorValue(0x599116)
                case .tint20:
                    return ColorValue(0x6BA02B)
                case .tint30:
                    return ColorValue(0x85B44C)
                case .tint40:
                    return ColorValue(0xBDD99B)
                case .tint50:
                    return ColorValue(0xDBEBC7)
                case .tint60:
                    return ColorValue(0xF6FAF0)
                }
            }
        case .gold:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xC19C00)
                case .shade10:
                    return ColorValue(0xAE8C00)
                case .shade20:
                    return ColorValue(0x937700)
                case .shade30:
                    return ColorValue(0x6C5700)
                case .shade40:
                    return ColorValue(0x3A2F00)
                case .shade50:
                    return ColorValue(0x1F1900)
                case .tint10:
                    return ColorValue(0xC8A718)
                case .tint20:
                    return ColorValue(0xD0B232)
                case .tint30:
                    return ColorValue(0xDAC157)
                case .tint40:
                    return ColorValue(0xECDFA5)
                case .tint50:
                    return ColorValue(0xF5EECE)
                case .tint60:
                    return ColorValue(0xFDFBF2)
                }
            }
        case .grape:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x881798)
                case .shade10:
                    return ColorValue(0x7A1589)
                case .shade20:
                    return ColorValue(0x671174)
                case .shade30:
                    return ColorValue(0x4C0D55)
                case .shade40:
                    return ColorValue(0x29072E)
                case .shade50:
                    return ColorValue(0x160418)
                case .tint10:
                    return ColorValue(0x952AA4)
                case .tint20:
                    return ColorValue(0xA33FB1)
                case .tint30:
                    return ColorValue(0xB55FC1)
                case .tint40:
                    return ColorValue(0xD9A7E0)
                case .tint50:
                    return ColorValue(0xEACEEF)
                case .tint60:
                    return ColorValue(0xFAF2FB)
                }
            }
        case .green:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x107C10)
                case .shade10:
                    return ColorValue(0x0E700E)
                case .shade20:
                    return ColorValue(0x0C5E0C)
                case .shade30:
                    return ColorValue(0x094509)
                case .shade40:
                    return ColorValue(0x052505)
                case .shade50:
                    return ColorValue(0x031403)
                case .tint10:
                    return ColorValue(0x218C21)
                case .tint20:
                    return ColorValue(0x359B35)
                case .tint30:
                    return ColorValue(0x54B054)
                case .tint40:
                    return ColorValue(0x9FD89F)
                case .tint50:
                    return ColorValue(0xC9EAC9)
                case .tint60:
                    return ColorValue(0xF1FAF1)
                }
            }
        case .hotPink:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xE3008C)
                case .shade10:
                    return ColorValue(0xCC007E)
                case .shade20:
                    return ColorValue(0xAD006A)
                case .shade30:
                    return ColorValue(0x7F004E)
                case .shade40:
                    return ColorValue(0x44002A)
                case .shade50:
                    return ColorValue(0x240016)
                case .tint10:
                    return ColorValue(0xE61C99)
                case .tint20:
                    return ColorValue(0xEA38A6)
                case .tint30:
                    return ColorValue(0xEE5FB7)
                case .tint40:
                    return ColorValue(0xF7ADDA)
                case .tint50:
                    return ColorValue(0xFBD2EB)
                case .tint60:
                    return ColorValue(0xFEF4FA)
                }
            }
        case .lavender:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x7160E8)
                case .shade10:
                    return ColorValue(0x6656D1)
                case .shade20:
                    return ColorValue(0x5649B0)
                case .shade30:
                    return ColorValue(0x3F3682)
                case .shade40:
                    return ColorValue(0x221D46)
                case .shade50:
                    return ColorValue(0x120F25)
                case .tint10:
                    return ColorValue(0x8172EB)
                case .tint20:
                    return ColorValue(0x9184EE)
                case .tint30:
                    return ColorValue(0xA79CF1)
                case .tint40:
                    return ColorValue(0xD2CCF8)
                case .tint50:
                    return ColorValue(0xE7E4FB)
                case .tint60:
                    return ColorValue(0xF9F8FE)
                }
            }
        case .lightBlue:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x3A96DD)
                case .shade10:
                    return ColorValue(0x3487C7)
                case .shade20:
                    return ColorValue(0x2C72A8)
                case .shade30:
                    return ColorValue(0x20547C)
                case .shade40:
                    return ColorValue(0x112D42)
                case .shade50:
                    return ColorValue(0x091823)
                case .tint10:
                    return ColorValue(0x4FA1E1)
                case .tint20:
                    return ColorValue(0x65ADE5)
                case .tint30:
                    return ColorValue(0x83BDEB)
                case .tint40:
                    return ColorValue(0xBFDDF5)
                case .tint50:
                    return ColorValue(0xDCEDFA)
                case .tint60:
                    return ColorValue(0xF6FAFE)
                }
            }
        case .lightGreen:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x13A10E)
                case .shade10:
                    return ColorValue(0x11910D)
                case .shade20:
                    return ColorValue(0x0E7A0B)
                case .shade30:
                    return ColorValue(0x0B5A08)
                case .shade40:
                    return ColorValue(0x063004)
                case .shade50:
                    return ColorValue(0x031A02)
                case .tint10:
                    return ColorValue(0x27AC22)
                case .tint20:
                    return ColorValue(0x3DB838)
                case .tint30:
                    return ColorValue(0x5EC75A)
                case .tint40:
                    return ColorValue(0xA7E3A5)
                case .tint50:
                    return ColorValue(0xCEF0CD)
                case .tint60:
                    return ColorValue(0xF2FBF2)
                }
            }
        case .lightTeal:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x00B7C3)
                case .shade10:
                    return ColorValue(0x00A5AF)
                case .shade20:
                    return ColorValue(0x008B94)
                case .shade30:
                    return ColorValue(0x00666D)
                case .shade40:
                    return ColorValue(0x00373A)
                case .shade50:
                    return ColorValue(0x001D1F)
                case .tint10:
                    return ColorValue(0x18BFCA)
                case .tint20:
                    return ColorValue(0x32C8D1)
                case .tint30:
                    return ColorValue(0x58D3DB)
                case .tint40:
                    return ColorValue(0xA6E9ED)
                case .tint50:
                    return ColorValue(0xCEF3F5)
                case .tint60:
                    return ColorValue(0xF2FCFD)
                }
            }
        case .lilac:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xB146C2)
                case .shade10:
                    return ColorValue(0x9F3FAF)
                case .shade20:
                    return ColorValue(0x863593)
                case .shade30:
                    return ColorValue(0x63276D)
                case .shade40:
                    return ColorValue(0x35153A)
                case .shade50:
                    return ColorValue(0x1C0B1F)
                case .tint10:
                    return ColorValue(0xBA58C9)
                case .tint20:
                    return ColorValue(0xC36BD1)
                case .tint30:
                    return ColorValue(0xCF87DA)
                case .tint40:
                    return ColorValue(0xE6BFED)
                case .tint50:
                    return ColorValue(0xF2DCF5)
                case .tint60:
                    return ColorValue(0xFCF6FD)
                }
            }
        case .lime:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x73AA24)
                case .shade10:
                    return ColorValue(0x689920)
                case .shade20:
                    return ColorValue(0x57811B)
                case .shade30:
                    return ColorValue(0x405F14)
                case .shade40:
                    return ColorValue(0x23330B)
                case .shade50:
                    return ColorValue(0x121B06)
                case .tint10:
                    return ColorValue(0x81B437)
                case .tint20:
                    return ColorValue(0x90BE4C)
                case .tint30:
                    return ColorValue(0xA4CC6C)
                case .tint40:
                    return ColorValue(0xCFE5AF)
                case .tint50:
                    return ColorValue(0xE5F1D3)
                case .tint60:
                    return ColorValue(0xF8FCF4)
                }
            }
        case .magenta:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xBF0077)
                case .shade10:
                    return ColorValue(0xAC006B)
                case .shade20:
                    return ColorValue(0x91005A)
                case .shade30:
                    return ColorValue(0x6B0043)
                case .shade40:
                    return ColorValue(0x390024)
                case .shade50:
                    return ColorValue(0x1F0013)
                case .tint10:
                    return ColorValue(0xC71885)
                case .tint20:
                    return ColorValue(0xCE3293)
                case .tint30:
                    return ColorValue(0xD957A8)
                case .tint40:
                    return ColorValue(0xECA5D1)
                case .tint50:
                    return ColorValue(0xF5CEE6)
                case .tint60:
                    return ColorValue(0xFCF2F9)
                }
            }
        case .marigold:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xEAA300)
                case .shade10:
                    return ColorValue(0xD39300)
                case .shade20:
                    return ColorValue(0xB27C00)
                case .shade30:
                    return ColorValue(0x835B00)
                case .shade40:
                    return ColorValue(0x463100)
                case .shade50:
                    return ColorValue(0x251A00)
                case .tint10:
                    return ColorValue(0xEDAD1C)
                case .tint20:
                    return ColorValue(0xEFB839)
                case .tint30:
                    return ColorValue(0xF2C661)
                case .tint40:
                    return ColorValue(0xF9E2AE)
                case .tint50:
                    return ColorValue(0xFCEFD3)
                case .tint60:
                    return ColorValue(0xFEFBF4)
                }
            }
        case .mink:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x5D5A58)
                case .shade10:
                    return ColorValue(0x54514F)
                case .shade20:
                    return ColorValue(0x474443)
                case .shade30:
                    return ColorValue(0x343231)
                case .shade40:
                    return ColorValue(0x1C1B1A)
                case .shade50:
                    return ColorValue(0x0F0E0E)
                case .tint10:
                    return ColorValue(0x706D6B)
                case .tint20:
                    return ColorValue(0x84817E)
                case .tint30:
                    return ColorValue(0x9E9B99)
                case .tint40:
                    return ColorValue(0xCECCCB)
                case .tint50:
                    return ColorValue(0xE5E4E3)
                case .tint60:
                    return ColorValue(0xF8F8F8)
                }
            }
        case .navy:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x0027B4)
                case .shade10:
                    return ColorValue(0x0023A2)
                case .shade20:
                    return ColorValue(0x001E89)
                case .shade30:
                    return ColorValue(0x001665)
                case .shade40:
                    return ColorValue(0x000C36)
                case .shade50:
                    return ColorValue(0x00061D)
                case .tint10:
                    return ColorValue(0x173BBD)
                case .tint20:
                    return ColorValue(0x3050C6)
                case .tint30:
                    return ColorValue(0x546FD2)
                case .tint40:
                    return ColorValue(0xA3B2E8)
                case .tint50:
                    return ColorValue(0xCCD5F3)
                case .tint60:
                    return ColorValue(0xF2F4FC)
                }
            }
        case .orange:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xF7630C)
                case .shade10:
                    return ColorValue(0xDE590B)
                case .shade20:
                    return ColorValue(0xBC4B09)
                case .shade30:
                    return ColorValue(0x8A3707)
                case .shade40:
                    return ColorValue(0x4A1E04)
                case .shade50:
                    return ColorValue(0x271002)
                case .tint10:
                    return ColorValue(0xF87528)
                case .tint20:
                    return ColorValue(0xF98845)
                case .tint30:
                    return ColorValue(0xFAA06B)
                case .tint40:
                    return ColorValue(0xFDCFB4)
                case .tint50:
                    return ColorValue(0xFEE5D7)
                case .tint60:
                    return ColorValue(0xFFF9F5)
                }
            }
        case .orchid:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x8764B8)
                case .shade10:
                    return ColorValue(0x795AA6)
                case .shade20:
                    return ColorValue(0x674C8C)
                case .shade30:
                    return ColorValue(0x4C3867)
                case .shade40:
                    return ColorValue(0x281E37)
                case .shade50:
                    return ColorValue(0x16101D)
                case .tint10:
                    return ColorValue(0x9373C0)
                case .tint20:
                    return ColorValue(0xA083C9)
                case .tint30:
                    return ColorValue(0xB29AD4)
                case .tint40:
                    return ColorValue(0xD7CAEA)
                case .tint50:
                    return ColorValue(0xE9E2F4)
                case .tint60:
                    return ColorValue(0xF9F8FC)
                }
            }
        case .peach:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xFF8C00)
                case .shade10:
                    return ColorValue(0xE67E00)
                case .shade20:
                    return ColorValue(0xC26A00)
                case .shade30:
                    return ColorValue(0x8F4E00)
                case .shade40:
                    return ColorValue(0x4D2A00)
                case .shade50:
                    return ColorValue(0x291600)
                case .tint10:
                    return ColorValue(0xFF9A1F)
                case .tint20:
                    return ColorValue(0xFFA83D)
                case .tint30:
                    return ColorValue(0xFFBA66)
                case .tint40:
                    return ColorValue(0xFFDDB3)
                case .tint50:
                    return ColorValue(0xFFEDD6)
                case .tint60:
                    return ColorValue(0xFFFAF5)
                }
            }
        case .pink:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xE43BA6)
                case .shade10:
                    return ColorValue(0xCD3595)
                case .shade20:
                    return ColorValue(0xAD2D7E)
                case .shade30:
                    return ColorValue(0x80215D)
                case .shade40:
                    return ColorValue(0x441232)
                case .shade50:
                    return ColorValue(0x24091B)
                case .tint10:
                    return ColorValue(0xE750B0)
                case .tint20:
                    return ColorValue(0xEA66BA)
                case .tint30:
                    return ColorValue(0xEF85C8)
                case .tint40:
                    return ColorValue(0xF7C0E3)
                case .tint50:
                    return ColorValue(0xFBDDF0)
                case .tint60:
                    return ColorValue(0xFEF6FB)
                }
            }
        case .platinum:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x69797E)
                case .shade10:
                    return ColorValue(0x5F6D71)
                case .shade20:
                    return ColorValue(0x505C60)
                case .shade30:
                    return ColorValue(0x3B4447)
                case .shade40:
                    return ColorValue(0x1F2426)
                case .shade50:
                    return ColorValue(0x111314)
                case .tint10:
                    return ColorValue(0x79898D)
                case .tint20:
                    return ColorValue(0x89989D)
                case .tint30:
                    return ColorValue(0xA0ADB2)
                case .tint40:
                    return ColorValue(0xCDD6D8)
                case .tint50:
                    return ColorValue(0xE4E9EA)
                case .tint60:
                    return ColorValue(0xF8F9FA)
                }
            }
        case .plum:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x77004D)
                case .shade10:
                    return ColorValue(0x6B0045)
                case .shade20:
                    return ColorValue(0x5A003B)
                case .shade30:
                    return ColorValue(0x43002B)
                case .shade40:
                    return ColorValue(0x240017)
                case .shade50:
                    return ColorValue(0x13000C)
                case .tint10:
                    return ColorValue(0x87105D)
                case .tint20:
                    return ColorValue(0x98246F)
                case .tint30:
                    return ColorValue(0xAD4589)
                case .tint40:
                    return ColorValue(0xD696C0)
                case .tint50:
                    return ColorValue(0xE9C4DC)
                case .tint60:
                    return ColorValue(0xFAF0F6)
                }
            }
        case .pumpkin:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xCA5010)
                case .shade10:
                    return ColorValue(0xB6480E)
                case .shade20:
                    return ColorValue(0x9A3D0C)
                case .shade30:
                    return ColorValue(0x712D09)
                case .shade40:
                    return ColorValue(0x3D1805)
                case .shade50:
                    return ColorValue(0x200D03)
                case .tint10:
                    return ColorValue(0xD06228)
                case .tint20:
                    return ColorValue(0xD77440)
                case .tint30:
                    return ColorValue(0xDF8E64)
                case .tint40:
                    return ColorValue(0xEFC4AD)
                case .tint50:
                    return ColorValue(0xF7DFD2)
                case .tint60:
                    return ColorValue(0xFDF7F4)
                }
            }
        case .purple:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x5C2E91)
                case .shade10:
                    return ColorValue(0x532982)
                case .shade20:
                    return ColorValue(0x46236E)
                case .shade30:
                    return ColorValue(0x341A51)
                case .shade40:
                    return ColorValue(0x1C0E2B)
                case .shade50:
                    return ColorValue(0x0F0717)
                case .tint10:
                    return ColorValue(0x6B3F9E)
                case .tint20:
                    return ColorValue(0x7C52AB)
                case .tint30:
                    return ColorValue(0x9470BD)
                case .tint40:
                    return ColorValue(0xC6B1DE)
                case .tint50:
                    return ColorValue(0xE0D3ED)
                case .tint60:
                    return ColorValue(0xF7F4FB)
                }
            }
        case .red:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xD13438)
                case .shade10:
                    return ColorValue(0xBC2F32)
                case .shade20:
                    return ColorValue(0x9F282B)
                case .shade30:
                    return ColorValue(0x751D1F)
                case .shade40:
                    return ColorValue(0x3F1011)
                case .shade50:
                    return ColorValue(0x210809)
                case .tint10:
                    return ColorValue(0xD7494C)
                case .tint20:
                    return ColorValue(0xDC5E62)
                case .tint30:
                    return ColorValue(0xE37D80)
                case .tint40:
                    return ColorValue(0xF1BBBC)
                case .tint50:
                    return ColorValue(0xF8DADB)
                case .tint60:
                    return ColorValue(0xFDF6F6)
                }
            }
        case .royalBlue:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x004E8C)
                case .shade10:
                    return ColorValue(0x00467E)
                case .shade20:
                    return ColorValue(0x003B6A)
                case .shade30:
                    return ColorValue(0x002C4E)
                case .shade40:
                    return ColorValue(0x00172A)
                case .shade50:
                    return ColorValue(0x000C16)
                case .tint10:
                    return ColorValue(0x125E9A)
                case .tint20:
                    return ColorValue(0x286FA8)
                case .tint30:
                    return ColorValue(0x4A89BA)
                case .tint40:
                    return ColorValue(0x9ABFDC)
                case .tint50:
                    return ColorValue(0xC7DCED)
                case .tint60:
                    return ColorValue(0xF0F6FA)
                }
            }
        case .seafoam:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x00CC6A)
                case .shade10:
                    return ColorValue(0x00B85F)
                case .shade20:
                    return ColorValue(0x009B51)
                case .shade30:
                    return ColorValue(0x00723B)
                case .shade40:
                    return ColorValue(0x003D20)
                case .shade50:
                    return ColorValue(0x002111)
                case .tint10:
                    return ColorValue(0x19D279)
                case .tint20:
                    return ColorValue(0x34D889)
                case .tint30:
                    return ColorValue(0x5AE0A0)
                case .tint40:
                    return ColorValue(0xA8F0CD)
                case .tint50:
                    return ColorValue(0xCFF7E4)
                case .tint60:
                    return ColorValue(0xF3FDF8)
                }
            }
        case .silver:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x859599)
                case .shade10:
                    return ColorValue(0x78868A)
                case .shade20:
                    return ColorValue(0x657174)
                case .shade30:
                    return ColorValue(0x4A5356)
                case .shade40:
                    return ColorValue(0x282D2E)
                case .shade50:
                    return ColorValue(0x151818)
                case .tint10:
                    return ColorValue(0x92A1A5)
                case .tint20:
                    return ColorValue(0xA0AEB1)
                case .tint30:
                    return ColorValue(0xB3BFC2)
                case .tint40:
                    return ColorValue(0xD8DFE0)
                case .tint50:
                    return ColorValue(0xEAEEEF)
                case .tint60:
                    return ColorValue(0xFAFBFB)
                }
            }
        case .steel:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x005B70)
                case .shade10:
                    return ColorValue(0x005265)
                case .shade20:
                    return ColorValue(0x004555)
                case .shade30:
                    return ColorValue(0x00333F)
                case .shade40:
                    return ColorValue(0x001B22)
                case .shade50:
                    return ColorValue(0x000F12)
                case .tint10:
                    return ColorValue(0x0F6C81)
                case .tint20:
                    return ColorValue(0x237D92)
                case .tint30:
                    return ColorValue(0x4496A9)
                case .tint40:
                    return ColorValue(0x94C8D4)
                case .tint50:
                    return ColorValue(0xC3E1E8)
                case .tint60:
                    return ColorValue(0xEFF7F9)
                }
            }
        case .teal:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0x038387)
                case .shade10:
                    return ColorValue(0x037679)
                case .shade20:
                    return ColorValue(0x026467)
                case .shade30:
                    return ColorValue(0x02494C)
                case .shade40:
                    return ColorValue(0x012728)
                case .shade50:
                    return ColorValue(0x001516)
                case .tint10:
                    return ColorValue(0x159195)
                case .tint20:
                    return ColorValue(0x2AA0A4)
                case .tint30:
                    return ColorValue(0x4CB4B7)
                case .tint40:
                    return ColorValue(0x9BD9DB)
                case .tint50:
                    return ColorValue(0xC7EBEC)
                case .tint60:
                    return ColorValue(0xF0FAFA)
                }
            }
        case .yellow:
            return TokenSet<SharedColorsTokens, ColorValue>.init { token in
                switch token {
                case .primary:
                    return ColorValue(0xFDE300)
                case .shade10:
                    return ColorValue(0xE4CC00)
                case .shade20:
                    return ColorValue(0xC0AD00)
                case .shade30:
                    return ColorValue(0x8E7F00)
                case .shade40:
                    return ColorValue(0x4C4400)
                case .shade50:
                    return ColorValue(0x282400)
                case .tint10:
                    return ColorValue(0xFDE61E)
                case .tint20:
                    return ColorValue(0xFDEA3D)
                case .tint30:
                    return ColorValue(0xFEEE66)
                case .tint40:
                    return ColorValue(0xFEF7B2)
                case .tint50:
                    return ColorValue(0xFFFAD6)
                case .tint60:
                    return ColorValue(0xFFFEF5)
                }
            }
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
