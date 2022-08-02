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
        case brandForegroundDisabled
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
        // Dark red
        case darkRedBackground2
        case darkRedForeground2
        case darkRedBorderActive
        // Cranberry
        case cranberryBackground2
        case cranberryForeground2
        case cranberryBorderActive
        // Red
        case redBackground1
        case redBackground2
        case redBackground3
        case redForeground1
        case redForeground2
        case redForeground3
        case redBorderActive
        case redBorder1
        case redBorder2
        // Dark orange
        case darkOrangeBackground1
        case darkOrangeBackground2
        case darkOrangeBackground3
        case darkOrangeForeground1
        case darkOrangeForeground2
        case darkOrangeForeground3
        case darkOrangeBorderActive
        case darkOrangeBorder1
        case darkOrangeBorder2
        // Pumpkin
        case pumpkinBackground2
        case pumpkinForeground2
        case pumpkinBorderActive
        // Peach
        case peachBackground2
        case peachForeground2
        case peachBorderActive
        // Marigold
        case marigoldBackground2
        case marigoldForeground2
        case marigoldBorderActive
        // Yellow
        case yellowBackground1
        case yellowBackground2
        case yellowBackground3
        case yellowForeground1
        case yellowForeground2
        case yellowForeground3
        case yellowBorderActive
        case yellowBorder1
        case yellowBorder2
        // Gold
        case goldBackground2
        case goldForeground2
        case goldBorderActive
        // Brass
        case brassBackground2
        case brassForeground2
        case brassBorderActive
        // Brown
        case brownBackground2
        case brownForeground2
        case brownBorderActive
        // Forest
        case forestBackground2
        case forestForeground2
        case forestBorderActive
        // Seafoam
        case seafoamBackground2
        case seafoamForeground2
        case seafoamBorderActive
        // Green
        case greenBackground1
        case greenBackground2
        case greenBackground3
        case greenForeground1
        case greenForeground2
        case greenForeground3
        case greenBorderActive
        case greenBorder1
        case greenBorder2
        // Dark green
        case darkGreenBackground2
        case darkGreenForeground2
        case darkGreenBorderActive
        // Light teal
        case lightTealBackground2
        case lightTealForeground2
        case lightTealBorderActive
        // Teal
        case tealBackground2
        case tealForeground2
        case tealBorderActive
        // Steel
        case steelBackground2
        case steelForeground2
        case steelBorderActive
        // Blue
        case blueBackground2
        case blueForeground2
        case blueBorderActive
        // Royal blue
        case royalBlueBackground2
        case royalBlueForeground2
        case royalBlueBorderActive
        // Cornflower
        case cornflowerBackground2
        case cornflowerForeground2
        case cornflowerBorderActive
        // Navy
        case navyBackground2
        case navyForeground2
        case navyBorderActive
        // Lavender
        case lavenderBackground2
        case lavenderForeground2
        case lavenderBorderActive
        // Purple
        case purpleBackground2
        case purpleForeground2
        case purpleBorderActive
        // Grape
        case grapeBackground2
        case grapeForeground2
        case grapeBorderActive
        // Berry
        case berryBackground1
        case berryBackground2
        case berryBackground3
        case berryForeground1
        case berryForeground2
        case berryForeground3
        case berryBorderActive
        case berryBorder1
        case berryBorder2
        // Lilac
        case lilacBackground2
        case lilacForeground2
        case lilacBorderActive
        // Pink
        case pinkBackground2
        case pinkForeground2
        case pinkBorderActive
        // Magenta
        case magentaBackground2
        case magentaForeground2
        case magentaBorderActive
        // Plum
        case plumBackground2
        case plumForeground2
        case plumBorderActive
        // Beige
        case beigeBackground2
        case beigeForeground2
        case beigeBorderActive
        // Mink
        case minkBackground2
        case minkForeground2
        case minkBorderActive
        // Platinum
        case platinumBackground2
        case platinumForeground2
        case platinumBorderActive
        // Anchor
        case anchorBackground2
        case anchorForeground2
        case anchorBorderActive
    }
    public lazy var colors: TokenSet<ColorsTokens, DynamicColor> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        // Foreground colors
        case .foreground1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey14],
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .foreground2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey38],
                                dark: strongSelf.globalTokens.neutralColors[.grey84])
        case .foreground3:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey50],
                                dark: strongSelf.globalTokens.neutralColors[.grey68])
        case .foregroundDisabled1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey74],
                                dark: strongSelf.globalTokens.neutralColors[.grey36])
        case .foregroundDisabled2:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.grey24])
        case .foregroundContrast:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.black],
                                dark: strongSelf.globalTokens.neutralColors[.black])
        case .foregroundOnColor:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.black])
        case .foregroundInverted1:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white])
        case .foregroundInverted2:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .brandForeground1:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.brandColors[.comm100].light)
        case .brandForeground1Pressed:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm50].light,
                                dark: strongSelf.globalTokens.brandColors[.comm140].light)
        case .brandForeground1Selected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm60].light,
                                dark: strongSelf.globalTokens.brandColors[.comm120].light)
        case .brandForeground2:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm160].light,
                                dark: strongSelf.globalTokens.brandColors[.comm20].light)
        case .brandForeground3:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm150].light)
        case .brandForeground4:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.brandColors[.comm120].light)
        case .brandForeground5:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm70].light)
        case .brandForegroundInverted:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .brandForegroundDisabled:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm90].light)
        // Background colors
        case .background1:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                             dark: strongSelf.globalTokens.neutralColors[.black],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey4])
        case .background1Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey18],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey18])
        case .background1Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                             dark: strongSelf.globalTokens.neutralColors[.grey14],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey14])
        case .background2:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                             dark: strongSelf.globalTokens.neutralColors[.grey12],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey16])
        case .background2Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey30],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey30])
        case .background2Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                             dark: strongSelf.globalTokens.neutralColors[.grey26],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey26])
        case .background3:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                             dark: strongSelf.globalTokens.neutralColors[.grey16],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey20])
        case .background3Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey34],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey34])
        case .background3Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey92],
                             dark: strongSelf.globalTokens.neutralColors[.grey30],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey30])
        case .background4:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey98],
                             dark: strongSelf.globalTokens.neutralColors[.grey20],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey24])
        case .background4Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey86],
                             dark: strongSelf.globalTokens.neutralColors[.grey38],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey38])
        case .background4Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey90],
                             dark: strongSelf.globalTokens.neutralColors[.grey34],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey34])
        case .background5:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey94],
                             dark: strongSelf.globalTokens.neutralColors[.grey24],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey28])
        case .background5Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey82],
                             dark: strongSelf.globalTokens.neutralColors[.grey42],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey42])
        case .background5Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey86],
                             dark: strongSelf.globalTokens.neutralColors[.grey38],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey38])
        case .background5SelectedBrandFilled:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                             dark: strongSelf.globalTokens.neutralColors[.grey38],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey38])
        case .background5BrandTint:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm160].light,
                             dark: strongSelf.globalTokens.neutralColors[.grey38],
                                darkElevated: strongSelf.globalTokens.neutralColors[.grey38])
        case .background6:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey82],
                             dark: strongSelf.globalTokens.neutralColors[.grey36],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey40])
        case .background6Pressed:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey70],
                             dark: strongSelf.globalTokens.neutralColors[.grey54],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey54])
        case .background6Selected:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey74],
                             dark: strongSelf.globalTokens.neutralColors[.grey50],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey50])
        case .backgroundInverted:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey14],
                             dark: strongSelf.globalTokens.neutralColors[.grey34],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey30])
        case .backgroundDisabled:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey88],
                             dark: strongSelf.globalTokens.neutralColors[.grey32],
                             darkElevated: strongSelf.globalTokens.neutralColors[.grey32])
        case .brandBackground1:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.brandColors[.comm100].light)
        case .brandBackground1Pressed:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm50].light,
                                dark: strongSelf.globalTokens.brandColors[.comm140].light)
        case .brandBackground1Selected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm60].light,
                                dark: strongSelf.globalTokens.brandColors[.comm120].light)
        case .brandBackground2:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm70].light)
        case .brandBackground2Pressed:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm40].light)
        case .brandBackground2Selected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light)
        case .brandBackground3:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm60].light,
                                dark: strongSelf.globalTokens.brandColors[.comm120].light)
        case .brandBackground3Pressed:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm30].light,
                                dark: strongSelf.globalTokens.brandColors[.comm160].light)
        case .brandBackground3Selected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm150].light)
        case .brandBackground4:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm160].light,
                                dark: strongSelf.globalTokens.brandColors[.comm20].light)
        case .background5BrandFilledSelected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.neutralColors[.grey38])
        case .background5BrandTintSelected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm160].light,
                                dark: strongSelf.globalTokens.neutralColors[.grey38])
        case .brandBackgroundInverted:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.white])
        case .brandBackgroundDisabled:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm140].light,
                                dark: strongSelf.globalTokens.brandColors[.comm40].light)
        case .brandBackgroundInvertedDisabled:
            return DynamicColor(light: strongSelf.globalTokens.neutralColors[.white],
                                dark: strongSelf.globalTokens.neutralColors[.grey86])
        case .stencil1:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey90],
                             dark: strongSelf.globalTokens.neutralColors[.grey34])
        case .stencil2:
         return DynamicColor(light: strongSelf.globalTokens.neutralColors[.grey98],
                             dark: strongSelf.globalTokens.neutralColors[.grey20])
        // Stroke colors
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
        case .brandStroke1:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm80].light,
                                dark: strongSelf.globalTokens.brandColors[.comm100].light)
        case .brandStroke1Pressed:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm50].light,
                                dark: strongSelf.globalTokens.brandColors[.comm140].light)
        case .brandStroke1Selected:
            return DynamicColor(light: strongSelf.globalTokens.brandColors[.comm60].light,
                                dark: strongSelf.globalTokens.brandColors[.comm120].light)
        //Dark red
        case .darkRedBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkRed][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.darkRed][.shade30])
        case .darkRedForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkRed][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.darkRed][.tint40])
        case .darkRedBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkRed][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.darkRed][.tint30])
        // Cranberry
        case .cranberryBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.cranberry][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.cranberry][.shade30])
        case .cranberryForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.cranberry][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.cranberry][.tint40])
        case .cranberryBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.cranberry][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.cranberry][.tint30])
        // Red
        case .redBackground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.tint60],
                                dark: strongSelf.globalTokens.sharedColors[.red][.shade40])
        case .redBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.red][.shade30])
        case .redBackground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.red][.shade10])
        case .redForeground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.shade20],
                                dark: strongSelf.globalTokens.sharedColors[.red][.tint30])
        case .redForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.red][.tint40])
        case .redForeground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.red][.tint20])
        case .redBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.red][.tint30])
        case .redBorder1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.tint50],
                                dark: strongSelf.globalTokens.sharedColors[.red][.shade30])
        case .redBorder2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.red][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.red][.tint20])
        // Green
        case .greenBackground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.tint60],
                                dark: strongSelf.globalTokens.sharedColors[.green][.shade40])
        case .greenBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.green][.shade30])
        case .greenBackground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.green][.shade10])
        case .greenForeground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.shade20],
                                dark: strongSelf.globalTokens.sharedColors[.green][.tint30])
        case .greenForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.green][.tint40])
        case .greenForeground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.green][.tint20])
        case .greenBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.green][.tint30])
        case .greenBorder1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.tint50],
                                dark: strongSelf.globalTokens.sharedColors[.green][.shade30])
        case .greenBorder2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.green][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.green][.tint20])
        // Dark orange
        case .darkOrangeBackground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.tint60],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.shade40])
        case .darkOrangeBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.shade30])
        case .darkOrangeBackground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.shade10])
        case .darkOrangeForeground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.shade20],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.tint30])
        case .darkOrangeForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.tint40])
        case .darkOrangeForeground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.tint20])
        case .darkOrangeBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.tint30])
        case .darkOrangeBorder1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.tint50],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.shade30])
        case .darkOrangeBorder2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkOrange][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.darkOrange][.tint20])
        // Yellow
        case .yellowBackground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.tint50],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.shade40])
        case .yellowBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.shade30])
        case .yellowBackground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.shade10])
        case .yellowForeground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.shade40],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.tint30])
        case .yellowForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.tint40])
        case .yellowForeground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.tint20])
        case .yellowBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.tint30])
        case .yellowBorder1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.shade30])
        case .yellowBorder2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.yellow][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.yellow][.tint20])
        // Berry
        case .berryBackground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.tint60],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.shade40])
        case .berryBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.shade30])
        case .berryBackground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.shade10])
        case .berryForeground1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.tint20],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.tint30])
        case .berryForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.tint40])
        case .berryForeground3:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.tint20])
        case .berryBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.tint30])
        case .berryBorder1:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.tint30],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.tint30])
        case .berryBorder2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.berry][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.berry][.tint20])
        // Pumpkin
        case .pumpkinBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.pumpkin][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.pumpkin][.shade30])
        case .pumpkinForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.pumpkin][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.pumpkin][.tint40])
        case .pumpkinBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.pumpkin][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.pumpkin][.tint30])
        // Peach
        case .peachBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.peach][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.peach][.shade30])
        case .peachForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.peach][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.peach][.tint40])
        case .peachBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.peach][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.peach][.tint30])
        // Marigold
        case .marigoldBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.marigold][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.marigold][.shade30])
        case .marigoldForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.marigold][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.marigold][.tint40])
        case .marigoldBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.marigold][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.marigold][.tint30])
        // Gold
        case .goldBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.gold][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.gold][.shade30])
        case .goldForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.gold][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.gold][.tint40])
        case .goldBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.gold][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.gold][.tint30])
        // Brass
        case .brassBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.brass][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.brass][.shade30])
        case .brassForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.brass][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.brass][.tint40])
        case .brassBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.brass][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.brass][.tint30])
        // Brown
        case .brownBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.brown][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.brown][.shade30])
        case .brownForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.brown][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.brown][.tint40])
        case .brownBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.brown][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.brown][.tint30])
        // Forest
        case .forestBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.forest][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.forest][.shade30])
        case .forestForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.forest][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.forest][.tint40])
        case .forestBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.forest][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.forest][.tint30])
        // Seafoam
        case .seafoamBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.seafoam][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.seafoam][.shade30])
        case .seafoamForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.seafoam][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.seafoam][.tint40])
        case .seafoamBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.seafoam][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.seafoam][.tint30])
        // Dark green
        case .darkGreenBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkGreen][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.darkGreen][.shade30])
        case .darkGreenForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkGreen][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.darkGreen][.tint40])
        case .darkGreenBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.darkGreen][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.darkGreen][.tint30])
        // Light teal
        case .lightTealBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lightTeal][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.lightTeal][.shade30])
        case .lightTealForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lightTeal][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.lightTeal][.tint40])
        case .lightTealBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lightTeal][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.lightTeal][.tint30])
        // Teal
        case .tealBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.teal][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.teal][.shade30])
        case .tealForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.teal][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.teal][.tint40])
        case .tealBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.teal][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.teal][.tint30])
        // Steel
        case .steelBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.steel][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.steel][.shade30])
        case .steelForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.steel][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.steel][.tint40])
        case .steelBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.steel][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.steel][.tint30])
        // Blue
        case .blueBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.blue][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.blue][.shade30])
        case .blueForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.blue][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.blue][.tint40])
        case .blueBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.blue][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.blue][.tint30])
        // Royal blue
        case .royalBlueBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.royalBlue][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.royalBlue][.shade30])
        case .royalBlueForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.royalBlue][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.royalBlue][.tint40])
        case .royalBlueBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.royalBlue][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.royalBlue][.tint30])
        // Cornflower
        case .cornflowerBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.cornflower][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.cornflower][.shade30])
        case .cornflowerForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.cornflower][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.cornflower][.tint40])
        case .cornflowerBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.cornflower][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.cornflower][.tint30])
        // Navy
        case .navyBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.navy][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.navy][.shade30])
        case .navyForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.navy][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.navy][.tint40])
        case .navyBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.navy][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.navy][.tint30])
        // Lavender
        case .lavenderBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lavender][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.lavender][.shade30])
        case .lavenderForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lavender][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.lavender][.tint40])
        case .lavenderBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lavender][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.lavender][.tint30])
        // Purple
        case .purpleBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.purple][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.purple][.shade30])
        case .purpleForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.purple][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.purple][.tint40])
        case .purpleBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.purple][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.purple][.tint30])
        // Grape
        case .grapeBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.grape][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.grape][.shade30])
        case .grapeForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.grape][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.grape][.tint40])
        case .grapeBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.grape][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.grape][.tint30])
        // Lilac
        case .lilacBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lilac][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.lilac][.shade30])
        case .lilacForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lilac][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.lilac][.tint40])
        case .lilacBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.lilac][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.lilac][.tint30])
        // Pink
        case .pinkBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.pink][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.pink][.shade30])
        case .pinkForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.pink][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.pink][.tint40])
        case .pinkBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.pink][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.pink][.tint30])
        // Magenta
        case .magentaBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.magenta][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.magenta][.shade30])
        case .magentaForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.magenta][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.magenta][.tint40])
        case .magentaBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.magenta][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.magenta][.tint30])
        // Plum
        case .plumBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.plum][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.plum][.shade30])
        case .plumForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.plum][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.plum][.tint40])
        case .plumBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.plum][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.plum][.tint30])
        // Beige
        case .beigeBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.beige][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.beige][.shade30])
        case .beigeForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.beige][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.beige][.tint40])
        case .beigeBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.beige][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.beige][.tint30])
        // Mink
        case .minkBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.mink][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.mink][.shade30])
        case .minkForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.mink][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.mink][.tint40])
        case .minkBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.mink][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.mink][.tint30])
        // Platinum
        case .platinumBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.platinum][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.platinum][.shade30])
        case .platinumForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.platinum][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.platinum][.tint40])
        case .platinumBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.platinum][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.platinum][.tint30])
        // Anchor
        case .anchorBackground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.anchor][.tint40],
                                dark: strongSelf.globalTokens.sharedColors[.anchor][.shade30])
        case .anchorForeground2:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.anchor][.shade30],
                                dark: strongSelf.globalTokens.sharedColors[.anchor][.tint40])
        case .anchorBorderActive:
            return DynamicColor(light: strongSelf.globalTokens.sharedColors[.anchor][.primary],
                                dark: strongSelf.globalTokens.sharedColors[.anchor][.tint30])
        }
    }

    // MARK: Initialization

    public init() {}

    lazy var globalTokens: GlobalTokens = FluentTheme.shared.globalTokens
}
