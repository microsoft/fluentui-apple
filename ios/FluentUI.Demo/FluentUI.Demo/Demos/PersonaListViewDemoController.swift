//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

let samplePersonas: [PersonaData] = [
    PersonaData(name: "Kat Larrson", email: "kat.larrson@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_kat_larsson"), color: Colors.Palette.cyanBlue10.color),
    PersonaData(name: "Kristin Patterson", email: "kristin.patterson@contoso.com", subtitle: "Software Engineer", color: Colors.Palette.red10.color),
    PersonaData(name: "Ashley McCarthy", avatarImage: UIImage(named: "avatar_ashley_mccarthy"), color: Colors.Palette.magenta20.color),
    PersonaData(name: "Allan Munger", email: "allan.munger@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_allan_munger"), color: Colors.Palette.green10.color),
    PersonaData(name: "Amanda Brady", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_amanda_brady"), color: Colors.Palette.magentaPink10.color),
    PersonaData(name: "Kevin Sturgis", email: "kevin.sturgis@contoso.com", subtitle: "Software Engineeer", color: Colors.Palette.cyanBlue20.color),
    PersonaData(name: "Lydia Bauer", email: "lydia.bauer@contoso.com", avatarImage: UIImage(named: "avatar_lydia_bauer"), color: Colors.Palette.orange20.color),
    PersonaData(name: "Robin Counts", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_robin_counts"), color: Colors.Palette.cyan20.color),
    PersonaData(name: "Tim Deboer", email: "tim.deboer@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_tim_deboer"), color: Colors.Palette.orangeYellow20.color),
    PersonaData(email: "wanda.howard@contoso.com", subtitle: "Director", color: Colors.Palette.red20.color),
    PersonaData(name: "Daisy Phillips", email: "daisy.phillips@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_daisy_phillips"), color: Colors.Palette.blue10.color),
    PersonaData(name: "Katri Ahokas", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_katri_ahokas"), color: Colors.Palette.magenta10.color),
    PersonaData(name: "Colin Ballinger", email: "colin.ballinger@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_colin_ballinger"), color: Colors.Palette.gray40.color),
    PersonaData(name: "Mona Kane", email: "mona.kane@contoso.com", subtitle: "Designer", color: Colors.Palette.green20.color),
    PersonaData(name: "Elvia Atkins", email: "elvia.atkins@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_elvia_atkins"), color: Colors.Palette.blueMagenta20.color),
    PersonaData(name: "Johnie McConnell", subtitle: "Designer", avatarImage: UIImage(named: "avatar_johnie_mcconnell"), color: Colors.Palette.pinkRed10.color),
    PersonaData(name: "Charlotte Waltsson", email: "charlotte.waltsson@contoso.com", subtitle: "Software Engineer", color: Colors.Palette.gray30.color),
    PersonaData(name: "Mauricio August", email: "mauricio.august@contoso.com", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_mauricio_august"), color: Colors.Palette.blueMagenta30.color),
    PersonaData(name: "Robert Tolbert", email: "robert.tolbert@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_robert_tolbert"), color: Colors.Palette.gray20.color),
    PersonaData(name: "Isaac Fielder", subtitle: "Designer", avatarImage: UIImage(named: "avatar_isaac_fielder"), color: Colors.Palette.cyan30.color),
    PersonaData(name: "Carole Poland", email: "carole.poland@contoso.com", subtitle: "Software Engineer", color: Colors.Palette.orange30.color),
    PersonaData(name: "Elliot Woodward", subtitle: "Designer", color: Colors.Palette.cyanBlue10.color),
    PersonaData(email: "carlos.slattery@contoso.com", subtitle: "Software Engineer", color: Colors.Palette.red10.color),
    PersonaData(name: "Henry Brill", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_henry_brill"), color: Colors.Palette.magenta20.color),
    PersonaData(name: "Cecil Folk", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_cecil_folk"), color: Colors.Palette.green10.color),
    PersonaData(name: "+1 (425) 123 4567", color: Colors.Palette.magentaPink10.color)
]

let searchDirectoryPersonas: [PersonaData] = [
    PersonaData(name: "Celeste Burton", email: "celeste.burton@contoso.com", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_celeste_burton")),
    PersonaData(name: "Erik Nason", email: "erik.nason@contoso.com", subtitle: "Designer"),
    PersonaData(name: "Miguel Garcia", email: "miguel.garcia@contoso.com", subtitle: "Software Engineer", avatarImage: UIImage(named: "avatar_miguel_garcia"))
]

class PersonaListViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let personaListView = PersonaListView()
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
        personaListView.frame = view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// MARK: - PersonaListViewDemoController: PersonaListViewSearchDirectoryDelegate

extension PersonaListViewDemoController: PersonaListViewSearchDirectoryDelegate {
    func personaListSearchDirectory(_ personaListView: PersonaListView, completion: @escaping ((_ success: Bool) -> Void)) {
        // Delay added for 2 seconds to demo activity indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            personaListView.personaList = searchDirectoryPersonas
            completion(true)
        }
    }
}
