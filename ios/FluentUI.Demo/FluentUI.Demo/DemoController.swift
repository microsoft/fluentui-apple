//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DemoController: UIViewController {
    static let margin: CGFloat = 16
    static let horizontalSpacing: CGFloat = 40
    static let verticalSpacing: CGFloat = 16
    static let rowTextWidth: CGFloat = 75

    class func createVerticalContainer() -> UIStackView {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        container.isLayoutMarginsRelativeArrangement = true
        container.spacing = verticalSpacing
        return container
    }

    let container: UIStackView = createVerticalContainer()
    let scrollingContainer = ScrollView(frame: .zero)

    var allowsContentToScroll: Bool { return true }

    func createButton(title: String, action: Selector) -> Button {
        let button = Button()
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @discardableResult
    func addDescription(text: String, textAlignment: NSTextAlignment = .natural) -> Label {
        let description = Label(style: .subhead, colorStyle: .regular)
        description.numberOfLines = 0
        description.text = text
        description.textAlignment = textAlignment
        container.addArrangedSubview(description)
        return description
    }

    func addTitle(text: String) {
        let titleLabel = Label(style: .headline)
        titleLabel.text = text
        titleLabel.textAlignment = .center
        container.addArrangedSubview(titleLabel)
    }

    func addRow(text: String = "", items: [UIView], textStyle: MSTextStyle = .subhead, textWidth: CGFloat = rowTextWidth, itemSpacing: CGFloat = horizontalSpacing, stretchItems: Bool = false, centerItems: Bool = false) {
        let itemsContainer = UIStackView()
        itemsContainer.axis = .vertical
        itemsContainer.alignment = stretchItems ? .fill : (centerItems ? .center : .leading)

        let itemRow = UIStackView()
        itemRow.axis = .horizontal
        itemRow.distribution = stretchItems ? .fillEqually : .fill
        itemRow.alignment = .center
        itemRow.spacing = itemSpacing

        if text != "" {
            let label = Label(style: textStyle, colorStyle: .regular)
            label.text = text
            label.widthAnchor.constraint(equalToConstant: textWidth).isActive = true
            itemRow.addArrangedSubview(label)
        }

        items.forEach { itemRow.addArrangedSubview($0) }
        itemsContainer.addArrangedSubview(itemRow)
        container.addArrangedSubview(itemsContainer)
    }

    func showMessage(_ message: String, autoDismiss: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        present(alert, animated: true)

        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: completion)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background1

        if allowsContentToScroll {
            view.addSubview(scrollingContainer)
            scrollingContainer.translatesAutoresizingMaskIntoConstraints = true
            scrollingContainer.frame = view.bounds
            scrollingContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.translatesAutoresizingMaskIntoConstraints = false
            scrollingContainer.addSubview(container)
            // UIScrollView in RTL mode still have leading on the left side, so we cannot rely on leading/trailing-based constraints
            NSLayoutConstraint.activate([container.topAnchor.constraint(equalTo: scrollingContainer.topAnchor),
                                         container.bottomAnchor.constraint(equalTo: scrollingContainer.bottomAnchor),
                                         container.leftAnchor.constraint(equalTo: scrollingContainer.leftAnchor),
                                         container.widthAnchor.constraint(equalTo: scrollingContainer.widthAnchor)])
        } else {
            view.addSubview(container)
            container.frame = view.bounds
            container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}
