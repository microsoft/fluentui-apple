//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public protocol BrandColors {
    var primary: ColorSet? { get }
    var tint10: ColorSet? { get }
    var tint20: ColorSet? { get }
    var tint30: ColorSet? { get }
    var tint40: ColorSet? { get }
    var shade10: ColorSet? { get }
    var shade20: ColorSet? { get }
    var shade30: ColorSet? { get }
}

struct DefaultBrandColors {
    static let primary: ColorSet = GlobalTokens.Colors.Brand.primary.value
    static let shade10: ColorSet = GlobalTokens.Colors.Brand.shade10.value
    static let shade20: ColorSet = GlobalTokens.Colors.Brand.shade20.value
    static let shade30: ColorSet = GlobalTokens.Colors.Brand.shade30.value
    static let tint10: ColorSet = GlobalTokens.Colors.Brand.tint10.value
    static let tint20: ColorSet = GlobalTokens.Colors.Brand.tint20.value
    static let tint30: ColorSet = GlobalTokens.Colors.Brand.tint30.value
    static let tint40: ColorSet = GlobalTokens.Colors.Brand.tint40.value
}
