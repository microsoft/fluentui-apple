//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

open class ControlTokens: NSObject {
    struct ControlBrandColors {
        var override: BrandColors?

        var primary: ColorSet { override?.primary ?? DefaultBrandColors.primary }
        var tint10: ColorSet { override?.tint10 ?? DefaultBrandColors.tint10 }
        var tint20: ColorSet { override?.tint20 ?? DefaultBrandColors.tint20 }
        var tint30: ColorSet { override?.tint30 ?? DefaultBrandColors.tint30 }
        var tint40: ColorSet { override?.tint40 ?? DefaultBrandColors.tint40 }
        var shade10: ColorSet { override?.shade10 ?? DefaultBrandColors.shade10 }
        var shade20: ColorSet { override?.shade20 ?? DefaultBrandColors.shade20 }
        var shade30: ColorSet { override?.shade30 ?? DefaultBrandColors.shade30 }
    }
    var brandColors = ControlBrandColors()
}
