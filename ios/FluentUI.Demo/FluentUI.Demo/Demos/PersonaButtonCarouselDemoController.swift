//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PersonaButtonCarouselDemoController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.largeBadgeReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.smallBadgeReuseIdentifier)

        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if showsFullCarousel(at: indexPath) {
            fatalError("showsFullCarousel() should always return false right now!")
        } else {
            cell = self.tableView(tableView, badgeCellForRowAt: indexPath)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch personaBadgeSize(for: section) {
        case .small:
            return "Small"
        case .large:
            return "Large"
        }
    }

    // MARK: - Helpers

    private func personaBadgeSize(for section: Int) -> MSFPersonaButtonSize {
        return (section % 2 == 0) ? .small : .large
    }

    private func showsFullCarousel(at indexPath: IndexPath) -> Bool {
        // TODO: Create PersonaButtonCarousel
        return false
    }

    private func tableView(_ tableView: UITableView, badgeCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let size = personaBadgeSize(for: indexPath.section)
        switch size {
        case .large:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.largeBadgeReuseIdentifier, for: indexPath)
        case .small:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.smallBadgeReuseIdentifier, for: indexPath)
        }

        // Create the PersonaButton to be displayed
        let personaBadge = MSFPersonaButtonView(size: size)
        let persona = personas[indexPath.item]
        personaBadge.state.image = persona.avatarImage
        personaBadge.state.primaryText = persona.primaryText
        personaBadge.state.secondaryText = persona.secondaryText
        personaBadge.state.onTapAction = { [weak self, personaBadge] in
            let alert = UIAlertController(title: nil, message: "PersonaButton tapped: \(personaBadge.state.primaryText ?? "(none)")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        cell.contentView.addSubview(personaBadge.view)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        var constraints: [NSLayoutConstraint] = []
        personaBadge.view.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(contentsOf: [
            personaBadge.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            personaBadge.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            personaBadge.view.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
        ])

        cell.contentView.addConstraints(constraints)

        return cell
    }

    private static let largeGridReuseIdentifier: String = "largeGridReuseIdentifier"
    private static let smallGridReuseIdentifier: String = "smallGridReuseIdentifier"
    private static let largeBadgeReuseIdentifier: String = "largeBadgeReuseIdentifier"
    private static let smallBadgeReuseIdentifier: String = "smallBadgeReuseIdentifier"

    private let personas: [PersonaData] = [
        PersonaData(firstName: "Kat", lastName: "Larrson", avatarImage: UIImage(named: "avatar_kat_larsson")),
        PersonaData(firstName: "Ashley", lastName: "McCarthy", avatarImage: UIImage(named: "avatar_ashley_mccarthy")),
        PersonaData(firstName: "Allan", lastName: "Munger", avatarImage: UIImage(named: "avatar_allan_munger")),
        PersonaData(firstName: "Amanda", lastName: "Brady", avatarImage: UIImage(named: "avatar_amanda_brady")),
        PersonaData(firstName: "Kevin", lastName: "Sturgis"),
        PersonaData(firstName: "Lydia", lastName: "Bauer", avatarImage: UIImage(named: "avatar_lydia_bauer")),
        PersonaData(firstName: "Robin", lastName: "Counts"),
        PersonaData(firstName: "Tim", lastName: "Deboer", avatarImage: UIImage(named: "avatar_tim_deboer")),
        PersonaData(firstName: "Daisy", lastName: "Phillips", avatarImage: UIImage(named: "avatar_daisy_phillips")),
        PersonaData(firstName: "Mona", lastName: "Kane", email: "mona.kane@contoso.com"),
        PersonaData(firstName: "Elvia", lastName: "Atkins", avatarImage: UIImage(named: "avatar_elvia_atkins")),
        PersonaData(firstName: "Johnie", lastName: "McConnell", subtitle: "Designer", avatarImage: UIImage(named: "avatar_johnie_mcconnell")),
        PersonaData(firstName: "Charlotte", lastName: "Waltsson"),
        PersonaData(firstName: "Mauricio", lastName: "August", avatarImage: UIImage(named: "avatar_mauricio_august")),
        PersonaData(firstName: "Robert", lastName: "Tolbert", avatarImage: UIImage(named: "avatar_robert_tolbert")),
        PersonaData(firstName: "Isaac", lastName: "Fielder", avatarImage: UIImage(named: "avatar_isaac_fielder")),
        PersonaData(firstName: "Carole", lastName: "Poland"),
        PersonaData(firstName: "Elliot", lastName: "Woodward"),
        PersonaData(firstName: "Henry", lastName: "Brill", avatarImage: UIImage(named: "avatar_henry_brill")),
        PersonaData(firstName: "Cecil", lastName: "Folk", avatarImage: UIImage(named: "avatar_cecil_folk")),
        PersonaData(name: "Katri Ahokas", avatarImage: UIImage(named: "avatar_katri_ahokas")),
        PersonaData(name: "Colin Ballinger", email: "colin.ballinger@contoso.com", avatarImage: UIImage(named: "avatar_colin_ballinger")),
        PersonaData(email: "wanda.howard@contoso.com"),
        PersonaData(email: "carlos.slattery@contoso.com", subtitle: "Software Engineer")
    ]

}
