//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: MSDrawerDemoController

class DrawerDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(barButtonTapped))

        addTitle(text: "Top Drawer")
        container.addArrangedSubview(createButton(title: "Show resizable", action: #selector(showTopDrawerButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show with no animation", action: #selector(showTopDrawerNotAnimatedButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show from custom base", action: #selector(showTopDrawerCustomOffsetButtonTapped)))

        addTitle(text: "Left/Right Drawer")
        addRow(
            items: [
                createButton(title: "Show from leading", action: #selector(showLeftDrawerButtonTapped)),
                createButton(title: "Show from trailing", action: #selector(showRightDrawerButtonTapped))
            ],
            itemSpacing: DemoController.verticalSpacing,
            stretchItems: true
        )
        addDescription(text: "Swipe from the left or right edge of the screen to reveal a drawer interactively")

        addTitle(text: "Bottom Drawer")
        container.addArrangedSubview(createButton(title: "Show resizable", action: #selector(showBottomDrawerButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show with no animation", action: #selector(showBottomDrawerNotAnimatedButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show from custom base", action: #selector(showBottomDrawerCustomOffsetButtonTapped)))

        container.addArrangedSubview(createButton(title: "Show always as slideover, resizable", action: #selector(showBottomDrawerCustomContentControllerButtonTapped)))

        container.addArrangedSubview(createButton(title: "Show with focusable content", action: #selector(showBottomDrawerFocusableContentButtonTapped)))

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

    @discardableResult
    private func presentDrawer(sourceView: UIView? = nil, barButtonItem: UIBarButtonItem? = nil, presentationOrigin: CGFloat = -1, presentationDirection: DrawerPresentationDirection, presentationStyle: DrawerPresentationStyle = .automatic, presentationOffset: CGFloat = 0, presentationBackground: DrawerPresentationBackground = .black, presentingGesture: UIPanGestureRecognizer? = nil, permittedArrowDirections: UIPopoverArrowDirection = [.left, .right], contentController: UIViewController? = nil, contentView: UIView? = nil, resizingBehavior: DrawerResizingBehavior = .none, adjustHeightForKeyboard: Bool = false, animated: Bool = true) -> DrawerController {
        let controller: DrawerController
        if let sourceView = sourceView {
            controller = DrawerController(sourceView: sourceView, sourceRect: sourceView.bounds.insetBy(dx: sourceView.bounds.width / 2, dy: 0), presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        } else if let barButtonItem = barButtonItem {
            controller = DrawerController(barButtonItem: barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        } else {
            preconditionFailure("Presenting a drawer requires either a sourceView or a barButtonItem")
        }

        controller.presentationStyle = presentationStyle
        controller.presentationOffset = presentationOffset
        controller.presentationBackground = presentationBackground
        controller.presentingGesture = presentingGesture
        controller.permittedArrowDirections = permittedArrowDirections
        controller.resizingBehavior = resizingBehavior
        controller.adjustsHeightForKeyboard = adjustHeightForKeyboard

        if let contentView = contentView {
            // `preferredContentSize` can be used to specify the preferred size of a drawer,
            // but here we just define the width and allow it to calculate height automatically
            controller.preferredContentSize.width = 360
            //controller.preferredContentSize.height = 230
            controller.contentView = contentView
        } else {
            controller.contentController = contentController
        }

        present(controller, animated: animated)

        return controller
    }

    private func actionViews(drawerHasFlexibleHeight: Bool) -> [UIView] {
        let spacer = UIView()
        spacer.backgroundColor = .orange
        spacer.layer.borderWidth = 1
        spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        var views = [UIView]()
        if drawerHasFlexibleHeight {
            views.append(createButton(title: "Change content height", action: #selector(changeContentHeightButtonTapped)))
            views.append(createButton(title: "Expand", action: #selector(expandButtonTapped)))
        }
        views.append(createButton(title: "Dismiss", action: #selector(dismissButtonTapped)))
        views.append(createButton(title: "Dismiss (no animation)", action: #selector(dismissNotAnimatedButtonTapped)))
        views.append(spacer)
        return views
    }

    private func containerForActionViews(drawerHasFlexibleHeight: Bool = true) -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews(drawerHasFlexibleHeight: drawerHasFlexibleHeight) {
            container.addArrangedSubview(view)
        }
        return container
    }

    @objc private func barButtonTapped(sender: UIBarButtonItem) {
        presentDrawer(barButtonItem: sender, presentationDirection: .down, permittedArrowDirections: .any, contentView: containerForActionViews())
    }

    @objc private func showTopDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }

    @objc private func showTopDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(), animated: false)
    }

    @objc private func showTopDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.maxY, presentationDirection: .down, contentView: containerForActionViews())
    }

    @objc private func showLeftDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .fromLeading, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func showRightDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .fromTrailing, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func showBottomDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }

    @objc private func showBottomDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(), animated: false)
    }

    @objc private func showBottomDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.minY, presentationDirection: .up, contentView: containerForActionViews())
    }

    private var contentControllerOriginalPreferredContentHeight: CGFloat = 0

    @objc private func showBottomDrawerCustomContentControllerButtonTapped(sender: UIButton) {
        let controller = UIViewController()
        controller.title = "Resizable slideover drawer"
        controller.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Change preferredContentSize", style: .plain, target: self, action: #selector(changePreferredContentSizeButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        controller.view.addSubview(personaListView)
        personaListView.frame = controller.view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let contentController = UINavigationController(rootViewController: controller)
        contentController.navigationBar.barTintColor = Colors.background1
        contentController.isToolbarHidden = false
        contentController.preferredContentSize = CGSize(width: 400, height: 400)
        contentControllerOriginalPreferredContentHeight = contentController.preferredContentSize.height

        let drawer = presentDrawer(sourceView: sender, presentationDirection: .up, presentationStyle: .slideover, presentationOffset: 20, presentationBackground: traitCollection.horizontalSizeClass == .regular ? .none : .black, contentController: contentController, resizingBehavior: .dismissOrExpand)

        drawer.contentScrollView = personaListView
    }

    @objc private func showBottomDrawerFocusableContentButtonTapped(sender: UIButton) {
        let contentController = UIViewController()

        let container = UIStackView()
        container.axis = .vertical
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        container.spacing = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        contentController.view.addSubview(container)
        NSLayoutConstraint.activate([container.topAnchor.constraint(equalTo: contentController.view.topAnchor),
                                     container.heightAnchor.constraint(equalTo: contentController.view.heightAnchor),
                                     container.leadingAnchor.constraint(equalTo: contentController.view.leadingAnchor),
                                     container.widthAnchor.constraint(equalTo: contentController.view.widthAnchor)])

        let textField = UITextField()
        textField.text = "Some focusable content"
        textField.delegate = self
        container.addArrangedSubview(textField)

        let button = Button(style: .primaryFilled)
        button.setTitle("Hide keyboard", for: .normal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(hideKeyboardButtonTapped), for: .touchUpInside)
        container.addArrangedSubview(button)

        presentDrawer(sourceView: sender, presentationDirection: .up, permittedArrowDirections: .any, contentController: contentController, resizingBehavior: .dismissOrExpand, adjustHeightForKeyboard: true)

        textField.becomeFirstResponder()
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        let leadingEdge: UIRectEdge = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? .left : .right

        presentDrawer(sourceView: view, presentationDirection: gesture.edges == leadingEdge ? .fromLeading : .fromTrailing, presentingGesture: gesture, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func changeContentHeightButtonTapped(sender: UIButton) {
        if let spacer = (sender.superview as? UIStackView)?.arrangedSubviews.last,
            let heightConstraint = spacer.constraints.first {
            heightConstraint.constant = heightConstraint.constant == 20 ? 100 : 20
        }
    }

    @objc private func expandButtonTapped(sender: UIButton) {
        guard let drawer = presentedViewController as? DrawerController else {
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

    @objc private func changePreferredContentSizeButtonTapped() {
        if let contentController = (presentedViewController as? DrawerController)?.contentController {
            var size = contentController.preferredContentSize
            size.height = size.height == contentControllerOriginalPreferredContentHeight ? 500 : 400
            contentController.preferredContentSize = size
        }
    }

    @objc private func hideKeyboardButtonTapped(sender: UIButton) {
        if let stackView = sender.superview as? UIStackView {
            let textField = stackView.arrangedSubviews.first(where: { $0 is UITextField })
            textField?.resignFirstResponder()
        }
    }
}

// MARK: - DrawerDemoController: UITextFieldDelegate

extension DrawerDemoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
