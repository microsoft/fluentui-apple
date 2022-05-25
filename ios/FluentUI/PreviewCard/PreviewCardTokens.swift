//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Pre-defined sizes of the PreviewCard.
@objc public enum MSFPreviewCardSize: Int, CaseIterable {
        /// 21:9 aspect ratio
    case ultrawideHeight
        /// 16:9 aspect ratio
    case landscapeHeight
        /// 4:3 aspect ratio
    case fullscreenHeight
        /// 1:1 aspect ratio
    case squareHeight
    /// CGFloat values for the height of individual PreviewCards.
    var cardHeight: CGFloat {
        switch self {
        case .ultrawideHeight:
        return 147
        case .landscapeHeight:
        return 192
        case .fullscreenHeight:
        return 257
        case .squareHeight:
        return 343
        }
    }
}
