//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ContactCollectionViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfaceSecondary

        let largeTitleLabel = createlabel(text: "Large")
        scrollingContainer.addSubview(largeTitleLabel)

        let largeCollectionView = ContactCollectionView(personas: personas)
        largeCollectionView.contactCollectionViewDelegate = self
        largeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollingContainer.addSubview(largeCollectionView)

        let smallTitleLabel = createlabel(text: "Small")
        scrollingContainer.addSubview(smallTitleLabel)

        let smallCollectionView = ContactCollectionView(size: .small, personas: personas)
        smallCollectionView.contactCollectionViewDelegate = self
        smallCollectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollingContainer.addSubview(smallCollectionView)

        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .center
        scrollingContainer.addSubview(stackView)

        stackView.addArrangedSubview(createlabel(text: "Large"))
        stackView.addArrangedSubview(ContactView(identifier: "Kat Larrson"))
        stackView.addArrangedSubview(ContactView(title: "Kristin", subtitle: "Patterson"))
        stackView.addArrangedSubview(createlabel(text: "Small"))
        stackView.addArrangedSubview(ContactView(identifier: "Kat Larrson", size: .small))
        stackView.addArrangedSubview(ContactView(title: "Kristin", subtitle: "Patterson", size: .small))

        NSLayoutConstraint.activate([
            largeTitleLabel.topAnchor.constraint(equalTo: scrollingContainer.topAnchor, constant: Constants.spacing),
            largeTitleLabel.leadingAnchor.constraint(equalTo: scrollingContainer.leadingAnchor, constant: Constants.leadingSpacing),
            largeCollectionView.topAnchor.constraint(equalTo: largeTitleLabel.bottomAnchor, constant: Constants.spacing),
            largeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            largeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            smallTitleLabel.topAnchor.constraint(equalTo: largeCollectionView.bottomAnchor, constant: Constants.spacing),
            smallTitleLabel.leadingAnchor.constraint(equalTo: scrollingContainer.leadingAnchor, constant: Constants.leadingSpacing),
            smallCollectionView.topAnchor.constraint(equalTo: smallTitleLabel.bottomAnchor, constant: Constants.spacing),
            smallCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            smallCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollingContainer.leadingAnchor, constant: Constants.leadingSpacing),
            stackView.topAnchor.constraint(equalTo: smallCollectionView.bottomAnchor, constant: Constants.spacing),
            stackView.bottomAnchor.constraint(equalTo: scrollingContainer.bottomAnchor)
        ])
    }

    private func createlabel(text: String) -> Label {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text

        return label
    }

    private struct Constants {
        static let spacing: CGFloat = 20
        static let leadingSpacing: CGFloat = 30
    }

    private let personas: [PersonaData] = [
        PersonaData(surname: "Kat", lastName: "Larrson", avatarImage: UIImage(named: "avatar_kat_larsson")),
        PersonaData(surname: "Ashley", lastName: "McCarthy", avatarImage: UIImage(named: "avatar_ashley_mccarthy")),
        PersonaData(surname: "Allan", lastName: "Munger", avatarImage: UIImage(named: "avatar_allan_munger")),
        PersonaData(surname: "Amanda", lastName: "Brady", avatarImage: UIImage(named: "avatar_amanda_brady")),
        PersonaData(surname: "Kevin", lastName: "Sturgis"),
        PersonaData(surname: "Lydia", lastName: "Bauer", avatarImage: UIImage(named: "avatar_lydia_bauer")),
        PersonaData(surname: "Robin", lastName: "Counts"),
        PersonaData(surname: "Tim", lastName: "Deboer", avatarImage: UIImage(named: "avatar_tim_deboer")),
        PersonaData(surname: "Daisy", lastName: "Phillips", avatarImage: UIImage(named: "avatar_daisy_phillips")),
        PersonaData(surname: "Mona", lastName: "Kane", email: "mona.kane@contoso.com"),
        PersonaData(surname: "Elvia", lastName: "Atkins", avatarImage: UIImage(named: "avatar_elvia_atkins")),
        PersonaData(surname: "Johnie", lastName: "McConnell", subtitle: "Designer", avatarImage: UIImage(named: "avatar_johnie_mcconnell")),
        PersonaData(surname: "Charlotte", lastName: "Waltsson"),
        PersonaData(surname: "Mauricio", lastName: "August", avatarImage: UIImage(named: "avatar_mauricio_august")),
        PersonaData(surname: "Robert", lastName: "Tolbert", avatarImage: UIImage(named: "avatar_robert_tolbert")),
        PersonaData(surname: "Isaac", lastName: "Fielder", avatarImage: UIImage(named: "avatar_isaac_fielder")),
        PersonaData(surname: "Carole", lastName: "Poland"),
        PersonaData(surname: "Elliot", lastName: "Woodward"),
        PersonaData(surname: "Henry", lastName: "Brill", avatarImage: UIImage(named: "avatar_henry_brill")),
        PersonaData(surname: "Cecil", lastName: "Folk", avatarImage: UIImage(named: "avatar_cecil_folk")),
        PersonaData(name: "Katri Ahokas", avatarImage: UIImage(named: "avatar_katri_ahokas")),
        PersonaData(name: "Colin Ballinger", email: "colin.ballinger@contoso.com", avatarImage: UIImage(named: "avatar_colin_ballinger")),
        PersonaData(email: "wanda.howard@contoso.com"),
        PersonaData(email: "carlos.slattery@contoso.com", subtitle: "Software Engineer")
    ]
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
