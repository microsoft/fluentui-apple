//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

// MARK: - DrawerDemoController

class DrawerDemoController: DemoController {

    private var verticalDrawerController: MSFDrawer?
    private var horizontalDrawerController: MSFDrawer?
    var verticalContentController: DrawerVerticalContentController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(showTopDrawerButtonTapped))

        addTitle(text: "Top Drawer")

        container.addArrangedSubview(createButton(title: "Show with animation", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)
        container.addArrangedSubview(createButton(title: "Show from custom base with width on landscape", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            let rect = buttonView.superview!.convert(buttonView.frame, to: nil)
            strongSelf.showTopDrawerButtonTapped(presentationHeight: rect.maxY)
        }).view)

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

        addTitle(text: "Bottom Drawer")

        container.addArrangedSubview(createButton(title: "Show with animation", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

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

        horizontalDrawerController = MSFDrawer(contentViewController: DrawerHorizontalContentController())
        horizontalDrawerController?.delegate = self

        self.verticalContentController = DrawerVerticalContentController()
        if let containerController = self.verticalContentController {
            verticalDrawerController = MSFDrawer(contentViewController: containerController)
            verticalDrawerController?.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private func showLeftDrawerClearBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showLeftDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showRightDrawerClearBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showRightDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showTopDrawerButtonTapped(presentationHeight: CGFloat = -1) {
        if let drawerController = verticalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .top
            if presentationHeight != -1 {
                drawerController.state.presentationOrigin = CGPoint(x: .zero, y: presentationHeight)
            }
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showBottomDrawerButtonTapped() {
        if let drawerController = verticalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .bottom
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        var isleftPresentation = gesture.velocity(in: view).x > 0
        if view.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            isleftPresentation.toggle()
        }

        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentingGesture = gesture
            drawerController.state.presentationDirection = isleftPresentation ? .left : .right
            present(drawerController, animated: true, completion: nil)
        }
    }
}

extension DrawerDemoController: MSFDrawerControllerDelegate {
    @objc func drawerDidChangeState(state: MSFDrawerState, controller: UIViewController) {
    }
}

// MARK: DrawerContentController

class DrawerHorizontalContentController: DemoController {

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

class DrawerVerticalContentController: DemoController {

    private func actionViews() -> [UIView] {
        let spacer = UIView()
        spacer.backgroundColor = .orange
        spacer.layer.borderWidth = 1
        spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        var views = [UIView]()

        views.append(createButton(title: "Dismiss", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dismiss(animated: true)
        }).view)

        views.append(createButton(title: "Dismiss (no animation)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dismiss(animated: false)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view = containerForActionViews()
    }
}
