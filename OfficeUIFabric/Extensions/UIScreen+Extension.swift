//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
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
}
