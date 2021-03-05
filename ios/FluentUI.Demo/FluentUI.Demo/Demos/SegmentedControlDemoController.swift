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

        addTitle(text: "Tabs (deprecated)")

        let tabsSegmentedControl = SegmentedControl(items: segmentTitles)
        tabsSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        container.addArrangedSubview(tabsSegmentedControl)
        controlLabels[tabsSegmentedControl] = addDescription(text: "", textAlignment: .center)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Tabs (deprecated)")

        let disabledTabsSegmentedControl = SegmentedControl(items: Array(segmentTitles.prefix(3)))
        disabledTabsSegmentedControl.isEnabled = false
        disabledTabsSegmentedControl.selectedSegmentIndex = 1
        container.addArrangedSubview(disabledTabsSegmentedControl)
        container.addArrangedSubview(UIView())

        addTitle(text: "Primary Pill")

        addPillControl(items: Array(segmentTitles.prefix(3)), style: .primaryPill)
        container.addArrangedSubview(UIView())

        addTitle(text: "Primary Pill with unequal buttons")

        addPillControl(items: Array(segmentTitles.prefix(2)), style: .primaryPill, equalSegments: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Primary Pill")

        addPillControl(items: Array(segmentTitles.prefix(2)), style: .primaryPill, enabled: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill")

        addPillControl(items: Array(segmentTitles.prefix(3)), style: .onBrandPill)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill with unequal buttons")

        addPillControl(items: Array(segmentTitles.prefix(2)), style: .onBrandPill, equalSegments: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled On Brand Pill")

        addPillControl(items: Array(segmentTitles.prefix(2)), style: .onBrandPill, enabled: false)
    }

    @objc func updateLabel(forControl control: SegmentedControl) {
        controlLabels[control]?.text = "\"\(segmentTitles[control.selectedSegmentIndex])\" segment is selected"
    }

    func addPillControl(items: [String], style: SegmentedControl.Style, equalSegments: Bool = true, enabled: Bool = true) {
        let pillControl = SegmentedControl(items: items, style: style)
        pillControl.shouldSetEqualWidthForSegments = equalSegments
        pillControl.isEnabled = enabled
        pillControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)

        let backgroundView = UIView()
        if style == .primaryPill {
            backgroundView.backgroundColor = Colors.Navigation.System.background
        } else {
            backgroundView.backgroundColor = UIColor(light: Colors.communicationBlue, dark: Colors.Navigation.System.background)
        }

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        pillControl.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(pillControl)
        container.addArrangedSubview(backgroundView)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
        var constraints = [backgroundView.topAnchor.constraint(equalTo: pillControl.topAnchor, constant: -margins.top),
                           backgroundView.bottomAnchor.constraint(equalTo: pillControl.bottomAnchor, constant: margins.bottom)]
        if equalSegments {
            constraints.append(pillControl.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        }

        NSLayoutConstraint.activate(constraints)

        if enabled {
            controlLabels[pillControl] = addDescription(text: "", textAlignment: .center)
        }
    }
}
