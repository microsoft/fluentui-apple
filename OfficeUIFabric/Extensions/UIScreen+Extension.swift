//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension UIScreen {
    var devicePixel: CGFloat { return 1 / scale }

    class var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    class var isLandscape: Bool { return !isPortrait }

    func roundToDevicePixels(_ value: CGFloat) -> CGFloat {
        return ceil(value * scale) / scale
    }

    func roundDownToDevicePixels(_ value: CGFloat) -> CGFloat {
        return floor(value * scale) / scale
    }

    func middleOrigin(_ containerSizeValue: CGFloat, containedSizeValue: CGFloat) -> CGFloat {
        return roundDownToDevicePixels((containerSizeValue - containedSizeValue) / 2.0)
    }
}
