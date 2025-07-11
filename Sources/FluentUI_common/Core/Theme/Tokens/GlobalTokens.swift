//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Global Tokens represent a unified set of constants to be used by Fluent UI.
///
/// Values are derived from the Fluent UI design token system at https://github.com/microsoft/fluentui-design-tokens.
@objc(MSFGlobalTokens)
public class GlobalTokens: NSObject {

    // MARK: - BrandColor

    @objc(MSFGlobalTokensBrandColor)
    public enum BrandColorToken: Int, CaseIterable, Hashable {
        // Communication blue colors
        case comm10
        case comm20
        case comm30
        case comm40
        case comm50
        case comm60
        case comm70
        case comm80
        case comm90
        case comm100
        case comm110
        case comm120
        case comm130
        case comm140
        case comm150
        case comm160

        // Gradient colors
        case gradientPrimaryLight
        case gradientPrimaryDark
        case gradientSecondaryLight
        case gradientSecondaryDark
        case gradientTertiaryLight
        case gradientTertiaryDark
    }

    public static func brandSwiftUIColor(_ token: BrandColorToken) -> Color {
        switch token {
        case .comm10:
            return Color(hexValue: 0x061724)
        case .comm20:
            return Color(hexValue: 0x082338)
        case .comm30:
            return Color(hexValue: 0x0A2E4A)
        case .comm40:
            return Color(hexValue: 0x0C3B5E)
        case .comm50:
            return Color(hexValue: 0x0E4775)
        case .comm60:
            return Color(hexValue: 0x0F548C)
        case .comm70:
            return Color(hexValue: 0x115EA3)
        case .comm80:
            return Color(hexValue: 0x0F6CBD)
        case .comm90:
            return Color(hexValue: 0x2886DE)
        case .comm100:
            return Color(hexValue: 0x479EF5)
        case .comm110:
            return Color(hexValue: 0x62ABF5)
        case .comm120:
            return Color(hexValue: 0x77B7F7)
        case .comm130:
            return Color(hexValue: 0x96C6FA)
        case .comm140:
            return Color(hexValue: 0xB4D6FA)
        case .comm150:
            return Color(hexValue: 0xCFE4FA)
        case .comm160:
            return Color(hexValue: 0xEBF3FC)
        case .gradientPrimaryLight:
            return Color(hexValue: 0x464FEB)
        case .gradientPrimaryDark:
            return Color(hexValue: 0x7385FF)
        case .gradientSecondaryLight:
            return Color(hexValue: 0x47CFFA)
        case .gradientSecondaryDark:
            return Color(hexValue: 0x7ADFFF)
        case .gradientTertiaryLight:
            return Color(hexValue: 0xB47CF8)
        case .gradientTertiaryDark:
            return Color(hexValue: 0xBF80FF)
        }
    }

    // MARK: - NeutralColor

    @objc(MSFGlobalTokensNeutralColor)
    public enum NeutralColorToken: Int, CaseIterable, Hashable {
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
    public static func neutralSwiftUIColor(_ token: NeutralColorToken) -> Color {
        switch token {
        case .black:
            return Color(hexValue: 0x000000)
        case .grey2:
            return Color(hexValue: 0x050505)
        case .grey4:
            return Color(hexValue: 0x0A0A0A)
        case .grey6:
            return Color(hexValue: 0x0F0F0F)
        case .grey8:
            return Color(hexValue: 0x141414)
        case .grey10:
            return Color(hexValue: 0x1A1A1A)
        case .grey12:
            return Color(hexValue: 0x1F1F1F)
        case .grey14:
            return Color(hexValue: 0x242424)
        case .grey16:
            return Color(hexValue: 0x292929)
        case .grey18:
            return Color(hexValue: 0x2E2E2E)
        case .grey20:
            return Color(hexValue: 0x333333)
        case .grey22:
            return Color(hexValue: 0x383838)
        case .grey24:
            return Color(hexValue: 0x3D3D3D)
        case .grey26:
            return Color(hexValue: 0x424242)
        case .grey28:
            return Color(hexValue: 0x474747)
        case .grey30:
            return Color(hexValue: 0x4D4D4D)
        case .grey32:
            return Color(hexValue: 0x525252)
        case .grey34:
            return Color(hexValue: 0x575757)
        case .grey36:
            return Color(hexValue: 0x5C5C5C)
        case .grey38:
            return Color(hexValue: 0x616161)
        case .grey40:
            return Color(hexValue: 0x666666)
        case .grey42:
            return Color(hexValue: 0x6B6B6B)
        case .grey44:
            return Color(hexValue: 0x707070)
        case .grey46:
            return Color(hexValue: 0x757575)
        case .grey48:
            return Color(hexValue: 0x7A7A7A)
        case .grey50:
            return Color(hexValue: 0x808080)
        case .grey52:
            return Color(hexValue: 0x858585)
        case .grey54:
            return Color(hexValue: 0x8A8A8A)
        case .grey56:
            return Color(hexValue: 0x8F8F8F)
        case .grey58:
            return Color(hexValue: 0x949494)
        case .grey60:
            return Color(hexValue: 0x999999)
        case .grey62:
            return Color(hexValue: 0x9E9E9E)
        case .grey64:
            return Color(hexValue: 0xA3A3A3)
        case .grey66:
            return Color(hexValue: 0xA8A8A8)
        case .grey68:
            return Color(hexValue: 0xADADAD)
        case .grey70:
            return Color(hexValue: 0xB2B2B2)
        case .grey72:
            return Color(hexValue: 0xB8B8B8)
        case .grey74:
            return Color(hexValue: 0xBDBDBD)
        case .grey76:
            return Color(hexValue: 0xC2C2C2)
        case .grey78:
            return Color(hexValue: 0xC7C7C7)
        case .grey80:
            return Color(hexValue: 0xCCCCCC)
        case .grey82:
            return Color(hexValue: 0xD1D1D1)
        case .grey84:
            return Color(hexValue: 0xD6D6D6)
        case .grey86:
            return Color(hexValue: 0xDBDBDB)
        case .grey88:
            return Color(hexValue: 0xE0E0E0)
        case .grey90:
            return Color(hexValue: 0xE5E5E5)
        case .grey92:
            return Color(hexValue: 0xEBEBEB)
        case .grey94:
            return Color(hexValue: 0xF0F0F0)
        case .grey96:
            return Color(hexValue: 0xF5F5F5)
        case .grey98:
            return Color(hexValue: 0xFAFAFA)
        case .white:
            return Color(hexValue: 0xFFFFFF)
        }
    }

    // MARK: - SharedColor

