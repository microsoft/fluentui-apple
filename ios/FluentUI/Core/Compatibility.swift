//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

struct Compatibility {
    /// A cross-version way to check if the current device is running visionOS.
    ///
    /// - Returns: `UIDevice.current.userInterfaceIdiom == .vision` if the current OS is >= iOS 17,
    /// and `false` otherwise.
    static func isDeviceIdiomVision() -> Bool {
        if #available(iOS 17, *) {
            return UIDevice.current.userInterfaceIdiom == .vision
        }
        return false
    }
}
