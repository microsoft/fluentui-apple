//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ContactCollectionViewDemoController: UIViewController {
    private let contactCollectionView = ContactCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfacePrimary

        contactCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contactCollectionView.contactList = samplePersonas

        view.addSubview(contactCollectionView)

        NSLayoutConstraint.activate([
            contactCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            contactCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
