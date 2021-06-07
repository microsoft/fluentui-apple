//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PersonaGridDemoController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaGridDemoController.largeGridItemReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaGridDemoController.smallGridItemReuseIdentifier)

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
        if showsFullGrid(at: indexPath) {
            fatalError("showsFullGrid() should always return false right now!")
        } else {
            cell = self.tableView(tableView, gridItemCellForRowAt: indexPath)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch personaGridItemSize(for: section) {
        case .small:
            return "Small"
        case .large:
            return "Large"
        }
    }

    // MARK: - Helpers

    private func personaGridItemSize(for section: Int) -> MSFPersonaGridSize {
        return (section % 2 == 0) ? .small : .large
    }

    private func showsFullGrid(at indexPath: IndexPath) -> Bool {
        // TODO
        return false
    }

    private func tableView(_ tableView: UITableView, gridItemCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let size = personaGridItemSize(for: indexPath.section)
        switch size {
        case .large:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaGridDemoController.largeGridItemReuseIdentifier, for: indexPath)
        case .small:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaGridDemoController.smallGridItemReuseIdentifier, for: indexPath)
        }

        // Create the PersonaGridItem to be displayed
        let personaGridItem = MSFPersonaGridItemView(size: size)
        let persona = personas[indexPath.item]
        personaGridItem.state.image = persona.avatarImage
        personaGridItem.state.primaryText = persona.primaryText
        personaGridItem.state.secondaryText = persona.secondaryText
        personaGridItem.state.onTapAction = { [weak self, personaGridItem] in
            let alert = UIAlertController(title: nil, message: "personaGridItem tapped: \(personaGridItem.state.primaryText ?? "(none)")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        cell.contentView.addSubview(personaGridItem.view)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        var constraints: [NSLayoutConstraint] = []
        personaGridItem.view.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(contentsOf: [
            personaGridItem.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            personaGridItem.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            personaGridItem.view.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
        ])

        cell.contentView.addConstraints(constraints)

        return cell
    }

    private static let largeGridReuseIdentifier: String = "largeGridReuseIdentifier"
    private static let smallGridReuseIdentifier: String = "smallGridReuseIdentifier"
    private static let largeGridItemReuseIdentifier: String = "largeGridItemReuseIdentifier"
    private static let smallGridItemReuseIdentifier: String = "smallGridItemReuseIdentifier"

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
