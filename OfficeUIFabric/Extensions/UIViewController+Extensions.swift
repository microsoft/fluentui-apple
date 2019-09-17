//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public extension UIViewController {
    /// Convenience method that adds a child view controller to the receiver and also establish the parent-children relationship between their corresponding views
    @objc func addChildController(_ childController: UIViewController, containingViewIn viewContainer: UIView? = nil) {
        addChild(childController)
        (viewContainer ?? view).addSubview(childController.view)
        childController.didMove(toParent: self)
    }

    /// Convenience method that removes a child view controller from the receiver and also remove the parent-children relationship of the childViewController
    @objc func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

    @objc func isAncestor(ofViewController viewController: UIViewController) -> Bool {
        for child in children {
            if child == viewController {
                return true
            }
            if child.isAncestor(ofViewController: viewController) {
                return true
            }
        }
        return false
    }
}
