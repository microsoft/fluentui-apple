//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class BottomSheetDemoController: DemoController {
// MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPersonaListView()
        setupBottomSheet()
    }

// MARK: Setup Methods

    private func setupPersonaListView() {
        view.addSubview(personaListView)
        personaListView.frame = view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupBottomSheet() {
        bottomSheetViewController = BottomSheetController()

        if let bottomSheet = bottomSheetViewController {
            self.addChild(bottomSheet)
            view.addSubview(bottomSheet.view)

            NSLayoutConstraint.activate([
                bottomSheet.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomSheet.view.trailingAnchor.constraint(equalTo:view.trailingAnchor),
                bottomSheet.view.topAnchor.constraint(equalTo: view.topAnchor),
                bottomSheet.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            bottomSheet.didMove(toParent: self)

            let personaVC = PersonaListViewController()
            bottomSheet.contentViewController = personaVC
            bottomSheet.hostedScrollView = personaVC.personaListView
            bottomSheet.expandedHeightFraction = 0.8
            bottomSheet.isExpandable = true
        }
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

fileprivate class PersonaListViewController: UIViewController {
    override func viewDidLoad() {
        view.addSubview(personaListView)
        personaListView.frame = view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]


//        view.heightAnchor.constraint(equalToConstant: 1200).isActive = true
    }

    public let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()
}
