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
        views.append(createButton(title: "Dismiss", action: { [weak self ] _ in
            if let strongSelf = self {
                strongSelf.dismissButtonTapped()
            }
        }).view)
        views.append(createButton(title: "Dismiss (no animation)", action: { [weak self ] _ in
            if let strongSelf = self {
                strongSelf.dismissNotAnimatedButtonTapped()
            }
        }).view)
        views.append(spacer)
        return views
    }

    public func containerForActionViews() -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews() {
            container.addArrangedSubview(view)
        }
        addBackgroundColor(container, color: Colors.surfacePrimary)
        return container
    }

    private func addBackgroundColor(_ stackview: UIStackView, color: UIColor) {
        let subView = UIView(frame: stackview.bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackview.insertSubview(subView, at: 0)
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

class DrawerVnextDemoController: DemoController, MSFDrawerVnextControllerDelegate {

    private var drawerController: MSFDrawerVnext?

    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Left/Right Drawer")
        addRow(items: [
            createButton(title: "Show from leading with clear background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showLeftDrawerClearBackgroundButtonTapped()
                }
            }).view,
            createButton(title: "Show from trailing with clear background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showRightDrawerClearBackgroundButtonTapped()
                }
            }).view
        ],
        itemSpacing: Constants.verticalSpacing,
        stretchItems: true)
        addRow(items: [
            createButton(title: "Show from leading with dimmed background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showLeftDrawerDimmedBackgroundButtonTapped()
                }
            }).view,
            createButton(title: "Show from trailing with dimmed background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showRightDrawerDimmedBackgroundButtonTapped()
                }
            }).view
        ],
        itemSpacing: Constants.verticalSpacing,
        stretchItems: true)
        addDescription(text: "Swipe from the left or right edge of the screen to reveal a drawer interactively")

        container.addArrangedSubview(UIView())

        // Screen edge gestures to interactively present side drawers

        let isLeadingEdgeLeftToRight = view.effectiveUserInterfaceLayoutDirection == .leftToRight

        let leadingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        leadingEdgeGesture.edges = isLeadingEdgeLeftToRight ? .left : .right
        view.addGestureRecognizer(leadingEdgeGesture)
        navigationController?.navigationController?.interactivePopGestureRecognizer?.require(toFail: leadingEdgeGesture)

        let trailingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        trailingEdgeGesture.edges = isLeadingEdgeLeftToRight ? .right : .left
        view.addGestureRecognizer(trailingEdgeGesture)

        drawerController = MSFDrawerVnext(contentViewController: DrawerContentController())
        drawerController?.delegate = self
    }

    @objc private func showLeftDrawerClearBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showLeftDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showRightDrawerClearBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showRightDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = drawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        if view.effectiveUserInterfaceLayoutDirection == .leftToRight {
            self.showRightDrawerDimmedBackgroundButtonTapped()
        } else {
            self.showLeftDrawerClearBackgroundButtonTapped()
        }
    }
}
