//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI

class BottomSheetDemoController: DemoController {
// MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainPersonaListView()
        setupBottomSheet()
    }

// MARK: Setup Methods

    private func setupMainPersonaListView() {
        view.addSubview(personaListView)

        NSLayoutConstraint.activate([
            personaListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personaListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personaListView.topAnchor.constraint(equalTo: view.topAnchor),
            personaListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBottomSheet() {
        let personaVC = BottomSheetPersonaListViewController()
        let bottomSheetVC = BottomSheetController(contentViewController: personaVC)
        bottomSheetVC.hostedScrollView = personaVC.personaListView
        bottomSheetVC.expandedHeightFraction = 0.8

        self.addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        NSLayoutConstraint.activate([
            bottomSheetVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            bottomSheetVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
