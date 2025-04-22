//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

@objc public extension UIViewController {
    var msfNavigationController: NavigationController? {
        return navigationController as? NavigationController
    }
}
