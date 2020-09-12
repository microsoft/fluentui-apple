//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class LabelDemoController: DemoController {
    private var dynamicLabels = [Label]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addLabel(text: "Text Styles", style: .headline, colorStyle: .regular).textAlignment = .center
        for style in TextStyle.allCases {
            dynamicLabels.append(addLabel(text: style.detailedDescription, style: style, colorStyle: .regular))
        }

        container.addArrangedSubview(UIView())  // spacer

        addLabel(text: "Text Color Styles", style: .headline, colorStyle: .regular).textAlignment = .center
        for colorStyle in TextColorStyle.allCases {
            addLabel(text: colorStyle.description, style: .body, colorStyle: colorStyle)
        }

        container.addArrangedSubview(UIView())  // spacer

        addLabel(text: "Test attributed strings", style: .headline, colorStyle: .regular).textAlignment = .center
        for colorStyle in TextColorStyle.allCases {
            addAttributedStringLabel(text: "Test attributed strings", substring: "attributed", style: .footnote, colorStyle: colorStyle)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @discardableResult
    func addLabel(text: String, style: TextStyle, colorStyle: TextColorStyle) -> Label {
        let label = Label(style: style, colorStyle: colorStyle)
        label.text = text
        label.numberOfLines = 0
        if colorStyle == .white {
            label.backgroundColor = .black
        }
        container.addArrangedSubview(label)
        return label
    }

    @discardableResult
    func addAttributedStringLabel(text: String, substring: String, style: TextStyle, colorStyle: TextColorStyle) -> Label {
        let label = Label(style: style, colorStyle: colorStyle)
        label.numberOfLines = 0
        let range = (text as NSString).range(of: substring)
        let attributedString = NSMutableAttributedString(string:text)

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        label.attributedText = attributedString

        container.addArrangedSubview(label)
        return label

    }

    @objc private func handleContentSizeCategoryDidChange() {
        for label in dynamicLabels {
            label.text = label.style.detailedDescription
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
        case .warning:
            return "Warning"
        case .disabled:
            return "Disabled"
        }
    }
}

extension TextStyle {
    var description: String {
        switch self {
        case .largeTitle:
            return "Large Title"
        case .title1:
            return "Title 1"
        case .title2:
            return "Title 2"
        case .headline:
            return "Headline"
        case .headlineUnscaled:
            return "Headline Unscaled"
        case .body:
            return "Body"
        case .bodyUnscaled:
            return "Body Unscaled"
        case .subhead:
            return "Subhead"
        case .footnote:
            return "Footnote"
        case .footnoteUnscaled:
            return "Footnote Unscaled"
        case .button1:
            return "Button 1"
        case .button2:
            return "Button 2"
        case .button3:
            return "Button 3"
        case .caption1:
            return "Caption 1"
        case .caption2:
            return "Caption 2"
        }
    }
    var detailedDescription: String {
        let weight: String
        switch font.fontDescriptor.weight {
        case .bold:
            weight = "Bold"
        case .semibold:
            weight = "Semibold"
        case .medium:
            weight = "Medium"
        default:
            weight = "Regular"
        }
        return "\(description) is \(weight) \(Int(font.pointSize))pt"
    }
}

extension UIFontDescriptor {
    var weight: UIFont.Weight {
        let traits = object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        if let weight = traits?[.weight] as? NSNumber {
            return UIFont.Weight(CGFloat(weight.floatValue))
        }
        return .regular
    }
}
