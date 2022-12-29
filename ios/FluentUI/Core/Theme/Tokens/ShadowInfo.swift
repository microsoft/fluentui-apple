//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Represents a two-part shadow as used by FluentUI.
@objc(MSFShadowInfo)
public class ShadowInfo: NSObject {
    /// Initializes a shadow struct to be used in Fluent.
    ///
    /// - Parameters:
    ///   - colorOne: The color of the shadow for shadow 1.
    ///   - blurOne: The blur of the shadow for shadow 1.
    ///   - xOne: The horizontal offset of the shadow for shadow 1.
    ///   - yOne: The vertical offset of the shadow for shadow 1.
    ///   - colorTwo: The color of the shadow for shadow 2.
    ///   - blurTwo: The blur of the shadow for shadow 2.
    ///   - xTwo: The horizontal offset of the shadow for shadow 2.
    ///   - yTwo: The vertical offset of the shadow for shadow 2.
    public init(colorOne: DynamicColor,
                blurOne: CGFloat,
                xOne: CGFloat,
                yOne: CGFloat,
                colorTwo: DynamicColor,
                blurTwo: CGFloat,
                xTwo: CGFloat,
                yTwo: CGFloat) {
        self.colorOne = colorOne
        self.blurOne = blurOne
        self.xOne = xOne
        self.yOne = yOne
        self.colorTwo = colorTwo
        self.blurTwo = blurTwo
        self.xTwo = xTwo
        self.yTwo = yTwo
    }

    /// The color of the shadow for shadow 1.
    @objc public let colorOne: DynamicColor

    /// The blur of the shadow for shadow 1.
    @objc public let blurOne: CGFloat

    /// The horizontal offset of the shadow for shadow 1.
    @objc public let xOne: CGFloat

    /// The vertical offset of the shadow for shadow 1.
    @objc public let yOne: CGFloat

    /// The color of the shadow for shadow 2.
    @objc public let colorTwo: DynamicColor

    /// The blur of the shadow for shadow 2.
    @objc public let blurTwo: CGFloat

    /// The horizontal offset of the shadow for shadow 2.
    @objc public let xTwo: CGFloat

    /// The vertical offset of the shadow for shadow 2.
    @objc public let yTwo: CGFloat
}
