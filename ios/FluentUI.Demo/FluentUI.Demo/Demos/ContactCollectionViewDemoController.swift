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

        contactCollectionView.delegate = self
        contactCollectionView.contactList = samplePersonas

        view.addSubview(contactCollectionView)
    }
}

extension ContactCollectionViewDemoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item \(indexPath.item) at section \(indexPath.section) selected")
    }
}
