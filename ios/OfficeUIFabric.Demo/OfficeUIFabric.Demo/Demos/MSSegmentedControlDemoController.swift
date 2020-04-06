//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

class MSSegmentedControlDemoController: DemoController {
    let segmentTitles: [String] = ["First", "Second", "Third", "Fourth"]

    var controlLabels = [MSSegmentedControl: MSLabel]() {
        didSet {
            controlLabels.forEach { updateLabel(forControl: $0.key) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background2

        container.layoutMargins.left = 0
        container.layoutMargins.right = 0

        addTitle(text: "Tabs")

        let tabsSegmentedControl = MSSegmentedControl(items: segmentTitles)
        tabsSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(tabsSegmentedControl)
        controlLabels[tabsSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Tabs")

        let disabledTabsSegmentedControl = MSSegmentedControl(items: Array(segmentTitles.prefix(3)))
        disabledTabsSegmentedControl.isEnabled = false
        disabledTabsSegmentedControl.selectedSegmentIndex = 1
        container.addArrangedSubview(disabledTabsSegmentedControl)
        container.addArrangedSubview(UIView())

        addTitle(text: "Switch")

        let switchSegmentedControl = MSSegmentedControl(items: Array(segmentTitles.prefix(2)), style: .switch)
        switchSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        addRow(items: [switchSegmentedControl], centerItems: true)
        controlLabels[switchSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Switch")

        let disabledSwitchSegmentedControl = MSSegmentedControl(items: Array(segmentTitles.prefix(2)), style: .switch)
        disabledSwitchSegmentedControl.isEnabled = false
        disabledSwitchSegmentedControl.selectedSegmentIndex = 1
        addRow(items: [disabledSwitchSegmentedControl], centerItems: true)
    }

    @objc func updateLabel(forControl control: MSSegmentedControl) {
        controlLabels[control]?.text = "\"\(segmentTitles[control.selectedSegmentIndex])\" segment is selected"
    }
}
