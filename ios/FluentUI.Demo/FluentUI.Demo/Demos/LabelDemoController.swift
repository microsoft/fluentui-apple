//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class LabelDemoController: DemoController {
    private var dynamicLabels = [Label]()
    private var textColorLabels = [Label]()

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "Labels are used to standardize text across your app."

        addTitle(text: "Text Styles")

        for style in FluentTheme.TypographyToken.allCases {
            let font = view.fluentTheme.typography(style)
            let fontWeight = font.fontDescriptor.weightDescriptor
            let detailedDescription = "\(style.description) is \(fontWeight) \(Int(font.pointSize))pt"
            dynamicLabels.append(addLabel(text: detailedDescription, style: style, colorStyle: .regular))
        }

        container.addArrangedSubview(UIView())  // spacer

        addTitle(text: "Text Color Styles")
        for colorStyle in TextColorStyle.allCases {
            textColorLabels.append(addLabel(text: colorStyle.description, style: .body1, colorStyle: colorStyle))
        }

        addTitle(text: "Text Color Custom Styles")

        let dangerSuccessLabel = Label(textStyle: .body1Strong, colorForTheme: {
            theme in
            UIColor(light: theme.color(.dangerForeground1), dark: theme.color(.successBackground2))
        })
        dangerSuccessLabel.text = "Danger/Success"
        container.addArrangedSubview(dangerSuccessLabel)
        textColorLabels.append(dangerSuccessLabel)

        let blueYellowLabel = Label(textStyle: .body1Strong, colorForTheme: {
            _ in
            UIColor(light: GlobalTokens.sharedColor(.blue, .primary), dark: GlobalTokens.sharedColor(.yellow, .primary))
        })
        blueYellowLabel.text = "Blue/Yellow"
        container.addArrangedSubview(blueYellowLabel)
        textColorLabels.append(blueYellowLabel)

        container.addArrangedSubview(UIView())  // spacer

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @discardableResult
    func addLabel(text: String, style: FluentTheme.TypographyToken, colorStyle: TextColorStyle) -> Label {
        let label = Label(textStyle: style, colorStyle: colorStyle)
        label.text = text
        label.numberOfLines = 0
        if colorStyle == .white {
            label.backgroundColor = .black
        }
        container.addArrangedSubview(label)
        return label
    }

    @objc private func handleContentSizeCategoryDidChange() {
        for label in dynamicLabels {
            let font = view.fluentTheme.typography(label.textStyle)
            let fontWeight = font.fontDescriptor.weightDescriptor
            let detailedDescription = "\(label.textStyle.description) is \(fontWeight) \(Int(font.pointSize))pt"
            label.text = detailedDescription
        }
    }
}

extension TextColorStyle {
    var description: String {
        switch self {
        case .regular:
            return "Regular"
        case .secondary:
            return "Secondary"
        case .white:
            return "White"
        case .primary:
            return "Primary"
        case .error:
            return "Error"
        }
    }
}

extension FluentTheme.TypographyToken {
    var description: String {
        switch self {
        case .display:
            return "Display"
        case .largeTitle:
            return "Large Title"
        case .title1:
            return "Title 1"
        case .title2:
            return "Title 2"
        case .title3:
            return "Title 3"
        case .body1Strong:
            return "Body 1 Strong"
        case .body1:
            return "Body 1"
        case .body2Strong:
            return "Body 2 Strong"
        case .body2:
            return "Body 2"
        case .caption1Strong:
            return "Caption 1 Strong"
        case .caption1:
            return "Caption 1"
        case .caption2:
            return "Caption 2"
        }
    }
}

extension UIFontDescriptor {
    var weightDescriptor: String {
        let traits = object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        if let weight = traits?[.weight] as? NSNumber {
            let fontWeight = UIFont.Weight(CGFloat(weight.floatValue))
            switch fontWeight {
            case .bold:
                return "Bold"
            case .semibold:
                return "Semibold"
            case .medium:
                return "Medium"
            default:
                return "Regular"
            }
        }
        return "Regular"
    }
}

extension LabelDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: LabelTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideLabelTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        for label in dynamicLabels {
            if isOverrideEnabled {
                label.tokenSet[.font] = perControlOverrideLabelTokens[.font] ?? label.tokenSet[.font]
            } else {
                label.tokenSet.removeOverride(.font)
            }
        }

        for label in textColorLabels {
            if isOverrideEnabled {
                label.tokenSet[.textColor] = perControlOverrideLabelTokens[.textColor] ?? label.tokenSet[.textColor]
            } else {
                label.tokenSet.removeOverride(.textColor)
            }
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: LabelTokenSet.self) != nil
    }

    // MARK: - Custom tokens

    private var themeWideOverrideLabelTokens: [LabelTokenSet.Tokens: ControlTokenValue] {
        return [
            .font: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 20.0),
                              size: 20.0)
            },
            .textColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.marigold, .shade30),
                               dark: GlobalTokens.sharedColor(.marigold, .tint40))
            }
        ]
    }

    private var perControlOverrideLabelTokens: [LabelTokenSet.Tokens: ControlTokenValue] {
        return [
            .font: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0),
                              size: 20.0)
            },
            .textColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .shade30))
            }
        ]
    }
}
