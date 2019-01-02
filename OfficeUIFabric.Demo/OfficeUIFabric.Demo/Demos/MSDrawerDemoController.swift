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

        container.addArrangedSubview(createButton(title: "Show resizable drawer (custom content)", action: #selector(showBottomDrawerCustomContentControllerButtonTapped)))

        container.addArrangedSubview(UIView())
    }

    private func presentDrawer(sourceView: UIView? = nil, barButtonItem: UIBarButtonItem? = nil, presentationOrigin: CGFloat = -1, presentationDirection: MSDrawerPresentationDirection, contentController: UIViewController? = nil, contentView: UIView? = nil, resizable: Bool = false, animated: Bool = true) {
        let controller: MSDrawerController
        if let sourceView = sourceView {
            controller = MSDrawerController(sourceView: sourceView, sourceRect: sourceView.bounds, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        } else if let barButtonItem = barButtonItem {
            controller = MSDrawerController(barButtonItem: barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        } else {
            fatalError("Presenting a drawer requires either a sourceView or a barButtonItem")
        }

        controller.allowsResizing = resizable

        if let contentView = contentView {
            controller.preferredContentSize.height = 200
            controller.contentView = contentView
        } else {
            controller.contentController = contentController
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

    private func containerForActionViews() -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews() {
            container.addArrangedSubview(view)
        }
        return container
    }

    @objc private func barButtonTapped(sender: UIBarButtonItem) {
        presentDrawer(barButtonItem: sender, presentationDirection: .down, contentView: containerForActionViews())
    }

    @objc private func showTopDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews())
    }

    @objc private func showTopDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(), animated: false)
    }

    @objc private func showTopDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.maxY, presentationDirection: .down, contentView: containerForActionViews())
    }

    @objc private func showBottomDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews())
    }

    @objc private func showBottomDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(), animated: false)
    }

    @objc private func showBottomDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.minY, presentationDirection: .up, contentView: containerForActionViews())
    }

    @objc private func showBottomDrawerCustomContentControllerButtonTapped(sender: UIButton) {
        let controller = UIViewController()
        controller.title = "Resizable drawer"
        controller.preferredContentSize = CGSize(width: 400, height: 400)

        let personaListView = MSPersonaListView()
        personaListView.personaList = samplePersonas
        controller.view.addSubview(personaListView)
        personaListView.fitIntoSuperview()

        let contentController = UINavigationController(rootViewController: controller)

        presentDrawer(sourceView: sender, presentationDirection: .up, contentController: contentController, resizable: true)
    }

    @objc private func expandButtonTapped(sender: UIButton) {
        guard let drawer = presentedViewController as? MSDrawerController else {
            return
        }
        drawer.isExpanded = !drawer.isExpanded
        sender.setTitle(drawer.isExpanded ? "Return to normal" : "Expand", for: .normal)
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func dismissNotAnimatedButtonTapped() {
        dismiss(animated: false)
    }
}
