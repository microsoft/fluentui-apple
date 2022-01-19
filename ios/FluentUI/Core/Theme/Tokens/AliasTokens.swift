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
