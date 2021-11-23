//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public class AliasTokens {

    // MARK: ForegroundColors

    public class ForegroundColors: TokenSet<ForegroundColors.Tokens, ColorSet> {
        public enum Tokens: CaseIterable {
            case neutral1
            case neutral2
            case neutral3
        }
    }
    lazy public var foregroundColors: ForegroundColors = .init([
        .neutral1: ColorSet(light: globalTokens.neutralColors[.grey14],
                            lightHighContrast: globalTokens.neutralColors[.black],
                            dark: globalTokens.neutralColors[.white],
                            darkHighContrast: globalTokens.neutralColors[.white]),
        .neutral2: ColorSet(light: globalTokens.neutralColors[.grey26],
                            lightHighContrast: globalTokens.neutralColors[.black],
                            dark: globalTokens.neutralColors[.grey84],
                            darkHighContrast: globalTokens.neutralColors[.white]),
        .neutral3: ColorSet(light: globalTokens.neutralColors[.grey38],
                            lightHighContrast: globalTokens.neutralColors[.grey14],
                            dark: globalTokens.neutralColors[.grey68],
                            darkHighContrast: globalTokens.neutralColors[.grey84])
    ])

    // MARK: BackgroundColors

    public class BackgroundColors: TokenSet<BackgroundColors.Tokens, ColorSet> {
        public enum Tokens: CaseIterable {
            case neutral1
            case neutral2
            case neutral3
        }
    }
    lazy public var backgroundColors: BackgroundColors = .init([
        .neutral1: ColorSet(light: globalTokens.neutralColors[.white],
                            dark: globalTokens.neutralColors[.black],
                            darkElevated: globalTokens.neutralColors[.grey4]),
        .neutral2: ColorSet(light: globalTokens.neutralColors[.grey98],
                            dark: globalTokens.neutralColors[.grey4],
                            darkElevated: globalTokens.neutralColors[.grey8]),
        .neutral3: ColorSet(light: globalTokens.neutralColors[.grey96],
                            dark: globalTokens.neutralColors[.grey8],
                            darkElevated: globalTokens.neutralColors[.grey12])
    ])

    // MARK: StrokeColors

    public class StrokeColors: TokenSet<StrokeColors.Tokens, ColorSet> {
        public enum Tokens: CaseIterable {
            case neutral1
            case neutral2
        }
    }
    lazy public var strokeColors: StrokeColors = .init([
        .neutral1: ColorSet(light: globalTokens.neutralColors[.grey94],
                            lightHighContrast: globalTokens.neutralColors[.grey38],
                            dark: globalTokens.neutralColors[.grey24],
                            darkHighContrast: globalTokens.neutralColors[.grey68],
                            darkElevated: globalTokens.neutralColors[.grey32]),
        .neutral2: ColorSet(light: globalTokens.neutralColors[.grey88],
                            lightHighContrast: globalTokens.neutralColors[.grey38],
                            dark: globalTokens.neutralColors[.grey32],
                            darkHighContrast: globalTokens.neutralColors[.grey68],
                            darkElevated: globalTokens.neutralColors[.grey36])
    ])

    // MARK: Initialization

    public init(globalTokens: GlobalTokens? = nil) {
        if let globalTokens = globalTokens {
            self.globalTokens = globalTokens
        }
    }

    static let shared = AliasTokens()
    private var globalTokens: GlobalTokens = .shared
}
