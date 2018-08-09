//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSLabelController: UIViewController {
    let container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        container.isLayoutMarginsRelativeArrangement = true
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addLabel(text: "Text Styles", style: .headline, colorStyle: .regular).textAlignment = .center
        for style in MSTextStyle.allCases {
            addLabel(text: style.detailedDescription, style: style, colorStyle: .regular)
        }

        container.addArrangedSubview(UIView(frame: .zero))  // spacer
        addLabel(text: "Text Color Styles", style: .headline, colorStyle: .regular).textAlignment = .center
        for colorStyle in MSTextColorStyle.allCases {
            addLabel(text: colorStyle.description, style: .body, colorStyle: colorStyle)
        }

        container.frame = view.bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(container)
    }

    @discardableResult
    func addLabel(text: String, style: MSTextStyle, colorStyle: MSTextColorStyle) -> MSLabel {
        let label = MSLabel(style: style, colorStyle: colorStyle)
        label.text = text
        if label.textColor == MSColors.white {
            label.backgroundColor = .black
        }
        container.addArrangedSubview(label)
        return label
    }
}

extension MSTextColorStyle {
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
        case .warning:
            return "Warning"
        }
    }
}

extension MSTextStyle {
    var description: String {
        switch self {
        case .title1:
            return "Title 1"
        case .title2:
            return "Title 2"
        case .headline:
            return "Headline"
        case .body:
            return "Body"
        case .subhead:
            return "Subhead"
        case .footnote:
            return "Footnote"
        case .caption1:
            return "Caption 1"
        case .caption2:
            return "Caption 2"
        }
    }
    var detailedDescription: String {
        return "\(description) is \(font.fontDescriptor.isSemibold ? "Semibold" : "Regular") \(Int(font.pointSize))pt"
    }
}

extension UIFontDescriptor {
    var isSemibold: Bool {
        if let traits = object(forKey: .traits) as? [UIFontDescriptor.TraitKey : Any], let weight = traits[.weight] as? NSNumber {
            return CGFloat(weight.floatValue) == UIFont.Weight.semibold.rawValue
        }
        return false
    }
}
