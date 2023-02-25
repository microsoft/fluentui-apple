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

        addLabel(text: "Text Styles", style: .body1Strong, colorStyle: .regular).textAlignment = .center

        for style in AliasTokens.TypographyTokens.allCases {
            let fontInfo = view.fluentTheme.aliasTokens.typography[style]
            let fontWeight = UIFont.fluent(fontInfo).fontDescriptor.weightDescriptor
            let detailedDescription = "\(style.description) is \(fontWeight) \(Int(fontInfo.size))pt"
            dynamicLabels.append(addLabel(text: detailedDescription, style: style, colorStyle: .regular))
        }

        container.addArrangedSubview(UIView())  // spacer

        addLabel(text: "Text Color Styles", style: .body1Strong, colorStyle: .regular).textAlignment = .center
        for colorStyle in TextColorStyle.allCases {
            textColorLabels.append(addLabel(text: colorStyle.description, style: .body1, colorStyle: colorStyle))
        }

        container.addArrangedSubview(UIView())  // spacer

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @discardableResult
    func addLabel(text: String, style: AliasTokens.TypographyTokens, colorStyle: TextColorStyle) -> Label {
        let label = Label(style: style, colorStyle: colorStyle)
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
            let fontInfo = view.fluentTheme.aliasTokens.typography[label.style]
            let fontWeight = UIFont.fluent(fontInfo).fontDescriptor.weightDescriptor
            let detailedDescription = "\(label.style.description) is \(fontWeight) \(Int(fontInfo.size))pt"
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

extension AliasTokens.TypographyTokens {
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
            .font: .fontInfo {
                return FontInfo(name: "Times", size: 20.0, weight: .regular)
            },
            .textColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.marigold, .shade30),
                                    dark: GlobalTokens.sharedColors(.marigold, .tint40))
            }
        ]
    }

    private var perControlOverrideLabelTokens: [LabelTokenSet.Tokens: ControlTokenValue] {
        return [
            .font: .fontInfo {
                return FontInfo(name: "Papyrus", size: 20.0, weight: .regular)
            },
            .textColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.orchid, .shade30))
            }
        ]
    }
}
