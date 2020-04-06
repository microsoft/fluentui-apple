//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UIViewController {
    var msNavigationController: MSNavigationController? {
        return navigationController as? MSNavigationController
    }
}
