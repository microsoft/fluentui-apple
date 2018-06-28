//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    private(set) var demoController: UIViewController?
    var demoControllerClass: UIViewController.Type? {
        didSet {
            if demoControllerClass != oldValue {
                initDemoController()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initDemoController()
    }
    
    private func initDemoController() {
        if !isViewLoaded {
            return
        }
        if let controller = demoController {
            controller.willMove(toParentViewController: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
        guard let controller = demoControllerClass?.init() else {
            return
        }
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.frame = view.bounds
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        demoController = controller
    }
}
