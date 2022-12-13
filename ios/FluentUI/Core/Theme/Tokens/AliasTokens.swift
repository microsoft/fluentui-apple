//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

@objc(MSFAliasTokens)
public final class AliasTokens: NSObject {

    // MARK: - BrandColors

    @objc(MSFBrandColorsAliasTokens)
    public enum BrandColorsTokens: Int, TokenSetKey {
        case primary
        case shade10
        case shade20
        case shade30
        case tint10
        case tint20
        case tint30
        case tint40
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `brandColors` property directly.")
    @objc(brandColorForToken:)
    public func brandColor(_ token: BrandColorsTokens) -> DynamicColor {
        return brandColors[token]
    }

    public var brandColors: TokenSet<BrandColorsTokens, DynamicColor> = .init { token in
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

    // MARK: ForegroundColors

    @objc(MSFForegroundColorsAliasTokens)
    public enum ForegroundColorsTokens: Int, TokenSetKey {
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

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `foregroundColors` property directly.")
    @objc(foregroundColorForToken:)
    public func foregroundColor(_ token: ForegroundColorsTokens) -> DynamicColor {
        return foregroundColors[token]
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

    @objc(MSFBackgroundColorsAliasTokens)
    public enum BackgroundColorsTokens: Int, TokenSetKey {
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

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `backgroundColors` property directly.")
    @objc(backgroundColorForToken:)
    public func backgroundColor(_ token: BackgroundColorsTokens) -> DynamicColor {
        return backgroundColors[token]
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

    @objc(MSFStrokeColorsAliasTokens)
    public enum StrokeColorsTokens: Int, TokenSetKey {
        case neutral1
        case neutral2
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `strokeColors` property directly.")
    @objc(strokeColorForToken:)
    public func strokeColor(_ token: StrokeColorsTokens) -> DynamicColor {
        return strokeColors[token]
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

    @objc(MSFShadowColorsAliasTokens)
    public enum ShadowColorsTokens: Int, TokenSetKey {
        case neutralAmbient
        case neutralKey
        case neutralAmbientLighter
        case neutralKeyLighter
        case neutralAmbientDarker
        case neutralKeyDarker
        case brandAmbient
        case brandKey
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `shadowColors` property directly.")
    @objc(shadowColorForToken:)
    public func shadowColor(_ token: ShadowColorsTokens) -> DynamicColor {
        return shadowColors[token]
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

    @objc(MSFTypographyAliasTokens)
    public enum TypographyTokens: Int, TokenSetKey {
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

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `typography` property directly.")
    @objc(typographyForToken:)
    public func typography(_ token: TypographyTokens) -> FontInfo {
        return typography[token]
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

    @objc(MSFShadowAliasTokens)
    public enum ShadowTokens: Int, TokenSetKey {
        case clear
        case shadow02
        case shadow04
        case shadow08
        case shadow16
        case shadow28
        case shadow64
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `shadow` property directly.")
    @objc(shadowForToken:)
    public func shadow(_ token: ShadowTokens) -> ShadowInfo {
        return shadow[token]
    }

    lazy public var shadow: TokenSet<ShadowTokens, ShadowInfo> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .clear:
            return ShadowInfo(colorOne: DynamicColor(light: ColorValue.clear),
                              blurOne: 0.0,
                              xOne: 0.0,
                              yOne: 0.0,
                              colorTwo: DynamicColor(light: ColorValue.clear),
                              blurTwo: 0.0,
                              xTwo: 0.0,
                              yTwo: 0.0)
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

    @objc(MSFElevationAliasTokens)
    public enum ElevationTokens: Int, TokenSetKey {
        case interactiveElevation1Rest
        case interactiveElevation1Hover
        case interactiveElevation1Pressed
        case interactiveElevation1Selected
        case interactiveElevation1Disabled
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `elevation` property directly.")
    @objc(elevationForToken:)
    public func elevation(_ token: ElevationTokens) -> ShadowInfo {
        return elevation[token]
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

    override init() {}
}
