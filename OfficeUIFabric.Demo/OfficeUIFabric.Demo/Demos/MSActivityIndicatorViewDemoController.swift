//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSActivityIndicatorViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        for size in MSActivityIndicatorViewSize.allCases {
            let activityIndicatorView = MSActivityIndicatorView(size: size)
            activityIndicatorView.startAnimating()
            addRow(text: size.description, items: [activityIndicatorView])
        }
    }
}

extension MSActivityIndicatorViewSize {
    var description: String {
        switch self {
        case .xSmall:
            return "XSmall"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .xLarge:
            return "XLarge"
        }
    }
}
