//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public final class AliasTokens {

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
    }
    public var brandColors: TokenSet<BrandColorsTokens, DynamicColor> = .init { token in
        switch token {
        case .primary:
            return DynamicColor(light: ColorValue(0x0F6CBD) /*comm80*/, dark: ColorValue(0x2886DE) /*comm90*/)
        case .shade10:
            return DynamicColor(light: ColorValue(0x115EA3) /*comm70*/, dark: ColorValue(0x292929) /*comm100*/)
        case .shade20:
            return DynamicColor(light: ColorValue(0x0F548C) /*comm60*/, dark: ColorValue(0x479EF5) /*comm110*/)
        case .shade30:
            return DynamicColor(light: ColorValue(0x0E4775) /*comm50*/, dark: ColorValue(0x77B7F7) /*comm120*/)
        case .tint10:
            return DynamicColor(light: ColorValue(0x2886DE) /*comm90*/, dark: ColorValue(0x0F6CBD) /*comm80*/)
        case .tint20:
            return DynamicColor(light: ColorValue(0x292929) /*comm100*/, dark: ColorValue(0x115EA3) /*comm70*/)
        case .tint30:
            return DynamicColor(light: ColorValue(0x479EF5) /*comm110*/, dark: ColorValue(0x0C3B5E) /*comm90*/)
        case .tint40:
            return DynamicColor(light: ColorValue(0xB4D6FA) /*comm140*/, dark: ColorValue(0x082338) /*comm20*/)
        case .comm10:
            return DynamicColor(light: ColorValue(0x061724))
        case .comm20:
            return DynamicColor(light: ColorValue(0x082338))
        case .comm30:
            return DynamicColor(light: ColorValue(0x0A2E4A))
        case .comm40:
            return DynamicColor(light: ColorValue(0x0C3B5E))
        case .comm50:
            return DynamicColor(light: ColorValue(0x0E4775))
        case .comm60:
            return DynamicColor(light: ColorValue(0x0F548C))
        case .comm70:
            return DynamicColor(light: ColorValue(0x115EA3))
        case .comm80:
            return DynamicColor(light: ColorValue(0x0F6CBD))
        case .comm90:
            return DynamicColor(light: ColorValue(0x2886DE))
        case .comm100:
            return DynamicColor(light: ColorValue(0x479EF5))
        case .comm110:
            return DynamicColor(light: ColorValue(0x62ABF5))
        case .comm120:
            return DynamicColor(light: ColorValue(0x77B7F7))
        case .comm130:
            return DynamicColor(light: ColorValue(0x96C6FA))
        case .comm140:
            return DynamicColor(light: ColorValue(0xB4D6FA))
        case .comm150:
            return DynamicColor(light: ColorValue(0xCFE4FA))
        case .comm160:
            return DynamicColor(light: ColorValue(0xEBF3FC))
        }
    }

    // MARK: ForegroundColors

    public enum ForegroundColorsTokens: CaseIterable {
        case neutral1
        case neutral2
        case neutral3
        case neutral4
        case neutralDisabled
        case neutralInverted
        case brandRest
        case brandHover
        case brandPressed
        case brandSelected
        case brandDisabled
    }
    public lazy var foregroundColors: TokenSet<ForegroundColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                lightHighContrast: GlobalTokens.neutralColors(.black),
                                dark: GlobalTokens.neutralColors(.white),
                                darkHighContrast: GlobalTokens.neutralColors(.white))
        case .neutral2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey26),
                                lightHighContrast: GlobalTokens.neutralColors(.black),
                                dark: GlobalTokens.neutralColors(.grey84),
                                darkHighContrast: GlobalTokens.neutralColors(.white))
        case .neutral3:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                lightHighContrast: GlobalTokens.neutralColors(.grey14),
                                dark: GlobalTokens.neutralColors(.grey68),
                                darkHighContrast: GlobalTokens.neutralColors(.grey84))
        case .neutral4:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey50),
                                lightHighContrast: GlobalTokens.neutralColors(.grey26),
                                dark: GlobalTokens.neutralColors(.grey52),
                                darkHighContrast: GlobalTokens.neutralColors(.grey84))
        case .neutralDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey74),
                                lightHighContrast: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey36),
                                darkHighContrast: GlobalTokens.neutralColors(.grey62))
        case .neutralInverted:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                lightHighContrast: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black),
                                darkHighContrast: GlobalTokens.neutralColors(.black))
        case .brandRest:
            return DynamicColor(light: strongSelf.brandColors[.primary].light,
                                lightHighContrast: strongSelf.brandColors[.shade20].light,
                                dark: strongSelf.brandColors[.primary].dark,
                                darkHighContrast: strongSelf.brandColors[.tint20].dark)
        case .brandHover:
            return strongSelf.brandColors[.shade10]
        case .brandPressed:
            return strongSelf.brandColors[.shade30]
        case .brandSelected:
            return strongSelf.brandColors[.shade20]
        case .brandDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey74),
                                dark: GlobalTokens.neutralColors(.grey36))
        }
    }

    // MARK: BackgroundColors

    public enum BackgroundColorsTokens: CaseIterable {
        case neutral1
        case neutral2
        case neutral3
        case neutral4
        case neutral5
        case neutralDisabled
        case brandRest
        case brandHover
        case brandPressed
        case brandSelected
        case brandDisabled
        case surfaceQuaternary
    }
    public lazy var backgroundColors: TokenSet<BackgroundColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black),
                                darkElevated: GlobalTokens.neutralColors(.grey4))
        case .neutral2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey98),
                                dark: GlobalTokens.neutralColors(.grey4),
                                darkElevated: GlobalTokens.neutralColors(.grey8))
        case .neutral3:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey96),
                                dark: GlobalTokens.neutralColors(.grey8),
                                darkElevated: GlobalTokens.neutralColors(.grey12))
        case .neutral4:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey94),
                                dark: GlobalTokens.neutralColors(.grey12),
                                darkElevated: GlobalTokens.neutralColors(.grey16))
        case .neutral5:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                                dark: GlobalTokens.neutralColors(.grey36),
                                darkElevated: GlobalTokens.neutralColors(.grey36))
        case .neutralDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey84),
                                darkElevated: GlobalTokens.neutralColors(.grey84))
        case .brandRest:
            return strongSelf.brandColors[.primary]
        case .brandHover:
            return strongSelf.brandColors[.shade10]
        case .brandPressed:
            return strongSelf.brandColors[.shade30]
        case .brandSelected:
            return strongSelf.brandColors[.shade20]
        case .brandDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey84))
        case .surfaceQuaternary:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey26))
        }
    }

    // MARK: StrokeColors

    public enum StrokeColorsTokens: CaseIterable {
        case neutral1
        case neutral2
    }
    public lazy var strokeColors: TokenSet<StrokeColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey94),
                                lightHighContrast: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey24),
                                darkHighContrast: GlobalTokens.neutralColors(.grey68),
                                darkElevated: GlobalTokens.neutralColors(.grey32))
        case .neutral2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                lightHighContrast: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey32),
                                darkHighContrast: GlobalTokens.neutralColors(.grey68),
                                darkElevated: GlobalTokens.neutralColors(.grey36))
        }
    }

    // MARK: - ShadowColors

    public enum ShadowColorsTokens: CaseIterable {
        case neutralAmbient
        case neutralKey
        case neutralAmbientLighter
        case neutralKeyLighter
        case neutralAmbientDarker
        case neutralKeyDarker
        case brandAmbient
        case brandKey
    }
    lazy public var shadowColors: TokenSet<ShadowColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutralAmbient:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.12),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.20))
        case .neutralKey:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.14),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.28))
        case .neutralAmbientLighter:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.06),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.12))
        case .neutralKeyLighter:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.07),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.14))
        case .neutralAmbientDarker:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.20),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.40))
        case .neutralKeyDarker:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.24),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.48))
        case .brandAmbient:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.30),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.30))
        case .brandKey:
            return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.25),
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.25))
        }
    }

    // MARK: - Typography

    public enum TypographyTokens: CaseIterable {
        case display
        case largeTitle
        case title1
        case title2
        case title3
        case body1Strong
        case body1
        case body2Strong
        case body2
        case caption1Strong
        case caption1
        case caption2
    }
    lazy public var typography: TokenSet<TypographyTokens, FontInfo> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .display:
            return .init(size: GlobalTokens.fontSize(.size900),
                         weight: GlobalTokens.fontWeight(.bold))
        case .largeTitle:
            return .init(size: GlobalTokens.fontSize(.size800),
                         weight: GlobalTokens.fontWeight(.bold))
        case .title1:
            return .init(size: GlobalTokens.fontSize(.size700),
                         weight: GlobalTokens.fontWeight(.bold))
        case .title2:
            return .init(size: GlobalTokens.fontSize(.size600),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .title3:
            return .init(size: GlobalTokens.fontSize(.size500),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .body1Strong:
            return .init(size: GlobalTokens.fontSize(.size400),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .body1:
            return .init(size: GlobalTokens.fontSize(.size400),
                         weight: GlobalTokens.fontWeight(.regular))
        case .body2Strong:
            return .init(size: GlobalTokens.fontSize(.size300),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .body2:
            return .init(size: GlobalTokens.fontSize(.size300),
                         weight: GlobalTokens.fontWeight(.regular))
        case .caption1Strong:
            return .init(size: GlobalTokens.fontSize(.size200),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .caption1:
            return .init(size: GlobalTokens.fontSize(.size200),
                         weight: GlobalTokens.fontWeight(.regular))
        case .caption2:
            return .init(size: GlobalTokens.fontSize(.size100),
                         weight: GlobalTokens.fontWeight(.regular))
        }
    }

    // MARK: - Shadow

    public enum ShadowTokens: CaseIterable {
        case shadow02
        case shadow04
        case shadow08
        case shadow16
        case shadow28
        case shadow64
    }
    lazy public var shadow: TokenSet<ShadowTokens, ShadowInfo> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .shadow02:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 2,
                              xOne: 0,
                              yOne: 1,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 2,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow04:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 4,
                              xOne: 0,
                              yOne: 2,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 2,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow08:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 8,
                              xOne: 0,
                              yOne: 4,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 2,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow16:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 16,
                              xOne: 0,
                              yOne: 8,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 2,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow28:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKeyDarker],
                              blurOne: 28,
                              xOne: 0,
                              yOne: 14,
                              colorTwo: strongSelf.shadowColors[.neutralAmbientDarker],
                              blurTwo: 8,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow64:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKeyDarker],
                              blurOne: 64,
                              xOne: 0,
                              yOne: 32,
                              colorTwo: strongSelf.shadowColors[.neutralAmbientDarker],
                              blurTwo: 8,
                              xTwo: 0,
                              yTwo: 0)
        }
    }

    // MARK: Elevation

    public enum ElevationTokens: CaseIterable {
        case interactiveElevation1Rest
        case interactiveElevation1Hover
        case interactiveElevation1Pressed
        case interactiveElevation1Selected
        case interactiveElevation1Disabled
    }
    lazy public var elevation: TokenSet<ElevationTokens, ShadowInfo> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .interactiveElevation1Rest:
            return strongSelf.shadow[.shadow08]
        case .interactiveElevation1Hover:
            return strongSelf.shadow[.shadow02]
        case .interactiveElevation1Pressed:
            return strongSelf.shadow[.shadow02]
        case .interactiveElevation1Selected:
            return strongSelf.shadow[.shadow02]
        case .interactiveElevation1Disabled:
            return strongSelf.shadow[.shadow02]
        }
    }

    // MARK: Colors

    public enum ColorsTokens: CaseIterable {
        // Foreground colors
        case foreground1
        case foreground2
        case foreground3
        case foregroundDisabled1
        case foregroundDisabled2
        case foregroundContrast
        case foregroundOnColor
        case foregroundInverted1
        case foregroundInverted2
        case brandForeground1
        case brandForeground1Pressed
        case brandForeground1Selected
        case brandForeground2
        case brandForeground3
        case brandForeground4
        case brandForeground5
        case brandForegroundInverted
        case brandForegroundDisabled1
        case brandForegroundDisabled2
        // Background colors
        case background1
        case background1Pressed
        case background1Selected
        case background2
        case background2Pressed
        case background2Selected
        case background3
        case background3Pressed
        case background3Selected
        case background4
        case background4Pressed
        case background4Selected
        case background5
        case background5Pressed
        case background5Selected
        case background5SelectedBrandFilled
        case background5BrandTint
        case background6
        case background6Pressed
        case background6Selected
        case backgroundInverted
        case backgroundDisabled
        case brandBackground1
        case brandBackground1Pressed
        case brandBackground1Selected
        case brandBackground2
        case brandBackground2Pressed
        case brandBackground2Selected
        case brandBackground3
        case brandBackground3Pressed
        case brandBackground3Selected
        case brandBackground4
        case background5BrandFilledSelected
        case background5BrandTintSelected
        case brandBackgroundInverted
        case brandBackgroundDisabled
        case brandBackgroundInvertedDisabled
        case stencil1
        case stencil2
        case canvasBackground
        // Stroke colors
        case stroke1
        case stroke2
        case strokeDisabled
        case strokeAccessible
        case strokeFocus1
        case strokeFocus2
        case brandStroke1
        case brandStroke1Pressed
        case brandStroke1Selected
    }
    public lazy var colors: TokenSet<ColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        // Foreground colors
        case .foreground1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                dark: GlobalTokens.neutralColors(.white))
        case .foreground2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey84))
        case .foreground3:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey50),
                                dark: GlobalTokens.neutralColors(.grey68))
        case .foregroundDisabled1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey74),
                                dark: GlobalTokens.neutralColors(.grey36))
        case .foregroundDisabled2:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.grey18))
        case .foregroundContrast:
            return DynamicColor(light: GlobalTokens.neutralColors(.black),
                                dark: GlobalTokens.neutralColors(.black))
        case .foregroundOnColor:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black))
        case .foregroundInverted1:
            return DynamicColor(light: GlobalTokens.neutralColors(.white))
        case .foregroundInverted2:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: GlobalTokens.neutralColors(.white))
        case .brandForeground1:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: strongSelf.brandColors[.comm100].light)
        case .brandForeground1Pressed:
            return DynamicColor(light: strongSelf.brandColors[.comm50].light,
                                dark: strongSelf.brandColors[.comm140].light)
        case .brandForeground1Selected:
            return DynamicColor(light: strongSelf.brandColors[.comm60].light,
                                dark: strongSelf.brandColors[.comm120].light)
        case .brandForeground2:
            return DynamicColor(light: strongSelf.brandColors[.comm160].light,
                                dark: strongSelf.brandColors[.comm20].light)
        case .brandForeground3:
            return DynamicColor(light: strongSelf.brandColors[.comm150].light)
        case .brandForeground4:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: strongSelf.brandColors[.comm120].light)
        case .brandForeground5:
            return DynamicColor(light: strongSelf.brandColors[.comm70].light)
        case .brandForegroundInverted:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: GlobalTokens.neutralColors(.white))
        case .brandForegroundDisabled1:
            return DynamicColor(light: strongSelf.brandColors[.comm90].light)
        case .brandForegroundDisabled2:
            return DynamicColor(light: strongSelf.brandColors[.comm140].light,
                                dark: strongSelf.brandColors[.comm40].light)
        // Background colors
        case .background1:
         return DynamicColor(light: GlobalTokens.neutralColors(.white),
                             dark: GlobalTokens.neutralColors(.black),
                             darkElevated: GlobalTokens.neutralColors(.grey4))
        case .background1Pressed:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                             dark: GlobalTokens.neutralColors(.grey18),
                             darkElevated: GlobalTokens.neutralColors(.grey18))
        case .background1Selected:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                             dark: GlobalTokens.neutralColors(.grey14),
                             darkElevated: GlobalTokens.neutralColors(.grey14))
        case .background2:
         return DynamicColor(light: GlobalTokens.neutralColors(.white),
                             dark: GlobalTokens.neutralColors(.grey12),
                             darkElevated: GlobalTokens.neutralColors(.grey16))
        case .background2Pressed:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                             dark: GlobalTokens.neutralColors(.grey30),
                             darkElevated: GlobalTokens.neutralColors(.grey30))
        case .background2Selected:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                             dark: GlobalTokens.neutralColors(.grey26),
                             darkElevated: GlobalTokens.neutralColors(.grey26))
        case .background3:
         return DynamicColor(light: GlobalTokens.neutralColors(.white),
                             dark: GlobalTokens.neutralColors(.grey16),
                             darkElevated: GlobalTokens.neutralColors(.grey20))
        case .background3Pressed:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                             dark: GlobalTokens.neutralColors(.grey34),
                             darkElevated: GlobalTokens.neutralColors(.grey34))
        case .background3Selected:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                             dark: GlobalTokens.neutralColors(.grey30),
                             darkElevated: GlobalTokens.neutralColors(.grey30))
        case .background4:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey98),
                             dark: GlobalTokens.neutralColors(.grey20),
                             darkElevated: GlobalTokens.neutralColors(.grey24))
        case .background4Pressed:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey86),
                             dark: GlobalTokens.neutralColors(.grey38),
                             darkElevated: GlobalTokens.neutralColors(.grey38))
        case .background4Selected:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey90),
                             dark: GlobalTokens.neutralColors(.grey34),
                             darkElevated: GlobalTokens.neutralColors(.grey34))
        case .background5:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey94),
                             dark: GlobalTokens.neutralColors(.grey24),
                             darkElevated: GlobalTokens.neutralColors(.grey28))
        case .background5Pressed:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                             dark: GlobalTokens.neutralColors(.grey42),
                             darkElevated: GlobalTokens.neutralColors(.grey42))
        case .background5Selected:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey86),
                             dark: GlobalTokens.neutralColors(.grey38),
                             darkElevated: GlobalTokens.neutralColors(.grey38))
        case .background5SelectedBrandFilled:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                             dark: GlobalTokens.neutralColors(.grey38),
                                darkElevated: GlobalTokens.neutralColors(.grey38))
        case .background5BrandTint:
            return DynamicColor(light: strongSelf.brandColors[.comm160].light,
                             dark: GlobalTokens.neutralColors(.grey38),
                                darkElevated: GlobalTokens.neutralColors(.grey38))
        case .background6:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                             dark: GlobalTokens.neutralColors(.grey36),
                             darkElevated: GlobalTokens.neutralColors(.grey40))
        case .background6Pressed:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey70),
                             dark: GlobalTokens.neutralColors(.grey54),
                             darkElevated: GlobalTokens.neutralColors(.grey54))
        case .background6Selected:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey74),
                             dark: GlobalTokens.neutralColors(.grey50),
                             darkElevated: GlobalTokens.neutralColors(.grey50))
        case .backgroundInverted:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                             dark: GlobalTokens.neutralColors(.grey34),
                             darkElevated: GlobalTokens.neutralColors(.grey30))
        case .backgroundDisabled:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                             dark: GlobalTokens.neutralColors(.grey32),
                             darkElevated: GlobalTokens.neutralColors(.grey32))
        case .brandBackground1:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: strongSelf.brandColors[.comm100].light)
        case .brandBackground1Pressed:
            return DynamicColor(light: strongSelf.brandColors[.comm50].light,
                                dark: strongSelf.brandColors[.comm140].light)
        case .brandBackground1Selected:
            return DynamicColor(light: strongSelf.brandColors[.comm60].light,
                                dark: strongSelf.brandColors[.comm120].light)
        case .brandBackground2:
            return DynamicColor(light: strongSelf.brandColors[.comm70].light)
        case .brandBackground2Pressed:
            return DynamicColor(light: strongSelf.brandColors[.comm40].light)
        case .brandBackground2Selected:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light)
        case .brandBackground3:
            return DynamicColor(light: strongSelf.brandColors[.comm60].light,
                                dark: strongSelf.brandColors[.comm120].light)
        case .brandBackground3Pressed:
            return DynamicColor(light: strongSelf.brandColors[.comm30].light,
                                dark: strongSelf.brandColors[.comm160].light)
        case .brandBackground3Selected:
            return DynamicColor(light: strongSelf.brandColors[.comm150].light)
        case .brandBackground4:
            return DynamicColor(light: strongSelf.brandColors[.comm160].light,
                                dark: strongSelf.brandColors[.comm20].light)
        case .background5BrandFilledSelected:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: GlobalTokens.neutralColors(.grey38))
        case .background5BrandTintSelected:
            return DynamicColor(light: strongSelf.brandColors[.comm160].light,
                                dark: GlobalTokens.neutralColors(.grey38))
        case .brandBackgroundInverted:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.white))
        case .brandBackgroundDisabled:
            return DynamicColor(light: strongSelf.brandColors[.comm140].light,
                                dark: strongSelf.brandColors[.comm40].light)
        case .brandBackgroundInvertedDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.grey86))
        case .stencil1:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey90),
                             dark: GlobalTokens.neutralColors(.grey34))
        case .stencil2:
         return DynamicColor(light: GlobalTokens.neutralColors(.grey98),
                             dark: GlobalTokens.neutralColors(.grey20))
        // Stroke colors
        case .stroke1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                                dark: GlobalTokens.neutralColors(.grey32))
        case .stroke2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey24))
        case .strokeDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey26))
        case .strokeAccessible:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey62))
        case .strokeFocus1:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black))
        case .strokeFocus2:
            return DynamicColor(light: GlobalTokens.neutralColors(.black),
                                dark: GlobalTokens.neutralColors(.white))
        case .brandStroke1:
            return DynamicColor(light: strongSelf.brandColors[.comm80].light,
                                dark: strongSelf.brandColors[.comm100].light)
        case .brandStroke1Pressed:
            return DynamicColor(light: strongSelf.brandColors[.comm50].light,
                                dark: strongSelf.brandColors[.comm140].light)
        case .brandStroke1Selected:
            return DynamicColor(light: strongSelf.brandColors[.comm60].light,
                                dark: strongSelf.brandColors[.comm120].light)
        case .canvasBackground:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey96),
                                dark: GlobalTokens.neutralColors(.grey12),
                                darkElevated: GlobalTokens.neutralColors(.grey16))
        }
    }

    // MARK: Shared Colors

    public enum SharedColorsTokens: CaseIterable {
        // Danger (Red)
        case dangerBackground1
        case dangerBackground2
        case dangerForeground1
        case dangerForeground2
        // Severe (Dark Orange)
        case severeBackground1
        case severeBackground2
        case severeForeground1
        case severeForeground2
        // Warning (Yellow)
        case warningBackground1
        case warningBackground2
        case warningForeground1
        case warningForeground2
        // Success (Green)
        case successBackground1
        case successBackground2
        case successForeground1
        case successForeground2
    }
    public lazy var sharedColors: TokenSet<SharedColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        // Danger
        case .dangerBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .tint60),
                                dark: GlobalTokens.sharedColors(.red, .shade40))
        case .dangerBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .primary),
                                dark: GlobalTokens.sharedColors(.red, .shade10))
        case .dangerForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                dark: GlobalTokens.sharedColors(.red, .tint30))
        case .dangerForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .primary),
                                dark: GlobalTokens.sharedColors(.red, .tint30))
        // Success
        case .successBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .tint60),
                                dark: GlobalTokens.sharedColors(.green, .shade40))
        case .successBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .primary),
                                dark: GlobalTokens.sharedColors(.green, .shade10))
        case .successForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .shade10),
                                dark: GlobalTokens.sharedColors(.green, .tint30))
        case .successForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .primary),
                                dark: GlobalTokens.sharedColors(.green, .tint30))
        // Severe
        case .severeBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .tint60),
                                dark: GlobalTokens.sharedColors(.darkOrange, .shade40))
        case .severeBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .primary),
                                dark: GlobalTokens.sharedColors(.darkOrange, .shade10))
        case .severeForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .shade10),
                                dark: GlobalTokens.sharedColors(.darkOrange, .tint30))
        case .severeForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .shade20),
                                dark: GlobalTokens.sharedColors(.darkOrange, .tint30))
        // Warning
        case .warningBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .tint60),
                                dark: GlobalTokens.sharedColors(.yellow, .shade40))
        case .warningBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .primary),
                                dark: GlobalTokens.sharedColors(.yellow, .shade10))
        case .warningForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .shade30),
                                dark: GlobalTokens.sharedColors(.yellow, .tint30))
        case .warningForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .shade30),
                                dark: GlobalTokens.sharedColors(.yellow, .tint30))
        }
    }

    // MARK: Initialization

    init() {}
}
