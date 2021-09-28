//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI

class BottomCommandingDemoController: UIViewController {

    override func loadView() {
        view = UIView()

        let optionTableViewController = UITableViewController(style: .plain)
        mainTableViewController = optionTableViewController

        let optionTableView: UITableView = optionTableViewController.tableView
        optionTableView.translatesAutoresizingMaskIntoConstraints = false
        optionTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        optionTableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        optionTableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.separatorStyle = .none

        let bottomCommandingVC = BottomCommandingController(with: optionTableViewController)
        bottomCommandingVC.heroItems = heroItems
        bottomCommandingVC.expandedListSections = shortCommandSectionList
        bottomCommandingVC.delegate = self

        addChild(bottomCommandingVC)
        view.addSubview(bottomCommandingVC.view)
        bottomCommandingVC.didMove(toParent: self)

        bottomCommandingController = bottomCommandingVC

        NSLayoutConstraint.activate([
            bottomCommandingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCommandingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCommandingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            bottomCommandingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private var mainTableViewController: UITableViewController?

    private lazy var heroItems: [CommandingItem] = {
        return Array(1...4).map {
            let item = CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
            item.selectedImage = homeSelectedImage
            return item
        }
    }()

    private lazy var booleanCommands: [CommandingItem] = Array(1...4).map {
        CommandingItem(title: "Boolean Item " + String($0), image: homeImage, action: commandAction, isToggleable: true)
    }

    private lazy var shortCommandSectionList: [CommandingSection] = [
        CommandingSection(title: "Section 1", items:
        Array(1...2).map {
            CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
        } + booleanCommands)
    ]

    private lazy var longCommandSectionList: [CommandingSection] = shortCommandSectionList
        + [
            CommandingSection(title: "Section 2", items:
            Array(1...7).map {
                CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
            }),
            CommandingSection(title: "Section 3", items:
            Array(1...7).map {
                CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
            }),
            CommandingSection(title: "Section 4", items:
            Array(1...7).map {
                CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
            })
        ]

    private lazy var currentExpandedListSections: [CommandingSection] = shortCommandSectionList

    private var demoOptionItems: [DemoItem] {
        return [DemoItem(title: "Hidden", type: .boolean, action: #selector(toggleHidden), isOn: bottomCommandingController?.isHidden ?? false),
                DemoItem(title: "Scroll to hide", type: .boolean, action: #selector(toggleScrollHiding), isOn: scrollHidingEnabled),
                DemoItem(title: "Sheet more button", type: .boolean, action: #selector(toggleSheetMoreButton), isOn: bottomCommandingController?.prefersSheetMoreButtonVisible ?? true),
                DemoItem(title: "Expanded list items", type: .boolean, action: #selector(toggleExpandedItems), isOn: expandedItemsVisible),
                DemoItem(title: "Additional expanded list items", type: .boolean, action: #selector(toggleAdditionalExpandedItems(_:)), isOn: additionalExpandedItemsVisible),
                DemoItem(title: "Popover on hero command tap", type: .boolean, action: #selector(toggleHeroPopover)),
                DemoItem(title: "Hero command isOn", type: .boolean, action: #selector(toggleHeroCommandOnOff)),
                DemoItem(title: "Hero command isEnabled", type: .boolean, action: #selector(toggleHeroCommandEnabled), isOn: true),
                DemoItem(title: "List command isEnabled", type: .boolean, action: #selector(toggleListCommandEnabled), isOn: true),
                DemoItem(title: "Long title hero items", type: .boolean, action: #selector(toggleLongTitleHeroItems), isOn: false),
                DemoItem(title: "Toggle boolean cells", type: .action, action: #selector(toggleBooleanCells)),
                DemoItem(title: "Change hero command titles", type: .action, action: #selector(changeHeroCommandTitle)),
                DemoItem(title: "Change hero command images", type: .action, action: #selector(changeHeroCommandIcon)),
                DemoItem(title: "Change list command titles", type: .action, action: #selector(changeListCommandTitle)),
                DemoItem(title: "Change list command images", type: .action, action: #selector(changeListCommandIcon)),
                DemoItem(title: "Hero command count", type: .stepper, action: nil)
        ]
    }

    @objc private func toggleHidden(_ sender: BooleanCell) {
        bottomCommandingController?.isHidden = sender.isOn
    }

    @objc private func toggleScrollHiding(_ sender: BooleanCell) {
        scrollHidingEnabled = sender.isOn
    }

    @objc private func toggleSheetMoreButton(_ sender: BooleanCell) {
        bottomCommandingController?.prefersSheetMoreButtonVisible = sender.isOn
    }

    @objc private func toggleExpandedItems(_ sender: BooleanCell) {
        expandedItemsVisible = sender.isOn
        if expandedItemsVisible {
            bottomCommandingController?.expandedListSections = currentExpandedListSections
        } else {
            bottomCommandingController?.expandedListSections = []
        }
    }

    @objc private func toggleAdditionalExpandedItems(_ sender: BooleanCell) {
        additionalExpandedItemsVisible = sender.isOn
        if additionalExpandedItemsVisible {
            currentExpandedListSections = longCommandSectionList
        } else {
            currentExpandedListSections = shortCommandSectionList
        }
        bottomCommandingController?.expandedListSections = currentExpandedListSections
    }

    private let modifiedCommandIndices: [Int] = [0, 3]

    @objc private func toggleHeroCommandOnOff(_ sender: BooleanCell) {
        modifiedCommandIndices.forEach {
            heroItems[$0].isOn = sender.isOn
        }
    }

    @objc private func toggleHeroCommandEnabled(_ sender: BooleanCell) {
        modifiedCommandIndices.forEach {
            heroItems[$0].isEnabled = sender.isOn
        }
    }

    @objc private func toggleListCommandEnabled(_ sender: BooleanCell) {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].isEnabled = sender.isOn
        }
    }

    @objc private func toggleLongTitleHeroItems(_ sender: BooleanCell) {
        heroItems.enumerated().forEach { (ix, item) in
            item.title = (sender.isOn ? "Long Title Hero Item " : "Item ") + String(ix)
        }
    }

    @objc private func toggleHeroPopover(_ sender: BooleanCell) {
        heroCommandPopoverEnabled = sender.isOn
    }

    @objc private func changeHeroCommandTitle() {
        modifiedCommandIndices.forEach {
            heroItems[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeListCommandTitle() {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeHeroCommandIcon() {
        modifiedCommandIndices.forEach {
            heroItems[$0].image = heroIconChanged ? homeImage : boldImage
            heroItems[$0].selectedImage = heroIconChanged ? homeSelectedImage : boldImage
        }
        heroIconChanged.toggle()
    }

    @objc private func changeListCommandIcon() {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].image = listIconChanged ? homeImage : boldImage
            currentExpandedListSections[0].items[$0].selectedImage = listIconChanged ? homeSelectedImage : boldImage
        }
        listIconChanged.toggle()
    }

    @objc private func toggleBooleanCells() {
        booleanCommands.forEach { $0.isOn.toggle() }
    }

    @objc private func commandAction(item: CommandingItem) {
        if heroItems.contains(item) {
            if heroCommandPopoverEnabled {
                if let rect = bottomCommandingController?.rectFor(heroItem: item) {
                    if let presentationController = customPopoverViewController.popoverPresentationController {
                        presentationController.sourceView = view
                        presentationController.sourceRect = bottomCommandingController?.view.convert(rect, to: view) ?? .zero
                    }
                    present(customPopoverViewController, animated: true)
                }
            } else {
                showMessage("Hero command tapped")
            }
        } else if currentExpandedListSections.contains(where: { $0.items.contains(item) }) {
            if !item.isToggleable {
                showMessage("Expanded list command tapped")
            }
        }
    }

    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private lazy var incrementHeroCommandCountButton: MSFButton = {
        let button = MSFButton(style: .secondary,
                               size: .small) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let currentCount = strongSelf.bottomCommandingController?.heroItems.count ?? 0
            if currentCount < 4 {
                let newCount = currentCount + 1
                strongSelf.bottomCommandingController?.heroItems = Array(strongSelf.heroItems[0..<newCount])
            }
        }
        button.state.image = UIImage(named: "ic_fluent_add_20_regular")
        button.accessibilityLabel = "Increment hero command count"

        return button
    }()

    private lazy var decrementHeroCommandCountButton: MSFButton = {
        let button = MSFButton(style: .secondary,
                               size: .small) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let currentCount = strongSelf.bottomCommandingController?.heroItems.count ?? 0
            if currentCount > 1 {
                let newCount = currentCount - 1
                strongSelf.bottomCommandingController?.heroItems = Array(strongSelf.heroItems[0..<newCount])
            }
        }
        button.state.image = UIImage(named: "ic_fluent_subtract_20_regular")
        button.accessibilityLabel = "Decrement hero command count"

        return button
    }()

    private lazy var customPopoverViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = Colors.navigationBarBackground
        viewController.preferredContentSize = CGSize(width: 300, height: 300)
        viewController.modalPresentationStyle = .popover

        let label = UILabel()
        label.text = "Custom modal"
        label.translatesAutoresizingMaskIntoConstraints = false

        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        return viewController
    }()

    private let homeImage = UIImage(named: "Home_24")!
    private let homeSelectedImage = UIImage(named: "Home_Selected_24")!
    private let boldImage = UIImage(named: "textBold24Regular")!

    private var heroIconChanged: Bool = false
    private var listIconChanged: Bool = false
    private var heroCommandPopoverEnabled: Bool = false

    private var bottomCommandingController: BottomCommandingController?

    private var expandedItemsVisible: Bool = true

    private var additionalExpandedItemsVisible: Bool = false

    private var previousScrollOffset: CGFloat = 0

    private var isHiding: Bool = false

    private var interactiveHidingAnimator: UIViewAnimating?

    private var scrollHidingEnabled: Bool = false

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

extension BottomCommandingDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension BottomCommandingDemoController: UITableViewDataSource {
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
        } else if item.type == .stepper {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            stackView.addArrangedSubview(decrementHeroCommandCountButton.view)
            stackView.addArrangedSubview(incrementHeroCommandCountButton.view)
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 4

            cell.setup(title: item.title, customAccessoryView: stackView)
            cell.titleNumberOfLines = 0
            return cell
        }

        return UITableViewCell()
    }
}

extension BottomCommandingDemoController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y

        if scrollView.isTracking && scrollHidingEnabled {
            var delta = contentOffset - previousScrollOffset
            if interactiveHidingAnimator == nil {
                isHiding = delta > 0 ? true : false
                interactiveHidingAnimator = bottomCommandingController?.prepareInteractiveIsHiddenChange(isHiding) { [weak self] _ in
                    self?.mainTableViewController?.tableView?.reloadData()
                    self?.mainTableViewController?.tableView?.layoutIfNeeded()
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

extension BottomCommandingDemoController: BottomCommandingControllerDelegate {
    func bottomCommandingControllerCollapsedHeightInSafeAreaDidChange(_ bottomCommandingController: BottomCommandingController) {
        if let tableView = mainTableViewController?.tableView {
            tableView.contentInset.bottom = bottomCommandingController.collapsedHeightInSafeArea
        }
    }
}
