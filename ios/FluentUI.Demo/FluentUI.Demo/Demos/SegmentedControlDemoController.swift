//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class SegmentedControlDemoController: DemoController {
    let segmentTitles: [String] = ["First", "Second", "Third", "Fourth"]

    var controlLabels = [SegmentedControl: Label]() {
        didSet {
            controlLabels.forEach { updateLabel(forControl: $0.key) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background2

        container.layoutMargins.left = 0
        container.layoutMargins.right = 0

        addTitle(text: "Tabs")

        let tabsSegmentedControl = SegmentedControl(items: segmentTitles)
        tabsSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(tabsSegmentedControl)
        controlLabels[tabsSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Tabs")

        let disabledTabsSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(3)))
        disabledTabsSegmentedControl.isEnabled = false
        disabledTabsSegmentedControl.selectedSegmentIndex = 1
        container.addArrangedSubview(disabledTabsSegmentedControl)
        container.addArrangedSubview(UIView())

        addTitle(text: "Switch")

        let switchSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(2)), style: .switch)
        switchSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        addRow(items: [switchSegmentedControl], centerItems: true)
        controlLabels[switchSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Switch")

        let disabledSwitchSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(2)), style: .switch)
        disabledSwitchSegmentedControl.isEnabled = false
        disabledSwitchSegmentedControl.selectedSegmentIndex = 1
        addRow(items: [disabledSwitchSegmentedControl], centerItems: true)
    }

    @objc func updateLabel(forControl control: SegmentedControl) {
        controlLabels[control]?.text = "\"\(segmentTitles[control.selectedSegmentIndex])\" segment is selected"
    }
}
