//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonVnextDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for size in MSFButtonVnextSize.allCases {
            addTitle(text: "\(size.description.capitalized) size")
            for style in MSFButtonVnextStyle.allCases {
                addDescription(text: "\(style.description) style:", textAlignment: .natural)

                let button = MSFButtonVnext(style: style, size: size, action: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.didPressButton()
                })
                button.state.text = "Button"

                let disabledButton = MSFButtonVnext(style: style, size: size, action: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }

                    strongSelf.didPressButton()
                })
                disabledButton.state.text = "Button"
                disabledButton.state.isDisabled = true

                addRow(items: [button.view, disabledButton.view], itemSpacing: 20)

                if let image = style.image {
                    let iconButton = MSFButtonVnext(style: style, size: size) {_ in
                        self.didPressButton()
                    }
                    iconButton.state.text = "Button"
                    iconButton.state.image = image

                    let disabledIconButton = MSFButtonVnext(style: style, size: size) {_ in
                        self.didPressButton()
                    }
                    disabledIconButton.state.isDisabled = true
                    disabledIconButton.state.text = "Button"
                    disabledIconButton.state.image = image

                    addRow(items: [iconButton.view, disabledIconButton.view], itemSpacing: 20)

                    let iconOnlyButton = MSFButtonVnext(style: style, size: size, action: { [weak self] _ in
                        guard let strongSelf = self else {
                            return
                        }

                        strongSelf.didPressButton()
                    })
                    iconOnlyButton.state.image = image

                    let disabledIconOnlyButton = MSFButtonVnext(style: style, size: size, action: { [weak self] _ in
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

        addTitle(text: "Theme overriding")
        let overridingTheme = FluentUIStyle()
        let colorAP = overridingTheme.Colors
        let brandAP = colorAP.Brand
        brandAP.primary = .purple
        colorAP.Brand = brandAP

        let border = overridingTheme.Border
        let radius = border.radius
        radius.small = 0
        radius.medium = 0
        radius.large = 0
        radius.xlarge = 0
        border.radius = radius

        overridingTheme.Border = border
        overridingTheme.Colors = colorAP

        for style in MSFButtonVnextStyle.allCases {
            let customThemeButton = MSFButtonVnext(style: style,
                                                   size: .medium,
                                                   action: { [weak self] _ in
                                                    guard let strongSelf = self else {
                                                        return
                                                    }
                                                    strongSelf.didPressButton()
                                                   },
                                                   theme: overridingTheme)
            customThemeButton.state.text = "Button"
            customThemeButton.state.image = style.image

            let disabledCstomThemeButton = MSFButtonVnext(style: style,
                                                          size: .medium,
                                                          action: { [weak self] _ in
                                                            guard let strongSelf = self else {
                                                                return
                                                            }
                                                            strongSelf.didPressButton()
                                                          },
                                                          theme: overridingTheme)
            disabledCstomThemeButton.state.text = "Button"
            disabledCstomThemeButton.state.isDisabled = true

            addRow(items: [customThemeButton.view, disabledCstomThemeButton.view], itemSpacing: 20)
        }

        container.addArrangedSubview(UIView())
    }

    func didPressButton() {
        // Temporary change to exercise the scenario where the color provider is set
        // and all teh Vnext controls are refreshed accordingly.
        if let window = self.view.window {
            Colors.setProvider(provider: SceneDelegate.colorProvider, for: window)
        }

        let alert = UIAlertController(title: "A button was pressed",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension MSFButtonVnextSize {
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

extension MSFButtonVnextStyle {
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
