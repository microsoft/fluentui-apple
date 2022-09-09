//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Representation of design tokens for the Indeterminate Progress Bar.
public class IndeterminateProgressBarTokenSet: ControlTokenSet<IndeterminateProgressBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Progress bar's background color.
        case backgroundColor

        /// Progress bar's gradient color.
        case gradientColor
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    theme.aliasTokens.backgroundColors[.surfaceQuaternary]
                }

            case .gradientColor:
                return .dynamicColor {
                    theme.aliasTokens.brandColors[.primary]
                }
            }
        }
    }
}

// MARK: - Constants

extension IndeterminateProgressBarTokenSet {
    static let animationDuration: Double = 1.75
    static let height: Double = 2.0

    static func initialStartPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: -1, y: 0.5)
    }

    static func initialEndPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: 0, y: 0.5)
    }

    static func finalStartPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: -1, y: 0.5) : UnitPoint(x: 1, y: 0.5)
    }

    static func finalEndPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: 0, y: 0.5) : UnitPoint(x: 2, y: 0.5)
    }
}