    @objc(MSFGlobalTokensSharedColorSet)
    public enum SharedColorSet: Int, CaseIterable, Hashable {
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

    @objc(MSFGlobalTokensSharedColor)
    public enum SharedColorToken: Int, CaseIterable, Hashable {
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

    public static func sharedSwiftUIColor(_ sharedColor: SharedColorSet, _ token: SharedColorToken) -> Color {
        switch sharedColor {
        case .anchor:
            switch token {
            case .primary:
                return Color(hexValue: 0x394146)
            case .shade10:
                return Color(hexValue: 0x333A3F)
            case .shade20:
                return Color(hexValue: 0x2B3135)
            case .shade30:
                return Color(hexValue: 0x202427)
            case .shade40:
                return Color(hexValue: 0x111315)
            case .shade50:
                return Color(hexValue: 0x090A0B)
            case .tint10:
                return Color(hexValue: 0x4D565C)
            case .tint20:
                return Color(hexValue: 0x626C72)
            case .tint30:
                return Color(hexValue: 0x808A90)
            case .tint40:
                return Color(hexValue: 0xBCC3C7)
            case .tint50:
                return Color(hexValue: 0xDBDFE1)
            case .tint60:
                return Color(hexValue: 0xF6F7F8)
            }
        case .beige:
            switch token {
            case .primary:
                return Color(hexValue: 0x7A7574)
            case .shade10:
                return Color(hexValue: 0x6E6968)
            case .shade20:
                return Color(hexValue: 0x5D5958)
            case .shade30:
                return Color(hexValue: 0x444241)
            case .shade40:
                return Color(hexValue: 0x252323)
            case .shade50:
                return Color(hexValue: 0x141313)
            case .tint10:
                return Color(hexValue: 0x8A8584)
            case .tint20:
                return Color(hexValue: 0x9A9594)
            case .tint30:
                return Color(hexValue: 0xAFABAA)
            case .tint40:
                return Color(hexValue: 0xD7D4D4)
            case .tint50:
                return Color(hexValue: 0xEAE8E8)
            case .tint60:
                return Color(hexValue: 0xFAF9F9)
            }
        case .berry:
            switch token {
            case .primary:
                return Color(hexValue: 0xC239B3)
            case .shade10:
                return Color(hexValue: 0xAF33A1)
            case .shade20:
                return Color(hexValue: 0x932B88)
            case .shade30:
                return Color(hexValue: 0x6D2064)
            case .shade40:
                return Color(hexValue: 0x3A1136)
            case .shade50:
                return Color(hexValue: 0x1F091D)
            case .tint10:
                return Color(hexValue: 0xC94CBC)
            case .tint20:
                return Color(hexValue: 0xD161C4)
            case .tint30:
                return Color(hexValue: 0xDA7ED0)
            case .tint40:
                return Color(hexValue: 0xEDBBE7)
            case .tint50:
                return Color(hexValue: 0xF5DAF2)
            case .tint60:
                return Color(hexValue: 0xFDF5FC)
            }
        case .blue:
            switch token {
            case .primary:
                return Color(hexValue: 0x0078D4)
            case .shade10:
                return Color(hexValue: 0x006CBF)
            case .shade20:
                return Color(hexValue: 0x005BA1)
            case .shade30:
                return Color(hexValue: 0x004377)
            case .shade40:
                return Color(hexValue: 0x002440)
            case .shade50:
                return Color(hexValue: 0x001322)
            case .tint10:
                return Color(hexValue: 0x1A86D9)
            case .tint20:
                return Color(hexValue: 0x3595DE)
            case .tint30:
                return Color(hexValue: 0x5CAAE5)
            case .tint40:
                return Color(hexValue: 0xA9D3F2)
            case .tint50:
                return Color(hexValue: 0xD0E7F8)
            case .tint60:
                return Color(hexValue: 0xF3F9FD)
            }
        case .brass:
            switch token {
            case .primary:
                return Color(hexValue: 0x986F0B)
            case .shade10:
                return Color(hexValue: 0x89640A)
            case .shade20:
                return Color(hexValue: 0x745408)
            case .shade30:
                return Color(hexValue: 0x553E06)
            case .shade40:
                return Color(hexValue: 0x2E2103)
            case .shade50:
                return Color(hexValue: 0x181202)
            case .tint10:
                return Color(hexValue: 0xA47D1E)
            case .tint20:
                return Color(hexValue: 0xB18C34)
            case .tint30:
                return Color(hexValue: 0xC1A256)
            case .tint40:
                return Color(hexValue: 0xE0CEA2)
            case .tint50:
                return Color(hexValue: 0xEFE4CB)
            case .tint60:
                return Color(hexValue: 0xFBF8F2)
            }
        case .bronze:
            switch token {
            case .primary:
                return Color(hexValue: 0xA74109)
            case .shade10:
                return Color(hexValue: 0x963A08)
            case .shade20:
                return Color(hexValue: 0x7F3107)
            case .shade30:
                return Color(hexValue: 0x5E2405)
            case .shade40:
                return Color(hexValue: 0x321303)
            case .shade50:
                return Color(hexValue: 0x1B0A01)
            case .tint10:
                return Color(hexValue: 0xB2521E)
            case .tint20:
                return Color(hexValue: 0xBC6535)
            case .tint30:
                return Color(hexValue: 0xCA8057)
            case .tint40:
                return Color(hexValue: 0xE5BBA4)
            case .tint50:
                return Color(hexValue: 0xF1D9CC)
            case .tint60:
                return Color(hexValue: 0xFBF5F2)
            }
        case .brown:
            switch token {
            case .primary:
                return Color(hexValue: 0x8E562E)
            case .shade10:
                return Color(hexValue: 0x804D29)
            case .shade20:
                return Color(hexValue: 0x6C4123)
            case .shade30:
                return Color(hexValue: 0x50301A)
            case .shade40:
                return Color(hexValue: 0x2B1A0E)
            case .shade50:
                return Color(hexValue: 0x170E07)
            case .tint10:
                return Color(hexValue: 0x9C663F)
            case .tint20:
                return Color(hexValue: 0xA97652)
            case .tint30:
                return Color(hexValue: 0xBB8F6F)
            case .tint40:
                return Color(hexValue: 0xDDC3B0)
            case .tint50:
                return Color(hexValue: 0xEDDED3)
            case .tint60:
                return Color(hexValue: 0xFAF7F4)
            }
        case .burgundy:
            switch token {
            case .primary:
                return Color(hexValue: 0xA4262C)
            case .shade10:
                return Color(hexValue: 0x942228)
            case .shade20:
                return Color(hexValue: 0x7D1D21)
            case .shade30:
                return Color(hexValue: 0x5C1519)
            case .shade40:
                return Color(hexValue: 0x310B0D)
            case .shade50:
                return Color(hexValue: 0x1A0607)
            case .tint10:
                return Color(hexValue: 0xAF393E)
            case .tint20:
                return Color(hexValue: 0xBA4D52)
            case .tint30:
                return Color(hexValue: 0xC86C70)
            case .tint40:
                return Color(hexValue: 0xE4AFB2)
            case .tint50:
                return Color(hexValue: 0xF0D3D4)
            case .tint60:
                return Color(hexValue: 0xFBF4F4)
            }
        case .charcoal:
            switch token {
            case .primary:
                return Color(hexValue: 0x393939)
            case .shade10:
                return Color(hexValue: 0x333333)
            case .shade20:
                return Color(hexValue: 0x2B2B2B)
            case .shade30:
                return Color(hexValue: 0x202020)
            case .shade40:
                return Color(hexValue: 0x111111)
            case .shade50:
                return Color(hexValue: 0x090909)
            case .tint10:
                return Color(hexValue: 0x515151)
            case .tint20:
                return Color(hexValue: 0x686868)
            case .tint30:
                return Color(hexValue: 0x888888)
            case .tint40:
                return Color(hexValue: 0xC4C4C4)
            case .tint50:
                return Color(hexValue: 0xDFDFDF)
            case .tint60:
                return Color(hexValue: 0xF7F7F7)
            }
        case .cornflower:
            switch token {
            case .primary:
                return Color(hexValue: 0x4F6BED)
            case .shade10:
                return Color(hexValue: 0x4760D5)
            case .shade20:
                return Color(hexValue: 0x3C51B4)
            case .shade30:
                return Color(hexValue: 0x2C3C85)
            case .shade40:
                return Color(hexValue: 0x182047)
            case .shade50:
                return Color(hexValue: 0x0D1126)
            case .tint10:
                return Color(hexValue: 0x637CEF)
            case .tint20:
                return Color(hexValue: 0x778DF1)
            case .tint30:
                return Color(hexValue: 0x93A4F4)
            case .tint40:
                return Color(hexValue: 0xC8D1FA)
            case .tint50:
                return Color(hexValue: 0xE1E6FC)
            case .tint60:
                return Color(hexValue: 0xF7F9FE)
            }
        case .cranberry:
            switch token {
            case .primary:
                return Color(hexValue: 0xC50F1F)
            case .shade10:
                return Color(hexValue: 0xB10E1C)
            case .shade20:
                return Color(hexValue: 0x960B18)
            case .shade30:
                return Color(hexValue: 0x6E0811)
            case .shade40:
                return Color(hexValue: 0x3B0509)
            case .shade50:
                return Color(hexValue: 0x200205)
            case .tint10:
                return Color(hexValue: 0xCC2635)
            case .tint20:
                return Color(hexValue: 0xD33F4C)
            case .tint30:
                return Color(hexValue: 0xDC626D)
            case .tint40:
                return Color(hexValue: 0xEEACB2)
            case .tint50:
                return Color(hexValue: 0xF6D1D5)
            case .tint60:
                return Color(hexValue: 0xFDF3F4)
            }
        case .cyan:
            switch token {
            case .primary:
                return Color(hexValue: 0x0099BC)
            case .shade10:
                return Color(hexValue: 0x008AA9)
            case .shade20:
                return Color(hexValue: 0x00748F)
            case .shade30:
                return Color(hexValue: 0x005669)
            case .shade40:
                return Color(hexValue: 0x002E38)
            case .shade50:
                return Color(hexValue: 0x00181E)
            case .tint10:
                return Color(hexValue: 0x18A4C4)
            case .tint20:
                return Color(hexValue: 0x31AFCC)
            case .tint30:
                return Color(hexValue: 0x56BFD7)
            case .tint40:
                return Color(hexValue: 0xA4DEEB)
            case .tint50:
                return Color(hexValue: 0xCDEDF4)
            case .tint60:
                return Color(hexValue: 0xF2FAFC)
            }
        case .darkBlue:
            switch token {
            case .primary:
                return Color(hexValue: 0x003966)
            case .shade10:
                return Color(hexValue: 0x00335C)
            case .shade20:
                return Color(hexValue: 0x002B4E)
            case .shade30:
                return Color(hexValue: 0x002039)
            case .shade40:
                return Color(hexValue: 0x00111F)
            case .shade50:
                return Color(hexValue: 0x000910)
            case .tint10:
                return Color(hexValue: 0x0E4A78)
            case .tint20:
                return Color(hexValue: 0x215C8B)
            case .tint30:
                return Color(hexValue: 0x4178A3)
            case .tint40:
                return Color(hexValue: 0x92B5D1)
            case .tint50:
                return Color(hexValue: 0xC2D6E7)
            case .tint60:
                return Color(hexValue: 0xEFF4F9)
            }
        case .darkBrown:
            switch token {
            case .primary:
                return Color(hexValue: 0x4D291C)
            case .shade10:
                return Color(hexValue: 0x452519)
            case .shade20:
                return Color(hexValue: 0x3A1F15)
            case .shade30:
                return Color(hexValue: 0x2B1710)
            case .shade40:
                return Color(hexValue: 0x170C08)
            case .shade50:
                return Color(hexValue: 0x0C0704)
            case .tint10:
                return Color(hexValue: 0x623A2B)
            case .tint20:
                return Color(hexValue: 0x784D3E)
            case .tint30:
                return Color(hexValue: 0x946B5C)
            case .tint40:
                return Color(hexValue: 0xCAADA3)
            case .tint50:
                return Color(hexValue: 0xE3D2CB)
            case .tint60:
                return Color(hexValue: 0xF8F3F2)
            }
        case .darkGreen:
            switch token {
            case .primary:
                return Color(hexValue: 0x0B6A0B)
            case .shade10:
                return Color(hexValue: 0x0A5F0A)
            case .shade20:
                return Color(hexValue: 0x085108)
            case .shade30:
                return Color(hexValue: 0x063B06)
            case .shade40:
                return Color(hexValue: 0x032003)
            case .shade50:
                return Color(hexValue: 0x021102)
            case .tint10:
                return Color(hexValue: 0x1A7C1A)
            case .tint20:
                return Color(hexValue: 0x2D8E2D)
            case .tint30:
                return Color(hexValue: 0x4DA64D)
            case .tint40:
                return Color(hexValue: 0x9AD29A)
            case .tint50:
                return Color(hexValue: 0xC6E7C6)
            case .tint60:
                return Color(hexValue: 0xF0F9F0)
            }
        case .darkOrange:
            switch token {
            case .primary:
                return Color(hexValue: 0xDA3B01)
            case .shade10:
                return Color(hexValue: 0xC43501)
            case .shade20:
                return Color(hexValue: 0xA62D01)
            case .shade30:
                return Color(hexValue: 0x7A2101)
            case .shade40:
                return Color(hexValue: 0x411200)
            case .shade50:
                return Color(hexValue: 0x230900)
            case .tint10:
                return Color(hexValue: 0xDE501C)
            case .tint20:
                return Color(hexValue: 0xE36537)
            case .tint30:
                return Color(hexValue: 0xE9835E)
            case .tint40:
                return Color(hexValue: 0xF4BFAB)
            case .tint50:
                return Color(hexValue: 0xF9DCD1)
            case .tint60:
                return Color(hexValue: 0xFDF6F3)
            }
        case .darkPurple:
            switch token {
            case .primary:
                return Color(hexValue: 0x401B6C)
            case .shade10:
                return Color(hexValue: 0x3A1861)
            case .shade20:
                return Color(hexValue: 0x311552)
            case .shade30:
                return Color(hexValue: 0x240F3C)
            case .shade40:
                return Color(hexValue: 0x130820)
            case .shade50:
                return Color(hexValue: 0x0A0411)
            case .tint10:
                return Color(hexValue: 0x512B7E)
            case .tint20:
                return Color(hexValue: 0x633E8F)
            case .tint30:
                return Color(hexValue: 0x7E5CA7)
            case .tint40:
                return Color(hexValue: 0xB9A3D3)
            case .tint50:
                return Color(hexValue: 0xD8CCE7)
            case .tint60:
                return Color(hexValue: 0xF5F2F9)
            }
        case .darkRed:
            switch token {
            case .primary:
                return Color(hexValue: 0x750B1C)
            case .shade10:
                return Color(hexValue: 0x690A19)
            case .shade20:
                return Color(hexValue: 0x590815)
            case .shade30:
                return Color(hexValue: 0x420610)
            case .shade40:
                return Color(hexValue: 0x230308)
            case .shade50:
                return Color(hexValue: 0x130204)
            case .tint10:
                return Color(hexValue: 0x861B2C)
            case .tint20:
                return Color(hexValue: 0x962F3F)
            case .tint30:
                return Color(hexValue: 0xAC4F5E)
            case .tint40:
                return Color(hexValue: 0xD69CA5)
            case .tint50:
                return Color(hexValue: 0xE9C7CD)
            case .tint60:
                return Color(hexValue: 0xF9F0F2)
            }
        case .darkTeal:
            switch token {
            case .primary:
                return Color(hexValue: 0x006666)
            case .shade10:
                return Color(hexValue: 0x005C5C)
            case .shade20:
                return Color(hexValue: 0x004E4E)
            case .shade30:
                return Color(hexValue: 0x003939)
            case .shade40:
                return Color(hexValue: 0x001F1F)
            case .shade50:
                return Color(hexValue: 0x001010)
            case .tint10:
                return Color(hexValue: 0x0E7878)
            case .tint20:
                return Color(hexValue: 0x218B8B)
            case .tint30:
                return Color(hexValue: 0x41A3A3)
            case .tint40:
                return Color(hexValue: 0x92D1D1)
            case .tint50:
                return Color(hexValue: 0xC2E7E7)
            case .tint60:
                return Color(hexValue: 0xEFF9F9)
            }
        case .forest:
            switch token {
            case .primary:
                return Color(hexValue: 0x498205)
            case .shade10:
                return Color(hexValue: 0x427505)
            case .shade20:
                return Color(hexValue: 0x376304)
            case .shade30:
                return Color(hexValue: 0x294903)
            case .shade40:
                return Color(hexValue: 0x162702)
            case .shade50:
                return Color(hexValue: 0x0C1501)
            case .tint10:
                return Color(hexValue: 0x599116)
            case .tint20:
                return Color(hexValue: 0x6BA02B)
            case .tint30:
                return Color(hexValue: 0x85B44C)
            case .tint40:
                return Color(hexValue: 0xBDD99B)
            case .tint50:
                return Color(hexValue: 0xDBEBC7)
            case .tint60:
                return Color(hexValue: 0xF6FAF0)
            }
        case .gold:
            switch token {
            case .primary:
                return Color(hexValue: 0xC19C00)
            case .shade10:
                return Color(hexValue: 0xAE8C00)
            case .shade20:
                return Color(hexValue: 0x937700)
            case .shade30:
                return Color(hexValue: 0x6C5700)
            case .shade40:
                return Color(hexValue: 0x3A2F00)
            case .shade50:
                return Color(hexValue: 0x1F1900)
            case .tint10:
                return Color(hexValue: 0xC8A718)
            case .tint20:
                return Color(hexValue: 0xD0B232)
            case .tint30:
                return Color(hexValue: 0xDAC157)
            case .tint40:
                return Color(hexValue: 0xECDFA5)
            case .tint50:
                return Color(hexValue: 0xF5EECE)
            case .tint60:
                return Color(hexValue: 0xFDFBF2)
            }
        case .grape:
            switch token {
            case .primary:
                return Color(hexValue: 0x881798)
            case .shade10:
                return Color(hexValue: 0x7A1589)
            case .shade20:
                return Color(hexValue: 0x671174)
            case .shade30:
                return Color(hexValue: 0x4C0D55)
            case .shade40:
                return Color(hexValue: 0x29072E)
            case .shade50:
                return Color(hexValue: 0x160418)
            case .tint10:
                return Color(hexValue: 0x952AA4)
            case .tint20:
                return Color(hexValue: 0xA33FB1)
            case .tint30:
                return Color(hexValue: 0xB55FC1)
            case .tint40:
                return Color(hexValue: 0xD9A7E0)
            case .tint50:
                return Color(hexValue: 0xEACEEF)
            case .tint60:
                return Color(hexValue: 0xFAF2FB)
            }
        case .green:
            switch token {
            case .primary:
                return Color(hexValue: 0x107C10)
            case .shade10:
                return Color(hexValue: 0x0E700E)
            case .shade20:
                return Color(hexValue: 0x0C5E0C)
            case .shade30:
                return Color(hexValue: 0x094509)
            case .shade40:
                return Color(hexValue: 0x052505)
            case .shade50:
                return Color(hexValue: 0x031403)
            case .tint10:
                return Color(hexValue: 0x218C21)
            case .tint20:
                return Color(hexValue: 0x359B35)
            case .tint30:
                return Color(hexValue: 0x54B054)
            case .tint40:
                return Color(hexValue: 0x9FD89F)
            case .tint50:
                return Color(hexValue: 0xC9EAC9)
            case .tint60:
                return Color(hexValue: 0xF1FAF1)
            }
        case .hotPink:
            switch token {
            case .primary:
                return Color(hexValue: 0xE3008C)
            case .shade10:
                return Color(hexValue: 0xCC007E)
            case .shade20:
                return Color(hexValue: 0xAD006A)
            case .shade30:
                return Color(hexValue: 0x7F004E)
            case .shade40:
                return Color(hexValue: 0x44002A)
            case .shade50:
                return Color(hexValue: 0x240016)
            case .tint10:
                return Color(hexValue: 0xE61C99)
            case .tint20:
                return Color(hexValue: 0xEA38A6)
            case .tint30:
                return Color(hexValue: 0xEE5FB7)
            case .tint40:
                return Color(hexValue: 0xF7ADDA)
            case .tint50:
                return Color(hexValue: 0xFBD2EB)
            case .tint60:
                return Color(hexValue: 0xFEF4FA)
            }
        case .lavender:
            switch token {
            case .primary:
                return Color(hexValue: 0x7160E8)
            case .shade10:
                return Color(hexValue: 0x6656D1)
            case .shade20:
                return Color(hexValue: 0x5649B0)
            case .shade30:
                return Color(hexValue: 0x3F3682)
            case .shade40:
                return Color(hexValue: 0x221D46)
            case .shade50:
                return Color(hexValue: 0x120F25)
            case .tint10:
                return Color(hexValue: 0x8172EB)
            case .tint20:
                return Color(hexValue: 0x9184EE)
            case .tint30:
                return Color(hexValue: 0xA79CF1)
            case .tint40:
                return Color(hexValue: 0xD2CCF8)
            case .tint50:
                return Color(hexValue: 0xE7E4FB)
            case .tint60:
                return Color(hexValue: 0xF9F8FE)
            }
        case .lightBlue:
            switch token {
            case .primary:
                return Color(hexValue: 0x3A96DD)
            case .shade10:
                return Color(hexValue: 0x3487C7)
            case .shade20:
                return Color(hexValue: 0x2C72A8)
            case .shade30:
                return Color(hexValue: 0x20547C)
            case .shade40:
                return Color(hexValue: 0x112D42)
            case .shade50:
                return Color(hexValue: 0x091823)
            case .tint10:
                return Color(hexValue: 0x4FA1E1)
            case .tint20:
                return Color(hexValue: 0x65ADE5)
            case .tint30:
                return Color(hexValue: 0x83BDEB)
            case .tint40:
                return Color(hexValue: 0xBFDDF5)
            case .tint50:
                return Color(hexValue: 0xDCEDFA)
            case .tint60:
                return Color(hexValue: 0xF6FAFE)
            }
        case .lightGreen:
            switch token {
            case .primary:
                return Color(hexValue: 0x13A10E)
            case .shade10:
                return Color(hexValue: 0x11910D)
            case .shade20:
                return Color(hexValue: 0x0E7A0B)
            case .shade30:
                return Color(hexValue: 0x0B5A08)
            case .shade40:
                return Color(hexValue: 0x063004)
            case .shade50:
                return Color(hexValue: 0x031A02)
            case .tint10:
                return Color(hexValue: 0x27AC22)
            case .tint20:
                return Color(hexValue: 0x3DB838)
            case .tint30:
                return Color(hexValue: 0x5EC75A)
            case .tint40:
                return Color(hexValue: 0xA7E3A5)
            case .tint50:
                return Color(hexValue: 0xCEF0CD)
            case .tint60:
                return Color(hexValue: 0xF2FBF2)
            }
        case .lightTeal:
            switch token {
            case .primary:
                return Color(hexValue: 0x00B7C3)
            case .shade10:
                return Color(hexValue: 0x00A5AF)
            case .shade20:
                return Color(hexValue: 0x008B94)
            case .shade30:
                return Color(hexValue: 0x00666D)
            case .shade40:
                return Color(hexValue: 0x00373A)
            case .shade50:
                return Color(hexValue: 0x001D1F)
            case .tint10:
                return Color(hexValue: 0x18BFCA)
            case .tint20:
                return Color(hexValue: 0x32C8D1)
            case .tint30:
                return Color(hexValue: 0x58D3DB)
            case .tint40:
                return Color(hexValue: 0xA6E9ED)
            case .tint50:
                return Color(hexValue: 0xCEF3F5)
            case .tint60:
                return Color(hexValue: 0xF2FCFD)
            }
        case .lilac:
            switch token {
            case .primary:
                return Color(hexValue: 0xB146C2)
            case .shade10:
                return Color(hexValue: 0x9F3FAF)
            case .shade20:
                return Color(hexValue: 0x863593)
            case .shade30:
                return Color(hexValue: 0x63276D)
            case .shade40:
                return Color(hexValue: 0x35153A)
            case .shade50:
                return Color(hexValue: 0x1C0B1F)
            case .tint10:
                return Color(hexValue: 0xBA58C9)
            case .tint20:
                return Color(hexValue: 0xC36BD1)
            case .tint30:
                return Color(hexValue: 0xCF87DA)
            case .tint40:
                return Color(hexValue: 0xE6BFED)
            case .tint50:
                return Color(hexValue: 0xF2DCF5)
            case .tint60:
                return Color(hexValue: 0xFCF6FD)
            }
        case .lime:
            switch token {
            case .primary:
                return Color(hexValue: 0x73AA24)
            case .shade10:
                return Color(hexValue: 0x689920)
            case .shade20:
                return Color(hexValue: 0x57811B)
            case .shade30:
                return Color(hexValue: 0x405F14)
            case .shade40:
                return Color(hexValue: 0x23330B)
            case .shade50:
                return Color(hexValue: 0x121B06)
            case .tint10:
                return Color(hexValue: 0x81B437)
            case .tint20:
                return Color(hexValue: 0x90BE4C)
            case .tint30:
                return Color(hexValue: 0xA4CC6C)
            case .tint40:
                return Color(hexValue: 0xCFE5AF)
            case .tint50:
                return Color(hexValue: 0xE5F1D3)
            case .tint60:
                return Color(hexValue: 0xF8FCF4)
            }
        case .magenta:
            switch token {
            case .primary:
                return Color(hexValue: 0xBF0077)
            case .shade10:
                return Color(hexValue: 0xAC006B)
            case .shade20:
                return Color(hexValue: 0x91005A)
            case .shade30:
                return Color(hexValue: 0x6B0043)
            case .shade40:
                return Color(hexValue: 0x390024)
            case .shade50:
                return Color(hexValue: 0x1F0013)
            case .tint10:
                return Color(hexValue: 0xC71885)
            case .tint20:
                return Color(hexValue: 0xCE3293)
            case .tint30:
                return Color(hexValue: 0xD957A8)
            case .tint40:
                return Color(hexValue: 0xECA5D1)
            case .tint50:
                return Color(hexValue: 0xF5CEE6)
            case .tint60:
                return Color(hexValue: 0xFCF2F9)
            }
        case .marigold:
            switch token {
            case .primary:
                return Color(hexValue: 0xEAA300)
            case .shade10:
                return Color(hexValue: 0xD39300)
            case .shade20:
                return Color(hexValue: 0xB27C00)
            case .shade30:
                return Color(hexValue: 0x835B00)
            case .shade40:
                return Color(hexValue: 0x463100)
            case .shade50:
                return Color(hexValue: 0x251A00)
            case .tint10:
                return Color(hexValue: 0xEDAD1C)
            case .tint20:
                return Color(hexValue: 0xEFB839)
            case .tint30:
                return Color(hexValue: 0xF2C661)
            case .tint40:
                return Color(hexValue: 0xF9E2AE)
            case .tint50:
                return Color(hexValue: 0xFCEFD3)
            case .tint60:
                return Color(hexValue: 0xFEFBF4)
            }
        case .mink:
            switch token {
            case .primary:
                return Color(hexValue: 0x5D5A58)
            case .shade10:
                return Color(hexValue: 0x54514F)
            case .shade20:
                return Color(hexValue: 0x474443)
            case .shade30:
                return Color(hexValue: 0x343231)
            case .shade40:
                return Color(hexValue: 0x1C1B1A)
            case .shade50:
                return Color(hexValue: 0x0F0E0E)
            case .tint10:
                return Color(hexValue: 0x706D6B)
            case .tint20:
                return Color(hexValue: 0x84817E)
            case .tint30:
                return Color(hexValue: 0x9E9B99)
            case .tint40:
                return Color(hexValue: 0xCECCCB)
            case .tint50:
                return Color(hexValue: 0xE5E4E3)
            case .tint60:
                return Color(hexValue: 0xF8F8F8)
            }
        case .navy:
            switch token {
            case .primary:
                return Color(hexValue: 0x0027B4)
            case .shade10:
                return Color(hexValue: 0x0023A2)
            case .shade20:
                return Color(hexValue: 0x001E89)
            case .shade30:
                return Color(hexValue: 0x001665)
            case .shade40:
                return Color(hexValue: 0x000C36)
            case .shade50:
                return Color(hexValue: 0x00061D)
            case .tint10:
                return Color(hexValue: 0x173BBD)
            case .tint20:
                return Color(hexValue: 0x3050C6)
            case .tint30:
                return Color(hexValue: 0x546FD2)
            case .tint40:
                return Color(hexValue: 0xA3B2E8)
            case .tint50:
                return Color(hexValue: 0xCCD5F3)
            case .tint60:
                return Color(hexValue: 0xF2F4FC)
            }
        case .orange:
            switch token {
            case .primary:
                return Color(hexValue: 0xF7630C)
            case .shade10:
                return Color(hexValue: 0xDE590B)
            case .shade20:
                return Color(hexValue: 0xBC4B09)
            case .shade30:
                return Color(hexValue: 0x8A3707)
            case .shade40:
                return Color(hexValue: 0x4A1E04)
            case .shade50:
                return Color(hexValue: 0x271002)
            case .tint10:
                return Color(hexValue: 0xF87528)
            case .tint20:
                return Color(hexValue: 0xF98845)
            case .tint30:
                return Color(hexValue: 0xFAA06B)
            case .tint40:
                return Color(hexValue: 0xFDCFB4)
            case .tint50:
                return Color(hexValue: 0xFEE5D7)
            case .tint60:
                return Color(hexValue: 0xFFF9F5)
            }
        case .orchid:
            switch token {
            case .primary:
                return Color(hexValue: 0x8764B8)
            case .shade10:
                return Color(hexValue: 0x795AA6)
            case .shade20:
                return Color(hexValue: 0x674C8C)
            case .shade30:
                return Color(hexValue: 0x4C3867)
            case .shade40:
                return Color(hexValue: 0x281E37)
            case .shade50:
                return Color(hexValue: 0x16101D)
            case .tint10:
                return Color(hexValue: 0x9373C0)
            case .tint20:
                return Color(hexValue: 0xA083C9)
            case .tint30:
                return Color(hexValue: 0xB29AD4)
            case .tint40:
                return Color(hexValue: 0xD7CAEA)
            case .tint50:
                return Color(hexValue: 0xE9E2F4)
            case .tint60:
                return Color(hexValue: 0xF9F8FC)
            }
        case .peach:
            switch token {
            case .primary:
                return Color(hexValue: 0xFF8C00)
            case .shade10:
                return Color(hexValue: 0xE67E00)
            case .shade20:
                return Color(hexValue: 0xC26A00)
            case .shade30:
                return Color(hexValue: 0x8F4E00)
            case .shade40:
                return Color(hexValue: 0x4D2A00)
            case .shade50:
                return Color(hexValue: 0x291600)
            case .tint10:
                return Color(hexValue: 0xFF9A1F)
            case .tint20:
                return Color(hexValue: 0xFFA83D)
            case .tint30:
                return Color(hexValue: 0xFFBA66)
            case .tint40:
                return Color(hexValue: 0xFFDDB3)
            case .tint50:
                return Color(hexValue: 0xFFEDD6)
            case .tint60:
                return Color(hexValue: 0xFFFAF5)
            }
        case .pink:
            switch token {
            case .primary:
                return Color(hexValue: 0xE43BA6)
            case .shade10:
                return Color(hexValue: 0xCD3595)
            case .shade20:
                return Color(hexValue: 0xAD2D7E)
            case .shade30:
                return Color(hexValue: 0x80215D)
            case .shade40:
                return Color(hexValue: 0x441232)
            case .shade50:
                return Color(hexValue: 0x24091B)
            case .tint10:
                return Color(hexValue: 0xE750B0)
            case .tint20:
                return Color(hexValue: 0xEA66BA)
            case .tint30:
                return Color(hexValue: 0xEF85C8)
            case .tint40:
                return Color(hexValue: 0xF7C0E3)
            case .tint50:
                return Color(hexValue: 0xFBDDF0)
            case .tint60:
                return Color(hexValue: 0xFEF6FB)
            }
        case .platinum:
            switch token {
            case .primary:
                return Color(hexValue: 0x69797E)
            case .shade10:
                return Color(hexValue: 0x5F6D71)
            case .shade20:
                return Color(hexValue: 0x505C60)
            case .shade30:
                return Color(hexValue: 0x3B4447)
            case .shade40:
                return Color(hexValue: 0x1F2426)
            case .shade50:
                return Color(hexValue: 0x111314)
            case .tint10:
                return Color(hexValue: 0x79898D)
            case .tint20:
                return Color(hexValue: 0x89989D)
            case .tint30:
                return Color(hexValue: 0xA0ADB2)
            case .tint40:
                return Color(hexValue: 0xCDD6D8)
            case .tint50:
                return Color(hexValue: 0xE4E9EA)
            case .tint60:
                return Color(hexValue: 0xF8F9FA)
            }
        case .plum:
            switch token {
            case .primary:
                return Color(hexValue: 0x77004D)
            case .shade10:
                return Color(hexValue: 0x6B0045)
            case .shade20:
                return Color(hexValue: 0x5A003B)
            case .shade30:
                return Color(hexValue: 0x43002B)
            case .shade40:
                return Color(hexValue: 0x240017)
            case .shade50:
                return Color(hexValue: 0x13000C)
            case .tint10:
                return Color(hexValue: 0x87105D)
            case .tint20:
                return Color(hexValue: 0x98246F)
            case .tint30:
                return Color(hexValue: 0xAD4589)
            case .tint40:
                return Color(hexValue: 0xD696C0)
            case .tint50:
                return Color(hexValue: 0xE9C4DC)
            case .tint60:
                return Color(hexValue: 0xFAF0F6)
            }
        case .pumpkin:
            switch token {
            case .primary:
                return Color(hexValue: 0xCA5010)
            case .shade10:
                return Color(hexValue: 0xB6480E)
            case .shade20:
                return Color(hexValue: 0x9A3D0C)
            case .shade30:
                return Color(hexValue: 0x712D09)
            case .shade40:
                return Color(hexValue: 0x3D1805)
            case .shade50:
                return Color(hexValue: 0x200D03)
            case .tint10:
                return Color(hexValue: 0xD06228)
            case .tint20:
                return Color(hexValue: 0xD77440)
            case .tint30:
                return Color(hexValue: 0xDF8E64)
            case .tint40:
                return Color(hexValue: 0xEFC4AD)
            case .tint50:
                return Color(hexValue: 0xF7DFD2)
            case .tint60:
                return Color(hexValue: 0xFDF7F4)
            }
        case .purple:
            switch token {
            case .primary:
                return Color(hexValue: 0x5C2E91)
            case .shade10:
                return Color(hexValue: 0x532982)
            case .shade20:
                return Color(hexValue: 0x46236E)
            case .shade30:
                return Color(hexValue: 0x341A51)
            case .shade40:
                return Color(hexValue: 0x1C0E2B)
            case .shade50:
                return Color(hexValue: 0x0F0717)
            case .tint10:
                return Color(hexValue: 0x6B3F9E)
            case .tint20:
                return Color(hexValue: 0x7C52AB)
            case .tint30:
                return Color(hexValue: 0x9470BD)
            case .tint40:
                return Color(hexValue: 0xC6B1DE)
            case .tint50:
                return Color(hexValue: 0xE0D3ED)
            case .tint60:
                return Color(hexValue: 0xF7F4FB)
            }
        case .red:
            switch token {
            case .primary:
                return Color(hexValue: 0xD13438)
            case .shade10:
                return Color(hexValue: 0xBC2F32)
            case .shade20:
                return Color(hexValue: 0x9F282B)
            case .shade30:
                return Color(hexValue: 0x751D1F)
            case .shade40:
                return Color(hexValue: 0x3F1011)
            case .shade50:
                return Color(hexValue: 0x210809)
            case .tint10:
                return Color(hexValue: 0xD7494C)
            case .tint20:
                return Color(hexValue: 0xDC5E62)
            case .tint30:
                return Color(hexValue: 0xE37D80)
            case .tint40:
                return Color(hexValue: 0xF1BBBC)
            case .tint50:
                return Color(hexValue: 0xF8DADB)
            case .tint60:
                return Color(hexValue: 0xFDF6F6)
            }
        case .royalBlue:
            switch token {
            case .primary:
                return Color(hexValue: 0x004E8C)
            case .shade10:
                return Color(hexValue: 0x00467E)
            case .shade20:
                return Color(hexValue: 0x003B6A)
            case .shade30:
                return Color(hexValue: 0x002C4E)
            case .shade40:
                return Color(hexValue: 0x00172A)
            case .shade50:
                return Color(hexValue: 0x000C16)
            case .tint10:
                return Color(hexValue: 0x125E9A)
            case .tint20:
                return Color(hexValue: 0x286FA8)
            case .tint30:
                return Color(hexValue: 0x4A89BA)
            case .tint40:
                return Color(hexValue: 0x9ABFDC)
            case .tint50:
                return Color(hexValue: 0xC7DCED)
            case .tint60:
                return Color(hexValue: 0xF0F6FA)
            }
        case .seafoam:
            switch token {
            case .primary:
                return Color(hexValue: 0x00CC6A)
            case .shade10:
                return Color(hexValue: 0x00B85F)
            case .shade20:
                return Color(hexValue: 0x009B51)
            case .shade30:
                return Color(hexValue: 0x00723B)
            case .shade40:
                return Color(hexValue: 0x003D20)
            case .shade50:
                return Color(hexValue: 0x002111)
            case .tint10:
                return Color(hexValue: 0x19D279)
            case .tint20:
                return Color(hexValue: 0x34D889)
            case .tint30:
                return Color(hexValue: 0x5AE0A0)
            case .tint40:
                return Color(hexValue: 0xA8F0CD)
            case .tint50:
                return Color(hexValue: 0xCFF7E4)
            case .tint60:
                return Color(hexValue: 0xF3FDF8)
            }
        case .silver:
            switch token {
            case .primary:
                return Color(hexValue: 0x859599)
            case .shade10:
                return Color(hexValue: 0x78868A)
            case .shade20:
                return Color(hexValue: 0x657174)
            case .shade30:
                return Color(hexValue: 0x4A5356)
            case .shade40:
                return Color(hexValue: 0x282D2E)
            case .shade50:
                return Color(hexValue: 0x151818)
            case .tint10:
                return Color(hexValue: 0x92A1A5)
            case .tint20:
                return Color(hexValue: 0xA0AEB1)
            case .tint30:
                return Color(hexValue: 0xB3BFC2)
            case .tint40:
                return Color(hexValue: 0xD8DFE0)
            case .tint50:
                return Color(hexValue: 0xEAEEEF)
            case .tint60:
                return Color(hexValue: 0xFAFBFB)
            }
        case .steel:
            switch token {
            case .primary:
                return Color(hexValue: 0x005B70)
            case .shade10:
                return Color(hexValue: 0x005265)
            case .shade20:
                return Color(hexValue: 0x004555)
            case .shade30:
                return Color(hexValue: 0x00333F)
            case .shade40:
                return Color(hexValue: 0x001B22)
            case .shade50:
                return Color(hexValue: 0x000F12)
            case .tint10:
                return Color(hexValue: 0x0F6C81)
            case .tint20:
                return Color(hexValue: 0x237D92)
            case .tint30:
                return Color(hexValue: 0x4496A9)
            case .tint40:
                return Color(hexValue: 0x94C8D4)
            case .tint50:
                return Color(hexValue: 0xC3E1E8)
            case .tint60:
                return Color(hexValue: 0xEFF7F9)
            }
        case .teal:
            switch token {
            case .primary:
                return Color(hexValue: 0x038387)
            case .shade10:
                return Color(hexValue: 0x037679)
            case .shade20:
                return Color(hexValue: 0x026467)
            case .shade30:
                return Color(hexValue: 0x02494C)
            case .shade40:
                return Color(hexValue: 0x012728)
            case .shade50:
                return Color(hexValue: 0x001516)
            case .tint10:
                return Color(hexValue: 0x159195)
            case .tint20:
                return Color(hexValue: 0x2AA0A4)
            case .tint30:
                return Color(hexValue: 0x4CB4B7)
            case .tint40:
                return Color(hexValue: 0x9BD9DB)
            case .tint50:
                return Color(hexValue: 0xC7EBEC)
            case .tint60:
                return Color(hexValue: 0xF0FAFA)
            }
        case .yellow:
            switch token {
            case .primary:
                return Color(hexValue: 0xFDE300)
            case .shade10:
                return Color(hexValue: 0xE4CC00)
            case .shade20:
                return Color(hexValue: 0xC0AD00)
            case .shade30:
                return Color(hexValue: 0x817400)
            case .shade40:
                return Color(hexValue: 0x4C4400)
            case .shade50:
                return Color(hexValue: 0x282400)
            case .tint10:
                return Color(hexValue: 0xFDE61E)
            case .tint20:
                return Color(hexValue: 0xFDEA3D)
            case .tint30:
                return Color(hexValue: 0xFEEE66)
            case .tint40:
                return Color(hexValue: 0xFEF7B2)
            case .tint50:
                return Color(hexValue: 0xFFFAD6)
            case .tint60:
                return Color(hexValue: 0xFFFEF5)
            }
        }
    }

