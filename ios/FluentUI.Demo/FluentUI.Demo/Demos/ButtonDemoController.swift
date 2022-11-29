//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading

        for style in ButtonStyle.allCases {
            addTitle(text: style.description)

            let button = Button(style: style)
            button.setTitle("Button", for: .normal)
            buttons.append(button)

            let disabledButton = Button(style: style)
            disabledButton.isEnabled = false
            disabledButton.setTitle("Button", for: .normal)
            buttons.append(disabledButton)

            addRow(items: [button, disabledButton], itemSpacing: 20)

            if let image = style.image {
                let iconButton = Button(style: style)
                iconButton.setTitle("Button", for: .normal)
                iconButton.image = image
                buttons.append(iconButton)

                let disabledIconButton = Button(style: style)
                disabledIconButton.isEnabled = false
                disabledIconButton.setTitle("Button", for: .normal)
                disabledIconButton.image = image
                buttons.append(disabledIconButton)

                addRow(items: [iconButton, disabledIconButton], itemSpacing: 20)

                let iconOnlyButton = Button(style: style)
                iconOnlyButton.image = image
                buttons.append(iconOnlyButton)

                let disabledIconOnlyButton = Button(style: style)
                disabledIconOnlyButton.isEnabled = false
                disabledIconOnlyButton.image = image
                buttons.append(disabledIconOnlyButton)

                addRow(items: [iconOnlyButton, disabledIconOnlyButton], itemSpacing: 20)
            }
        }

        addTitle(text: "With multi-line title")
        let button = Button(style: .primaryFilled)
        button.setTitle("Longer Text Button", for: .normal)
        button.titleLabel?.numberOfLines = 0
        buttons.append(button)

        let iconButton = Button(style: .primaryFilled)
        iconButton.setTitle("Longer Text Button", for: .normal)
        iconButton.titleLabel?.numberOfLines = 0
        iconButton.image = ButtonStyle.primaryFilled.image
        buttons.append(iconButton)

        addRow(items: [button])
        addRow(items: [iconButton])

        container.addArrangedSubview(UIView())
    }

    private var buttons: [Button] = []
}

extension ButtonStyle {
    var description: String {
        switch self {
        case .borderless:
            return "Borderless"
        case .dangerFilled:
            return "Danger filled"
        case .dangerOutline:
            return "Danger outline"
        case .primaryFilled:
            return "Primary filled"
        case .primaryOutline:
            return "Primary outline"
        case .secondaryOutline:
            return "Secondary outline"
        case .tertiaryOutline:
            return "Tertiary outline"
        }
    }

    var image: UIImage? {
        switch self {
        case .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return UIImage(named: "Placeholder_24")!
        case .secondaryOutline, .borderless:
            return UIImage(named: "Placeholder_20")!
        case .tertiaryOutline:
            return nil
        }
    }
}

extension ButtonDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: ButtonTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverrideButtonTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        for button in buttons {
            button.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideButtonTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: ButtonTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens

    private var themeWideOverrideButtonTokens: [ButtonTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleFont: .fontInfo { FontInfo(name: "Times", size: 20.0, weight: .regular) },
        ]
    }

    private var perControlOverrideButtonTokens: [ButtonTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleFont: .fontInfo { FontInfo(name: "Papyrus", size: 20.0, weight: .regular) }
        ]
    }
}
