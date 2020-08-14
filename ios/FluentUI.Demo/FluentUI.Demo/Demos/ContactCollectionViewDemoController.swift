//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ContactCollectionViewDemoController: UIViewController {
    let samplePersonas: [AvatarData] = [
        AvatarData(primaryText: "Kat", secondaryText: "Larrson", image: UIImage(named: "avatar_kat_larsson")),
        AvatarData(primaryText: "Kristin", secondaryText: "Patterson", image: nil),
        AvatarData(primaryText: "Ashley", secondaryText: "McCarthy", image: UIImage(named: "avatar_ashley_mccarthy")),
        AvatarData(primaryText: "Allan", secondaryText: "Munger", image: UIImage(named: "avatar_allan_munger")),
        AvatarData(primaryText: "Amanda", secondaryText: "Brady", image: UIImage(named: "avatar_amanda_brady")),
        AvatarData(primaryText: "Kevin", secondaryText: "Sturgis", image: nil),
        AvatarData(primaryText: "Lydia", secondaryText: "Bauer", image: UIImage(named: "avatar_lydia_bauer")),
        AvatarData(primaryText: "Robin", secondaryText: "Counts", image: UIImage(named: "avatar_robin_counts")),
        AvatarData(primaryText: "Tim", secondaryText: "Deboer", image: UIImage(named: "avatar_tim_deboer")),
        AvatarData(primaryText: "wanda.howard@contoso.com", secondaryText: "", image: nil),
        AvatarData(primaryText: "Daisy", secondaryText: "Phillips", image: UIImage(named: "avatar_daisy_phillips")),
        AvatarData(primaryText: "Katri", secondaryText: "Ahokas", image: UIImage(named: "avatar_katri_ahokas")),
        AvatarData(primaryText: "Colin", secondaryText: "Ballinger", image: UIImage(named: "avatar_colin_ballinger")),
        AvatarData(primaryText: "Mona", secondaryText: "Kane", image: nil),
        AvatarData(primaryText: "Elvia", secondaryText: "Atkins", image: UIImage(named: "avatar_elvia_atkins")),
        AvatarData(primaryText: "Johnie", secondaryText: "McConnell", image: UIImage(named: "avatar_johnie_mcconnell")),
        AvatarData(primaryText: "Charlotte", secondaryText: "Waltsson", image: nil),
        AvatarData(primaryText: "Mauricio", secondaryText: "August", image: UIImage(named: "avatar_mauricio_august")),
        AvatarData(primaryText: "Robert", secondaryText: "Tolbert", image: UIImage(named: "avatar_robert_tolbert")),
        AvatarData(primaryText: "Isaac", secondaryText: "Fielder", image: UIImage(named: "avatar_isaac_fielder")),
        AvatarData(primaryText: "Carole", secondaryText: "Poland", image: nil),
        AvatarData(primaryText: "Elliot", secondaryText: "Woodward", image: nil),
        AvatarData(primaryText: "carlos.slattery@contoso.com", secondaryText: "", image: nil),
        AvatarData(primaryText: "Henry", secondaryText: "Brill", image: UIImage(named: "avatar_henry_brill")),
        AvatarData(primaryText: "Cecil", secondaryText: "Folk", image: UIImage(named: "avatar_cecil_folk"))
    ]

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
    func didTapOnContactViewAtIndex(index: Int, avatarData: AvatarData) {
        let identifier = avatarData.secondaryText.count > 0 ? "\(avatarData.primaryText) \(avatarData.secondaryText)"  : avatarData.primaryText
        let alert = UIAlertController(title: "\(identifier) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
