//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Header styles.
@objc public enum MSFHeaderStyle: Int, CaseIterable {
    case standard
    case subtle
}

public class HeaderTokenSet: ControlTokenSet<HeaderTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        ///  The background color of the List Header.
        case backgroundColor

        /// The color of the List Header text.
        case textColor

        /// Height of the List Header.
        case headerHeight

        /// Top padding of the List Header.
        case topPadding

        /// Leading padding of the List Header.
        case leadingPadding

        /// Bottom padding of the List Header.
        case bottomPadding

        /// Trailing padding of the List Header.
        case trailingPadding

        /// The font used for the List Header.
        case textFont
    }

    init(style: @escaping () -> MSFHeaderStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral1] }

            case .textColor:
                return .dynamicColor {
                    switch style() {
                    case .standard:
                        return theme.aliasTokens.foregroundColors[.neutral1]
                    case .subtle:
                        return theme.aliasTokens.foregroundColors[.neutral3]
                    }
                }

            case .headerHeight:
                return .float { theme.globalTokens.spacing[.xxxLarge] }

            case .topPadding:
                return .float {
                    switch style() {
                    case .standard:
                        return theme.globalTokens.spacing[.medium]
                    case .subtle:
                        return theme.globalTokens.spacing[.xLarge]
                    }
                }

            case .leadingPadding:
                return .float { theme.globalTokens.spacing[.medium] }

            case .bottomPadding:
                return .float { theme.globalTokens.spacing[.xSmall] }

            case .trailingPadding:
                return .float { theme.globalTokens.spacing[.medium] }

            case .textFont:
                return .fontInfo {
                    switch style() {
                    case .standard:
                        return theme.aliasTokens.typography[.body1Strong]
                    case .subtle:
                        return theme.aliasTokens.typography[.caption1]
                    }
                }
            }
        }
    }

    /// The Header style.
    var style: () -> MSFHeaderStyle
}
