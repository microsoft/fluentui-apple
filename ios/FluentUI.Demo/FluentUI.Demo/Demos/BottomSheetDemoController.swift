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

    override func viewWillDisappear(_ animated: Bool) {
        bottomSheetViewController?.view.removeFromSuperview()
        super.viewWillDisappear(animated)
    }

// MARK: Setup Methods

    private func setupPersonaListView() {
        view.addSubview(personaListView)
        personaListView.frame = view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupBottomSheet() {
        let contentViewController = UIViewController()
        bottomSheetViewController = BottomSheetViewController(with: contentViewController)

        if let bottomSheet = bottomSheetViewController, let navController = navigationController {
            if let rootview = navController.view {
                rootview.addSubview(bottomSheet.view)
            }
        }
    }

// MARK: Private properties
    private let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private var bottomSheetViewController: BottomSheetViewController?
}
