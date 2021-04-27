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
        let commandingBottomSheetVC = CommandingBottomSheetController()
        commandingBottomSheetVC.heroItems = [CommandingItem(title: "Item1", action: {}), CommandingItem(title: "Item2", action: {})]

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
