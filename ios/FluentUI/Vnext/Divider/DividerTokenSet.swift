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
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .padding:
            return .float {
                switch self.spacing() {
                case .none:
                    return self.globalTokens.spacing[.none]
                case .medium:
                    return self.globalTokens.spacing[.medium]
                }
            }

        case .color:
            return .dynamicColor { self.aliasTokens.strokeColors[.neutral2] }
        }
    }

    /// MSFDividerSpacing enumeration value that will define pre-defined value for the padding.
    let spacing: () -> MSFDividerSpacing
}
