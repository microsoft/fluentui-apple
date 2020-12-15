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
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

class DrawerPresentingController: DemoController {

    public weak var delegate: DrawerPresentationDelegate?

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
    }

    @objc private func showLeftDrawerClearBackgroundButtonTapped(sender: UIButton) {
        delegate?.showLeftDrawerClearBackgroundSelected()
    }

    @objc private func showLeftDrawerDimmedBackgroundButtonTapped(sender: UIButton) {
        delegate?.showLeftDrawerDimmedBackgroundSelected()
    }

    @objc private func showRightDrawerClearBackgroundButtonTapped(sender: UIButton) {
        delegate?.showRightDrawerClearBackgroundSelected()
    }

    @objc private func showRightDrawerDimmedBackgroundButtonTapped(sender: UIButton) {
        delegate?.showRightDrawerDimmedBackgroundSelected()
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        let leadingEdge: UIRectEdge = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? .left : .right
        if leadingEdge == .left {
            delegate?.showLeftDrawerDimmedBackgroundSelected()
        } else {
            delegate?.showRightDrawerDimmedBackgroundSelected()
        }
    }
}

public protocol DrawerPresentationDelegate: AnyObject {
    func showLeftDrawerClearBackgroundSelected()
    func showLeftDrawerDimmedBackgroundSelected()
    func showRightDrawerClearBackgroundSelected()
    func showRightDrawerDimmedBackgroundSelected()
}

// MARK: VNTDrawerDemoController

class DrawerVnextDemoController: DemoController, DrawerPresentationDelegate {

    private var drawerController: VXTDrawerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let presentationController = DrawerPresentingController()
        presentationController.delegate = self

        let controller = VXTDrawerController(contentView: DrawerContentController().containerForActionViews(),
                                             presentationController: presentationController)
        container.addArrangedSubview(controller.view)
        self.drawerController = controller

        controller.view.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func showLeftDrawerClearBackgroundSelected() {
        drawerController?.drawerState.backgroundDimmed = false
        drawerController?.drawerState.presentationDirection = .left
        drawerController?.drawerState.isExpanded.toggle()
    }

    func showLeftDrawerDimmedBackgroundSelected() {
        drawerController?.drawerState.backgroundDimmed = true
        drawerController?.drawerState.presentationDirection = .left
        drawerController?.drawerState.isExpanded.toggle()
    }

    func showRightDrawerClearBackgroundSelected() {
        drawerController?.drawerState.backgroundDimmed = false
        drawerController?.drawerState.presentationDirection = .right
        drawerController?.drawerState.isExpanded.toggle()
    }

    func showRightDrawerDimmedBackgroundSelected() {
        drawerController?.drawerState.backgroundDimmed = true
        drawerController?.drawerState.presentationDirection = .right
        drawerController?.drawerState.isExpanded.toggle()
    }
}
