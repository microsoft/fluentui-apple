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

            let button = makeButton(style: style,
                                    title: "Button")
            let disabledButton = makeButton(style: style,
                                            title: "Button",
                                            isEnabled: false)
            addRow(items: [button, disabledButton], itemSpacing: 20)

            if let image = style.image {
                let iconButton = makeButton(style: style,
                                            title: "Button",
                                            image: image)
                let disabledIconButton = makeButton(style: style,
                                                    title: "Button",
                                                    image: image,
                                                    isEnabled: false)
                addRow(items: [iconButton, disabledIconButton], itemSpacing: 20)

                let iconOnlyButton = makeButton(style: style,
                                                image: image)
                let disabledIconOnlyButton = makeButton(style: style,
                                                        image: image,
                                                        isEnabled: false)
                addRow(items: [iconOnlyButton, disabledIconOnlyButton], itemSpacing: 20)
            }
        }

        addTitle(text: "With multi-line title")
        let button = makeButton(style: .primaryFilled,
                                title: "Longer Text Button")
        let iconButton = makeButton(style: .primaryFilled,
                                    title: "Longer Text Button",
                                    image: ButtonStyle.primaryFilled.image)
        addRow(items: [button])
        addRow(items: [iconButton])

        container.addArrangedSubview(UIView())
    }

    private func makeButton(style: ButtonStyle, title: String? = nil, image: UIImage? = nil, isEnabled: Bool = true) -> Button {
        let button = Button(style: style)
        if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.numberOfLines = 0
        }
        if let image = image {
            button.image = image
        }
        button.isEnabled = isEnabled
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        buttons.append(button)
        return button
    }

    @objc private func handleTap() {
        let alert = UIAlertController(title: "Button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
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

        fluentTheme.register(tokenSetType: ButtonTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideButtonTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        for button in buttons {
            button.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideButtonTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: ButtonTokenSet.self) != nil
    }

    // MARK: - Custom tokens

    private var themeWideOverrideButtonTokens: [ButtonTokenSet.Tokens: ControlTokenValue] {
        let foreground = DynamicColor(light: GlobalTokens.sharedColors(.marigold, .tint40),
                                      dark: GlobalTokens.sharedColors(.marigold, .shade30))
        let background = DynamicColor(light: GlobalTokens.sharedColors(.marigold, .shade30),
                                      dark: GlobalTokens.sharedColors(.marigold, .tint40))
        let clear = DynamicColor(light: .clear)
        return [
            .titleFont: .fontInfo { FontInfo(name: "Times", size: 20.0, weight: .regular) },
            .foregroundColor: .buttonDynamicColors {
                ButtonDynamicColors(rest: foreground, hover: foreground, pressed: foreground, selected: foreground, disabled: foreground)
            },
            .backgroundColor: .buttonDynamicColors {
                ButtonDynamicColors(rest: background, hover: background, pressed: background, selected: background, disabled: background)
            },
            .borderColor: .buttonDynamicColors {
                ButtonDynamicColors(rest: clear, hover: clear, pressed: clear, selected: clear, disabled: clear)
            }
        ]
    }

    private var perControlOverrideButtonTokens: [ButtonTokenSet.Tokens: ControlTokenValue] {
        let foreground = DynamicColor(light: GlobalTokens.sharedColors(.orchid, .tint40),
                                      dark: GlobalTokens.sharedColors(.orchid, .shade30))
        let background = DynamicColor(light: GlobalTokens.sharedColors(.orchid, .shade30),
                                      dark: GlobalTokens.sharedColors(.orchid, .tint40))
        let clear = DynamicColor(light: .clear)
        return [
            .titleFont: .fontInfo { FontInfo(name: "Papyrus", size: 20.0, weight: .regular) },
            .foregroundColor: .buttonDynamicColors {
                ButtonDynamicColors(rest: foreground, hover: foreground, pressed: foreground, selected: foreground, disabled: foreground)
            },
            .backgroundColor: .buttonDynamicColors {
                ButtonDynamicColors(rest: background, hover: background, pressed: background, selected: background, disabled: background)
            },
            .borderColor: .buttonDynamicColors {
                ButtonDynamicColors(rest: clear, hover: clear, pressed: clear, selected: clear, disabled: clear)
            }
        ]
    }
}
