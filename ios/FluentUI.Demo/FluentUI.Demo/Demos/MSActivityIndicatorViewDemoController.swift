//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ActivityIndicatorViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        for size in ActivityIndicatorViewSize.allCases.reversed() {
            let activityIndicatorView = ActivityIndicatorView(size: size)
            activityIndicatorView.startAnimating()
            addRow(text: size.description, items: [activityIndicatorView])
        }
    }
}

extension ActivityIndicatorViewSize {
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
