//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

// MARK: MSTooltipDemoController

class MSTooltipDemoController: DemoController {
    let titleView = MSTwoLinesTitleView(style: .dark)
    var edgeCaseStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.setup(title: title ?? "")
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show on title", style: .plain, target: self, action: #selector(showTitleTooltip))

        container.addArrangedSubview(createButton(title: "Show single-line tooltip below", action: #selector(showSingleTooltipBelow)))
        container.addArrangedSubview(createButton(title: "Show single-line tooltip above", action: #selector(showSingleTooltipAbove)))
        container.addArrangedSubview(createButton(title: "Show double-line tooltip below", action: #selector(showDoubleTooltipBelow)))
        container.addArrangedSubview(createButton(title: "Show double-line tooltip above", action: #selector(showDoubleTooltipAbove)))
        container.addArrangedSubview(createButton(title: "Show with tap on tooltip dismiss mode", action: #selector(showTapOnToDismissTooltip)))
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

        let leftButton = createButton(title: "Show tooltip\n(with arrow left)", action: #selector(showTooltipLeftArrow))
        leftButton.titleLabel?.textAlignment = .center
        leftButton.titleLabel?.lineBreakMode = .byWordWrapping

        let rightButton = createButton(title: "Show tooltip\n(with arrow right)", action: #selector(showTooltipRightArrow))
        rightButton.titleLabel?.textAlignment = .center
        rightButton.titleLabel?.lineBreakMode = .byWordWrapping

        container.addArrangedSubview(leftButton)
        container.addArrangedSubview(rightButton)
        return container
    }

    func createEdgeCaseButtons() -> UIStackView {
        let container = UIStackView()
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.alignment = .fill

        let topleftButton = createButton(title: "", action: #selector(showTopLeftOffsetTooltip))
        let topRightButton = createButton(title: "", action: #selector(showTopRightOffsetTooltip))
        let bottomLeftButton = createButton(title: "", action: #selector(showBottomLeftOffsetTooltip))
        let bottomRightButton = createButton(title: "", action: #selector(showBottomRightOffsetTooltip))

        for button in [topleftButton, topRightButton, bottomLeftButton, bottomRightButton] {
            button.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        }

        let topContainer = UIStackView()
        topContainer.axis = .horizontal
        topContainer.distribution = .equalSpacing
        topContainer.addArrangedSubview(topleftButton)
        topContainer.addArrangedSubview(topRightButton)

        let middleLabel = MSLabel(style: .headline, colorStyle: .regular)
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
        MSTooltip.shared.show(with: "This is a title-based tooltip.", for: titleView, preferredArrowDirection: .up)
    }

    @objc func showSingleTooltipBelow(sender: MSButton) {
        MSTooltip.shared.show(with: "This is pointing up.", for: sender, preferredArrowDirection: .up)
    }

    @objc func showSingleTooltipAbove(sender: MSButton) {
        MSTooltip.shared.show(with: "This is pointing down.", for: sender)
    }

    @objc func showDoubleTooltipBelow(sender: MSButton) {
        MSTooltip.shared.show(with: "This is a very long message, and this is also pointing up.", for: sender, preferredArrowDirection: .up)
    }

    @objc func showDoubleTooltipAbove(sender: MSButton) {
        MSTooltip.shared.show(with: "This is a very long message, and this is also pointing down.", for: sender)
    }

    @objc func showTapOnToDismissTooltip(sender: MSButton) {
        MSTooltip.shared.show(with: "Tap on this tooltip to dismiss.", for: sender, preferredArrowDirection: .up, dismissOn: .tapOnTooltip)
    }

    @objc func showTooltipLeftArrow(sender: MSButton) {
        MSTooltip.shared.show(with: "This is pointing left.", for: sender, preferredArrowDirection: .left)
    }

    @objc func showTooltipRightArrow(sender: MSButton) {
        MSTooltip.shared.show(with: "This is pointing right.", for: sender, preferredArrowDirection: .right)
    }

    @objc func showTopLeftOffsetTooltip(sender: MSButton) {
        MSTooltip.shared.show(with: "This is an offset tooltip.", for: sender, preferredArrowDirection: .up)
    }

    @objc func showTopRightOffsetTooltip(sender: MSButton) {
        guard let window = view.window else {
            return
        }
        var margins = MSTooltip.defaultScreenMargins
        margins.top = edgeCaseStackView.convert(edgeCaseStackView.bounds, to: window).minY - window.safeAreaInsets.top
        margins.left = window.frame.inset(by: window.safeAreaInsets).midX
        MSTooltip.shared.show(with: "This is a very long, offset message.", for: sender, preferredArrowDirection: .right, screenMargins: margins)
    }

    @objc func showBottomLeftOffsetTooltip(sender: MSButton) {
        guard let window = view.window else {
            return
        }
        var margins = MSTooltip.defaultScreenMargins
        margins.right = window.frame.inset(by: window.safeAreaInsets).midX
        MSTooltip.shared.show(with: "This is a very long, offset message.", for: sender, preferredArrowDirection: .left, screenMargins: margins)
    }

    @objc func showBottomRightOffsetTooltip(sender: MSButton) {
        MSTooltip.shared.show(with: "This is an offset tooltip.", for: sender)
    }
}
