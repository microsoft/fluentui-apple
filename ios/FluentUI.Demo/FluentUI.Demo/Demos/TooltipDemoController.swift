//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: TooltipDemoController

class TooltipDemoController: DemoController {
    let titleView = TwoLineTitleView(style: .system)
    var edgeCaseStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.setup(title: title ?? "", interactivePart: .title)
        titleView.delegate = self
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Show on title", style: .plain, target: self, action: #selector(showTitleTooltip)))

        container.addArrangedSubview(createButton(title: "Show single-line tooltip below", action: #selector(showSingleTooltipBelow)))
        container.addArrangedSubview(createButton(title: "Show double-line tooltip above", action: #selector(showDoubleTooltipAbove)))
        container.addArrangedSubview(createButton(title: "Show tooltip with title above", action: #selector(showTooltipWithTitle)))
        container.addArrangedSubview(createButton(title: "Show with tap on tooltip dismissal", action: #selector(showTooltipWithTapOnTooltipDismissal)))
        container.addArrangedSubview(createButton(title: "Show with tap on tooltip or anchor dismissal", action: #selector(showTooltipWithTapOnTooltipOrAnchorDismissal)))
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

        let middleLabel = Label(textStyle: .body1Strong, colorStyle: .regular)
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

    @objc func showSingleTooltipBelow(sender: Button) {
        Tooltip.shared.show(with: "This is pointing up.", for: sender, preferredArrowDirection: .up)
    }

    @objc func showDoubleTooltipAbove(sender: Button) {
        Tooltip.shared.show(with: "This is a very long message, and this is also pointing down.", for: sender)
    }

    @objc func showTooltipWithTitle(sender: Button) {
        Tooltip.shared.show(with: "This is the message of the tooltip.", title: "This is a tooltip title", for: sender)
    }

    @objc func showTooltipWithTapOnTooltipDismissal(sender: Button) {
        Tooltip.shared.show(with: "Tap on this tooltip to dismiss.", for: sender, preferredArrowDirection: .up, dismissOn: .tapOnTooltip)
    }

    @objc func showTooltipWithTapOnTooltipOrAnchorDismissal(sender: Button) {
        Tooltip.shared.show(with: "Tap on this tooltip or this title button to dismiss.", for: titleView, dismissOn: .tapOnTooltipOrAnchor)
    }

    @objc func showTooltipLeftArrow(sender: Button) {
        Tooltip.shared.show(with: "This is pointing left.", for: sender, preferredArrowDirection: .left)
    }

    @objc func showTooltipRightArrow(sender: Button) {
        Tooltip.shared.show(with: "This is pointing right.", for: sender, preferredArrowDirection: .right)
    }

    @objc func showTopLeftOffsetTooltip(sender: Button) {
        Tooltip.shared.show(with: "This is an offset tooltip.", for: sender, preferredArrowDirection: .up)
    }

    @objc func showTopRightOffsetTooltip(sender: Button) {
        Tooltip.shared.show(with: "This is a very long, offset message.", for: sender, preferredArrowDirection: .right)
    }

    @objc func showBottomLeftOffsetTooltip(sender: Button) {
        Tooltip.shared.show(with: "This is a very long, offset message.", for: sender, preferredArrowDirection: .left)
    }

    @objc func showBottomRightOffsetTooltip(sender: Button) {
        Tooltip.shared.show(with: "This is an offset tooltip.", for: sender)
    }
}

// MARK: - TooltipDemoController: TwoLineTitleViewDelegate

extension TooltipDemoController: TwoLineTitleViewDelegate {
    func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView) {
        let alert = UIAlertController(title: nil, message: "The two line title view was pressed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TooltipDemoController: DemoAppearanceDelegate

extension TooltipDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TooltipTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideTooltipTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        Tooltip.shared.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideTooltipTokens : nil)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TooltipTokenSet.self) != nil
    }

    // MARK: - Custom tokens
    private var themeWideOverrideTooltipTokens: [TooltipTokenSet.Tokens: ControlTokenValue] {
        return [
            .tooltipColor: .uiColor {
                // "Berry"
                return UIColor(light: GlobalTokens.sharedColor(.berry, .shade30),
                               dark: GlobalTokens.sharedColor(.berry, .tint20))
            }
        ]
    }

    private var perControlOverrideTooltipTokens: [TooltipTokenSet.Tokens: ControlTokenValue] {
        return [
            .tooltipColor: .uiColor {
                // "Brass"
                return UIColor(light: GlobalTokens.sharedColor(.brass, .tint40),
                               dark: GlobalTokens.sharedColor(.brass, .shade30))
            },
            .textColor: .uiColor {
                // "Forest"
                return UIColor(light: GlobalTokens.sharedColor(.forest, .shade30),
                               dark: GlobalTokens.sharedColor(.forest, .tint40))
            },
            .backgroundCornerRadius: .float {
                return 0
            }
        ]
    }
}
