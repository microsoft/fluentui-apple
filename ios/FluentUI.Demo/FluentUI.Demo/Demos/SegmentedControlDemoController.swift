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
        view.backgroundColor = Colors.surfaceSecondary

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

        addTitle(text: "Primary Pill")

        let primarySegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(2)), style: .primaryPill)
        primarySegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(primarySegmentedControl)
        controlLabels[primarySegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Primary Pill with unequal buttons")

        let unequalPrimarySegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(2)), style: .primaryPill)
        unequalPrimarySegmentedControl.segmentsHaveEqualWidth = false
        unequalPrimarySegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(unequalPrimarySegmentedControl)
        controlLabels[unequalPrimarySegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Primary Pill")

        let disabledPrimarySegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(3)), style: .primaryPill)
        disabledPrimarySegmentedControl.isEnabled = false
        disabledPrimarySegmentedControl.selectedSegmentIndex = 1
        container.addArrangedSubview(disabledPrimarySegmentedControl)
        container.addArrangedSubview(UIView())
        
        addTitle(text: "On Brand Pill")

        let onBrandSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(2)), style: .onBrandPill)
        onBrandSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(onBrandSegmentedControl)
        controlLabels[onBrandSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill with unequal buttons")

        let unequalOnBrandSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(2)), style: .onBrandPill)
        unequalOnBrandSegmentedControl.segmentsHaveEqualWidth = false
        unequalOnBrandSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(unequalOnBrandSegmentedControl)
        controlLabels[unequalOnBrandSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled On Brand Pill")

        let disabledOnBrandSwitchSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(3)), style: .onBrandPill)
        disabledOnBrandSwitchSegmentedControl.isEnabled = false
        disabledOnBrandSwitchSegmentedControl.selectedSegmentIndex = 1
        container.addArrangedSubview(disabledOnBrandSwitchSegmentedControl)
    }

    @objc func updateLabel(forControl control: SegmentedControl) {
        controlLabels[control]?.text = "\"\(segmentTitles[control.selectedSegmentIndex])\" segment is selected"
    }
}