    // MARK: - FontSize

    public enum FontSizeToken: CaseIterable, Hashable {
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
    public static func fontSize(_ token: FontSizeToken) -> CGFloat {
        return platformGlobalTokenProvider.fontSize(for: token)
    }

    // MARK: - FontWeight

    public enum FontWeightToken: CaseIterable, Hashable {
        case regular
        case medium
        case semibold
        case bold
    }
    public static func fontWeight(_ token: FontWeightToken) -> Font.Weight {
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

    public enum IconSizeToken: CaseIterable, Hashable {
        case size100
        case size120
        case size160
        case size200
        case size240
        case size280
        case size360
        case size400
        case size480
    }
    public static func icon(_ token: IconSizeToken) -> CGFloat {
        switch token {
        case .size100:
            return 10
        case .size120:
            return 12
        case .size160:
            return 16
        case .size200:
            return 20
        case .size240:
            return 24
        case .size280:
            return 28
        case .size360:
            return 36
        case .size400:
            return 40
        case .size480:
            return 48
        }
    }

    // MARK: - Spacing

    public enum SpacingToken: CaseIterable, Hashable {
        case sizeNone
        case size20
        case size40
        case size60
        case size80
        case size100
        case size120
        case size160
        case size200
        case size240
        case size280
        case size320
        case size360
        case size400
        case size480
        case size520
        case size560
    }
    public static func spacing(_ token: SpacingToken) -> CGFloat {
        switch token {
        case .sizeNone:
            return 0
        case .size20:
            return 2
        case .size40:
            return 4
        case .size60:
            return 6
        case .size80:
            return 8
        case .size100:
            return 10
        case .size120:
            return 12
        case .size160:
            return 16
        case .size200:
            return 20
        case .size240:
            return 24
        case .size280:
            return 28
        case .size320:
            return 32
        case .size360:
            return 36
        case .size400:
            return 40
        case .size480:
            return 48
        case .size520:
            return 52
        case .size560:
            return 56
        }
    }

    // MARK: - BorderRadius

    public enum CornerRadiusToken: CaseIterable, Hashable {
        case radiusNone
        case radius20
        case radius40
        case radius60
        case radius80
        case radius120
        case radiusCircular
    }
    public static func corner(_ token: CornerRadiusToken) -> CGFloat {
        switch token {
        case .radiusNone:
            return 0
        case .radius20:
            return 2
        case .radius40:
            return 4
        case .radius60:
            return 6
        case .radius80:
            return 8
        case .radius120:
            return 12
        case .radiusCircular:
            return 9999
        }
    }

    // MARK: - BorderSize

    public enum StrokeWidthToken: CaseIterable, Hashable {
        case widthNone
        case width05
        case width10
        case width15
        case width20
        case width30
        case width40
        case width60
    }
    public static func stroke(_ token: StrokeWidthToken) -> CGFloat {
        switch token {
        case .widthNone:
            return 0
        case .width05:
            return 0.5
        case .width10:
            return 1
        case .width15:
            return 1.5
        case .width20:
            return 2
        case .width30:
            return 3
        case .width40:
            return 4
        case .width60:
            return 6
        }
    }

    // MARK: - Initialization

    @available(*, unavailable)
    private override init() {
        preconditionFailure("GlobalTokens should never be initialized!")
    }

    // MARK: - PlatformGlobalTokenProviding

    private static var platformGlobalTokenProvider: any PlatformGlobalTokenProviding.Type {
        // We need slightly different implementations depending on how our package is loaded.
#if SWIFT_PACKAGE || COCOAPODS
        // In this case, the protocol conformance happens in a different module, so we need to
        // convert the type conditionally and fail if something goes wrong.
        guard let platformGlobalTokenProvider = self as? PlatformGlobalTokenProviding.Type else {
            preconditionFailure("GlobalTokens should conform to PlatformGlobalTokenProviding")
        }
#else
        // Otherwise, we're all in one module and thus the type conversion is guaranteed.
        let platformGlobalTokenProvider = self as PlatformGlobalTokenProviding.Type
#endif
        return platformGlobalTokenProvider
    }
}
