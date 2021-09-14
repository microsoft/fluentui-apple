//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI

class BottomSheetDemoController: UIViewController {

    override func loadView() {
        view = UIView()

        let optionTableView = UITableView(frame: .zero, style: .plain)
        optionTableView.translatesAutoresizingMaskIntoConstraints = false
        optionTableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        optionTableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.separatorStyle = .none
        view.addSubview(optionTableView)
        mainTableView = optionTableView

        let bottomSheetViewController = BottomSheetController(headerContentView: headerView, expandedContentView: personaListView)
        bottomSheetViewController.hostedScrollView = personaListView
        bottomSheetViewController.collapsedContentHeight = BottomSheetDemoController.headerHeight
        bottomSheetViewController.delegate = self

        self.bottomSheetViewController = bottomSheetViewController

        self.addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.didMove(toParent: self)

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

    @objc private func toggleScrollHiding(_ sender: BooleanCell) {
        scrollHidingEnabled = sender.isOn
    }

    @objc private func fullScreenSheetContent() {
        // This is also the default value which results in a full screen sheet.
        bottomSheetViewController?.preferredExpandedContentHeight = 0
    }

    @objc private func fixedHeightSheetContent() {
        bottomSheetViewController?.preferredExpandedContentHeight = 400
    }

    private let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.backgroundColor = Colors.NavigationBar.background
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.surfaceQuaternary
        view.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true

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

    private var isScrolling: Bool = false

    private var isHiding: Bool = false

    private var interactiveHidingAnimator: UIViewPropertyAnimator?

    private var demoOptionItems: [DemoItem] {
        [
            DemoItem(title: "Expandable", type: .boolean, action: #selector(toggleExpandable), isOn: bottomSheetViewController?.isExpandable ?? true),
            DemoItem(title: "Hidden", type: .boolean, action: #selector(toggleHidden), isOn: bottomSheetViewController?.isHidden ?? false),
            DemoItem(title: "Hide on scroll", type: .boolean, action: #selector(toggleScrollHiding), isOn: scrollHidingEnabled),
            DemoItem(title: "Full screen sheet content", type: .action, action: #selector(fullScreenSheetContent)),
            DemoItem(title: "Fixed height sheet content", type: .action, action: #selector(fixedHeightSheetContent))
        ]
    }

    private static let headerHeight: CGFloat = 70

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
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoOptionItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = demoOptionItems[indexPath.row]

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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = scrollHidingEnabled
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y

        if isScrolling {
            var delta = contentOffset - previousScrollOffset
            if interactiveHidingAnimator == nil {
                isHiding = delta > 0 ? true : false
                interactiveHidingAnimator = bottomSheetViewController?.startInteractiveHiddenStateChange(to: isHiding)
                interactiveHidingAnimator?.addCompletion { [weak self] _ in
                    self?.mainTableView?.reloadData()
                    self?.mainTableView?.layoutIfNeeded()
                    self?.interactiveHidingAnimator = nil
                }
            }
            if let animator = interactiveHidingAnimator {
                if animator.isRunning {
                    animator.pauseAnimation()
                }

                delta *= isHiding ? 1 : -1
                animator.fractionComplete += delta / 100
            }
        }

        previousScrollOffset = contentOffset
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrolling = false
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
    func bottomSheetControllerCollapsedSheetHeightDidChange(_ bottomSheetController: BottomSheetController) {
        if let tableView = mainTableView {
            tableView.contentInset.bottom = bottomSheetController.collapsedHeightInSafeArea
        }
    }
}
