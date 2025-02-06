//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ListItemDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = ListItemDemoControllerSwiftUI()
        self.hostingController = hostingController
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                                     hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)])

        readmeString = "A list item displays a single row of data in a list.\n\nUse list items for displaying rows of data in a single column."
    }

    override func didMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window,
              let hostingController else {
            return
        }

        hostingController.rootView.fluentTheme = window.fluentTheme
    }

    var hostingController: ListItemDemoControllerSwiftUI?
}
