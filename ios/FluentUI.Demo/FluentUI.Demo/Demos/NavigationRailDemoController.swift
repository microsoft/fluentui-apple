//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class NavigationRailDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.addArrangedSubview(createButton(title: "Show leading rail", action: #selector(presentControllerWithLeadingRail)))
		container.addArrangedSubview(createButton(title: "Show trailing rail", action: #selector(presentControllerWithTrailingRail)))
    }

	private func presentController(horizontalPosition: NavigationRail.HorizontalPosition) {
        let controller = UIViewController(nibName: nil, bundle: nil)
		controller.modalPresentationStyle = .fullScreen
		controller.view.backgroundColor = Colors.background1

		let rail = NavigationRail(with: horizontalPosition)
		rail.insert(in: controller.view)

		let button = Button()
		button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissControllerWithRail), for: .touchUpInside)
		controller.view.addSubview(button)

		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
			button.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor)
		])

        present(controller, animated: false)
	}

	@objc private func presentControllerWithLeadingRail() {
		presentController(horizontalPosition: .leading)
	}

	@objc private func presentControllerWithTrailingRail() {
		presentController(horizontalPosition: .trailing)
	}

	@objc private func dismissControllerWithRail() {
		dismiss(animated: false, completion: nil)
	}
}
