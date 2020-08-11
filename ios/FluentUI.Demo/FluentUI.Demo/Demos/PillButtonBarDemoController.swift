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

        let disableFilledSwitchView = UISwitch()
        disableFilledSwitchView.isOn = true
        disableFilledSwitchView.addTarget(self, action: #selector(toggleFilledPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Filled"))
        addRow(items: [createLabelWithText("Enable/Disable pills in Filled Pill Bar"), disableFilledSwitchView], itemSpacing: 20, centerItems: true)
        let filledBar = createBar(items: items, style: .filled)
        container.addArrangedSubview(filledBar)
        self.filledBar = filledBar
        container.addArrangedSubview(UIView())

        let disableCustomFilledSwitchView = UISwitch()
        disableCustomFilledSwitchView.isOn = true
        disableCustomFilledSwitchView.addTarget(self, action: #selector(toggleCustomFilledPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Filled With Custom Pills Background"))
        addRow(items: [createLabelWithText("Enable/Disable pills in custom Filled Pill Bar"), disableCustomFilledSwitchView], itemSpacing: 20, centerItems: true)
        let customBar = createBar(items: items, style: .filled, useCustomPillsBackground: true)
        container.addArrangedSubview(customBar)
        self.customBar = customBar
        container.addArrangedSubview(UIView())

        let disableOutlinedSwitchView = UISwitch()
        disableOutlinedSwitchView.isOn = true
        disableOutlinedSwitchView.addTarget(self, action: #selector(toggleOutlinedPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Outline"))
        addRow(items: [createLabelWithText("Enable/Disable pills in Outline Pill bar"), disableOutlinedSwitchView], itemSpacing: 20, centerItems: true)
        let outlineBar = createBar(items: items)
        container.addArrangedSubview(outlineBar)
        self.outlineBar = outlineBar
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
            filledBar?.backgroundColor = UIColor(light: Colors.primary(for: window), dark: Colors.Navigation.System.background)
            customBar?.backgroundColor = UIColor(light: Colors.primary(for: window), dark: Colors.Navigation.System.background)
        }
    }

    func createBar(items: [PillButtonBarItem], style: PillButtonStyle = .outline, centerAligned: Bool = false, disabledItems: Bool = false, useCustomPillsBackground: Bool = false) -> UIView {
        let bar = PillButtonBar(pillButtonStyle: style, pillButtonBackgroundColor: useCustomPillsBackground ? Colors.Palette.successShade20.color : nil)
        bar.items = items
        _ = bar.selectItem(atIndex: 0)
        bar.barDelegate = self
        bar.centerAligned = centerAligned

        if disabledItems {
            items.forEach { bar.disableItem($0) }
        }

        let backgroundView = UIView()
        if style == .outline {
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

    @objc private func toggleFilledPills(switchView: UISwitch) {
        let pillBar = self.filledBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    @objc private func toggleCustomFilledPills(switchView: UISwitch) {
        let pillBar = self.customBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    @objc private func toggleOutlinedPills(switchView: UISwitch) {
        let pillBar = self.outlineBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    private var filledBar: UIView?

    private var customBar: UIView?

    private var outlineBar: UIView?
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
