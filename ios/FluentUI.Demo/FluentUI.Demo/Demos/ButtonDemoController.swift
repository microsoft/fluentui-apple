//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for size in MSFButtonSize.allCases {
            addTitle(text: "\(size.description.capitalized) size")
            for style in MSFButtonStyle.allCases {
                addDescription(text: "\(style.description) style:", textAlignment: .natural)

                let button = MSFButton(style: style, size: size, action: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.didPressButton()
                })
                button.state.text = "Button"

                let disabledButton = MSFButton(style: style, size: size, action: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.didPressButton()
                })
                disabledButton.state.text = "Button"
                disabledButton.state.isDisabled = true

                addRow(items: [button.view, disabledButton.view], itemSpacing: 20)

                if let image = style.image {
                    let iconButton = MSFButton(style: style, size: size) {_ in
                        self.didPressButton()
                    }
                    iconButton.state.text = "Button"
                    iconButton.state.image = image

                    let disabledIconButton = MSFButton(style: style, size: size) {_ in
                        self.didPressButton()
                    }
                    disabledIconButton.state.isDisabled = true
                    disabledIconButton.state.text = "Button"
                    disabledIconButton.state.image = image

                    addRow(items: [iconButton.view, disabledIconButton.view], itemSpacing: 20)

                    let iconOnlyButton = MSFButton(style: style, size: size, action: { [weak self] _ in
                        guard let strongSelf = self else {
                            return
                        }

                        strongSelf.didPressButton()
                    })
                    iconOnlyButton.state.image = image

                    let disabledIconOnlyButton = MSFButton(style: style, size: size, action: { [weak self] _ in
                        guard let strongSelf = self else {
                            return
                        }

                        strongSelf.didPressButton()
                    })
                    disabledIconOnlyButton.state.isDisabled = true
                    disabledIconOnlyButton.state.image = image

                    addRow(items: [iconOnlyButton.view, disabledIconOnlyButton.view], itemSpacing: 20)
                }
            }
        }

        container.addArrangedSubview(UIView())
    }

    func didPressButton() {
        let alert = UIAlertController(title: "A button was pressed",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension MSFButtonSize {
    var description: String {
        switch self {
        case .large:
            return "large"
        case .medium:
            return "medium"
        case .small:
            return "small"
        }
    }
}

extension MSFButtonStyle {
    var description: String {
        switch self {
        case .primary:
            return "Primary"
        case .secondary:
            return "Secondary"
        case .ghost:
            return "Ghost"
        }
    }

    var image: UIImage? {
        switch self {
        case .primary:
            return UIImage(named: "Placeholder_24")!
        case .secondary:
            return UIImage(named: "Placeholder_20")!
        case .ghost:
            return nil
        }
    }
}
