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

    // MARK: - Convenience Factory Methods

    /// Creates a configuration for a standard title line.
    /// - Returns: Configuration with height 64pt, 85% width, 12pt corner radius.
    @objc public static func titleLine() -> ShimmerLineConfig {
        ShimmerLineConfig(height: 64, widthPercent: 0.85, cornerRadius: NSNumber(value: 12))
    }

    /// Creates a configuration for a subtitle line.
    /// - Returns: Configuration with height 40pt, 55% width, 10pt corner radius.
    @objc public static func subtitleLine() -> ShimmerLineConfig {
        ShimmerLineConfig(height: 40, widthPercent: 0.55, cornerRadius: NSNumber(value: 10))
    }

    /// Creates a configuration for a large content block.
    /// - Parameter height: Height of the content block. Default is 400pt.
    /// - Returns: Configuration with specified height, full width, 16pt corner radius.
    @objc public static func contentBlock(height: CGFloat = 400) -> ShimmerLineConfig {
        ShimmerLineConfig(height: height, widthPercent: 1.0, cornerRadius: NSNumber(value: 16))
    }

    /// Creates a configuration for a standard list item.
    /// - Returns: Configuration with height 36pt, full width, 8pt corner radius.
    @objc public static func listItem() -> ShimmerLineConfig {
        ShimmerLineConfig(height: 36, widthPercent: 1.0, cornerRadius: NSNumber(value: 8))
    }

    /// Creates a configuration for a standard row with default token height.
    /// - Parameter widthPercent: Horizontal fill percentage (0.0 to 1.0). Default is 0.85.
    /// - Returns: Configuration with token-based height, specified width, default corner radius.
    @objc public static func standardRow(widthPercent: CGFloat = 0.85) -> ShimmerLineConfig {
        ShimmerLineConfig(height: 44, widthPercent: widthPercent, cornerRadius: nil)
    }
}
