//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ShimmerLinesViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Default Shimmer
        container.addArrangedSubview(ShimmerLinesView())
    }
}
