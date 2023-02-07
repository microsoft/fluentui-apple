//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Pre-defined spacings of the divider
@objc public enum MSFDividerSpacing: Int {
    case none
    case medium
}

/// Design token set for the `FluentDivider` control.
public class DividerTokenSet: ControlTokenSet<DividerTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the padding around the Fluent Divider.
        case padding

        /// The color of the Fluent Divider
        case color
    }

    init(spacing: @escaping () -> MSFDividerSpacing) {
        self.spacing = spacing
        super.init { [spacing] token, theme in
            switch token {
            case .padding:
                return .float {
                    switch spacing() {
                    case .none:
                        return GlobalTokens.spacing(.sizeNone)
                    case .medium:
                        return GlobalTokens.spacing(.size160)
                    }
                }

            case .color:
                return .dynamicColor { theme.aliasTokens.colors[.stroke2] }
            }
        }
    }

    /// MSFDividerSpacing enumeration value that will define pre-defined value for the padding.
    let spacing: () -> MSFDividerSpacing

    /// The default thickness for the divider: half pt.
    static var thickness: CGFloat { return GlobalTokens.stroke(.width05) }
}
