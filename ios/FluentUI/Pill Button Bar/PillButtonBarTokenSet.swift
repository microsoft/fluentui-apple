//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `PillButtonBar` control
public class PillButtonBarTokenSet: ControlTokenSet<PillButtonBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Maximum spacing between `PillButton` controls
        case maxButtonsSpacing

        /// Minimum spacing between `PillButton` controls
        case minButtonsSpacing

        /// Minimum width of the last button that must be showing on screen when the `PillButtonBar` loads or redraws
        case minButtonVisibleWidth

        /// Minimum width of a `PillButton`
        case minButtonWidth

        /// Minimum height of the `PillButtonBar`
        case minHeight

        /// Offset from the leading edge when the `PillButtonBar` loads or redraws
        case sideInset
    }

    init() {
        super.init { token, _ in
            switch token {
            case .maxButtonsSpacing:
                return .float {
                    10
                }

            case .minButtonsSpacing:
                return .float {
                    GlobalTokens.spacing(.xSmall)
                }

            case .minButtonVisibleWidth:
                return .float {
                    GlobalTokens.spacing(.large)
                }

            case .minButtonWidth:
                return .float {
                    56
                }

            case .minHeight:
                return .float {
                    28
                }

            case .sideInset:
                return .float {
                    GlobalTokens.spacing(.medium)
                }
            }
        }
    }
}
