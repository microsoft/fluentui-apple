//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class BottomCommandingDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomCommandingVC = BottomCommandingController()
        bottomCommandingVC.heroItems = heroItems
        bottomCommandingVC.expandedListSections = expandedListSections

        addChild(bottomCommandingVC)
        view.addSubview(bottomCommandingVC.view)
        bottomCommandingVC.didMove(toParent: self)

        bottomCommandingController = bottomCommandingVC

        container.addArrangedSubview(createLabelAndSwitchRow(labelText: "Expanded list items", switchAction: #selector(toggleExpandedItems), isOn: true))
        container.addArrangedSubview(createLabelAndSwitchRow(labelText: "Hero command isOn", switchAction: #selector(toggleHeroCommandOnOff)))
        container.addArrangedSubview(createLabelAndSwitchRow(labelText: "Hero command isEnabled", switchAction: #selector(toggleHeroCommandEnabled), isOn: true))
        container.addArrangedSubview(createLabelAndSwitchRow(labelText: "List command isEnabled", switchAction: #selector(toggleListCommandEnabled), isOn: true))
        container.addArrangedSubview(createButton(title: "Change hero command titles", action: #selector(changeHeroCommandTitle)))
        container.addArrangedSubview(createButton(title: "Change hero command images", action: #selector(changeHeroCommandIcon)))
        container.addArrangedSubview(createButton(title: "Change list command titles", action: #selector(changeListCommandTitle)))
        container.addArrangedSubview(createButton(title: "Change list command images", action: #selector(changeListCommandIcon)))
        addRow(text: "Hero command count", items: [decrementHeroCommandCountButton, incrementHeroCommandCountButton], textWidth: 150)

        NSLayoutConstraint.activate([
            bottomCommandingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCommandingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCommandingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            bottomCommandingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBottomSheet() {

    }

    @objc private func toggleExpandedItems() {
        if bottomCommandingController?.expandedListSections.count == 0 {
            bottomCommandingController?.expandedListSections = expandedListSections
        } else {
            bottomCommandingController?.expandedListSections = []
        }
    }

    @objc private func toggleHeroCommandOnOff() {
        [0, 2, 4].forEach {
            heroItems[$0].isOn.toggle()
        }
    }

    @objc private func toggleHeroCommandEnabled() {
        [0, 2, 4].forEach {
            heroItems[$0].isEnabled.toggle()
        }
    }

    @objc private func toggleListCommandEnabled() {
        [0, 2, 4].forEach {
            expandedListSections[0].items[$0].isEnabled.toggle()
        }
    }

    @objc private func changeHeroCommandTitle() {
        [0, 2, 4].forEach {
            heroItems[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeListCommandTitle() {
        [0, 2, 4].forEach {
            expandedListSections[0].items[$0].title = "Item " + String(Int.random(in: 6..<100))
        }
    }

    @objc private func changeHeroCommandIcon() {
        [0, 2, 4].forEach {
            heroItems[$0].image = UIImage(named: iconChanged ? "Home_24" : "textBold24Regular")!
            heroItems[$0].selectedImage = UIImage(named: iconChanged ? "Home_Selected_24" : "textBold24Regular")!
        }
        iconChanged.toggle()
    }

    @objc private func changeListCommandIcon() {
        [0, 2, 4].forEach {
            expandedListSections[0].items[$0].image = UIImage(named: iconChanged ? "Home_24" : "textBold24Regular")!
            expandedListSections[0].items[$0].selectedImage = UIImage(named: iconChanged ? "Home_Selected_24" : "textBold24Regular")!
        }
        iconChanged.toggle()
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
            showMessage("Expanded list command tapped")
        }
    }

    private lazy var heroItems: [CommandingItem] = [
        CommandingItem(title: "Item 1", image: UIImage(named: "Home_24")!, action: commandAction, selectedImage: UIImage(named: "Home_Selected_24")!),
        CommandingItem(title: "Item 2", image: UIImage(named: "Home_24")!, action: commandAction, selectedImage: UIImage(named: "Home_Selected_24")!),
        CommandingItem(title: "Item 3", image: UIImage(named: "Home_24")!, action: commandAction, selectedImage: UIImage(named: "Home_Selected_24")!),
        CommandingItem(title: "Item 4", image: UIImage(named: "Home_24")!, action: commandAction, selectedImage: UIImage(named: "Home_Selected_24")!),
        CommandingItem(title: "Item 5", image: UIImage(named: "Home_24")!, action: commandAction, selectedImage: UIImage(named: "Home_Selected_24")!)
    ]

    private lazy var expandedListSections: [CommandingSection] = [
        CommandingSection(title: "Section 1", items: [
            CommandingItem(title: "Item 1", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 2", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 3", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 4", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 5", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 6", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 7", image: UIImage(named: "Home_24")!, action: commandAction)
        ]),
        CommandingSection(title: "Section 2", items: [
            CommandingItem(title: "Item 1", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 2", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 3", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 4", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 5", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 6", image: UIImage(named: "Home_24")!, action: commandAction),
            CommandingItem(title: "Item 7", image: UIImage(named: "Home_24")!, action: commandAction)
        ])
    ]

    private lazy var incrementHeroCommandCountButton: Button = {
        return createButton(title: "+", action: #selector(incrementHeroCommands))
    }()

    private lazy var decrementHeroCommandCountButton: Button = {
        return createButton(title: "-", action: #selector(decrementHeroCommands))
    }()

    private var iconChanged: Bool = false

    private var bottomCommandingController: BottomCommandingController?
}
