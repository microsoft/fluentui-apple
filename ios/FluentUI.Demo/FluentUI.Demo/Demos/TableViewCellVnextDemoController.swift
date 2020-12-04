//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TableViewCellVnextDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading
        let sampleCell1 = TableViewCellVnext(title: "Sample Title1", subtitle: "", leadingView: "Settings_24")
        let sampleCell2 = TableViewCellVnext(title: "Sample Title2", subtitle: "", leadingView: "New_24")
        let sampleCell3 = TableViewCellVnext(title: "Sample Title3", subtitle: "", leadingView: "Home_24")
//        let sampleCellView1 = sampleCell1.rootView
//        let sampleCellView2 = sampleCell2.rootView
//        let sampleCellView3 = sampleCell3.rootView
        let sampleCellView1 = sampleCell1.view ?? UIView()
        let sampleCellView2 = sampleCell2.view ?? UIView()
        let sampleCellView3 = sampleCell3.view ?? UIView()
//        let sampleCells = [sampleCellView1, sampleCellView2, sampleCellView3]
        addRow(items: [sampleCellView1])
        addRow(items: [sampleCellView2])
        addRow(items: [sampleCellView3])
        container.addArrangedSubview(UIView())
    }
}
