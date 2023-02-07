//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TextFieldDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let textField1 = FluentTextField()
        textField1.placeholder = "Validates text on each input character"
        textField1.leadingImage = UIImage(named: "Placeholder_24")
        textField1.onEditingChanged = onEditingChanged

        let textField2 = FluentTextField()
        textField2.placeholder = "Hint text"
        textField2.leadingImage = UIImage(named: "Placeholder_24")
        textField2.labelText = "Changes leading image on selection"
        textField2.assistiveText = "Validates text on selection and deselection"
        textField2.onDidBeginEditing = onDidBeginEditing
        textField2.onDidEndEditing = onDidEndEditing

        let textField3 = FluentTextField()
        textField3.placeholder = "Hint text"
        textField3.assistiveText = "Validates on press of return key"
        textField3.onReturn = onReturn

        let objcDemoButton = Button(style: .outline)
        objcDemoButton.setTitle("Show Objective C Demo", for: .normal)
        objcDemoButton.addTarget(self, action: #selector(showObjCDemo), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [textField1, textField2, textField3, objcDemoButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: stack.topAnchor),
            safeArea.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: stack.trailingAnchor)
        ])
    }

    func validateText(_ textfield: FluentTextField) -> FluentTextInputError? {
        guard let text = textfield.text else {
            return FluentTextInputError(localizedDescription: "Input text must exist?")
        }
        if text.contains("/") {
            return FluentTextInputError(localizedDescription: "Input text cannot contain the following characters: /")
        }
        return nil
    }

    func onEditingChanged (_ textfield: FluentTextField) {
        textfield.error = validateText(textfield)
    }

    func onDidBeginEditing(_ textfield: FluentTextField) {
        if let image = UIImage(named: "play-in-circle-24x24") {
            textfield.leadingImage = image.withRenderingMode(.alwaysTemplate)
        }
        textfield.error = validateText(textfield)
    }

    func onDidEndEditing(_ textfield: FluentTextField) {
        textfield.leadingImage = UIImage(named: "Placeholder_24")
        textfield.error = validateText(textfield)
    }

    func onReturn(_ textfield: FluentTextField) -> Bool {
        let error = validateText(textfield)
        textfield.error = error
        return error != nil
    }

    @objc func showObjCDemo(sender: Button) {
        navigationController?.pushViewController(TextFieldObjCDemoController(), animated: true)
    }
}
