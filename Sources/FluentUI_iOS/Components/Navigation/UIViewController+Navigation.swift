//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI_common
import UIKit

@objc public extension UIViewController {
    var msfNavigationController: NavigationController? {
        return navigationController as? NavigationController
    }
}
