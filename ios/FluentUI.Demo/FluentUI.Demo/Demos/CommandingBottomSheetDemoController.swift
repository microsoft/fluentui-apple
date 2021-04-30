//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class CommandingBottomSheetDemoController: DemoController {
// MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainPersonaListView()
        setupBottomSheet()
    }

// MARK: Setup Methods

    private func setupMainPersonaListView() {
        view.addSubview(personaListView)
        personaListView.frame = view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupBottomSheet() {
        let commandingBottomSheetVC = BottomCommandingController()
        commandingBottomSheetVC.heroItems = [
            CommandingItem(title: "Item 1", image: UIImage(named: "Home_24")!, action: { _ in }, selectedImage: UIImage(named: "Home_Selected_24")!),
            CommandingItem(title: "Item 2", image: UIImage(named: "Home_24")!, action: { _ in }, selectedImage: UIImage(named: "Home_Selected_24")!),
            CommandingItem(title: "Item 3", image: UIImage(named: "Home_24")!, action: { _ in }, selectedImage: UIImage(named: "Home_Selected_24")!),
            CommandingItem(title: "Item 4", image: UIImage(named: "Home_24")!, action: { _ in }, selectedImage: UIImage(named: "Home_Selected_24")!),
            CommandingItem(title: "Item 5", image: UIImage(named: "Home_24")!, action: { _ in }, selectedImage: UIImage(named: "Home_Selected_24")!)
        ]

        commandingBottomSheetVC.listCommandSections = [
            CommandingSection(title: "Section 1", items: [
                CommandingItem(title: "Item 1", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 2", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 3", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 4", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 5", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 6", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 7", image: UIImage(named: "Home_24")!, action: { _ in })
            ]),
            CommandingSection(title: "Section 2", items: [
                CommandingItem(title: "Item 1", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 2", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 3", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 4", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 5", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 6", image: UIImage(named: "Home_24")!, action: { _ in }),
                CommandingItem(title: "Item 7", image: UIImage(named: "Home_24")!, action: { _ in })
            ])
        ]

        addChild(commandingBottomSheetVC)
        view.addSubview(commandingBottomSheetVC.view)
        commandingBottomSheetVC.didMove(toParent: self)

        NSLayoutConstraint.activate([
            commandingBottomSheetVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commandingBottomSheetVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commandingBottomSheetVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            commandingBottomSheetVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

// MARK: Private properties
    private let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private var bottomSheetViewController: BottomSheetController?
}
