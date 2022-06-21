//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public final class AliasTokens {

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
        // New foreground colors
        case foreground1
        case foreground1Colorful
        case foreground2
        case foreground2Colorful
        case foreground3
        case foreground3Colorful
        case foregroundDisabled1
        case foregroundDisabled1Colorful
        case foregroundDisabled2
        case foregroundContrast
        case foregroundContrastColorful
        case foregroundOnColor
        case foregroundOnColorColorful
        case foregroundInverted1
        case foregroundInverted1Colorful
        case foregroundInverted2
        case foregroundInverted2Colorful

    }
    public lazy var foregroundColors: TokenSet<ForegroundColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey14],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.black],
                                dark: strongSelf.globalTokens.neutralColors[.white],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.white])
        case .neutral2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey26],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.black],
                                dark: strongSelf.globalTokens.neutralColors[.grey84],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.white])
        case .neutral3:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey38],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.grey14],
                                dark: strongSelf.globalTokens.neutralColors[.grey68],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.grey84])
        case .neutral4:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey50],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.grey26],
                                dark: strongSelf.globalTokens.neutralColors[.grey52],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.grey84])
        case .neutralDisabled:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey74],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.grey38],
                                dark: strongSelf.globalTokens.neutralColors[.grey36],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.grey62])
        case .neutralInverted:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.black],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.black])
        case .brandRest:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.primary].light,
                                lightHighContrast: strongSelf.globalTokens.brandColors[.shade20].light,
                                dark: strongSelf.globalTokens.brandColors[.primary].dark,
                                darkHighContrast: strongSelf.globalTokens.brandColors[.tint20].dark)
        case .brandHover:
            return strongSelf.globalTokens.brandColors[.shade10]
        case .brandPressed:
            return strongSelf.globalTokens.brandColors[.shade30]
        case .brandSelected:
            return strongSelf.globalTokens.brandColors[.shade20]
        case .brandDisabled:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey74],
                                dark: strongSelf.globalTokens.neutralColors[.grey36])
        // New foreground colors
        case .foreground1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey14],
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .foreground1Colorful:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white])
        case .foreground2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey38],
                                dark: strongSelf.globalTokens.neutralColors[.grey84])
        case .foreground2Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm160].light)
        case .foreground3:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey50],
                                dark: strongSelf.globalTokens.neutralColors[.grey68])
        case .foreground3Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm150].light)
        case .foregroundDisabled1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey74],
                                dark: strongSelf.globalTokens.neutralColors[.grey36])
        case .foregroundDisabled1Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm90].light)
        case .foregroundDisabled2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.grey24])
        case .foregroundContrast:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.black],
                                dark: strongSelf.globalTokens.neutralColors[.black])
        case .foregroundContrastColorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm70].light)
        case .foregroundOnColor:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.black])
        case .foregroundOnColorColorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light)
        case .foregroundInverted1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .foregroundInverted1Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light)
        case .foregroundInverted2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.comm80],
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .foregroundInverted2Colorful:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white])
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
        // New background colors
        case background1
        case background1Colorful
        case background1Pressed
        case background1PressedColorful
        case background1Selected
        case background1SelectedColorful
        case background2
        case background2Colorful
        case background2Pressed
        case background2PressedColorful
        case background2Selected
        case background2SelectedColorful
        case background3
        case background3Colorful
        case background3Pressed
        case background3PressedColorful
        case background3Selected
        case background3SelectedColorful
        case background4
        case background4Pressed
        case background4Selected
        case background5
        case background5Colorful
        case background5Pressed
        case background5PressedColorful
        case background5Selected
        case background5SelectedColorful
        case background5SelectedBrandFilled
        case background5SelectedBrandFilledColorful
        case background5BrandTint
        case background6
        case background6Colorful
        case background6Pressed
        case background6PressedColorful
        case background6Selected
        case background6SelectedColorful
        case backgroundInverted
        case backgroundDisabled
        case stencil1
        case stencil2
    }
    public lazy var backgroundColors: TokenSet<BackgroundColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.black],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey4])
        case .neutral2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey98],
                                dark: strongSelf.globalTokens.neutralColors[.grey4],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey8])
        case .neutral3:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey96],
                                dark: strongSelf.globalTokens.neutralColors[.grey8],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey12])
        case .neutral4:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey94],
                                dark: strongSelf.globalTokens.neutralColors[.grey12],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey16])
        case .neutral5:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                                dark: strongSelf.globalTokens.neutralColors[.grey36],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey36])
        case .neutralDisabled:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                                dark: strongSelf.globalTokens.neutralColors[.grey84],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey84])
        case .brandRest:
            return strongSelf.globalTokens.brandColors[.primary]
        case .brandHover:
            return strongSelf.globalTokens.brandColors[.shade10]
        case .brandPressed:
            return strongSelf.globalTokens.brandColors[.shade30]
        case .brandSelected:
            return strongSelf.globalTokens.brandColors[.shade20]
        case .brandDisabled:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                                dark: strongSelf.globalTokens.neutralColors[.grey84])
        case .surfaceQuaternary:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                                dark: strongSelf.globalTokens.neutralColors[.grey26])
        // New background colors
        case .background1:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                             dark: strongSelf.globalTokens.neutralColors[.black])
        case .background1Colorful:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white])
        case .background1Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey18])
        case .background1PressedColorful:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88])
        case .background1Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                             dark: strongSelf.globalTokens.neutralColors[.grey14])
        case .background1SelectedColorful:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92])
        case .background2:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                             dark: strongSelf.globalTokens.neutralColors[.grey12])
        case .background2Colorful:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white])
        case .background2Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey30])
        case .background2PressedColorful:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88])
        case .background2Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                             dark: strongSelf.globalTokens.neutralColors[.grey26])
        case .background2SelectedColorful:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92])
        case .background3:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                             dark: strongSelf.globalTokens.neutralColors[.grey16])
        case .background3Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light)
        case .background3Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey34])
        case .background3PressedColorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm50].light)
        case .background3Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                             dark: strongSelf.globalTokens.neutralColors[.grey30])
        case .background3SelectedColorful:
         return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm60].light)
        case .background4:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey98],
                             dark: strongSelf.globalTokens.neutralColors[.grey20])
        case .background4Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey86],
                             dark: strongSelf.globalTokens.neutralColors[.grey38])
        case .background4Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey90],
                             dark: strongSelf.globalTokens.neutralColors[.grey34])
        case .background5:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey94],
                             dark: strongSelf.globalTokens.neutralColors[.grey24])
        case .background5Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm70].light)
        case .background5Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey82],
                             dark: strongSelf.globalTokens.neutralColors[.grey42])
        case .background5PressedColorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm40].light)
        case .background5Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey86],
                             dark: strongSelf.globalTokens.neutralColors[.grey38])
        case .background5SelectedColorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm50].light)
        case .background5SelectedBrandFilled:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                             dark: strongSelf.globalTokens.neutralColors[.grey38])
        case .background5SelectedBrandFilledColorful:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white])
        case .background5BrandTint:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm160].light,
                             dark: strongSelf.globalTokens.neutralColors[.grey38])
        case .background6:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey82],
                             dark: strongSelf.globalTokens.neutralColors[.grey36])
        case .background6Colorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm60].light)
        case .background6Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey70],
                             dark: strongSelf.globalTokens.neutralColors[.grey54])
        case .background6PressedColorful:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm30].light)
        case .background6Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey74],
                             dark: strongSelf.globalTokens.neutralColors[.grey50])
        case .background6SelectedColorful:
        return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm150].light)
        case .backgroundInverted:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey14],
                             dark: strongSelf.globalTokens.neutralColors[.grey34])
        case .backgroundDisabled:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey32])
        case .stencil1:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey90],
                             dark: strongSelf.globalTokens.neutralColors[.grey34])
        case .stencil2:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey98],
                             dark: strongSelf.globalTokens.neutralColors[.grey20])
        }
    }

    // MARK: StrokeColors

    public enum StrokeColorsTokens: CaseIterable {
        case neutral1
        case neutral2
        // New stroke colors
        case stroke1
        case stroke2
        case strokeDisabled
        case strokeAccessible
        case strokeFocus1
        case strokeFocus2
    }
    public lazy var strokeColors: TokenSet<StrokeColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey94],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.grey38],
                                dark: strongSelf.globalTokens.neutralColors[.grey24],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.grey68],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey32])
        case .neutral2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                                lightHighContrast: strongSelf.globalTokens.neutralColors[.grey38],
                                dark: strongSelf.globalTokens.neutralColors[.grey32],
                                darkHighContrast: strongSelf.globalTokens.neutralColors[.grey68],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey36])
        case .stroke1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey82],
                                dark: strongSelf.globalTokens.neutralColors[.grey32])
        case .stroke2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                                dark: strongSelf.globalTokens.neutralColors[.grey24])
        case .strokeDisabled:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                                dark: strongSelf.globalTokens.neutralColors[.grey26])
        case .strokeAccessible:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey38],
                                dark: strongSelf.globalTokens.neutralColors[.grey62])
        case .strokeFocus1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.black])
        case .strokeFocus2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.black],
                                dark: strongSelf.globalTokens.neutralColors[.white])
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
                                dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.24))
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
            return .init(size: strongSelf.globalTokens.fontSize[.size900],
                         weight: strongSelf.globalTokens.fontWeight[.bold])
        case .largeTitle:
            return .init(size: strongSelf.globalTokens.fontSize[.size800],
                         weight: strongSelf.globalTokens.fontWeight[.bold])
        case .title1:
            return .init(size: strongSelf.globalTokens.fontSize[.size700],
                         weight: strongSelf.globalTokens.fontWeight[.bold])
        case .title2:
            return .init(size: strongSelf.globalTokens.fontSize[.size600],
                         weight: strongSelf.globalTokens.fontWeight[.semibold])
        case .title3:
            return .init(size: strongSelf.globalTokens.fontSize[.size500],
                         weight: strongSelf.globalTokens.fontWeight[.semibold])
        case .body1Strong:
            return .init(size: strongSelf.globalTokens.fontSize[.size400],
                         weight: strongSelf.globalTokens.fontWeight[.semibold])
        case .body1:
            return .init(size: strongSelf.globalTokens.fontSize[.size400],
                         weight: strongSelf.globalTokens.fontWeight[.regular])
        case .body2Strong:
            return .init(size: strongSelf.globalTokens.fontSize[.size300],
                         weight: strongSelf.globalTokens.fontWeight[.semibold])
        case .body2:
            return .init(size: strongSelf.globalTokens.fontSize[.size300],
                         weight: strongSelf.globalTokens.fontWeight[.regular])
        case .caption1Strong:
            return .init(size: strongSelf.globalTokens.fontSize[.size200],
                         weight: strongSelf.globalTokens.fontWeight[.semibold])
        case .caption1:
            return .init(size: strongSelf.globalTokens.fontSize[.size200],
                         weight: strongSelf.globalTokens.fontWeight[.regular])
        case .caption2:
            return .init(size: strongSelf.globalTokens.fontSize[.size100],
                         weight: strongSelf.globalTokens.fontWeight[.regular])
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
                              blurOne: 1,
                              xOne: 0,
                              yOne: 1,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 1,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow04:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 2,
                              xOne: 0,
                              yOne: 2,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 1,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow08:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 4,
                              xOne: 0,
                              yOne: 4,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 1,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow16:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKey],
                              blurOne: 8,
                              xOne: 0,
                              yOne: 8,
                              colorTwo: strongSelf.shadowColors[.neutralAmbient],
                              blurTwo: 1,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow28:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKeyDarker],
                              blurOne: 14,
                              xOne: 0,
                              yOne: 14,
                              colorTwo: strongSelf.shadowColors[.neutralAmbientDarker],
                              blurTwo: 4,
                              xTwo: 0,
                              yTwo: 0)
        case .shadow64:
            return ShadowInfo(colorOne: strongSelf.shadowColors[.neutralKeyDarker],
                              blurOne: 32,
                              xOne: 0,
                              yOne: 32,
                              colorTwo: strongSelf.shadowColors[.neutralAmbientDarker],
                              blurTwo: 4,
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

    // MARK: Initialization

    public init() {}

    lazy var globalTokens: GlobalTokens = FluentTheme.shared.globalTokens
}
