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

        contactCollectionView.contactCollectionViewDelegate = self
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

extension ContactCollectionViewDemoController: ContactCollectionViewDelegate {
    func didTapOnContactViewAtIndex(index: Int, personaData: PersonaData) {
        let identifier = personaData.name.count > 0 ? personaData.name : personaData.email
        let alert = UIAlertController(title: "\(identifier) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
