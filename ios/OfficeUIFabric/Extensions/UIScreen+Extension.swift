//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public extension UIScreen {
    var devicePixel: CGFloat { return 1 / scale }

    func roundToDevicePixels(_ value: CGFloat) -> CGFloat {
        /*
         Round to 3 digits after floating point to better match the device rounding on 3x devices.
         Avoids a situation where calculated size is smaller than screen size by a difference in 4th+ position after floaing point.
         For example:
           calculated = 52.666666666666671
               actual = 52.666667938232422
        */
        return ceil(ceil(value * scale) / scale * 1000) / 1000
    }

    func roundDownToDevicePixels(_ value: CGFloat) -> CGFloat {
        return floor(value * scale) / scale
    }

    func middleOrigin(_ containerSizeValue: CGFloat, containedSizeValue: CGFloat) -> CGFloat {
        return roundDownToDevicePixels((containerSizeValue - containedSizeValue) / 2.0)
    }
}
