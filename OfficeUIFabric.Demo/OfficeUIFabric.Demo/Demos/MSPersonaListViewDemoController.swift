//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

let samplePersonas: [MSPersonaData] = [
    MSPersonaData(name: "Kat Larrson", email: "kat.larrson@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_kat_larsson")),
    MSPersonaData(name: "Kristin Patterson", email: "kristin.patterson@contoso.com", subtitle: "Software Engineer"),
    MSPersonaData(name: "Ashley McCarthy", avatarImage: UIImage(named: "avatar_ashley_mccarthy")),
    MSPersonaData(name: "Carole Poland", email: "carole.poland@contoso.com", subtitle: "Software Engineer"),
    MSPersonaData(name: "Allan Munger", email: "allan.munger@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_allan_munger")),
    MSPersonaData(name: "Amanda Brady", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_amanda_brady")),
    MSPersonaData(name: "Kevin Sturgis", email: "kevin.sturgis@contoso.com", subtitle: "Software Engineeer"),
    MSPersonaData(name: "Lydia Bauer", email: "lydia.bauer@contoso.com", avatarImage: UIImage(named: "avatar_lydia_bauer")),
    MSPersonaData(name: "Robin Counts", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_robin_counts")),
    MSPersonaData(name: "Tim Deboer", email: "tim.deboer@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_tim_deboer")),
    MSPersonaData(email: "wanda.howard@contoso.com", subtitle: "Director"),
    MSPersonaData(name: "Daisy Phillips", email: "daisy.phillips@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_daisy_phillips")),
    MSPersonaData(name: "Katri Ahokas", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_katri_ahokas")),
    MSPersonaData(name: "Colin Ballinger", email: "colin.ballinger@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_colin_ballinger")),
    MSPersonaData(name: "Mona Kane", email: "mona.kane@contoso.com", subtitle: "Designer"),
    MSPersonaData(name: "Elvia Atkins", email: "elvia.atkins@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_elvia_atkins")),
    MSPersonaData(name: "Johnie McConnell", subtitle: "Designer", avatarImage: UIImage(named: "avatar_johnie_mcconnell")),
    MSPersonaData(name: "Charlotte Waltsson", email: "charlotte.waltsson@contoso.com", subtitle: "Software Engineer"),
    MSPersonaData(name: "Mauricio August", email: "mauricio.august@contoso.com", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_mauricio_august")),
    MSPersonaData(name: "Robert Tolbert", email: "robert.tolbert@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_robert_tolbert")),
    MSPersonaData(name: "Isaac Fielder", subtitle: "Designer", avatarImage: UIImage(named: "avatar_isaac_fielder")),
    MSPersonaData(name: "Elliot Woodward", subtitle: "Designer"),
    MSPersonaData(email: "carlos.slattery@contoso.com", subtitle: "Software Engineer"),
    MSPersonaData(name: "Henry Brill", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_henry_brill")),
    MSPersonaData(name: "Cecil Folk", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_cecil_folk"))
]

class MSPersonaListViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let personaListView = MSPersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.showsSearchDirectoryButton = true
        personaListView.searchDirectoryDelegate = self
        personaListView.accessoryType = .disclosureIndicator
        personaListView.onPersonaSelected = { [unowned self] persona in
            let name = !persona.name.isEmpty ? persona.name : persona.email
            let alert = UIAlertController(title: "\(name) selected", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        view.addSubview(personaListView)
        personaListView.fitIntoSuperview()
    }
}

// MARK: - MSPersonaListViewDemoController: MSPersonaListViewSearchDirectoryDelegate

extension MSPersonaListViewDemoController: MSPersonaListViewSearchDirectoryDelegate {
    func personaListSearchDirectory(_ personaListView: MSPersonaListView, completion: @escaping ((_ success: Bool) -> Void)) {
        // Delay added for 2 seconds to demo activity indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let personas: [MSPersona] = [
                MSPersonaData(name: "Celeste Burton", email: "celeste.burton@contoso.com", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_celeste_burton")),
                MSPersonaData(name: "Erik Nason", email: "erik.nason@contoso.com", subtitle: "Designer"),
                MSPersonaData(name: "Miguel Garcia", email: "miguel.garcia@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_miguel_garcia"))
            ]
            personaListView.personaList = personas
            completion(true)
        }
    }
}
