//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "ShimmerLinesViewAppearance")
public typealias MSShimmerLinesViewAppearance = ShimmerLinesViewAppearance

/**
 `ShimmerLinesViewAppearance` describes the appearance of a shimmer view (ie loading content view)
 */

@available(*, deprecated, message: "Use individual properties on ShimmerView instead")
@objc(MSFShimmerLinesViewAppearance)
public class ShimmerLinesViewAppearance: NSObject {
    @objc public let lineCount: Int // use 0 if the number of lines should adapt to the available height
    @objc public let lineHeight: CGFloat
    @objc public let lineSpacing: CGFloat
    @objc public let firstLineFillPercent: CGFloat
    @objc public let lastLineFillPercent: CGFloat

    /// Create an apperance shimmer view apperance object
    /// - Parameter lineCount: Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
    /// - Parameter lineHeight: Height of shimmering line
    /// - Parameter lineSpacing: Spacing between lines (if lines > 1)
    /// - Parameter firstLineFillPercent: if two or more lines, the percent the first line should fill the available horizontal space
    /// - Parameter lastLineFillPercent: the percent the last line should fill the available horizontal space.
    @objc public init(lineCount: Int = 3,
                      lineHeight: CGFloat = 11,
                      lineSpacing: CGFloat = 11,
                      firstLineFillPercent: CGFloat = 0.94,
                      lastLineFillPercent: CGFloat = 0.6) {
        self.lineCount = lineCount
        self.lineHeight = lineHeight
        self.lineSpacing = lineSpacing
        self.firstLineFillPercent = firstLineFillPercent
        self.lastLineFillPercent = lastLineFillPercent
    }
}
