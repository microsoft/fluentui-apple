//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct ShadowInfo {
    let primaryColor: ColorSet
    let primaryBlur: CGFloat
    let primaryX: CGFloat
    let primaryY: CGFloat
    let secondaryColor: ColorSet
    let secondaryBlur: CGFloat
    let secondaryX: CGFloat
    let secondaryY: CGFloat
}

public final class AliasTokens {

    // MARK: ForegroundColors

    public enum ForegroundColorsTokens: CaseIterable {
        case neutral1
        case neutral2
        case neutral3
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
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey88],
                            dark: strongSelf.globalTokens.neutralColors[.grey84])
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
    lazy public var shadowColors: TokenSet<ShadowColorsTokens, ColorSet> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutralAmbient:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.12),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.24))
        case .neutralKey:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.14),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.28))
        case .neutralAmbientLighter:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.06),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.12))
        case .neutralKeyLighter:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.07),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.14))
        case .neutralAmbientDarker:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.20),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.40))
        case .neutralKeyDarker:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.24),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.48))
        case .brandAmbient:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.30),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.30))
        case .brandKey:
            return ColorSet(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.25),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.25))
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
            return ShadowInfo(primaryColor: ColorSet(light: ColorValue(r: 1.0, g: 0.0, b: 0.0, a: 0.12), dark: ColorValue(r: 1.0, g: 0.0, b: 0.0, a: 0.24)), //strongSelf.shadowColors[.neutralAmbient],
                              primaryBlur: 1,
                              primaryX: 0,
                              primaryY: 0,
                              secondaryColor: ColorSet(light: ColorValue(r: 1.0, g: 0.0, b: 0.0, a: 0.12), dark: ColorValue(r: 1.0, g: 0.0, b: 0.0, a: 0.24)), //strongSelf.shadowColors[.neutralKey],
                              secondaryBlur: 1,
                              secondaryX: 0,
                              secondaryY: 1)
        case .shadow04:
            return ShadowInfo(primaryColor: strongSelf.shadowColors[.neutralAmbient],
                              primaryBlur: 1,
                              primaryX: 0,
                              primaryY: 0,
                              secondaryColor: strongSelf.shadowColors[.neutralKey],
                              secondaryBlur: 2,
                              secondaryX: 0,
                              secondaryY: 2)
        case .shadow08:
            return ShadowInfo(primaryColor: ColorSet(light: ColorValue(r: 0.0, g: 1.0, b: 0.0, a: 0.12), dark: ColorValue(r: 1.0, g: 0.0, b: 0.0, a: 0.24)), //strongSelf.shadowColors[.neutralAmbient],
                              primaryBlur: 1,
                              primaryX: 0,
                              primaryY: 0,
                              secondaryColor: ColorSet(light: ColorValue(r: 0.0, g: 1.0, b: 0.0, a: 0.12), dark: ColorValue(r: 1.0, g: 0.0, b: 0.0, a: 0.24)), //strongSelf.shadowColors[.neutralKey],
                              secondaryBlur: 4,
                              secondaryX: 0,
                              secondaryY: 4)
        case .shadow16:
            return ShadowInfo(primaryColor: strongSelf.shadowColors[.neutralAmbient],
                              primaryBlur: 1,
                              primaryX: 0,
                              primaryY: 0,
                              secondaryColor: strongSelf.shadowColors[.neutralKey],
                              secondaryBlur: 8,
                              secondaryX: 0,
                              secondaryY: 8)
        case .shadow28:
            return ShadowInfo(primaryColor: strongSelf.shadowColors[.neutralAmbientDarker],
                              primaryBlur: 4,
                              primaryX: 0,
                              primaryY: 0,
                              secondaryColor: strongSelf.shadowColors[.neutralKeyDarker],
                              secondaryBlur: 14,
                              secondaryX: 0,
                              secondaryY: 14)
        case .shadow64:
            return ShadowInfo(primaryColor: strongSelf.shadowColors[.neutralAmbientDarker],
                              primaryBlur: 4,
                              primaryX: 0,
                              primaryY: 0,
                              secondaryColor: strongSelf.shadowColors[.neutralKeyDarker],
                              secondaryBlur: 32,
                              secondaryX: 0,
                              secondaryY: 32)
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
