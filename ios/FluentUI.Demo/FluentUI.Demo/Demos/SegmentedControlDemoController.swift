//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SegmentedControlDemoController: DemoController {
    let segmentItems: [SegmentItem] = [
        SegmentItem(title: "First"),
        SegmentItem(title: "Second"),
        SegmentItem(title: "Third", isUnread: true),
        SegmentItem(title: "Fourth")
    ]

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

        addTitle(text: "Primary Pill")

        addPillControl(items: Array(segmentItems.prefix(3)), style: .primaryPill)
        container.addArrangedSubview(UIView())

        addTitle(text: "Primary Pill with unequal buttons")

        addPillControl(items: Array(segmentItems.prefix(2)), style: .primaryPill, equalSegments: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Primary Pill")

        addPillControl(items: Array(segmentItems.prefix(2)), style: .primaryPill, enabled: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill")

        addPillControl(items: Array(segmentItems.prefix(4)), style: .onBrandPill)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill with unequal buttons")

        addPillControl(items: Array(segmentItems.prefix(2)), style: .onBrandPill, equalSegments: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled On Brand Pill")

        addPillControl(items: Array(segmentItems.prefix(2)), style: .onBrandPill, enabled: false)
    }

    @objc func updateLabel(forControl control: SegmentedControl) {
        controlLabels[control]?.text = "\"\(segmentItems[control.selectedSegmentIndex].title)\" segment is selected"
    }

    func addPillControl(items: [SegmentItem], style: SegmentedControlStyle, equalSegments: Bool = true, enabled: Bool = true) {
        let pillControl = SegmentedControl(items: items, style: style)
        pillControl.shouldSetEqualWidthForSegments = equalSegments
        pillControl.isEnabled = enabled
        pillControl.addTarget(self, action: #selector(updateLabel(forControl:)), for: .valueChanged)

        let backgroundView = UIView()
        if style == .primaryPill {
            backgroundView.backgroundColor = Colors.navigationBarBackground
        } else {
            backgroundView.backgroundColor = UIColor(light: Colors.communicationBlue, dark: Colors.navigationBarBackground)
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

        segmentedControls.append(pillControl)
    }

    private var segmentedControls: [SegmentedControl] = []
}

extension SegmentedControlDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        var tokensClosure: ((SegmentedControl) -> SegmentedControlTokens)?
        if isOverrideEnabled {
            tokensClosure = { _ in
                return ThemeWideOverrideSegmentedControlTokens()
            }
        }

        fluentTheme.register(controlType: SegmentedControl.self, tokens: tokensClosure)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        self.segmentedControls.forEach({ segmentedControl in
            let tokens = isOverrideEnabled ? PerControlOverrideSegmentedControlTokens() : nil
            _ = segmentedControl.overrideTokens(tokens)
        })
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokenOverride(for: FluentButton.self) != nil
    }

    // MARK: - Custom tokens

    private class ThemeWideOverrideSegmentedControlTokens: SegmentedControlTokens {
        override var font: FontInfo {
            return FontInfo(name: "Times", size: 20.0, weight: .regular)
        }
    }

    private class PerControlOverrideSegmentedControlTokens: SegmentedControlTokens {
        override var font: FontInfo {
            return FontInfo(name: "Papyrus", size: 10.0, weight: .regular)
        }
    }
}
