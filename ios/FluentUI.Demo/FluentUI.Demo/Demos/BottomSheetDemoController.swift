//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class BottomSheetDemoController: DemoController {

// MARK: Private properties
    private let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private var bottomSheetViewController: BottomSheetViewController?

// MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPersonaListView()
        setupBottomSheet()
    }

// MARK: Setup Methods

    private func setupPersonaListView() {
        self.view.addSubview(personaListView)
        NSLayoutConstraint.activate([
            personaListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            personaListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            personaListView.topAnchor.constraint(equalTo: self.view.topAnchor),
            personaListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func setupBottomSheet() {
        let contentViewController = TabButtonViewController()
        bottomSheetViewController = BottomSheetViewController(with: contentViewController)

        if let bottomSheet = bottomSheetViewController {
            addChild(bottomSheet)
            view.addSubview(bottomSheet.view)
            bottomSheet.view.frame = CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width, height: 200)
        }
    }
}

class TabButtonViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        let button = Button(style: .primaryFilled)
        button.setTitle("Longer Text Button", for: .normal)
        button.titleLabel?.numberOfLines = 0

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
        ])
    }
}
