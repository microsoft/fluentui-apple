//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public protocol BrandColors {
    var primary: ColorSet { get }
    var tint10: ColorSet { get }
    var tint20: ColorSet { get }
    var tint30: ColorSet { get }
    var tint40: ColorSet { get }
    var shade10: ColorSet { get }
    var shade20: ColorSet { get }
    var shade30: ColorSet { get }
}

class DefaultBrandColors: BrandColors {
    let primary: ColorSet = GlobalTokens.Colors.Brand.primary.value
    let shade10: ColorSet = GlobalTokens.Colors.Brand.shade10.value
    let shade20: ColorSet = GlobalTokens.Colors.Brand.shade20.value
    let shade30: ColorSet = GlobalTokens.Colors.Brand.shade30.value
    let tint10: ColorSet = GlobalTokens.Colors.Brand.tint10.value
    let tint20: ColorSet = GlobalTokens.Colors.Brand.tint20.value
    let tint30: ColorSet = GlobalTokens.Colors.Brand.tint30.value
    let tint40: ColorSet = GlobalTokens.Colors.Brand.tint40.value
}
