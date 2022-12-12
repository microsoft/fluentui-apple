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
            for size in ButtonSize.allCases {
                addTitle(text: style.description + ", " + size.description)

                let button = createButton(with: style,
                                          size: size,
                                          title: "Text")
                let disabledButton = createButton(with: style,
                                                  size: size,
                                                  title: "Text",
                                                  isEnabled: false)
                let titleButtonStack = UIStackView(arrangedSubviews: [button, disabledButton])
                titleButtonStack.spacing = 20
                titleButtonStack.distribution = .fillProportionally
                container.addArrangedSubview(titleButtonStack)

                if let image = size.image {
                    let iconButton = createButton(with: style,
                                                  size: size,
                                                  title: "Text",
                                                  image: image)
                    let disabledIconButton = createButton(with: style,
                                                          size: size,
                                                          title: "Text",
                                                          image: image,
                                                          isEnabled: false)
                    let titleImageButtonStack = UIStackView(arrangedSubviews: [iconButton, disabledIconButton])
                    titleImageButtonStack.spacing = 20
                    titleImageButtonStack.distribution = .fillProportionally
                    container.addArrangedSubview(titleImageButtonStack)

                    let iconOnlyButton = createButton(with: style,
                                                      size: size,
                                                      image: image)
                    let disabledIconOnlyButton = createButton(with: style,
                                                              size: size,
                                                              image: image,
                                                              isEnabled: false)
                    let imageButtonStack = UIStackView(arrangedSubviews: [iconOnlyButton, disabledIconOnlyButton])
                    imageButtonStack.spacing = 20
                    imageButtonStack.distribution = .fillProportionally
                    container.addArrangedSubview(imageButtonStack)
                }
            }
        }

        addTitle(text: "With multi-line title")
        let button = createButton(with: .accent,
                                  title: "Longer Text Button")
        let iconButton = createButton(with: .accent,
                                      title: "Longer Text Button",
                                      image: ButtonSize.large.image)
        addRow(items: [button])
        addRow(items: [iconButton])

        container.addArrangedSubview(UIView())
    }

    private func createButton(with style: ButtonStyle, size: ButtonSize = .large, title: String? = nil, image: UIImage? = nil, isEnabled: Bool = true) -> Button {
        let button = Button(style: style)
        button.size = size
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
        case .accent:
            return "Accent"
        case .outline:
            return "Outline"
        case .subtle:
            return "Subtle"
        case .danger:
            return "Danger"
        case .dangerOutline:
            return "Danger outline"
        case .dangerSubtle:
            return "Danger subtle"
        }
    }
}

extension ButtonSize {
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

    var image: UIImage? {
        switch self {
        case .large, .medium:
            return UIImage(named: "Placeholder_20")!
        case .small:
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
        return [
            .titleFont: .fontInfo { FontInfo(name: "Times", size: 20.0, weight: .regular) },
            .backgroundColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.marigold, .shade30),
                                    dark: GlobalTokens.sharedColors(.marigold, .tint40))
            },
            .borderColor: .dynamicColor { DynamicColor(light: .clear) },
            .foregroundColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.marigold, .tint40),
                                    dark: GlobalTokens.sharedColors(.marigold, .shade30))
            }
        ]
    }

    private var perControlOverrideButtonTokens: [ButtonTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleFont: .fontInfo { FontInfo(name: "Papyrus", size: 20.0, weight: .regular) },
            .backgroundColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.orchid, .shade30),
                                    dark: GlobalTokens.sharedColors(.orchid, .tint40))
            },
            .borderColor: .dynamicColor { DynamicColor(light: .clear) },
            .foregroundColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.orchid, .tint40),
                                    dark: GlobalTokens.sharedColors(.orchid, .shade30))
            }
        ]
    }
}
