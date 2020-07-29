//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ContactCollectionViewDemoController: DemoController {
    private let contactCollectionView = ContactCollectionView()

    override func viewDidLoad() {
        view.backgroundColor = UIColor.lightGray

        super.viewDidLoad()

        contactCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contactCollectionView.contactList = samplePersonas

        view.addSubview(contactCollectionView)

        // TODO: Find out why setting this allows my collection view to scroll
        contactCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contactCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
