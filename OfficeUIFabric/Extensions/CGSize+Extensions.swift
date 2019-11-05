//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension CGSize {
    static var max: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }

    var roundedToDevicePixels: CGSize {
        return CGSize(
            width: UIScreen.main.roundToDevicePixels(width),
            height: UIScreen.main.roundToDevicePixels(height)
        )
    }
}
