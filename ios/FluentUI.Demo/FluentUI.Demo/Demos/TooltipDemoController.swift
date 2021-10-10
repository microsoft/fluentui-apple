//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: TooltipDemoController

class TooltipDemoController: DemoController {
    let titleView = TwoLineTitleView(style: .dark)
    var edgeCaseStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.setup(title: title ?? "", interactivePart: .title)
        titleView.delegate = self
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show on title", style: .plain, target: self, action: #selector(showTitleTooltip))

        container.addArrangedSubview(createButton(title: "Show single-line tooltip below", action: { sender in
            Tooltip.shared.show(with: "This is pointing up.", for: sender.view, preferredArrowDirection: .up)
        }).view)
        container.addArrangedSubview(createButton(title: "Show double-line tooltip above", action: { sender in
            Tooltip.shared.show(with: "This is a very long message, and this is also pointing down.", for: sender.view)
        }).view)
        container.addArrangedSubview(createButton(title: "Show with tap on tooltip dismissal", action: { sender in
            Tooltip.shared.show(with: "Tap on this tooltip to dismiss.", for: sender.view, preferredArrowDirection: .up, dismissOn: .tapOnTooltip)
        }).view)
        container.addArrangedSubview(createButton(title: "Show with tap on tooltip or anchor dismissal", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            Tooltip.shared.show(with: "Tap on this tooltip or this title button to dismiss.", for: strongSelf.titleView, dismissOn: .tapOnTooltipOrAnchor)
        }).view)
        container.addArrangedSubview(createLeftRightButtons())

        edgeCaseStackView = createEdgeCaseButtons()
        container.addArrangedSubview(edgeCaseStackView)
        edgeCaseStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: container.layoutMargins.top).isActive = true
        let bottomConstraint = container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }

    func createLeftRightButtons() -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.spacing = 16.0

        let leftButton = createButton(title: "Show tooltip\n(with arrow left)", action: { sender in
            Tooltip.shared.show(with: "This is pointing left.", for: sender.view, preferredArrowDirection: .left)
        })

        let rightButton = createButton(title: "Show tooltip\n(with arrow right)", action: { sender in
            Tooltip.shared.show(with: "This is pointing right.", for: sender.view, preferredArrowDirection: .right)
        })

        container.addArrangedSubview(leftButton.view)
        container.addArrangedSubview(rightButton.view)
        return container
    }

    func createEdgeCaseButtons() -> UIStackView {
        let container = UIStackView()
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.alignment = .fill

        let topleftButton = createButton(title: " ", action: { sender in
            Tooltip.shared.show(with: "This is an offset tooltip.", for: sender.view, preferredArrowDirection: .up)
        }).view

        let topRightButton = createButton(title: "", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            guard let window = strongSelf.view.window else {
                return
            }

            let edgeCaseStackView = strongSelf.edgeCaseStackView!
            var margins = Tooltip.defaultScreenMargins
            margins.top = edgeCaseStackView.convert(edgeCaseStackView.bounds, to: window).minY - window.safeAreaInsets.top
            margins.left = window.frame.inset(by: window.safeAreaInsets).midX
            Tooltip.shared.show(with: "This is a very long, offset message.", for: sender.view, preferredArrowDirection: .right, screenMargins: margins)
        }).view

        let bottomLeftButton = createButton(title: "", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            guard let window = strongSelf.view.window else {
                return
            }
            var margins = Tooltip.defaultScreenMargins
            margins.right = window.frame.inset(by: window.safeAreaInsets).midX
            Tooltip.shared.show(with: "This is a very long, offset message.", for: sender.view, preferredArrowDirection: .left, screenMargins: margins)
        }).view

        let bottomRightButton = createButton(title: "", action: { sender in
            Tooltip.shared.show(with: "This is an offset tooltip.", for: sender.view)
        }).view

        for button in [topleftButton, topRightButton, bottomLeftButton, bottomRightButton] {
            button.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        }

        let topContainer = UIStackView()
        topContainer.axis = .horizontal
        topContainer.distribution = .equalSpacing
        topContainer.addArrangedSubview(topleftButton)
        topContainer.addArrangedSubview(topRightButton)

        let middleLabel = Label(style: .headline, colorStyle: .regular)
        middleLabel.text = "Press corner buttons to show offset tooltips"
        middleLabel.numberOfLines = 0
        middleLabel.textAlignment = .center

        let bottomContainer = UIStackView()
        bottomContainer.axis = .horizontal
        bottomContainer.distribution = .equalSpacing
        bottomContainer.addArrangedSubview(bottomLeftButton)
        bottomContainer.addArrangedSubview(bottomRightButton)

        container.addArrangedSubview(topContainer)
        container.addArrangedSubview(middleLabel)
        container.addArrangedSubview(bottomContainer)
        return container
    }

    @objc func showTitleTooltip(sender: UIBarButtonItem) {
        Tooltip.shared.show(with: "This is a title-based tooltip.", for: titleView, preferredArrowDirection: .up)
    }
}

// MARK: - TooltipDemoController: TwoLineTitleViewDelegate

extension TooltipDemoController: TwoLineTitleViewDelegate {
    func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView) {
        let alert = UIAlertController(title: nil, message: "The title button was pressed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
