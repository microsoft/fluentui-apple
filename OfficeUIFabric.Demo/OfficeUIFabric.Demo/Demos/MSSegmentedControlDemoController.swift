//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation
import OfficeUIFabric

class MSSegmentedControlDemoController: DemoController {
    let segmentTitles: [String] = ["First", "Second", "Third", "Fourth"]

    var controlLabels = [MSSegmentedControl: MSLabel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        container.layoutMargins = UIEdgeInsets.zero

        let fourButtonSegmentedControl = MSSegmentedControl(items: segmentTitles)
        let threeButtonSegmentedControl = MSSegmentedControl(items: Array(segmentTitles.prefix(3)))
        let twoButtonSegmentedControl = MSSegmentedControl(items: Array(segmentTitles.prefix(2)))
        let disabledSegmentedControl = MSSegmentedControl(items: segmentTitles)

        fourButtonSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        threeButtonSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        twoButtonSegmentedControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)
        disabledSegmentedControl.isEnabled = false
        disabledSegmentedControl.selectedSegmentIndex = 2

        let fourButtonLabel = createLabel()
        let threeButtonLabel = createLabel()
        let twoButtonLabel = createLabel()

        controlLabels[fourButtonSegmentedControl] = fourButtonLabel
        controlLabels[threeButtonSegmentedControl] = threeButtonLabel
        controlLabels[twoButtonSegmentedControl] = twoButtonLabel

        for (control, label) in controlLabels {
            updateLabel(forControl: control)
            container.addArrangedSubview(control)
            container.addArrangedSubview(label)
            container.addArrangedSubview(UIView())
        }

        container.addArrangedSubview(disabledSegmentedControl)
    }

    @objc func updateLabel(forControl control: MSSegmentedControl) {
        controlLabels[control]?.text = segmentTitles[control.selectedSegmentIndex]
    }

    func createLabel() -> MSLabel {
        let label = MSLabel(style: .headline, colorStyle: .regular)
        label.textAlignment = .center
        return label
    }
}
