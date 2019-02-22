//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension UIFont {
    var deviceLineHeight: CGFloat { return UIScreen.main.roundToDevicePixels(lineHeight) }
    var deviceLineHeightWithLeading: CGFloat { return UIScreen.main.roundToDevicePixels(lineHeight + leading) }

    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        return UIFont(descriptor: fontDescriptor.withWeight(weight), size: pointSize)
    }
}
