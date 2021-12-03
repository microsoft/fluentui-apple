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
    }
    public lazy var foregroundColors: TokenSet<ForegroundColorsTokens, ColorSet> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey14],
                            lightHighContrast: strongSelf.globalTokens.neutralColors[.black],
                            dark: strongSelf.globalTokens.neutralColors[.white],
                            darkHighContrast: strongSelf.globalTokens.neutralColors[.white])
        case .neutral2:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey26],
                            lightHighContrast: strongSelf.globalTokens.neutralColors[.black],
                            dark: strongSelf.globalTokens.neutralColors[.grey84],
                            darkHighContrast: strongSelf.globalTokens.neutralColors[.white])
        case .neutral3:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey38],
                            lightHighContrast: strongSelf.globalTokens.neutralColors[.grey14],
                            dark: strongSelf.globalTokens.neutralColors[.grey68],
                            darkHighContrast: strongSelf.globalTokens.neutralColors[.grey84])
        }
    }

    // MARK: BackgroundColors

    public enum BackgroundColorsTokens: CaseIterable {
        case neutral1
        case neutral2
        case neutral3
    }
    public lazy var backgroundColors: TokenSet<BackgroundColorsTokens, ColorSet> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.white],
                            dark: strongSelf.globalTokens.neutralColors[.black],
                            darkElevated: strongSelf.globalTokens.neutralColors[.grey4])
        case .neutral2:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey98],
                            dark: strongSelf.globalTokens.neutralColors[.grey4],
                            darkElevated: strongSelf.globalTokens.neutralColors[.grey8])
        case .neutral3:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey96],
                            dark: strongSelf.globalTokens.neutralColors[.grey8],
                            darkElevated: strongSelf.globalTokens.neutralColors[.grey12])
        }
    }

    // MARK: StrokeColors

    public enum StrokeColorsTokens: CaseIterable {
        case neutral1
        case neutral2
    }
    public lazy var strokeColors: TokenSet<StrokeColorsTokens, ColorSet> = .init { [weak self] token in
        guard let strongSelf = self else { preconditionFailure() }
        switch token {
        case .neutral1:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey94],
                            lightHighContrast: strongSelf.globalTokens.neutralColors[.grey38],
                            dark: strongSelf.globalTokens.neutralColors[.grey24],
                            darkHighContrast: strongSelf.globalTokens.neutralColors[.grey68],
                            darkElevated: strongSelf.globalTokens.neutralColors[.grey32])
        case .neutral2:
            return ColorSet(light: strongSelf.globalTokens.neutralColors[.grey88],
                            lightHighContrast: strongSelf.globalTokens.neutralColors[.grey38],
                            dark: strongSelf.globalTokens.neutralColors[.grey32],
                            darkHighContrast: strongSelf.globalTokens.neutralColors[.grey68],
                            darkElevated: strongSelf.globalTokens.neutralColors[.grey36])
        }
    }

    // MARK: Initialization

    public init(globalTokens: GlobalTokens? = nil) {
        if let globalTokens = globalTokens {
            self.globalTokens = globalTokens
        }
    }

    static let shared = AliasTokens()
    private var globalTokens: GlobalTokens = .shared
}
