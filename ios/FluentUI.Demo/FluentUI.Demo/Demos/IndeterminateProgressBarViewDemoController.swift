//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class IndeterminateProgressBarViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        //Indeterminate Progress Bar
        let progressBar = IndeterminateProgressBarView()
        container.addArrangedSubview(progressBar)
    }
}
