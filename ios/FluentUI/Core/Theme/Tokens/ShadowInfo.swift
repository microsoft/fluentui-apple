//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics

/// Represents a two-part shadow as used by FluentUI.
/// Blur refers to the radius of the shadow's blur.
public struct ShadowInfo {
    let colorOne: DynamicColor
    let blurOne: CGFloat
    let xOne: CGFloat
    let yOne: CGFloat
    let colorTwo: DynamicColor
    let blurTwo: CGFloat
    let xTwo: CGFloat
    let yTwo: CGFloat
}
