//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics

/// Represents a two-part shadow as used by FluentUI.
public struct ShadowInfo: Equatable {
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

    public let colorOne: DynamicColor
    public let blurOne: CGFloat
    public let xOne: CGFloat
    public let yOne: CGFloat
    public let colorTwo: DynamicColor
    public let blurTwo: CGFloat
    public let xTwo: CGFloat
    public let yTwo: CGFloat
}
