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

        /// Progress bar's height.
        case height
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .backgroundColor:
            return .dynamicColor {
                self.aliasTokens.backgroundColors[.surfaceQuaternary]
            }

        case .gradientColor:
            return .dynamicColor {
                self.globalTokens.brandColors[.primary]
            }

        case .height:
            return .float { 2 }
        }
    }
}
