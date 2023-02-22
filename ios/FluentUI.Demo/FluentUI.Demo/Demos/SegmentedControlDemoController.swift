//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SegmentedControlDemoController: DemoController {
    let segmentItems: [SegmentItem] = [
        SegmentItem(title: "First"),
        SegmentItem(title: "Second", image: UIImage(named: "Placeholder_20"), isUnread: true),
        SegmentItem(title: "Third", isUnread: true),
        SegmentItem(title: "Fourth"),
        SegmentItem(title: "Fifth"),
        SegmentItem(title: "Sixth"),
        SegmentItem(title: "Seventh"),
        SegmentItem(title: "Eigth"),
        SegmentItem(title: "Ninth"),
        SegmentItem(title: "Tenth")
    ]

    var controlLabels = [SegmentedControl: Label]() {
        didSet {
            controlLabels.forEach { updateLabel(forControl: $0.key) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(dynamicColor: view.fluentTheme.aliasTokens.colors[.background1])

        readmeString = "A segmented control lets someone select one option from a set of two or more segments in a single, horizontal container.\n\nSegmented controls work well for changing states of elements or views within a single context, like filtering search results. It’s best not to use them to initiate actions or navigate to a new page. To let people navigate between the main sections of an app, use the tab bar."

        container.layoutMargins.left = 0
        container.layoutMargins.right = 0

        addTitle(text: "Primary Pill")
        addDescription(text: "fixed width, equal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(3)),
                       style: .primaryPill)
        container.addArrangedSubview(UIView())

        addTitle(text: "Primary Pill")
        addDescription(text: "not fixed width, unequal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(10)),
                       style: .primaryPill,
                       equalSegments: false,
                       isFixedWidth: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Primary Pill")
        addDescription(text: "not fixed width, unequal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(2)),
                       style: .primaryPill,
                       equalSegments: false,
                       isFixedWidth: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled Primary Pill")
        addDescription(text: "fixed width, equal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(2)),
                       style: .primaryPill,
                       enabled: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill")
        addDescription(text: "not fixed width, equal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(10)),
                       style: .onBrandPill,
                       equalSegments: true,
                       isFixedWidth: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "On Brand Pill")
        addDescription(text: "not fixed width, equal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(2)),
                       style: .onBrandPill,
                       isFixedWidth: false)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled On Brand Pill")
        addDescription(text: "fixed width, equal buttons", textAlignment: .center)
        addPillControl(items: Array(segmentItems.prefix(2)),
                       style: .onBrandPill,
                       enabled: false)
    }

    @objc func updateLabel(forControl control: SegmentedControl) {
        controlLabels[control]?.text = "\"\(segmentItems[control.selectedSegmentIndex].title)\" segment is selected"
    }

    func addPillControl(items: [SegmentItem], style: SegmentedControlStyle, equalSegments: Bool = true, enabled: Bool = true, isFixedWidth: Bool = true) {
        let pillControl = SegmentedControl(items: items, style: style)
        pillControl.shouldSetEqualWidthForSegments = equalSegments
        pillControl.isFixedWidth = isFixedWidth
        pillControl.isEnabled = enabled
        pillControl.onSelectAction = { [weak self] (_, _) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.updateLabel(forControl: pillControl)
        }

        let backgroundStyle: ColoredPillBackgroundStyle = {
            switch style {
            case .primaryPill:
                return .neutral
            case .onBrandPill:
                return .brand
            }
        }()
        let backgroundView = ColoredPillBackgroundView(style: backgroundStyle)
        segmentedControls.append(pillControl)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        pillControl.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(pillControl)
        container.addArrangedSubview(backgroundView)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
        var constraints = [backgroundView.topAnchor.constraint(equalTo: pillControl.topAnchor,
                                                               constant: -margins.top),
                           backgroundView.bottomAnchor.constraint(equalTo: pillControl.bottomAnchor,
                                                                  constant: margins.bottom)]
        if equalSegments {
            constraints.append(pillControl.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        }
        if isFixedWidth {
            constraints.append(contentsOf: [
                backgroundView.leadingAnchor.constraint(lessThanOrEqualTo: pillControl.leadingAnchor),
                backgroundView.trailingAnchor.constraint(greaterThanOrEqualTo: pillControl.trailingAnchor)
            ])
        } else {
            constraints.append(contentsOf: [
                backgroundView.leadingAnchor.constraint(equalTo: pillControl.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: pillControl.trailingAnchor)
            ])
        }

        NSLayoutConstraint.activate(constraints)

        if enabled {
            controlLabels[pillControl] = addDescription(text: "", textAlignment: .center)
        }
    }

    private var segmentedControls: [SegmentedControl] = []
}

extension SegmentedControlDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: SegmentedControlTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideSegmentedControlTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        self.segmentedControls.forEach({ segmentedControl in
            segmentedControl.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideSegmentedControlTokens : nil)
        })
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: SegmentedControlTokenSet.self) != nil
    }

    // MARK: - Custom tokens

    private var themeWideOverrideSegmentedControlTokens: [SegmentedControlTokenSet.Tokens: ControlTokenValue] {
        return [
            .font: .fontInfo {
                return FontInfo(name: "Times", size: 20.0, weight: .regular)
            }
        ]
    }

    private var perControlOverrideSegmentedControlTokens: [SegmentedControlTokenSet.Tokens: ControlTokenValue] {
        return [
            .font: .fontInfo {
                return FontInfo(name: "Papyrus", size: 10.0, weight: .regular)
            }
        ]
    }
}
