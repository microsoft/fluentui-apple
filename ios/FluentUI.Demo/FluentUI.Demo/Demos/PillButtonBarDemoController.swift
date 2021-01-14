//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PillButtonBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layoutMargins.right = 0
        container.layoutMargins.left = 0
        var items: [PillButtonBarItem] = [PillButtonBarItem(title: "All"),
                                          PillButtonBarItem(title: "Documents"),
                                          PillButtonBarItem(title: "People"),
                                          PillButtonBarItem(title: "Other"),
                                          PillButtonBarItem(title: "Templates"),
                                          PillButtonBarItem(title: "Actions"),
                                          PillButtonBarItem(title: "More")]

        let disableOnBrandSwitchView = UISwitch()
        disableOnBrandSwitchView.isOn = true
        disableOnBrandSwitchView.addTarget(self, action: #selector(toggleOnBrandPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("onBrand"))
        addRow(items: [createLabelWithText("Enable/Disable pills in onBrand Pill Bar"), disableOnBrandSwitchView], itemSpacing: 20, centerItems: true)
        let onBrandBar = createBar(items: items, style: .onBrand)
        container.addArrangedSubview(onBrandBar)
        self.onBrandBar = onBrandBar
        container.addArrangedSubview(UIView())

        let disableCustomOnBrandSwitchView = UISwitch()
        disableCustomOnBrandSwitchView.isOn = true
        disableCustomOnBrandSwitchView.addTarget(self, action: #selector(toggleCustomOnBrandPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("onBrand With Custom Pills Background"))
        addRow(items: [createLabelWithText("Enable/Disable pills in custom onBrand Pill Bar"), disableCustomOnBrandSwitchView], itemSpacing: 20, centerItems: true)
        let customBar = createBar(items: items, style: .onBrand, useCustomPillsColors: true)
        container.addArrangedSubview(customBar)
        self.customBar = customBar
        container.addArrangedSubview(UIView())

        let disablePrimarySwitchView = UISwitch()
        disablePrimarySwitchView.isOn = true
        disablePrimarySwitchView.addTarget(self, action: #selector(togglePrimaryPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Primary"))
        addRow(items: [createLabelWithText("Enable/Disable pills in Primary Pill bar"), disablePrimarySwitchView], itemSpacing: 20, centerItems: true)
        let primaryBar = createBar(items: items)
        container.addArrangedSubview(primaryBar)
        self.primaryBar = primaryBar
        container.addArrangedSubview(UIView())

        // When inserting longer button "Templates" instead of shorter "Other" button as the fourth button, compact layouts (most iPhones)
        // will end up with a button configuration where the last visible button won't be a clear indication that the view is scrollable,
        // so our algorithm to adjust insets and spacings will kick in, making the three first buttons longer than in the previous line.
        let item = items.remove(at: 4)
        items.insert(item, at: 3)

        container.addArrangedSubview(createLabelWithText("Optimized for scrolling visibility"))
        addDescription(text: "On a narrow screen like iPhone Portrait, the default sizes will leave the next button hidden. Spacing and button sizing is changed to make clear that the view can be scrolled")
        container.addArrangedSubview(createBar(items: items))
        container.addArrangedSubview(UIView())

        items = Array(items[0...1])
        container.addArrangedSubview(createLabelWithText("Leading Aligned"))
        container.addArrangedSubview(createBar(items: items))
        container.addArrangedSubview(UIView())

        container.addArrangedSubview(createLabelWithText("Center Aligned"))
        let bar = createBar(items: items, centerAligned: true)
        container.addArrangedSubview(bar)
        container.addArrangedSubview(UIView())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = view.window {
            onBrandBar?.backgroundColor = UIColor(light: Colors.primary(for: window), dark: Colors.Navigation.System.background)
            customBar?.backgroundColor = UIColor(light: Colors.primary(for: window), dark: Colors.Navigation.System.background)
        }
    }

    func createBar(items: [PillButtonBarItem], style: PillButtonStyle = .primary, centerAligned: Bool = false, disabledItems: Bool = false, useCustomPillsColors: Bool = false) -> UIView {
        let pillButtonBackgroundColor = useCustomPillsColors ? Colors.textOnAccent : nil
        let pillSelectedButtonBackgroundColor = useCustomPillsColors ? Colors.textPrimary : nil
        let pillButtonTextColor = useCustomPillsColors ? Colors.textPrimary : nil
        let pillSelectedButtontextColor = useCustomPillsColors ? Colors.textOnAccent : nil

        let bar = PillButtonBar(pillButtonStyle: style, pillButtonBackgroundColor: pillButtonBackgroundColor, selectedPillButtonBackgroundColor: pillSelectedButtonBackgroundColor, pillButtonTextColor: pillButtonTextColor, selectedPillButtonTextColor: pillSelectedButtontextColor)
        bar.items = items
        _ = bar.selectItem(atIndex: 0)
        bar.barDelegate = self
        bar.centerAligned = centerAligned

        if disabledItems {
            items.forEach { bar.disableItem($0) }
        }

        let backgroundView = UIView()
        if style == .primary {
            backgroundView.backgroundColor = Colors.Navigation.System.background
        }

        backgroundView.addSubview(bar)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0.0)
        fitViewIntoSuperview(bar, margins: margins)
        return backgroundView
    }

    func createLabelWithText(_ text: String = "") -> Label {
        let label = Label(style: .subhead, colorStyle: .regular)
        label.text = text
        label.textAlignment = .center
        return label
    }

    func fitViewIntoSuperview(_ view: UIView, margins: UIEdgeInsets) {
        guard let superview = view.superview else {
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margins.left),
                           view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margins.right),
                           view.topAnchor.constraint(equalTo: superview.topAnchor, constant: margins.top),
                           view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margins.bottom)]

        NSLayoutConstraint.activate(constraints)
    }

    func togglePills(pillBar: PillButtonBar, enable: Bool) {
        if let items = pillBar.items {
            if enable {
                for item in items {
                    pillBar.enableItem(item)
                }
            } else {
                for item in items {
                    pillBar.disableItem(item)
                }
            }
        }
    }

    @objc private func toggleOnBrandPills(switchView: UISwitch) {
        let pillBar = self.onBrandBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    @objc private func toggleCustomOnBrandPills(switchView: UISwitch) {
        let pillBar = self.customBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    @objc private func togglePrimaryPills(switchView: UISwitch) {
        let pillBar = self.primaryBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    private var onBrandBar: UIView?

    private var customBar: UIView?

    private var primaryBar: UIView?
}

// MARK: - PillButtonBarDemoController: PillButtonBarDelegate

extension PillButtonBarDemoController: PillButtonBarDelegate {
    func pillBar(_ pillBar: PillButtonBar, didSelectItem item: PillButtonBarItem, atIndex index: Int) {
        let alert = UIAlertController(title: "Item \(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
