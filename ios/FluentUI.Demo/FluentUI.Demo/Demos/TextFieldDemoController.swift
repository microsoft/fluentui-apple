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
        textField1.placeholder = "Hint text"

        let textField2 = FluentTextField()
        textField2.placeholder = "Hint text"
        textField2.leadingImage = UIImage(named: "Placeholder_24")

        let textField3 = FluentTextField()
        textField3.placeholder = "Hint text"
        textField3.leadingImage = UIImage(named: "Placeholder_24")
        textField3.labelText = "Label"
//        textField3.assistiveText = "Assistive text"
        textField3.assistiveText = "Really long assitive text to test what happens when you have a really long assistive text. Does it have a good linebreak strat?"

        let stack = UIStackView(arrangedSubviews: [textField1, textField2, textField3])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: stack.topAnchor),
            safeArea.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])
    }
}
