//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI

class BottomCommandingDemoController: UIViewController {

    override func loadView() {
        view = UIView()

        let optionTableView = UITableView(frame: .zero, style: .plain)
        optionTableView.translatesAutoresizingMaskIntoConstraints = false
        optionTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        optionTableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        optionTableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.separatorStyle = .none
        view.addSubview(optionTableView)

        let bottomCommandingVC = BottomCommandingController()
        bottomCommandingVC.heroItems = heroItems
        bottomCommandingVC.expandedListSections = expandedListSections

        addChild(bottomCommandingVC)
        view.addSubview(bottomCommandingVC.view)
        bottomCommandingVC.didMove(toParent: self)

        bottomCommandingController = bottomCommandingVC

        NSLayoutConstraint.activate([
            optionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionTableView.topAnchor.constraint(equalTo: view.topAnchor),
            optionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCommandingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCommandingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCommandingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            bottomCommandingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

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

    private lazy var expandedListSections: [CommandingSection] = [
        CommandingSection(title: "Section 1", items:
        Array(1...2).map {
            CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
        } + booleanCommands),
        CommandingSection(title: "Section 2", items: Array(1...7).map {
            CommandingItem(title: "Item " + String($0), image: homeImage, action: commandAction)
        })
    ]

    private lazy var demoOptionItems: [DemoItem] = {
        return [DemoItem(title: "Hidden", type: .boolean, action: #selector(toggleHidden), isOn: false),
                DemoItem(title: "Sheet more button", type: .boolean, action: #selector(toggleSheetMoreButton), isOn: true),
                DemoItem(title: "Expanded list items", type: .boolean, action: #selector(toggleExpandedItems), isOn: true),
                DemoItem(title: "Hero command isOn", type: .boolean, action: #selector(toggleHeroCommandOnOff)),
                DemoItem(title: "Hero command isEnabled", type: .boolean, action: #selector(toggleHeroCommandEnabled), isOn: true),
                DemoItem(title: "List command isEnabled", type: .boolean, action: #selector(toggleListCommandEnabled), isOn: true),
                DemoItem(title: "Toggle boolean cells", type: .action, action: #selector(toggleBooleanCells)),
                DemoItem(title: "Change hero command titles", type: .action, action: #selector(changeHeroCommandTitle)),
                DemoItem(title: "Change hero command images", type: .action, action: #selector(changeHeroCommandIcon)),
                DemoItem(title: "Change list command titles", type: .action, action: #selector(changeListCommandTitle)),
                DemoItem(title: "Change list command images", type: .action, action: #selector(changeListCommandIcon)),
                DemoItem(title: "Hero command count", type: .stepper, action: nil)
        ]
    }()

    @objc private func toggleHidden() {
        bottomCommandingController?.isHidden.toggle()
    }

    @objc private func toggleSheetMoreButton() {
        bottomCommandingController?.prefersSheetMoreButtonVisible.toggle()
    }

    @objc private func toggleExpandedItems() {
        if bottomCommandingController?.expandedListSections.count == 0 {
            bottomCommandingController?.expandedListSections = expandedListSections
        } else {
            bottomCommandingController?.expandedListSections = []
        }
    }

    private let modifiedCommandIndices: [Int] = [0, 3]

    @objc private func toggleHeroCommandOnOff() {
        modifiedCommandIndices.forEach {
            heroItems[$0].isOn.toggle()
        }
    }

    @objc private func toggleHeroCommandEnabled() {
        modifiedCommandIndices.forEach {
            heroItems[$0].isEnabled.toggle()
        }
    }

    @objc private func toggleListCommandEnabled() {
        modifiedCommandIndices.forEach {
            expandedListSections[0].items[$0].isEnabled.toggle()
        }
    }

    @objc private func changeHeroCommandTitle() {
        modifiedCommandIndices.forEach {
            heroItems[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeListCommandTitle() {
        modifiedCommandIndices.forEach {
            expandedListSections[0].items[$0].title = "Item " + String(Int.random(in: 6..<100))
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
            expandedListSections[0].items[$0].image = listIconChanged ? homeImage : boldImage
            expandedListSections[0].items[$0].selectedImage = listIconChanged ? homeSelectedImage : boldImage
        }
        listIconChanged.toggle()
    }

    @objc private func toggleBooleanCells() {
        booleanCommands.forEach { $0.isOn.toggle() }
    }

    @objc private func incrementHeroCommands() {
        let currentCount = bottomCommandingController?.heroItems.count ?? 0
        if currentCount < 5 {
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
            showMessage("Hero command tapped")
        } else if expandedListSections.contains(where: { $0.items.contains(item) }) {
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

    private let homeImage = UIImage(named: "Home_24")!
    private let homeSelectedImage = UIImage(named: "Home_Selected_24")!
    private let boldImage = UIImage(named: "textBold24Regular")!

    private var heroIconChanged: Bool = false
    private var listIconChanged: Bool = false

    private var bottomCommandingController: BottomCommandingController?

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
