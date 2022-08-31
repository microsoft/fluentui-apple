//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Adds an animated shimmering effect to any view.
    /// - Parameters:
    ///   - style: `MSFShimmerStyle` enum value that defines the style of the Shimmer being presented.
    ///   - shouldAddShimmeringCover: Determines whether the view itself is shimmered or an added cover on top is shimmered.
    ///   - usesTextHeightForLabels: Whether to use the height of the view (if the view is a label), else default to token value.
    ///   - animationId: When displaying one or more shimmers, this ID will synchronize the animations.
    ///   - isLabel: Whether the view is a label or not.
    ///   - isShimmering: Whether the shimmering effect is active.
    @ViewBuilder func shimmering(style: MSFShimmerStyle = .revealing,
                                 shouldAddShimmeringCover: Bool = true,
                                 usesTextHeightForLabels: Bool = false,
                                 animationId: Namespace.ID,
                                 isLabel: Bool = false,
                                 isShimmering: Bool = true) -> some View {
        modifier(ShimmerView(tokenSet: ShimmerTokenSet(style: { style }),
                             state: MSFShimmerStateImpl(style: style,
                                                        shouldAddShimmeringCover: shouldAddShimmeringCover,
                                                        usesTextHeightForLabels: usesTextHeightForLabels),
                             animationId: animationId,
                             isLabel: isLabel,
                             isShimmering: isShimmering))
    }
}
