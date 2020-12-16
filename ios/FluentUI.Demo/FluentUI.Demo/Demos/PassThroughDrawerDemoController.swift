//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

// MARK: PassThroughDrawerDemoController.swift

class PassThroughDrawerDemoController: DemoController {

// MARK: Private properties
	private let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private let spacer: UIView = {
        let spacer = UIView()
        spacer.backgroundColor = .orange
        spacer.layer.borderWidth = 1
        spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        return spacer
    }()

    private var contentControllerOriginalPreferredContentHeight: CGFloat = 0
    private var drawerController: DrawerController?

// MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPersonaListView()
        updateNavigationTitle()
        setupPassThroughDrawer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerController?.dismiss(animated: false, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let drawerController = self.drawerController {
            present(drawerController, animated: true, completion: nil)
        }
    }

// MARK: Setup Methods

    private func setupPersonaListView() {
        self.view.addSubview(personaListView)
        NSLayoutConstraint.activate([
            personaListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            personaListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            personaListView.topAnchor.constraint(equalTo: self.view.topAnchor),
            personaListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func setupPassThroughDrawer() {
        let controller = DrawerController(sourceView: self.view, sourceRect: self.view.bounds, presentationOrigin: -1, presentationDirection: .up)

        controller.presentationStyle = .slideover
        controller.presentationBackground = .none
        controller.resizingBehavior = .expand
        controller.passThroughView = self.navigationController?.view
        controller.preferredContentSize.width = 360
        controller.contentView = containerForActionViews()
        self.drawerController = controller
    }

    private func updateNavigationTitle() {
        navigationItem.title = "PassThroughDrawerDemoController"
    }

// MARK: Private Methods

    private func containerForActionViews(drawerHasFlexibleHeight: Bool = true) -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews(drawerHasFlexibleHeight: drawerHasFlexibleHeight) {
            container.addArrangedSubview(view)
        }
        return container
    }

    private func actionViews(drawerHasFlexibleHeight: Bool) -> [UIView] {
        var views = [UIView]()
        if drawerHasFlexibleHeight {
            let container = DemoController.createHorizontalContainer()
            container.addArrangedSubview(createButton(title: "Change content height", action: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }

                if let heightConstraint = strongSelf.spacer.constraints.first {
                    heightConstraint.constant = heightConstraint.constant == 20 ? 100 : 20
                }
            }).view)

            container.addArrangedSubview(createButton(title: "Expand", action: { [weak self] sender in
                guard let strongSelf = self else {
                    return
                }

                guard let drawer = strongSelf.presentedViewController as? DrawerController else {
                    return
                }
                drawer.isExpanded = !drawer.isExpanded
                sender.state.text = drawer.isExpanded ? "Return to normal" : "Expand"
            }).view)
            views.append(container)
        }

        let container = DemoController.createHorizontalContainer()
        container.addArrangedSubview(createButton(title: "Dismiss", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dismiss(animated: true)
        }).view)

        container.addArrangedSubview(createButton(title: "Dismiss (no animation)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dismiss(animated: false)
        }).view)

        views.append(container)
        views.append(spacer)
        return views
    }

    @objc private func changePreferredContentSizeButtonTapped() {
        if let contentController = (presentedViewController as? DrawerController)?.contentController {
            var size = contentController.preferredContentSize
            size.height = size.height == contentControllerOriginalPreferredContentHeight ? 500 : 400
            contentController.preferredContentSize = size
        }
    }

}
