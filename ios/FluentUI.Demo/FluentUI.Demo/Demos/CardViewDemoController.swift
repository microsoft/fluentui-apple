//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class CardViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading

        let demoIcon = UIImage(named: "flag-24x24")

        for style in CardStyle.allCases {
            addTitle(text: style.description)

            switch style {
            case .horizontal:
                if let demoIcon = demoIcon {
                    let card = CardView(style: style, title: "Title", icon: demoIcon, colorStyle: .neutral)
                    card.delegate = self
                    let cardWithSubtitle = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, colorStyle: .appColor)
                    cardWithSubtitle.customBackgroundColor = .clear
                    cardWithSubtitle.delegate = self
                    let cardWithLongTitle = CardView(style: style, title: "Title that is very very very very long", icon: demoIcon, colorStyle: .appColor)
                    cardWithLongTitle.twoLineTitle = true
                    cardWithLongTitle.delegate = self
                    // Card with a custom background color without setting customBackgroundColor so the default background color is used
                    let cardLongTitleAndSubtitle = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very long", icon: demoIcon, colorStyle: .custom)
                    cardLongTitleAndSubtitle.delegate = self

                    addRow(items: [card, cardWithSubtitle], itemSpacing: Constants.itemSpacing)
                    addRow(items: [cardWithLongTitle, cardLongTitleAndSubtitle], itemSpacing: Constants.itemSpacing)
                }
            case .vertical:
                if let demoIcon = demoIcon {
                    let card = CardView(style: style, title: "Title", icon: demoIcon, colorStyle: .appColor)
                    card.delegate = self
                    let cardWithSubtitle = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, colorStyle: .neutral)
                    cardWithSubtitle.delegate = self
                    let cardWithLongTitle = CardView(style: style, title: "Title that is very very very very long", icon: demoIcon, colorStyle: .custom)
                    cardWithLongTitle.twoLineTitle = true
                    cardWithLongTitle.delegate = self
                    let cardWithLongTitleAndSubtitle = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very long", icon: demoIcon, colorStyle: .appColor)
                    cardWithLongTitleAndSubtitle.delegate = self

                    addRow(items: [card, cardWithSubtitle], itemSpacing: Constants.itemSpacing)
                    addRow(items: [cardWithLongTitle, cardWithLongTitleAndSubtitle], itemSpacing: Constants.itemSpacing)
                }
            }
        }

        container.addArrangedSubview(UIView())
    }

    private struct Constants {
        static let itemSpacing: CGFloat = 20
    }
}

extension CardStyle {
    var description: String {
        switch self {
        case .horizontal:
            return "Horizontal Card"
        case .vertical:
            return "Vertical Card"
        }
    }
}

// MARK: - CardDemoController: CardDelegate

extension CardViewDemoController: CardDelegate {
    func didTapCard(_ card: CardView) {
        let alert = UIAlertController(title: "Card was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
