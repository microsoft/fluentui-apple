//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: PeoplePickerSampleData

class PeoplePickerSampleData {
    struct Variant {
        let description: String
        let numberOfLines: Int
        let pickedPersonas: [Persona]
        let allowsPickedPersonasToAppearAsSuggested: Bool
        let showsSearchDirectoryButton: Bool
        let hidePersonaListViewWhenNoSuggestedPersonas: Bool

        init(description: String, numberOfLines: Int = 0, pickedPersonas: [Persona] = [], allowsPickedPersonasToAppearAsSuggested: Bool = true, showsSearchDirectoryButton: Bool = true, hidePersonaListViewWhenNoSuggestedPersonas: Bool = false) {
            self.description = description
            self.numberOfLines = numberOfLines
            self.pickedPersonas = pickedPersonas
            self.allowsPickedPersonasToAppearAsSuggested = allowsPickedPersonasToAppearAsSuggested
            self.showsSearchDirectoryButton = showsSearchDirectoryButton
            self.hidePersonaListViewWhenNoSuggestedPersonas = hidePersonaListViewWhenNoSuggestedPersonas
        }
    }

    static let variants: [Variant] = [
        Variant(description: "Standard implementation with one line of picked personas", numberOfLines: 1, pickedPersonas: [samplePersonas[0], samplePersonas[4], samplePersonas[11], samplePersonas[14]]),
        Variant(description: "Doesn't allow picked personas to appear as suggested", pickedPersonas: [samplePersonas[0], samplePersonas[8]], allowsPickedPersonasToAppearAsSuggested: false),
        Variant(description: "Hides search directory button", pickedPersonas: [samplePersonas[13]], showsSearchDirectoryButton: false, hidePersonaListViewWhenNoSuggestedPersonas: true),
        Variant(description: "Includes callback when picking a suggested persona")
    ]
}

final class AsyncImageDemoPersona: PersonaData {

    public func fetchImage(completion: @escaping (UIImage?) -> Void) {
        // for demo purposes, the "fetched" image is not being cached. The image will be "re-fetched" every time the cell appears on the screen.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let avatarImageName = "avatar_\(self.name.lowercased().replacingOccurrences(of: " ", with: "_"))"
            let image = UIImage(named: avatarImageName)
            completion(image)
        }
    }
}

var asyncImagePersonas: [AsyncImageDemoPersona] = {
    return samplePersonas.map { persona in
        AsyncImageDemoPersona(name: persona.name,
                              email: persona.email,
                              subtitle: persona.subtitle)
    }
}()

// MARK: - PeoplePickerDemoController

class PeoplePickerDemoController: DemoController {
    var peoplePickers: [PeoplePicker] = []

    private let asyncImageSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        asyncImageSwitch.addTarget(self, action: #selector(onAsyncImageSwitchValueChanged), for: .valueChanged)
        setupView()
    }

    private func setupView() {
        container.addArrangedSubview(createAsyncImageToggle())
        container.addArrangedSubview(Separator())

        for (index, variant) in PeoplePickerSampleData.variants.enumerated() {
            addDescription(text: variant.description)
            addPeoplePicker(for: variant)
            if index != PeoplePickerSampleData.variants.count - 1 {
                container.addArrangedSubview(Separator())
            }
        }
    }

    private func addPeoplePicker(for variant: PeoplePickerSampleData.Variant) {
        let peoplePicker = PeoplePicker()
        peoplePicker.label = "Send to:"
        peoplePicker.availablePersonas = samplePersonas
        peoplePicker.pickedPersonas = variant.pickedPersonas
        peoplePicker.showsSearchDirectoryButton = variant.showsSearchDirectoryButton
        peoplePicker.numberOfLines = variant.numberOfLines
        peoplePicker.allowsPickedPersonasToAppearAsSuggested = variant.allowsPickedPersonasToAppearAsSuggested
        peoplePicker.showsSearchDirectoryButton = variant.showsSearchDirectoryButton
        peoplePicker.hidePersonaListViewWhenNoSuggestedPersonas = variant.hidePersonaListViewWhenNoSuggestedPersonas
        peoplePicker.delegate = self
        peoplePickers.append(peoplePicker)
        container.addArrangedSubview(peoplePicker)
    }

    private func createAsyncImageToggle() -> UIStackView {
        let asyncImageRow = UIStackView()
        asyncImageRow.axis = .horizontal
        asyncImageRow.alignment = .center
        asyncImageRow.distribution = .equalSpacing

        let asyncImageLabel = Label(style: .subhead, colorStyle: .regular)
        asyncImageLabel.text = "Load persona images asynchronously"

        asyncImageRow.addArrangedSubview(asyncImageLabel)
        asyncImageRow.addArrangedSubview(asyncImageSwitch)
        return asyncImageRow
    }

    @objc private func onAsyncImageSwitchValueChanged() {
        for peoplePicker in peoplePickers {
            peoplePicker.availablePersonas = asyncImageSwitch.isOn ? asyncImagePersonas : samplePersonas
        }
    }
}

// MARK: - PeoplePickerDemoController: PeoplePickerDelegate

extension PeoplePickerDemoController: PeoplePickerDelegate {
    func peoplePicker(_ peoplePicker: PeoplePicker, personaFromText text: String) -> Persona {
        return samplePersonas.first { return $0.name.lowercased() == text.lowercased() } ?? PersonaData(name: text)
    }

    func peoplePicker(_ peoplePicker: PeoplePicker, personaIsValid persona: Persona) -> Bool {
        let availablePersonas = samplePersonas + searchDirectoryPersonas
        return availablePersonas.contains { $0.name == persona.name }
    }

    func peoplePicker(_ peoplePicker: PeoplePicker, didPickPersona persona: Persona) {
        if peoplePicker == peoplePickers.last {
            showMessage("\(persona.name) was picked")
        }
    }

    func peoplePicker(_ peoplePicker: PeoplePicker, didTapSelectedPersona persona: Persona) {
        peoplePicker.badge(for: persona)?.isSelected = false
        showMessage("\(persona.name) was tapped")
    }

    func peoplePicker(_ peoplePicker: PeoplePicker, searchDirectoryWithCompletion completion: @escaping ([Persona], Bool) -> Void) {
        // Delay added for 2 seconds to demo activity indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let text = peoplePicker.textFieldContent.lowercased()
            let personas = searchDirectoryPersonas.filter { $0.name.lowercased().contains(text) }
            completion(personas, true)
        }
    }

    func peoplePickerDidHidePersonaSuggestions(_ peoplePicker: PeoplePicker) {
        UIAccessibility.post(notification: .layoutChanged, argument: peoplePicker.badges.last)
    }
}
