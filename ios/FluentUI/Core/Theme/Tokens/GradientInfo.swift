//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics
import Foundation
import SwiftUI

/// Represents a gradient as used by FluentUI.
@objc public class GradientInfo: NSObject {
    /// Initializes a gradient to be used in Fluent.
    ///
    /// - Parameters:
    ///   - colors: The color of the shadow for shadow 1.
    ///   - startPoint: The blur of the shadow for shadow 1.
    ///   - endPoint: The horizontal offset of the shadow for shadow 1.
    public init(colors: [DynamicColor],
                startPoint: CGPoint,
                endPoint: CGPoint) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    /// The array of colors to apply to this linear gradient.
    public let colors: [DynamicColor]

    /// The starting point for this gradient. Values should range from 0.0 to 1.0.
    public let startPoint: CGPoint

    /// The ending point for this gradient. Values should range from 0.0 to 1.0.
    public let endPoint: CGPoint
}

// MARK: - Extensions

extension LinearGradient {
    /// Internal property to generate a SwiftUI `LinearGradient` from a gradient info.
    init(gradientInfo: GradientInfo) {
        self.init(colors: gradientInfo.colors.map({ Color(dynamicColor: $0) }),
                  startPoint: UnitPoint(x: gradientInfo.startPoint.x, y: gradientInfo.startPoint.y),
                  endPoint: UnitPoint(x: gradientInfo.endPoint.x, y: gradientInfo.endPoint.y))
    }
}
