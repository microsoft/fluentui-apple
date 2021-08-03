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
        PersonaData(firstName: "Kat", lastName: "Larrson", image: UIImage(named: "avatar_kat_larsson")),
        PersonaData(firstName: "Ashley", lastName: "McCarthy", image: UIImage(named: "avatar_ashley_mccarthy")),
        PersonaData(firstName: "Allan", lastName: "Munger", image: UIImage(named: "avatar_allan_munger")),
        PersonaData(firstName: "Amanda", lastName: "Brady", image: UIImage(named: "avatar_amanda_brady")),
        PersonaData(firstName: "Kevin", lastName: "Sturgis"),
        PersonaData(firstName: "Lydia", lastName: "Bauer", image: UIImage(named: "avatar_lydia_bauer")),
        PersonaData(firstName: "Robin", lastName: "Counts"),
        PersonaData(firstName: "Tim", lastName: "Deboer", image: UIImage(named: "avatar_tim_deboer")),
        PersonaData(firstName: "Daisy", lastName: "Phillips", image: UIImage(named: "avatar_daisy_phillips")),
        PersonaData(firstName: "Mona", lastName: "Kane", email: "mona.kane@contoso.com"),
        PersonaData(firstName: "Elvia", lastName: "Atkins", image: UIImage(named: "avatar_elvia_atkins")),
        PersonaData(firstName: "Johnie", lastName: "McConnell", subtitle: "Designer", image: UIImage(named: "avatar_johnie_mcconnell")),
        PersonaData(firstName: "Charlotte", lastName: "Waltsson"),
        PersonaData(firstName: "Mauricio", lastName: "August", image: UIImage(named: "avatar_mauricio_august")),
        PersonaData(firstName: "Robert", lastName: "Tolbert", image: UIImage(named: "avatar_robert_tolbert")),
        PersonaData(firstName: "Isaac", lastName: "Fielder", image: UIImage(named: "avatar_isaac_fielder")),
        PersonaData(firstName: "Carole", lastName: "Poland"),
        PersonaData(firstName: "Elliot", lastName: "Woodward"),
        PersonaData(firstName: "Henry", lastName: "Brill", image: UIImage(named: "avatar_henry_brill")),
        PersonaData(firstName: "Cecil", lastName: "Folk", image: UIImage(named: "avatar_cecil_folk")),
        PersonaData(name: "Katri Ahokas", image: UIImage(named: "avatar_katri_ahokas")),
        PersonaData(name: "Colin Ballinger", email: "colin.ballinger@contoso.com", image: UIImage(named: "avatar_colin_ballinger")),
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
