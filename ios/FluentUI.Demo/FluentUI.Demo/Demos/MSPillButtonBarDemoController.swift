//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class MSPillButtonBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layoutMargins.right = 0
        container.layoutMargins.left = 0
        var items: [MSPillButtonBarItem] = [MSPillButtonBarItem(title: "All"),
                                            MSPillButtonBarItem(title: "Documents"),
                                            MSPillButtonBarItem(title: "People"),
                                            MSPillButtonBarItem(title: "Other"),
                                            MSPillButtonBarItem(title: "Templates"),
                                            MSPillButtonBarItem(title: "Actions"),
                                            MSPillButtonBarItem(title: "More")]

        container.addArrangedSubview(createLabelWithText("Filled"))
        container.addArrangedSubview(createBar(items: items, style: .filled))
        container.addArrangedSubview(UIView())

        container.addArrangedSubview(createLabelWithText("Outline"))
        container.addArrangedSubview(createBar(items: items))
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

    func createBar(items: [MSPillButtonBarItem], style: MSPillButtonStyle = .outline, centerAligned: Bool = false) -> UIView {
        let bar = MSPillButtonBar(pillButtonStyle: style)
        bar.items = items
        _ = bar.selectItem(_atIndex: 0)
        bar.barDelegate = self
        bar.centerAligned = centerAligned

        let backgroundViewColor = style == .outline ? MSColors.Navigation.System.background
                                                  : MSColors.Navigation.Primary.background

        let backgroundView = UIView()
        backgroundView.backgroundColor = backgroundViewColor
        backgroundView.addSubview(bar)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0.0)
        fitViewIntoSuperview(bar, margins: margins)
        return backgroundView
    }

    func createLabelWithText(_ text: String = "") -> MSLabel {
        let label = MSLabel(style: .subhead, colorStyle: .regular)
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
}

// MARK: - MSPillButtonBarDemoController: MSPillButtonBarDelegate

extension MSPillButtonBarDemoController: MSPillButtonBarDelegate {
    func pillBar(_ pillBar: MSPillButtonBar, didSelectItem item: MSPillButtonBarItem, atIndex index: Int) {
        let alert = UIAlertController(title: "Item \(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
