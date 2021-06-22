//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PersonaButtonCarouselDemoController: UITableViewController,
                                           MSFPersonaButtonCarouselDelegate {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ActionsCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.controlReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.largeCarouselReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.smallCarouselReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.largeButtonReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PersonaButtonCarouselDemoController.smallButtonReuseIdentifier)

        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    struct TableSectionInfo {
        var actionButtons: Bool = false
        var size: MSFPersonaButtonSize = .large
        var carousel: Bool = false
    }
    let tableInfo: [TableSectionInfo] = [
        TableSectionInfo(actionButtons: true),
        TableSectionInfo(size: .large, carousel: true),
        TableSectionInfo(size: .small, carousel: true),
        TableSectionInfo(size: .large, carousel: false),
        TableSectionInfo(size: .small, carousel: false)
    ]

    struct ActionButtonInfo {
        var title: String
        var action: Selector
    }
    let actionButtons: [ActionButtonInfo] = [
        ActionButtonInfo(title: "Append random persona", action: #selector(handleAppendPersona)),
        ActionButtonInfo(title: "Remove random persona", action: #selector(handleRemovePersona))
    ]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableInfo.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableInfo[section].actionButtons ? actionButtons.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if isActionButtonsSection(indexPath.section) {
            cell = self.tableView(tableView, controlCellForRowAt: indexPath)
        } else if showsFullCarousel(at: indexPath.section) {
            cell = self.tableView(tableView, carouselCellForRowAt: indexPath)
        } else {
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isActionButtonsSection(section) {
            return "Actions"
        }
        let sizeString = { () -> String in
            switch self.personaButtonSize(for: section) {
            case .small:
                return "Small"
            case .large:
                return "Large"
            }
        }()
        let styleString = { () -> String in
            if self.showsFullCarousel(at: section) {
                return "Carousel"
            } else {
                return "Button"
            }
        }()
        return "\(String(describing: sizeString)) \(String(describing: styleString))"
    }

    // MARK: - MSFPersonaButtonCarouselDelegate
    func didTap(on personaData: PersonaData, at index: Int) {
        let identifier = personaData.name.count > 0 ? personaData.name : personaData.email
        let alert = UIAlertController(title: "\(identifier) at index \(index) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    // MARK: - Actions

    @objc private func handleAppendPersona() {
        carousels.forEach { (_ : MSFPersonaButtonSize, carousel: MSFPersonaButtonCarousel) in
            let random = Int.random(in: 0...personas.count - 1)
            carousel.append(personas[random])
        }
    }

    @objc private func handleRemovePersona() {
        carousels.forEach { (_ : MSFPersonaButtonSize, carousel: MSFPersonaButtonCarousel) in
            let count = carousel.count()
            if count > 0 {
                let random = Int.random(in: 0...count - 1)
                carousel.remove(at: random)
            }
        }
    }

    // MARK: - Helpers

    private func isActionButtonsSection(_ section: Int) -> Bool {
        return tableInfo[section].actionButtons
    }

    private func personaButtonSize(for section: Int) -> MSFPersonaButtonSize {
        return tableInfo[section].size
    }

    private func showsFullCarousel(at section: Int) -> Bool {
        return tableInfo[section].carousel
    }

    private func tableView(_ tableView: UITableView, controlCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.controlReuseIdentifier, for: indexPath) as! ActionsCell
        let info = actionButtons[indexPath.item]
        cell.setup(action1Title: info.title)
        cell.action1Button.addTarget(self, action: info.action, for: .touchUpInside)
        return cell
    }

    private func tableView(_ tableView: UITableView, carouselCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let size = personaButtonSize(for: indexPath.section)
        switch size {
        case .large:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.largeCarouselReuseIdentifier, for: indexPath)
        case .small:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.smallCarouselReuseIdentifier, for: indexPath)
        }

        let carousel = MSFPersonaButtonCarousel(size: size, personas: personas, theme: nil)
        carousels[size] = carousel
        carousel.delegate = self

        cell.contentView.addSubview(carousel.view)
        cell.selectionStyle = .none
        cell.backgroundColor = .tertiarySystemFill
        var constraints: [NSLayoutConstraint] = []
        carousel.view.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(contentsOf: [
            carousel.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            carousel.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            carousel.view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            carousel.view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor)
        ])

        cell.contentView.addConstraints(constraints)

        return cell
    }

    private func tableView(_ tableView: UITableView, buttonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let size = personaButtonSize(for: indexPath.section)
        switch size {
        case .large:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.largeButtonReuseIdentifier, for: indexPath)
        case .small:
            cell = tableView.dequeueReusableCell(withIdentifier: PersonaButtonCarouselDemoController.smallButtonReuseIdentifier, for: indexPath)
        }

        // Create the PersonaButton to be displayed
        let personaButton = MSFPersonaButtonView(size: size)
        let persona = personas[indexPath.item]
        personaButton.state.image = persona.avatarImage
        personaButton.state.primaryText = persona.primaryText
        personaButton.state.secondaryText = persona.secondaryText
        personaButton.state.onTapAction = { [weak self, personaButton] in
            let alert = UIAlertController(title: nil, message: "PersonaButton tapped: \(personaButton.state.primaryText ?? "(none)")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        cell.contentView.addSubview(personaButton.view)
        cell.selectionStyle = .none
        cell.backgroundColor = .tertiarySystemFill
        var constraints: [NSLayoutConstraint] = []
        personaButton.view.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(contentsOf: [
            personaButton.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            personaButton.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            personaButton.view.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
        ])

        cell.contentView.addConstraints(constraints)

        return cell
    }

    private var carousels: [MSFPersonaButtonSize: MSFPersonaButtonCarousel] = [:]

    private static let controlReuseIdentifier: String = "controlReuseIdentifier"
    private static let largeCarouselReuseIdentifier: String = "largeCarouselReuseIdentifier"
    private static let smallCarouselReuseIdentifier: String = "smallCarouselReuseIdentifier"
    private static let largeButtonReuseIdentifier: String = "largeButtonReuseIdentifier"
    private static let smallButtonReuseIdentifier: String = "smallButtonReuseIdentifier"

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
