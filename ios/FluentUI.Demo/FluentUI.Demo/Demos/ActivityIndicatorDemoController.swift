//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ActivityIndicatorDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let enablePointerInteractionSettingView = createLabelAndSwitchRow(labelText: "Hides when stopped",
                                                                          switchAction: #selector(toggleShouldHideWhenStopped(switchView:)),
                                                                          isOn: shouldHideWhenStopped)
        addRow(items: [enablePointerInteractionSettingView])

        let startStopButton = createButton(title: "Start / Stop activity") { _ in
            self.isAnimating.toggle()
        }

        addRow(items: [startStopButton.view])

        addTitle(text: "Default color")
        for size in MSFActivityIndicatorSize.allCases.reversed() {
            let activityIndicator = MSFActivityIndicator(size: size)
            indicators.append(activityIndicator)

            activityIndicator.state.isAnimating = self.isAnimating
            addRow(text: size.description, items: [activityIndicator.view])
        }

        addTitle(text: "Custom color")
        for size in MSFActivityIndicatorSize.allCases.reversed() {
            let activityIndicator = MSFActivityIndicator(size: size)
            indicators.append(activityIndicator)

            activityIndicator.state.color = Colors.communicationBlue
            activityIndicator.state.isAnimating = self.isAnimating
            addRow(text: size.description, items: [activityIndicator.view])
        }
    }

    @objc private func toggleShouldHideWhenStopped(switchView: UISwitch) {
        shouldHideWhenStopped = switchView.isOn
    }

    private var shouldHideWhenStopped: Bool = true {
        didSet {
            if oldValue != shouldHideWhenStopped {
                self.indicators.forEach { indicator in
                    indicator.state.hidesWhenStopped = shouldHideWhenStopped
                }
            }
        }
    }

    private var isAnimating: Bool = true {
        didSet {
            if oldValue != isAnimating {
                self.indicators.forEach { indicator in
                    indicator.state.isAnimating = isAnimating
                }
            }
        }
    }

    private var indicators: [MSFActivityIndicator] = []
}

extension MSFActivityIndicatorSize {
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
