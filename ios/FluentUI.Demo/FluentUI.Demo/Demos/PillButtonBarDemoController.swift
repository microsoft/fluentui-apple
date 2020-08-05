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
        addRow(items: [createLabelWithText("Enable/Disable pills in Filled Pill Bar below"), disableFilledSwitchView], itemSpacing: 20, centerItems: true)
        let filledBar = createBar(items: items, style: .filled)
        container.addArrangedSubview(filledBar)
        self.filledBar = filledBar
        container.addArrangedSubview(UIView())

        let disableGradientSwitchView = UISwitch()
        disableGradientSwitchView.isOn = true
        disableGradientSwitchView.addTarget(self, action: #selector(toggleGradientPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Gradient"))
        addRow(items: [createLabelWithText("Enable/Disable pills in Gradient Pill Bar below"), disableGradientSwitchView], itemSpacing: 20, centerItems: true)
        let gradientBar = createBar(items: items, style: .gradient)
        container.addArrangedSubview(gradientBar)
        self.gradientBar = gradientBar
        container.addArrangedSubview(UIView())

        let disableOutlinedSwitchView = UISwitch()
        disableOutlinedSwitchView.isOn = true
        disableOutlinedSwitchView.addTarget(self, action: #selector(toggleOutlinedPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Outline"))
        addRow(items: [createLabelWithText("Enable/Disable pills in Outline Pill bar below"), disableOutlinedSwitchView], itemSpacing: 20, centerItems: true)
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
        }
    }

    func createBar(items: [PillButtonBarItem], style: PillButtonStyle = .outline, centerAligned: Bool = false, disabledItems: Bool = false) -> UIView {
        let bar = PillButtonBar(pillButtonStyle: style)
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
        } else if style == .gradient {
            backgroundView.backgroundColor = getCustomBackgroundColor(width: view.frame.width)
        }

        backgroundView.addSubview(bar)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0.0)
        fitViewIntoSuperview(bar, margins: margins)
        return backgroundView
    }

    func getCustomBackgroundColor(width: CGFloat) -> UIColor {
        let startColor: UIColor = #colorLiteral(red: 0.01404584414, green: 0.4073548353, blue: 0.8523316062, alpha: 1)
        let midColor: UIColor = #colorLiteral(red: 0.2156807228, green: 0.6311728202, blue: 0.9168139814, alpha: 1)
        let endColor: UIColor = #colorLiteral(red: 0.3765182292, green: 0.7099975095, blue: 0.9298384652, alpha: 1)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 1.0)
        gradientLayer.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(light: image != nil ? UIColor(patternImage: image!) : endColor, dark: Colors.Navigation.System.background)
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

    @objc private func toggleGradientPills(switchView: UISwitch) {
        let pillBar = self.gradientBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    @objc private func toggleOutlinedPills(switchView: UISwitch) {
        let pillBar = self.outlineBar?.subviews[0] as! PillButtonBar
        togglePills(pillBar: pillBar, enable: switchView.isOn)
    }

    private var filledBar: UIView?

    private var gradientBar: UIView?

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
