//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public final class AliasTokens {

    // MARK: ForegroundColors

    public enum ForegroundColorsTokens {
        case neutral1
        case neutral2
        case neutral3
    }
    lazy var foregroundColors: TokenSet<ForegroundColorsTokens, ColorSet> = .init { token in
        switch token {
        case .neutral1:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey14],
                            lightHighContrast: GlobalTokens.shared.neutralColors[.black],
                            dark: GlobalTokens.shared.neutralColors[.white],
                            darkHighContrast: GlobalTokens.shared.neutralColors[.white])
        case .neutral2:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey26],
                            lightHighContrast: GlobalTokens.shared.neutralColors[.black],
                            dark: GlobalTokens.shared.neutralColors[.grey84],
                            darkHighContrast: GlobalTokens.shared.neutralColors[.white])
        case .neutral3:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey38],
                            lightHighContrast: GlobalTokens.shared.neutralColors[.grey14],
                            dark: GlobalTokens.shared.neutralColors[.grey68],
                            darkHighContrast: GlobalTokens.shared.neutralColors[.grey84])
        }
    }

    // MARK: BackgroundColors

    public enum BackgroundColorsTokens {
        case neutral1
        case neutral2
        case neutral3
    }
    public lazy var backgroundColors: TokenSet<BackgroundColorsTokens, ColorSet> = .init { token in
        switch token {
        case .neutral1:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.white],
                            dark: GlobalTokens.shared.neutralColors[.black],
                            darkElevated: GlobalTokens.shared.neutralColors[.grey4])
        case .neutral2:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey98],
                            dark: GlobalTokens.shared.neutralColors[.grey4],
                            darkElevated: GlobalTokens.shared.neutralColors[.grey8])
        case .neutral3:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey96],
                            dark: GlobalTokens.shared.neutralColors[.grey8],
                            darkElevated: GlobalTokens.shared.neutralColors[.grey12])
        }
    }

    // MARK: StrokeColors

    public enum StrokeColorsTokens {
        case neutral1
        case neutral2
    }
    public lazy var strokeColors: TokenSet<StrokeColorsTokens, ColorSet> = .init { token in
        switch token {
        case .neutral1:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey94],
                            lightHighContrast: GlobalTokens.shared.neutralColors[.grey38],
                            dark: GlobalTokens.shared.neutralColors[.grey24],
                            darkHighContrast: GlobalTokens.shared.neutralColors[.grey68],
                            darkElevated: GlobalTokens.shared.neutralColors[.grey32])
        case .neutral2:
            return ColorSet(light: GlobalTokens.shared.neutralColors[.grey88],
                            lightHighContrast: GlobalTokens.shared.neutralColors[.grey38],
                            dark: GlobalTokens.shared.neutralColors[.grey32],
                            darkHighContrast: GlobalTokens.shared.neutralColors[.grey68],
                            darkElevated: GlobalTokens.shared.neutralColors[.grey36])
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
