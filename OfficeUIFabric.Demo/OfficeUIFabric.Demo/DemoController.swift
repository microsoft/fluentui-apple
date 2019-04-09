//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class DemoController: UIViewController {
    class func createVerticalContainer() -> UIStackView {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        container.isLayoutMarginsRelativeArrangement = true
        container.spacing = 16
        return container
    }

    let container: UIStackView = createVerticalContainer()
    let scrollingContainer = UIScrollView(frame: .zero)

    func createButton(title: String, action: Selector) -> MSButton {
        let button = MSButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    func addTitle(text: String) {
        let titleLabel = MSLabel(style: .headline)
        titleLabel.text = text
        titleLabel.textAlignment = .center
        container.addArrangedSubview(titleLabel)
    }

    func addRow(text: String, items: [UIView]) {
        let itemsContainer = UIStackView()
        itemsContainer.axis = .vertical
        itemsContainer.alignment = .leading

        let itemRow = UIStackView()
        itemRow.axis = .horizontal
        itemRow.alignment = .center
        itemRow.spacing = 40

        let label = MSLabel(style: .subhead, colorStyle: .regular)
        label.text = text
        label.widthAnchor.constraint(equalToConstant: 65).isActive = true

        itemRow.addArrangedSubview(label)
        items.forEach { itemRow.addArrangedSubview($0) }
        itemsContainer.addArrangedSubview(itemRow)
        container.addArrangedSubview(itemsContainer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background

        view.addSubview(scrollingContainer)
        scrollingContainer.fitIntoSuperview()
        scrollingContainer.addSubview(container)
        // UIScrollView in RTL mode still have leading on the left side, so we cannot rely on leading/trailing-based constraints
        container.fitIntoSuperview(usingConstraints: true, usingLeadingTrailing: false, autoHeight: true)
    }
}
