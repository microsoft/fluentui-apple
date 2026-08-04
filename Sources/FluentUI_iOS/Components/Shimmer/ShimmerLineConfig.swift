//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Configuration for a single shimmer line, defining its visual appearance.
@objc(MSFShimmerLineConfig)
public class ShimmerLineConfig: NSObject {
    /// Height of the line in points.
    @objc public let height: CGFloat

    /// Horizontal fill percentage (0.0 to 1.0) determining how much of the available width the line should occupy.
    @objc public let widthPercent: CGFloat

    /// Corner radius for the line. If nil, uses the default from the token set.
    @objc public let cornerRadius: NSNumber?

    /// Creates a shimmer line configuration.
    /// - Parameters:
    ///   - height: Height of the line in points.
    ///   - widthPercent: Horizontal fill percentage (0.0 to 1.0). Default is 1.0 (full width).
    ///   - cornerRadius: Corner radius for the line. Pass nil to use default from token set.
    @objc public init(
        height: CGFloat,
        widthPercent: CGFloat = 1.0,
        cornerRadius: NSNumber? = nil
    ) {
        self.height = height
        self.widthPercent = max(0.0, min(1.0, widthPercent))
        self.cornerRadius = cornerRadius
        super.init()
    }
}
