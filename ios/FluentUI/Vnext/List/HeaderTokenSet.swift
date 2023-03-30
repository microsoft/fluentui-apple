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
                return .uiColor { theme.color(.background1) }

            case .textColor:
                return .uiColor {
                    switch style() {
                    case .standard:
                        return theme.color(.foreground1)
                    case .subtle:
                        return theme.color(.foreground2)
                    }
                }

            case .headerHeight:
                return .float { GlobalTokens.spacing(.size480) }

            case .topPadding:
                return .float {
                    switch style() {
                    case .standard:
                        return GlobalTokens.spacing(.size160)
                    case .subtle:
                        return GlobalTokens.spacing(.size240)
                    }
                }

            case .leadingPadding:
                return .float { GlobalTokens.spacing(.size160) }

            case .bottomPadding:
                return .float { GlobalTokens.spacing(.size80) }

            case .trailingPadding:
                return .float { GlobalTokens.spacing(.size160) }

            case .textFont:
                return .uiFont {
                    switch style() {
                    case .standard:
                        return theme.typography(.body1Strong)
                    case .subtle:
                        return theme.typography(.caption1)
                    }
                }
            }
        }
    }

    /// The Header style.
    var style: () -> MSFHeaderStyle
}
