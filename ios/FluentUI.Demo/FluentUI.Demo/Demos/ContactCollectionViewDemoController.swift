//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ContactCollectionViewDemoController: DemoController {
    private let contactCollectionView = ContactCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        contactCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contactCollectionView.contactList = samplePersonas

        view.addSubview(contactCollectionView)

        contactCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contactCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
