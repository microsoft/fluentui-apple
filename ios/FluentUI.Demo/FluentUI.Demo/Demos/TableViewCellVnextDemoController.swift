//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
//import SwiftUI

class TableViewCellVnextDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading
        let sampleCell = TableViewCellVnext(title: "Sample Title", cellSubtitle: "Sample Subtitle", cellLeadingView: "Settings_24")
        let sampleCellView = sampleCell.view ?? UIView()
        addRow(items: [sampleCellView])
        container.addArrangedSubview(UIView())
    }
}
