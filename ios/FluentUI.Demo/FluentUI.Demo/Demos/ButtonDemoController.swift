//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "A button triggers a single action or event.\n\nUse buttons for important actions like submitting a response, committing a change, or moving to the next step. If you need to navigate to another place, try a link instead."

        container.alignment = .leading

        addTitle(text: "SwiftUI Button Demo")
        container.addArrangedSubview(createButton(title: "Show", action: #selector(showSwiftUIDemo)))

        for style in ButtonStyle.allCases {
            for size in ButtonSizeCategory.allCases {
                if style.isFloating && size == .medium {
                    continue
                }

                addTitle(text: style.description + ", " + size.description)

                let button = createButton(with: style,
                                          sizeCategory: size,
                                          title: "Text")
                let disabledButton = createButton(with: style,
                                                  sizeCategory: size,
                                                  title: "Text",
                                                  isEnabled: false)
                let titleButtonStack = UIStackView(arrangedSubviews: [button, disabledButton])
                titleButtonStack.spacing = 20
                titleButtonStack.distribution = .fillProportionally
                container.addArrangedSubview(titleButtonStack)

                if let image = style.image ?? size.image {
                    let iconButton = createButton(with: style,
                                                  sizeCategory: size,
                                                  title: "Text",
                                                  image: image)
                    let disabledIconButton = createButton(with: style,
                                                          sizeCategory: size,
                                                          title: "Text",
                                                          image: image,
                                                          isEnabled: false)
                    let titleImageButtonStack = UIStackView(arrangedSubviews: [iconButton, disabledIconButton])
                    titleImageButtonStack.spacing = 20
                    titleImageButtonStack.distribution = .fillProportionally
                    container.addArrangedSubview(titleImageButtonStack)

                    let iconOnlyButton = createButton(with: style,
                                                      sizeCategory: size,
                                                      image: image)
                    let disabledIconOnlyButton = createButton(with: style,
                                                              sizeCategory: size,
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
                                      image: ButtonSizeCategory.large.image)
        addRow(items: [button])
        addRow(items: [iconButton])

        container.addArrangedSubview(UIView())

        let customButton = createButton(with: .accent, sizeCategory: .small, title: "ToolBar Test Button")
        customButton.tokenSet[.titleFont] = .uiFont { [weak self] in
            let theme = self?.view.fluentTheme ?? FluentTheme.shared
            return theme.typography(.caption1Strong, adjustsForContentSizeCategory: false)
        }
        customButton.showsLargeContentViewer = true
        let buttonBarItem = UIBarButtonItem.init(customView: customButton)
        customButton.sizeToFit()
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            buttonBarItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    private func createButton(with style: ButtonStyle, sizeCategory: ButtonSizeCategory = .large, title: String? = nil, image: UIImage? = nil, isEnabled: Bool = true) -> Button {
        let button = Button(style: style)
        button.sizeCategory = sizeCategory
        if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.numberOfLines = 0
            if style.isFloating {
                button.showsLargeContentViewer = true
            }
        } else {
            button.showsLargeContentViewer = true
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
        case .outlineAccent:
            return "Outline accent"
        case .outlineNeutral:
            return "Outline neutral"
        case .subtle:
            return "Subtle"
        case .transparentNeutral:
            return "Transparent neutral"
        case .danger:
            return "Danger"
        case .dangerOutline:
            return "Danger outline"
        case .dangerSubtle:
            return "Danger subtle"
        case .floatingAccent:
            return "Floating accent"
        case .floatingSubtle:
            return "Floating subtle"
        case .outline:
            return "Outline accent"
        }
    }

    var image: UIImage? {
        switch self.isFloating {
        case true:
            return UIImage(named: "Placeholder_24")!
        case false:
            return nil
        }
    }
}

extension ButtonSizeCategory {
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
            .titleFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 20.0),
                              size: 20.0)
            },
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.marigold, .shade30),
                               dark: GlobalTokens.sharedColor(.marigold, .tint40))
            },
            .borderColor: .uiColor { .clear },
            .foregroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.marigold, .tint40),
                               dark: GlobalTokens.sharedColor(.marigold, .shade30))
            }
        ]
    }

    private var perControlOverrideButtonTokens: [ButtonTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0),
                              size: 20.0)
            },
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .shade30),
                               dark: GlobalTokens.sharedColor(.orchid, .tint40))
            },
            .borderColor: .uiColor { .clear },
            .foregroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .tint40),
                               dark: GlobalTokens.sharedColor(.orchid, .shade30))
            }
        ]
    }

    @objc private func showSwiftUIDemo() {
        navigationController?.pushViewController(ButtonDemoControllerSwiftUI(),
                                                 animated: true)
    }
}
