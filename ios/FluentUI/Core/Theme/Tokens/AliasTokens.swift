//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct ShadowTokens {
    let primaryColor: ColorValue
    let primaryBlur: CGFloat
    let primaryX: CGFloat
    let primaryY: CGFloat
    let secondaryColor: ColorValue
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
        case clear
        case opacity12
        case opacity14
        case opacity20
        case opacity24
        case opacity28
        case opacity40
        case opacity48
        case opacity60
        case opaque
    }
    lazy public var shadowColors: TokenSet<ShadowColorsTokens, ColorSet> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .clear:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity12:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity14:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity20:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity24:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity28:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity40:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity48:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opacity60:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])
        case .opaque:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey28])

        }
    }

    // MARK: - Shadow

    public enum ShadowToken: CaseIterable {
        case shadow02
        case shadow04
        case shadow08
        case shadow16
        case shadow28
        case shadow64
    }
    lazy public var shadow: TokenSet<ShadowToken, ShadowTokens> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .shadow02:
            return ShadowTokens(primaryColor: strongSelf.globalTokens.neutralColors[.grey14],
                                primaryBlur: 1,
                                primaryX: 0,
                                primaryY: 1,
                                secondaryColor: strongSelf.globalTokens.neutralColors[.grey12],
                                secondaryBlur: 1,
                                secondaryX: 0,
                                secondaryY: 0)
        case .shadow04:
            return ShadowTokens(primaryColor: strongSelf.globalTokens.neutralColors[.grey14],
                                primaryBlur: 1,
                                primaryX: 0,
                                primaryY: 1,
                                secondaryColor: strongSelf.globalTokens.neutralColors[.grey12],
                                secondaryBlur: 1,
                                secondaryX: 0,
                                secondaryY: 0)
        case .shadow08:
            return ShadowTokens(primaryColor: strongSelf.globalTokens.neutralColors[.grey14],
                                primaryBlur: 1,
                                primaryX: 0,
                                primaryY: 1,
                                secondaryColor: strongSelf.globalTokens.neutralColors[.grey12],
                                secondaryBlur: 1,
                                secondaryX: 0,
                                secondaryY: 0)
        case .shadow16:
            return ShadowTokens(primaryColor: strongSelf.globalTokens.neutralColors[.grey14],
                                primaryBlur: 1,
                                primaryX: 0,
                                primaryY: 1,
                                secondaryColor: strongSelf.globalTokens.neutralColors[.grey12],
                                secondaryBlur: 1,
                                secondaryX: 0,
                                secondaryY: 0)
        case .shadow28:
            return ShadowTokens(primaryColor: strongSelf.globalTokens.neutralColors[.grey14],
                                primaryBlur: 1,
                                primaryX: 0,
                                primaryY: 1,
                                secondaryColor: strongSelf.globalTokens.neutralColors[.grey12],
                                secondaryBlur: 1,
                                secondaryX: 0,
                                secondaryY: 0)
        case .shadow64:
            return ShadowTokens(primaryColor: strongSelf.globalTokens.neutralColors[.grey14],
                                primaryBlur: 1,
                                primaryX: 0,
                                primaryY: 1,
                                secondaryColor: strongSelf.globalTokens.neutralColors[.grey12],
                                secondaryBlur: 1,
                                secondaryX: 0,
                                secondaryY: 0)
        }
    }

    // MARK: Initialization

    public init() {}

    lazy var globalTokens: GlobalTokens = FluentTheme.shared.globalTokens
}
