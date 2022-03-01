//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DemoController: UIViewController {
    struct Constants {
        static let margin: CGFloat = 16
        static let horizontalSpacing: CGFloat = 40
        static let horizontalContainerItemSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 16
        static let rowTextWidth: CGFloat = 75
        static let stackViewSpacing: CGFloat = 10
    }

    class func createVerticalContainer() -> UIStackView {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.layoutMargins = UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: Constants.margin, right: Constants.margin)
        container.isLayoutMarginsRelativeArrangement = true
        container.spacing = Constants.verticalSpacing
        return container
    }

    class func createHorizontalContainer() -> UIStackView {
        let container = UIStackView(frame: .zero)
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.spacing = Constants.horizontalContainerItemSpacing
        return container
    }

    let container: UIStackView = createVerticalContainer()
    let scrollingContainer = DemoControllerScrollView(frame: .zero)

    var allowsContentToScroll: Bool { return true }

    func createButton(title: String, action: (( MSFButton) -> Void)?) -> MSFButton {
        let button = MSFButton(style: .secondary, size: .small, action: action)
        button.state.text = title
        return button
    }

    @discardableResult
    func addDescription(text: String, textAlignment: NSTextAlignment = .natural) -> Label {
        let description = Label(style: .subhead, colorStyle: .regular)
        description.numberOfLines = 0
        description.text = text
        description.textAlignment = textAlignment
        description.numberOfLines = 0
        container.addArrangedSubview(description)
        return description
    }

    func addTitle(text: String) {
        let titleLabel = Label(style: .headline)
        titleLabel.text = text
        titleLabel.textAlignment = .center
        titleLabel.accessibilityTraits.insert(.header)
        titleLabel.numberOfLines = 0
        container.addArrangedSubview(titleLabel)
    }

    func addRow(text: String = "", items: [UIView], textStyle: TextStyle = .subhead, textWidth: CGFloat = Constants.rowTextWidth, itemSpacing: CGFloat = Constants.horizontalSpacing, stretchItems: Bool = false, centerItems: Bool = false) {
        let itemsContainer = UIStackView()
        itemsContainer.axis = .vertical
        itemsContainer.alignment = stretchItems ? .fill : (centerItems ? .center : .leading)

        let itemRow = UIStackView()
        itemRow.axis = .horizontal
        itemRow.distribution = stretchItems ? .fillEqually : .fill
        itemRow.alignment = .center
        itemRow.spacing = itemSpacing

        if !text.isEmpty {
            let label = Label(style: textStyle, colorStyle: .regular)
            label.text = text
            label.widthAnchor.constraint(equalToConstant: textWidth).isActive = true
            itemRow.addArrangedSubview(label)
        }

        items.forEach { itemRow.addArrangedSubview($0) }
        itemsContainer.addArrangedSubview(itemRow)
        itemRow.accessibilityElements = itemRow.arrangedSubviews
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

    func createLabelAndSwitchRow(labelText: String, switchAction: Selector, isOn: Bool = false) -> UIView {
        let switchView = UISwitch()
        switchView.isOn = isOn
        switchView.addTarget(self, action: switchAction, for: .valueChanged)

        return createLabelAndViewsRow(labelText: labelText, views: [switchView])
    }

    func createLabelAndViewsRow(labelText: String, views: [UIView]) -> UIView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.stackViewSpacing

        let label = Label(style: .subhead, colorStyle: .regular)
        label.text = labelText
        stackView.addArrangedSubview(label)

        for view in views {
            stackView.addArrangedSubview(view)
        }

        return stackView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfacePrimary

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

        // Child scroll views interfere with largeTitleDisplayMode, so let's
        // disable it for all DemoController subclasses.
        self.navigationItem.largeTitleDisplayMode = .never

        configureAppearancePopover()
    }

    // MARK: - Demo Appearance Popover

    func configureAppearancePopover() {
        // If a subclass implements `DemoAppearanceDelegate`, becocontrolTokensHashme the delegate.
        appearanceController.delegate = self as? DemoAppearanceDelegate

        // Display the DemoAppearancePopover button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_fluent_settings_24_regular"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showAppearancePopover))
    }

    @objc func showAppearancePopover(_ sender: UIBarButtonItem) {
        appearanceController.popoverPresentationController?.barButtonItem = sender
        appearanceController.popoverPresentationController?.delegate = self
        self.present(appearanceController, animated: true, completion: nil)
    }

    private lazy var appearanceController: DemoAppearanceController = DemoAppearanceController()
}

extension DemoController: UIPopoverPresentationControllerDelegate {
    /// Overridden to allow for popover-style modal presentation on compact (e.g. iPhone) devices.
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
