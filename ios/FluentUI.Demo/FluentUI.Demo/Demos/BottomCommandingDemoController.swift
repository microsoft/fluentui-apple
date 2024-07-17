//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BottomCommandingDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let optionTableViewController = UITableViewController(style: .insetGrouped)
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
        bottomCommandingVC.heroItems = Array(heroItems.prefix(9))
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
        return Array(1...25).map {
            let item = CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
            item.selectedImage = homeSelectedImage
            item.isOn = ($0 % 3 == 1)
            item.isEnabled = ($0 % 2 == 1)
            return item
        }
    }()

    private lazy var booleanCommands: [CommandingItem] = Array(1...4).map {
        CommandingItem(title: "Boolean Item " + String($0), image: homeImage, action: commandAction, isToggleable: true)
    }

    private lazy var badgeCommand: CommandingItem = {
        let badge = BadgeView(dataSource: BadgeViewDataSource(text: "Badge"))
        let item = CommandingItem(title: "Badge Item", image: homeImage, action: commandAction)
        item.trailingView = badge
        return item
    }()

    private lazy var shortCommandSectionList: [CommandingSection] = [
        CommandingSection(title: "Section 1", items:
        Array(1...2).map {
            CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
        } + booleanCommands + [badgeCommand])
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

    private var demoOptionItems: [[DemoItem]] {
        return [
            [
                DemoItem(title: "Hidden", type: .boolean, action: #selector(toggleHidden), isOn: bottomCommandingController?.isHidden ?? false),
                DemoItem(title: "Scroll to hide", type: .boolean, action: #selector(toggleScrollHiding), isOn: scrollHidingEnabled),
                DemoItem(title: "Sheet more button", type: .boolean, action: #selector(toggleSheetMoreButton), isOn: bottomCommandingController?.prefersSheetMoreButtonVisible ?? true),
                DemoItem(title: "Sheet should always fill width", type: .boolean, action: #selector(toggleFillWidth), isOn: bottomCommandingController?.sheetShouldAlwaysFillWidth ?? true)
            ],
            [
                DemoItem(title: "Hero command count", type: .stepper, action: nil),
                DemoItem(title: "Expanded list items", type: .boolean, action: #selector(toggleExpandedItems), isOn: expandedItemsVisible),
                DemoItem(title: "Additional expanded list items", type: .boolean, action: #selector(toggleAdditionalExpandedItems(_:)), isOn: additionalExpandedItemsVisible),
                DemoItem(title: "Popover on hero command tap", type: .boolean, action: #selector(toggleHeroPopover)),
                DemoItem(title: "Hero command isOn", type: .boolean, action: #selector(toggleModifiableHeroCommandsOnOff), isOn: true),
                DemoItem(title: "Hero command isEnabled", type: .boolean, action: #selector(toggleModifiableHeroCommandsEnabled), isOn: false),
                DemoItem(title: "List command isEnabled", type: .boolean, action: #selector(toggleModifiableListCommandsEnabled), isOn: true),
                DemoItem(title: "Long title hero items", type: .boolean, action: #selector(toggleLongTitleHeroItems), isOn: false),
                DemoItem(title: "Hero command isHidden", type: .boolean, action: #selector(toggleModifiableHeroCommandsHidden), isOn: false),
                DemoItem(title: "List command isHidden", type: .boolean, action: #selector(toggleModifiableListCommandsHidden), isOn: false),
                DemoItem(title: "Toggle boolean cells", type: .action, action: #selector(toggleBooleanCells)),
                DemoItem(title: "Change hero command titles", type: .action, action: #selector(changeModifiableHeroCommandsTitle)),
                DemoItem(title: "Change hero command images", type: .action, action: #selector(changeModifiableHeroCommandsIcon)),
                DemoItem(title: "Change list command titles", type: .action, action: #selector(changeModifiableListCommandsTitle)),
                DemoItem(title: "Change list command images", type: .action, action: #selector(changeModifiableListCommandsIcon))
            ]
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

    @objc private func toggleFillWidth(_ sender: BooleanCell) {
        bottomCommandingController?.sheetShouldAlwaysFillWidth = sender.isOn
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

    @objc private func toggleModifiableHeroCommandsOnOff(_ sender: BooleanCell) {
        for (index, heroItem) in heroItems.enumerated() {
            if (index + 1) % 3 == 1 {
                heroItem.isOn = sender.isOn
            }
        }
    }

    @objc private func toggleModifiableHeroCommandsEnabled(_ sender: BooleanCell) {
        for (index, heroItem) in heroItems.enumerated() {
            if index % 2 == 1 {
                heroItem.isEnabled = sender.isOn
            }
        }
    }

    @objc private func toggleModifiableListCommandsEnabled(_ sender: BooleanCell) {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].isEnabled = sender.isOn
        }
    }

    @objc private func toggleModifiableHeroCommandsHidden(_ sender: BooleanCell) {
        for (index, heroItem) in heroItems.enumerated() {
            if index % 2 == 1 {
                heroItem.isHidden = sender.isOn
            }
        }
    }

    @objc private func toggleModifiableListCommandsHidden(_ sender: BooleanCell) {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].isHidden = sender.isOn
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

    @objc private func changeModifiableHeroCommandsTitle() {
        modifiedCommandIndices.forEach {
            heroItems[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeModifiableListCommandsTitle() {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeModifiableHeroCommandsIcon() {
        modifiedCommandIndices.forEach {
            heroItems[$0].image = heroIconChanged ? homeImage : boldImage
            heroItems[$0].selectedImage = heroIconChanged ? homeSelectedImage : boldImage
        }
        heroIconChanged.toggle()
    }

    @objc private func changeModifiableListCommandsIcon() {
        modifiedCommandIndices.forEach {
            currentExpandedListSections[0].items[$0].image = listIconChanged ? homeImage : boldImage
            currentExpandedListSections[0].items[$0].selectedImage = listIconChanged ? homeSelectedImage : boldImage
        }
        listIconChanged.toggle()
    }

    @objc private func toggleBooleanCells() {
        booleanCommands.forEach { $0.isOn.toggle() }
    }

    @objc private func incrementHeroCommands() {
        let currentCount = bottomCommandingController?.heroItems.count ?? 0
        if currentCount < 25 {
            let newCount = currentCount + 1
            bottomCommandingController?.heroItems = Array(heroItems[0..<newCount])
        }
    }

    @objc private func decrementHeroCommands() {
        let currentCount = bottomCommandingController?.heroItems.count ?? 0
        if currentCount > 1 {
            let newCount = currentCount - 1
            bottomCommandingController?.heroItems = Array(heroItems[0..<newCount])
        }
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

    private lazy var incrementHeroCommandCountButton: Button = {
        let button = Button()
        button.image = UIImage(named: "ic_fluent_add_20_regular")
        button.accessibilityLabel = "Increment hero command count"
        button.addTarget(self, action: #selector(incrementHeroCommands), for: .touchUpInside)
        return button
    }()

    private lazy var decrementHeroCommandCountButton: Button = {
        let button = Button()
        button.image = UIImage(named: "ic_fluent_subtract_20_regular")
        button.accessibilityLabel = "Decrement hero command count"
        button.addTarget(self, action: #selector(decrementHeroCommands), for: .touchUpInside)
        return button
    }()

    private lazy var customPopoverViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = view.fluentTheme.color(.background3)
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

    private let homeImage: UIImage = .init(named: "Home_24")!
    private let homeSelectedImage: UIImage = .init(named: "Home_Selected_24")!
    private let boldImage: UIImage = .init(named: "textBold24Regular")!

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
        return demoOptionItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoOptionItems[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Settings"
        case 1:
            return "Command settings"
        default:
            return nil
        }
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
        } else if item.type == .stepper {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            stackView.addArrangedSubview(decrementHeroCommandCountButton)
            stackView.addArrangedSubview(incrementHeroCommandCountButton)
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

extension BottomCommandingDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: BottomCommandingTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverrideBottomCommandingTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        bottomCommandingController?.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideBottomCommandingTokens : nil)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: BottomCommandingTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens
    private var themeWideOverrideBottomCommandingTokens: [BottomCommandingTokenSet.Tokens: ControlTokenValue] {
        let foregroundColor = UIColor(light: GlobalTokens.sharedColor(.plum, .shade30),
                                      dark: GlobalTokens.sharedColor(.plum, .tint40))
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.plum, .tint40),
                               dark: GlobalTokens.sharedColor(.plum, .shade30))
            },
            .cornerRadius: .float { GlobalTokens.corner(.radiusNone) },
            .heroDisabledColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.plum, .tint30),
                               dark: GlobalTokens.sharedColor(.plum, .tint20))
            },
            .heroLabelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 20.0),
                              size: 20.0)
            },
            .heroRestIconColor: .uiColor { foregroundColor },
            .heroRestLabelColor: .uiColor { foregroundColor },
            .heroSelectedColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.forest, .shade30),
                               dark: GlobalTokens.sharedColor(.forest, .tint40))
            },
            .listIconColor: .uiColor { foregroundColor },
            .listLabelColor: .uiColor { foregroundColor },
            .listLabelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 20.0),
                              size: 20.0)
            },
            .listSectionLabelColor: .uiColor { foregroundColor },
            .listSectionLabelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 16.0),
                              size: 16.0)
            },
            .resizingHandleMarkColor: .uiColor { foregroundColor },
            .strokeColor: .uiColor { foregroundColor },
            .shadow: .shadowInfo { FluentTheme.shared.shadow(.clear) }
        ]
    }

    private var perControlOverrideBottomCommandingTokens: [BottomCommandingTokenSet.Tokens: ControlTokenValue] {
        let foregroundColor = UIColor(light: GlobalTokens.sharedColor(.forest, .shade30),
                                      dark: GlobalTokens.sharedColor(.forest, .tint40))
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.forest, .tint40),
                               dark: GlobalTokens.sharedColor(.forest, .shade30))
            },
            .cornerRadius: .float { GlobalTokens.corner(.radius40) },
            .heroDisabledColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.forest, .tint20),
                               dark: GlobalTokens.sharedColor(.forest, .shade10))
            },
            .heroLabelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0),
                              size: 20.0)
            },
            .heroRestIconColor: .uiColor { foregroundColor },
            .heroRestLabelColor: .uiColor { foregroundColor },
            .heroSelectedColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.plum, .primary),
                               dark: GlobalTokens.sharedColor(.plum, .tint40))
            },
            .listIconColor: .uiColor { foregroundColor },
            .listLabelColor: .uiColor { foregroundColor },
            .listLabelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0),
                              size: 20.0)
            },
            .listSectionLabelColor: .uiColor { foregroundColor },
            .listSectionLabelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 16.0),
                              size: 16.0)
            },
            .resizingHandleMarkColor: .uiColor { foregroundColor },
            .strokeColor: .uiColor { foregroundColor },
            .shadow: .shadowInfo { FluentTheme.shared.shadow(.shadow64) }
        ]
    }
}
