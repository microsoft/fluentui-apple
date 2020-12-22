//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

// MARK: DrawerContentController

class DrawerContentController: DemoController {

    public func actionViews() -> [UIView] {
        let spacer = UIView()
        spacer.backgroundColor = .orange
        spacer.layer.borderWidth = 1
        spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        var views = [UIView]()
        views.append(createButton(title: "Dismiss", action: #selector(dismissButtonTapped)))
        views.append(createButton(title: "Dismiss (no animation)", action: #selector(dismissNotAnimatedButtonTapped)))
        views.append(spacer)
        return views
    }

    public func containerForActionViews() -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews() {
            container.addArrangedSubview(view)
        }
        container.addBackground(color: Colors.surfacePrimary)
        return container
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func dismissNotAnimatedButtonTapped() {
        dismiss(animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = containerForActionViews()
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

class DrawerVnextDemoController: DemoController {

    private var drawerController: DrawerVnext?

    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Left/Right Drawer")
        addRow(
            items: [
                createButton(title: "Show from leading with clear background", action: #selector(showLeftDrawerClearBackgroundButtonTapped)),
                createButton(title: "Show from trailing with clear background", action: #selector(showRightDrawerClearBackgroundButtonTapped))
            ],
            itemSpacing: Constants.verticalSpacing,
            stretchItems: true
        )
        addRow(
            items: [
                createButton(title: "Show from leading with dimmed background", action: #selector(showLeftDrawerDimmedBackgroundButtonTapped)),
                createButton(title: "Show from trailing with dimmed background", action: #selector(showRightDrawerDimmedBackgroundButtonTapped))
            ],
            itemSpacing: Constants.verticalSpacing,
            stretchItems: true
        )
        addDescription(text: "Swipe from the left or right edge of the screen to reveal a drawer interactively")

        container.addArrangedSubview(UIView())

        // Screen edge gestures to interactively present side drawers

        let leadingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        leadingEdgeGesture.edges = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? .left : .right
        view.addGestureRecognizer(leadingEdgeGesture)
        navigationController?.navigationController?.interactivePopGestureRecognizer?.require(toFail: leadingEdgeGesture)

        let trailingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        trailingEdgeGesture.edges = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? .right : .left
        view.addGestureRecognizer(trailingEdgeGesture)

        drawerController = DrawerVnext(contentViewController: DrawerContentController())
    }

    @objc private func showLeftDrawerClearBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.drawerState.backgroundDimmed = false
            drawerController.drawerState.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showLeftDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.drawerState.backgroundDimmed = true
            drawerController.drawerState.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showRightDrawerClearBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.drawerState.backgroundDimmed = false
            drawerController.drawerState.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showRightDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.drawerState.backgroundDimmed = true
            drawerController.drawerState.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        let leadingEdge: UIRectEdge = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? .left : .right
        if leadingEdge == .left {
            self.showLeftDrawerDimmedBackgroundButtonTapped()
        } else {
            self.showRightDrawerDimmedBackgroundButtonTapped()
        }
    }
}
