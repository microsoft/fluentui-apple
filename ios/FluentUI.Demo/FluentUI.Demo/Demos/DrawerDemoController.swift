//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: DrawerDemoController

class DrawerDemoController: DemoController {

    private var shouldConfirmDrawerDismissal: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(barButtonTapped))

        addTitle(text: "Top Drawer")
        container.addArrangedSubview(createButton(title: "Show resizable with clear background", action: #selector(showTopDrawerButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show resizable with max content height", action: #selector(showTopDrawerWithMaxContentHeightTapped)))
        container.addArrangedSubview(createButton(title: "Show non dismissable", action: #selector(showTopDrawerNotDismissableButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show changing resizing behaviour", action: #selector(showTopDrawerChangingResizingBehaviour)))
        container.addArrangedSubview(createButton(title: "Show with no animation", action: #selector(showTopDrawerNotAnimatedButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show from custom base with width on landscape", action: #selector(showTopDrawerCustomOffsetButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show respecting safe area width", action: #selector(showTopDrawerSafeAreaButtonTapped)))

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

        addTitle(text: "Bottom Drawer")
        container.addArrangedSubview(createButton(title: "Show resizable", action: #selector(showBottomDrawerButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show resizable with max content height", action: #selector(showBottomDrawerWithMaxContentHeightTapped)))
        container.addArrangedSubview(createButton(title: "Show with underlying interactable content view", action: #selector(showBottomDrawerWithUnderlyingInteractableViewButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show changing resizing behaviour", action: #selector(showBottomDrawerChangingResizingBehaviour)))
        container.addArrangedSubview(createButton(title: "Show with no animation", action: #selector(showBottomDrawerNotAnimatedButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show from custom base", action: #selector(showBottomDrawerCustomOffsetButtonTapped)))

        container.addArrangedSubview(createButton(title: "Show always as slideover, resizable with dimmed background", action: #selector(showBottomDrawerCustomContentControllerDimmedBackgroundButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show always as slideover, resizable with clear background", action: #selector(showBottomDrawerCustomContentControllerClearBackgroundButtonTapped)))

        container.addArrangedSubview(createButton(title: "Show with focusable content", action: #selector(showBottomDrawerFocusableContentButtonTapped)))

        container.addArrangedSubview(createButton(title: "Show dismiss blocking drawer", action: #selector(showBottomDrawerBlockingDismissButtonTapped)))

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
    private func presentDrawer(sourceView: UIView? = nil,
                               barButtonItem: UIBarButtonItem? = nil,
                               presentationOrigin: CGFloat = -1,
                               presentationDirection: DrawerPresentationDirection,
                               presentationStyle: DrawerPresentationStyle = .automatic,
                               presentationOffset: CGFloat = 0,
                               presentationBackground: DrawerPresentationBackground = .black,
                               presentingGesture: UIPanGestureRecognizer? = nil,
                               permittedArrowDirections: UIPopoverArrowDirection = [.left, .right],
                               contentController: UIViewController? = nil,
                               contentView: UIView? = nil,
                               resizingBehavior: DrawerResizingBehavior = .none,
                               adjustHeightForKeyboard: Bool = false,
                               animated: Bool = true,
                               customWidth: Bool = false,
                               respectSafeAreaWidth: Bool = false,
                               maxDrawerHeight: CGFloat = -1) -> DrawerController {
        let controller: DrawerController
        if let sourceView = sourceView {
            controller = DrawerController(sourceView: sourceView, sourceRect: sourceView.bounds.insetBy(dx: sourceView.bounds.width / 2, dy: 0), presentationOrigin: presentationOrigin, presentationDirection: presentationDirection, preferredMaximumHeight: maxDrawerHeight)
            controller.delegate = self
        } else if let barButtonItem = barButtonItem {
            controller = DrawerController(barButtonItem: barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection, preferredMaximumHeight: maxDrawerHeight)
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
        controller.shouldRespectSafeAreaForWindowFullWidth = respectSafeAreaWidth

        if let contentView = contentView {
            // `preferredContentSize` can be used to specify the preferred size of a drawer,
            // but here we just define the width and allow it to calculate height automatically
            controller.preferredContentSize.width = 360
            controller.contentView = contentView
            if customWidth {
                controller.shouldUseWindowFullWidthInLandscape = false
            }
        } else {
            controller.contentController = contentController
        }

        present(controller, animated: animated)

        return controller
    }

    private var contentControllerOriginalPreferredContentHeight: CGFloat = 0

    @objc private func customContentNavigationController(content: UIView) -> UINavigationController {
        let controller = UIViewController()
        controller.title = "Resizable slideover drawer"
        controller.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Change preferredContentSize", style: .plain, target: self, action: #selector(changePreferredContentSizeButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        controller.view.addSubview(content)
        content.frame = controller.view.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        content.backgroundColor = Colors.NavigationBar.background

        let contentController = UINavigationController(rootViewController: controller)
        contentController.navigationBar.barTintColor = Colors.NavigationBar.background
        contentController.toolbar.barTintColor = Colors.Toolbar.background
        contentController.isToolbarHidden = false
        contentController.preferredContentSize = CGSize(width: 400, height: 400)
        contentControllerOriginalPreferredContentHeight = contentController.preferredContentSize.height

        return contentController
    }

    private func actionViews(drawerHasFlexibleHeight: Bool, drawerHasToggleResizingBehaviorButton: Bool) -> [UIView] {
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
        if drawerHasToggleResizingBehaviorButton {
            views.append(createButton(title: "Resizing - None", action: #selector(updateResizingBehaviourButtonTapped)))
        }
        views.append(spacer)
        return views
    }

    private func containerForActionViews(drawerHasFlexibleHeight: Bool = true, drawerHasToggleResizingBehaviorButton: Bool = false) -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews(drawerHasFlexibleHeight: drawerHasFlexibleHeight, drawerHasToggleResizingBehaviorButton: drawerHasToggleResizingBehaviorButton) {
            container.addArrangedSubview(view)
        }
        return container
    }

    @objc private func barButtonTapped(sender: UIBarButtonItem) {
        presentDrawer(barButtonItem: sender, presentationDirection: .down, permittedArrowDirections: .any, contentView: containerForActionViews())
    }

    @objc private func showTopDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, presentationBackground: .none, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }

    @objc private func showTopDrawerWithMaxContentHeightTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .expand, maxDrawerHeight: 350)
    }

    @objc private func showTopDrawerNotDismissableButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(), resizingBehavior: .expand)
    }

    @objc private func showTopDrawerChangingResizingBehaviour(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(drawerHasFlexibleHeight: true, drawerHasToggleResizingBehaviorButton: true), resizingBehavior: .expand)
    }

    @objc private func showTopDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(), animated: false)
    }

    @objc private func showTopDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.maxY, presentationDirection: .down, contentView: containerForActionViews(), customWidth: true)
    }

    @objc private func showTopDrawerSafeAreaButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .down, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand, respectSafeAreaWidth: true)
    }

    @objc private func showLeftDrawerClearBackgroundButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .fromLeading, presentationBackground: .none, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func showLeftDrawerDimmedBackgroundButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .fromLeading, presentationBackground: .black, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func showRightDrawerClearBackgroundButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .fromTrailing, presentationBackground: .none, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func showRightDrawerDimmedBackgroundButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .fromTrailing, presentationBackground: .black, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismiss)
    }

    @objc private func showBottomDrawerButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }

    @objc private func showBottomDrawerWithMaxContentHeightTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(drawerHasFlexibleHeight: false), resizingBehavior: .dismissOrExpand, maxDrawerHeight: 350)
    }

    @objc private func showBottomDrawerChangingResizingBehaviour(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(drawerHasFlexibleHeight: true, drawerHasToggleResizingBehaviorButton: true), resizingBehavior: .expand)
    }

    @objc private func showBottomDrawerWithUnderlyingInteractableViewButtonTapped(sender: UIButton) {
        navigationController?.pushViewController(PassThroughDrawerDemoController(), animated: true)
    }

    @objc private func showBottomDrawerNotAnimatedButtonTapped(sender: UIButton) {
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(), animated: false)
    }

    @objc private func showBottomDrawerCustomOffsetButtonTapped(sender: UIButton) {
        let rect = sender.superview!.convert(sender.frame, to: nil)
        presentDrawer(sourceView: sender, presentationOrigin: rect.minY, presentationDirection: .up, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }

    @objc private func showBottomDrawerBlockingDismissButtonTapped(sender: UIButton) {
        shouldConfirmDrawerDismissal = true
        presentDrawer(sourceView: sender, presentationDirection: .up, contentView: containerForActionViews(), resizingBehavior: .dismissOrExpand)
    }

    @objc private func showBottomDrawerCustomContentControllerDimmedBackgroundButtonTapped(sender: UIButton) {
        showBottomDrawerCustomContentController(sourceView: sender,
                                                presentationBackground: .black)
    }

    @objc private func showBottomDrawerCustomContentControllerClearBackgroundButtonTapped(sender: UIButton) {
        showBottomDrawerCustomContentController(sourceView: sender,
                                                presentationBackground: .none)
    }

    @objc private func showBottomDrawerCustomContentController(sourceView: UIView,
                                                               presentationBackground: DrawerPresentationBackground) {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas

        let contentController = customContentNavigationController(content: personaListView)

        let drawer = presentDrawer(sourceView: sourceView,
                                   presentationDirection: .up,
                                   presentationStyle: .slideover,
                                   presentationOffset: 20,
                                   presentationBackground: presentationBackground,
                                   contentController: contentController,
                                   resizingBehavior: .dismissOrExpand)

        drawer.resizingHandleViewBackgroundColor = Colors.NavigationBar.background
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
    @objc private func updateResizingBehaviourButtonTapped(sender: UIButton) {
        guard let drawer = presentedViewController as? DrawerController else {
            return
        }
        let isResizingBehaviourNone = drawer.resizingBehavior == .none
        drawer.resizingBehavior = isResizingBehaviourNone ? .expand : .none
        sender.setTitle(isResizingBehaviourNone ? "Resizing - None" : "Resizing - Expand", for: .normal)
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

extension DrawerDemoController: DrawerControllerDelegate {
    func drawerControllerShouldDismissDrawer(_ controller: DrawerController) -> Bool {
        if shouldConfirmDrawerDismissal {
            let alert = UIAlertController(title: "Do you really want to dismiss the drawer?", message: nil, preferredStyle: .alert)
            controller.present(alert, animated: true)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            let noAction = UIAlertAction(title: "No", style: .cancel)
            alert.addAction(yesAction)
            alert.addAction(noAction)
        }
        return !shouldConfirmDrawerDismissal
    }

    func drawerControllerDidDismiss(_ controller: DrawerController) {
        // reset the flag once drawer gets dismissed
        shouldConfirmDrawerDismissal = false
    }
}
