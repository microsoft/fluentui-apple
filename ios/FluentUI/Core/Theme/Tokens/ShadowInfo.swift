//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics

/// Represents a two-part shadow as used by FluentUI.
public struct ShadowInfo {
    /// The color of the shadow for shadow 1
    let colorOne: DynamicColor

    /// The radius of the shadow for shadow 1
    let blurOne: CGFloat

    /// The offset of the shadow on the x-axis for shadow 1, from the center of the control
    let xOne: CGFloat

    /// The offset of the shadow on the y-axis for shadow 1, from the center of the control
    let yOne: CGFloat

    /// The color of the shadow for shadow 2
    let colorTwo: DynamicColor

    /// The radius of the shadow for shadow 2
    let blurTwo: CGFloat

    /// The size of the shadow on the x-axis (also, width) for shadow 2
    let xTwo: CGFloat

    /// The size of the shadow on the y-axis (also, height) for shadow 2
    let yTwo: CGFloat
}
