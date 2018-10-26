//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: Traits

public extension UIViewController {
    @objc var isWidthCompact: Bool {
        return traitCollection.horizontalSizeClass == .compact
    }

    @objc var isWidthRegular: Bool {
        return traitCollection.horizontalSizeClass == .regular
    }

    @objc var isHeightCompact: Bool {
        return traitCollection.verticalSizeClass == .compact
    }

    @objc var isHeightRegular: Bool {
        return traitCollection.verticalSizeClass == .regular
    }
}

// MARK: - Add/Remove Child View Controller

public extension UIViewController {
    /// Convenience method that adds a child view controller to the receiver and also establish the parent-children relationship between their corresponding views
    @objc func addChildController(_ childController: UIViewController) {
        addChildViewController(childController)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }

    /// Convenience method that removes a child view controller from the receiver and also remove the parent-children relationship of the childViewController
    @objc func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParentViewController: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
    }
}
