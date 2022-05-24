//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Pre-defined sizes of the PreviewCard.
@objc public enum MSFPreviewCardSize: Int, CaseIterable {
    case ultrawideHeight
    case landscapeHeight
    case oldLandscapeHeight
    case squareHeight
    /// CGFloat values for the height of individual PreviewCards.
    var cardHeight: CGFloat {
        switch self {
        case .ultrawideHeight:
        return 147
        case .landscapeHeight:
        return 192
        case .oldLandscapeHeight:
        return 257
        case .squareHeight:
        return 343
        }
    }
}
