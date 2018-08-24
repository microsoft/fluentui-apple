//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSDrawerDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(barButtonTapped))

        container.addArrangedSubview(createButton(title: "Show top drawer", action: #selector(showTopDrawerButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show top drawer (no animation)", action: #selector(showTopDrawerNotAnimatedButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show top drawer (custom base)", action: #selector(showTopDrawerCustomOffsetButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show bottom drawer", action: #selector(showBottomDrawerButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show bottom drawer (no animation)", action: #selector(showBottomDrawerNotAnimatedButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show bottom drawer (custom base)", action: #selector(showBottomDrawerCustomOffsetButtonTapped)))
        container.addArrangedSubview(UIView())
    }

    private func presentDrawer(sourceView: UIView? = nil, barButtonItem: UIBarButtonItem? = nil, presentationOrigin: CGFloat = -1, presentationDirection: MSDrawerPresentationDirection, views: [UIView], animated: Bool = true) {
        let controller: MSDrawerController
        if let sourceView = sourceView {
            controller = MSDrawerController(sourceView: sourceView, sourceRect: sourceView.bounds, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        } else if let barButtonItem = barButtonItem {
            controller = MSDrawerController(barButtonItem: barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        } else {
            fatalError()
        }
        controller.preferredContentSize = CGSize(width: controller.preferredWidth, height: 200)

        // View container
        let viewContainer = DemoController.createVerticalContainer()
        viewContainer.frame = controller.view.bounds
        viewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.addSubview(viewContainer)

        // Views
        for view in views {
            viewContainer.addArrangedSubview(view)
        }

        present(controller, animated: animated)
    }

    private func actionViews() -> [UIView] {
        return [
            createButton(title: "Expand", action: #selector(expandButtonTapped)),
            createButton(title: "Dismiss", action: #selector(dismissButtonTapped)),
            createButton(title: "Dismiss (no animation)", action: #selector(dismissNotAnimatedButtonTapped)),
            UIView()    // spacer
        ]
    }

    @objc private func barButtonTapped(sender: UIBarButtonItem) {
        presentDrawer(barButtonItem: sender, presentationDirection: .down, views: actionViews())
    }

    @objc private func showTopDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, views: actionViews())
    }

    @objc private func showTopDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, views: actionViews(), animated: false)
    }

    @objc private func showTopDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.maxY, presentationDirection: .down, views: actionViews())
    }

    @objc private func showBottomDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, views: actionViews())
    }

    @objc private func showBottomDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, views: actionViews(), animated: false)
    }

    @objc private func showBottomDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.minY, presentationDirection: .up, views: actionViews())
    }

    @objc private func expandButtonTapped() {
        // TODO
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func dismissNotAnimatedButtonTapped() {
        dismiss(animated: false)
    }
}
