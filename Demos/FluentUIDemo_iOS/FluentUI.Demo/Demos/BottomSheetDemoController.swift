//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class BottomSheetDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        readmeString = "Bottom sheets are helpful for enabling a simple task that people can complete before returning to the parent view."

        let optionTableView = UITableView(frame: .zero, style: .insetGrouped)
        optionTableView.translatesAutoresizingMaskIntoConstraints = false
        optionTableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        optionTableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.separatorStyle = .none
        view.addSubview(optionTableView)
        mainTableView = optionTableView

        let bottomSheetViewController = BottomSheetController(headerContentView: headerView, expandedContentView: contentNavigationController.view)
        bottomSheetViewController.hostedScrollView = personaListView
        bottomSheetViewController.headerContentHeight = BottomSheetDemoController.headerHeight
        bottomSheetViewController.delegate = self
        bottomSheetViewController.collapsedHeightResolver = { context in
            return context.containerTraitCollection.verticalSizeClass == .regular ? 100 : 70
        }

        bottomSheetViewController.partialHeightResolver = { context in
            return context.maximumHeight * 0.5
        }

        self.bottomSheetViewController = bottomSheetViewController

        self.addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.didMove(toParent: self)

        // If we're hosting a VC view in the bottom sheet, the VC itself needs to be a child of the bottom sheet VC
        // This is important to ensure safe area changes propagate correctly.
        bottomSheetViewController.addChild(contentNavigationController)
        contentNavigationController.didMove(toParent: bottomSheetViewController)

        NSLayoutConstraint.activate([
            optionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionTableView.topAnchor.constraint(equalTo: view.topAnchor),
            optionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            bottomSheetViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private var mainTableView: UITableView?

    @objc private func toggleExpandable(_ sender: BooleanCell) {
        bottomSheetViewController?.isExpandable = sender.isOn
    }

    @objc private func toggleHidden(_ sender: BooleanCell) {
        bottomSheetViewController?.isHidden = sender.isOn
    }

    @objc private func toggleFillWidth(_ sender: BooleanCell) {
        bottomSheetViewController?.shouldAlwaysFillWidth = sender.isOn
    }

    @objc private func toggleScrollHiding(_ sender: BooleanCell) {
        scrollHidingEnabled = sender.isOn
    }

    @objc private func toggleCollapsedContentHiding(_ sender: BooleanCell) {
        bottomSheetViewController?.shouldHideCollapsedContent.toggle()
    }

    @objc private func toggleFlexibleSheetHeight(_ sender: BooleanCell) {
        bottomSheetViewController?.isFlexibleHeight = sender.isOn
    }

    @objc private func toggleHandleUsingCustomAccessibilityLabel(_ sender: BooleanCell) {
        let isOn = sender.isOn
        bottomSheetViewController?.handleCollapseCustomAccessibilityLabel = isOn ? "Collapse Bottom Sheet" : nil
        bottomSheetViewController?.handleExpandCustomAccessibilityLabel = isOn ? "Expand Bottom Sheet" : nil
    }

    @objc private func toggleFullScreenSheetContent(_ sender: BooleanCell) {
        bottomSheetViewController?.preferredExpandedContentHeight = sender.isOn ? 0 : 400
    }

    @objc private func toggleTrailingEdge(_ sender: BooleanCell) {
        bottomSheetViewController?.anchoredEdge = sender.isOn ? .trailing : .center
    }

    @objc private func togglePreferredWidth(_ sender: BooleanCell) {
        bottomSheetViewController?.preferredWidth = sender.isOn ? 400 : 0
    }

    @objc private func showTransientSheet() {
        let hostingVC = UIHostingController(rootView: BottomSheetDemoListContentView())

        guard let sheetContentView = hostingVC.view else {
            return
        }

        // This is the bottom sheet that will temporarily be displayed after tapping the "Show transient sheet" button.
        // There can be multiple of these on screen at the same time. All the currently presented transient sheets
        // are tracked in presentedTransientSheets.
        let secondarySheetController = BottomSheetController(expandedContentView: sheetContentView)
        secondarySheetController.delegate = self
        secondarySheetController.collapsedContentHeight = 250
        secondarySheetController.isHidden = true
        secondarySheetController.shouldAlwaysFillWidth = false
        secondarySheetController.shouldHideCollapsedContent = false
        secondarySheetController.isFlexibleHeight = true
        secondarySheetController.allowsSwipeToHide = true

        let dismissButton = Button(primaryAction: UIAction(title: "Dismiss", handler: { [weak secondarySheetController] _ in
            secondarySheetController?.setIsHidden(true, animated: true)
        }))

        dismissButton.style = .accent
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        sheetContentView.addSubview(dismissButton)

        let anotherOneButton = Button(primaryAction: UIAction(title: "Show another sheet", handler: { [weak self] _ in
            self?.showTransientSheet()
        }))
        anotherOneButton.translatesAutoresizingMaskIntoConstraints = false
        sheetContentView.addSubview(anotherOneButton)

        addChild(secondarySheetController)
        view.addSubview(secondarySheetController.view)
        secondarySheetController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            secondarySheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondarySheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondarySheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            secondarySheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: sheetContentView.leadingAnchor, constant: 18),
            dismissButton.trailingAnchor.constraint(equalTo: sheetContentView.trailingAnchor, constant: -18),
            dismissButton.bottomAnchor.constraint(equalTo: sheetContentView.safeAreaLayoutGuide.bottomAnchor),
            anotherOneButton.leadingAnchor.constraint(equalTo: dismissButton.leadingAnchor),
            anotherOneButton.trailingAnchor.constraint(equalTo: dismissButton.trailingAnchor),
            anotherOneButton.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -18)
        ])

        // We need to layout before unhiding to ensure the sheet controller
        // has a meaningful initial frame to use for the animation.
        view.layoutIfNeeded()
        secondarySheetController.isHidden = false
        presentedTransientSheets.append(secondarySheetController)
    }

    private lazy var personaListView: UIScrollView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.backgroundColor = .clear
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private lazy var expandedContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(personaListView)

        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)

        let label = Label()
        label.text = "Bottom view"
        label.translatesAutoresizingMaskIntoConstraints = false

        bottomView.addSubview(label)

        NSLayoutConstraint.activate([
            personaListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personaListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personaListView.topAnchor.constraint(equalTo: view.topAnchor),
            personaListView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 30),
            label.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
        return view
    }()

    private lazy var contentNavigationController: UIViewController = {
        let contentVC = UIViewController()
        let contentVCView: UIView = contentVC.view
        let barButtonItem = UIBarButtonItem(title: "Sample", style: .done, target: nil, action: nil)

        contentVC.navigationItem.title = "Nav title"
        contentVC.navigationItem.rightBarButtonItem = barButtonItem
        contentVCView.addSubview(expandedContentView)

        expandedContentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            expandedContentView.leadingAnchor.constraint(equalTo: contentVCView.leadingAnchor),
            expandedContentView.trailingAnchor.constraint(equalTo: contentVCView.trailingAnchor),
            expandedContentView.topAnchor.constraint(equalTo: contentVCView.topAnchor),
            expandedContentView.bottomAnchor.constraint(equalTo: contentVCView.bottomAnchor)
        ])

        return UINavigationController(rootViewController: contentVC)
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        let label = Label()
        label.text = "Header view"
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()

    private var bottomSheetViewController: BottomSheetController?

    private var previousScrollOffset: CGFloat = 0

    private var scrollHidingEnabled: Bool = false

    private var collapsedContentHidingEnabled: Bool = true

    private var isHandleUsingCustomAccessibilityLabel: Bool = false

    private var isHiding: Bool = false

    private var interactiveHidingAnimator: UIViewAnimating?

    private var demoOptionItems: [[DemoItem]] {
        [
            [
                DemoItem(title: "Expandable", type: .boolean, action: #selector(toggleExpandable), isOn: bottomSheetViewController?.isExpandable ?? true),
                DemoItem(title: "Hidden", type: .boolean, action: #selector(toggleHidden), isOn: bottomSheetViewController?.isHidden ?? false),
                DemoItem(title: "Should always fill width", type: .boolean, action: #selector(toggleFillWidth), isOn: bottomSheetViewController?.shouldAlwaysFillWidth ?? false),
                DemoItem(title: "Scroll to hide", type: .boolean, action: #selector(toggleScrollHiding), isOn: scrollHidingEnabled),
                DemoItem(title: "Hide collapsed content", type: .boolean, action: #selector(toggleCollapsedContentHiding), isOn: collapsedContentHidingEnabled),
                DemoItem(title: "Flexible sheet height", type: .boolean, action: #selector(toggleFlexibleSheetHeight), isOn: bottomSheetViewController?.isFlexibleHeight ?? false),
                DemoItem(title: "Use custom handle accessibility label", type: .boolean, action: #selector(toggleHandleUsingCustomAccessibilityLabel), isOn: isHandleUsingCustomAccessibilityLabel),
                DemoItem(title: "Full screen sheet content", type: .boolean, action: #selector(toggleFullScreenSheetContent), isOn: bottomSheetViewController?.preferredExpandedContentHeight == 0),
                DemoItem(title: "Attach to trailing edge",
                          type: .boolean,
                        action: #selector(toggleTrailingEdge),
                          isOn: bottomSheetViewController?.anchoredEdge == .trailing),
                DemoItem(title: "Set preferred width to 400",
                          type: .boolean,
                        action: #selector(togglePreferredWidth),
                          isOn: bottomSheetViewController?.preferredWidth == 400)
            ],
            [
                DemoItem(title: "Show transient sheet", type: .action, action: #selector(showTransientSheet))
            ]
        ]
    }

    private var presentedTransientSheets = [BottomSheetController]()

    private static let headerHeight: CGFloat = 30

    private enum DemoItemType {
        case action
        case boolean
        case stepper
    }

    private struct DemoItem {
        let title: String
        let type: DemoItemType
        let action: Selector?
        var isOn: Bool = false
    }
}

private class BottomSheetPersonaListViewController: UIViewController {
    override func loadView() {
        view = UIView()
        view.addSubview(personaListView)

        NSLayoutConstraint.activate([
            personaListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personaListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personaListView.topAnchor.constraint(equalTo: view.topAnchor),
            personaListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    public let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()
}

extension BottomSheetDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension BottomSheetDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return demoOptionItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoOptionItems[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Settings" : nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = demoOptionItems[indexPath.section][indexPath.row]

        if item.type == .boolean {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }
            cell.setup(title: item.title, isOn: item.isOn)
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.perform(item.action, with: cell)
            }
            return cell
        } else if item.type == .action {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }
            cell.setup(action1Title: item.title)
            if let action = item.action {
                cell.action1Button.addTarget(self, action: action, for: .touchUpInside)
            }
            cell.bottomSeparatorType = .full
            return cell
        }

        return UITableViewCell()
    }
}

extension BottomSheetDemoController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y

        if scrollView.isTracking && scrollHidingEnabled {
            var delta = contentOffset - previousScrollOffset
            if interactiveHidingAnimator == nil {
                isHiding = delta > 0 ? true : false
                interactiveHidingAnimator = bottomSheetViewController?.prepareInteractiveIsHiddenChange(isHiding) { [weak self] _ in
                    self?.mainTableView?.reloadData()
                    self?.mainTableView?.layoutIfNeeded()
                    self?.interactiveHidingAnimator = nil
                }
            }
            if let animator = interactiveHidingAnimator {
                if animator.isRunning {
                    animator.pauseAnimation()
                }

                // fractionComplete either represents progress to hidden or unhidden,
                // so we need to adjust the delta to account for this
                delta *= isHiding ? 1 : -1
                animator.fractionComplete += delta / 100
            }
        }

        previousScrollOffset = contentOffset
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let animator = interactiveHidingAnimator {
            if animator.fractionComplete > 0.5 {
                animator.startAnimation()
            } else {
                animator.isReversed.toggle()
                isHiding.toggle()
                animator.startAnimation()
            }
        }
    }
}

extension BottomSheetDemoController: BottomSheetControllerDelegate {
    func bottomSheetControllerCollapsedHeightInSafeAreaDidChange(_ bottomSheetController: BottomSheetController) {
        if let tableView = mainTableView {
            tableView.contentInset.bottom = bottomSheetController.collapsedHeightInSafeArea
        }
    }

    func bottomSheetController(_ bottomSheetController: BottomSheetController, didMoveTo expansionState: BottomSheetExpansionState, interaction: BottomSheetInteraction) {
        guard expansionState == .hidden, let index = presentedTransientSheets.firstIndex(of: bottomSheetController) else {
            return
        }

        presentedTransientSheets.remove(at: index)
        bottomSheetController.willMove(toParent: nil)
        bottomSheetController.removeFromParent()
        bottomSheetController.view.removeFromSuperview()
    }
}

extension BottomSheetDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: BottomSheetTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverrideBottomSheetTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        bottomSheetViewController?.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideBottomSheetTokens : nil)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: BottomSheetTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens
    private var themeWideOverrideBottomSheetTokens: [BottomSheetTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor { UIColor(light: GlobalTokens.sharedColor(.plum, .tint40),
                                                 dark: GlobalTokens.sharedColor(.plum, .shade30))
            }
        ]
    }

    private var perControlOverrideBottomSheetTokens: [BottomSheetTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor { UIColor(light: GlobalTokens.sharedColor(.forest, .tint40),
                                                 dark: GlobalTokens.sharedColor(.forest, .shade30))
            }
        ]
    }
}

struct BottomSheetDemoListContentView: View {
    var body: some View {
            List {
                Text("Cell with Swipe Action")
                    .swipeActions {
                        Button(action: {}, label: {
                            Text("Action")
                        })
                    }
                Text("Cell without Swipe Action")
            }
            .listStyle(.plain)
    }
}
