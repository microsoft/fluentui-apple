//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class CardDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading

        let demoIcon = UIImage(named: "flag-24x24")
        let demoBackgroundImage = UIImage(named: "site")

        for style in CardStyle.allCases {
            addTitle(text: style.description)

            switch style {
            case .announcement:
                let card = Card(announementCardTitle: "Title", subtitle: "Subtitle that can be 2 lines if there isn't enough room", buttonTitle: "Button Title", image: demoBackgroundImage!, backgroundColor: .white)
                card.delegate = self

                addRow(items: [card])
            case .medium:
                let card = Card(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon!, image: demoBackgroundImage!, backgroundColor: CardBackgroundColor.white)
                card.delegate = self

                addRow(items: [card])
            case .small:
                let card = Card(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon!, image: demoBackgroundImage!, backgroundColor: CardBackgroundColor.white)
                card.delegate = self

                addRow(items: [card])
            case .xSmallHorizontal:
                let card = Card(simplifiedStyle: style, title: "Title", icon: demoIcon!, backgroundColor: CardBackgroundColor.appColor)
                card.delegate = self
                let cardWithSubtitle = Card(simplifiedStyle: style, title: "Title", subtitle: "Subtitle", icon: demoIcon!, backgroundColor: CardBackgroundColor.gray)
                cardWithSubtitle.delegate = self
                let cardWithLongText = Card(simplifiedStyle: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very very very very long", icon: demoIcon!, backgroundColor: CardBackgroundColor.gray)
                cardWithLongText.delegate = self

                addRow(items: [card, cardWithSubtitle], itemSpacing: 20)
                addRow(items: [cardWithLongText])
            case .xSmallVertical:
                  let card = Card(simplifiedStyle: style, title: "Title", icon: demoIcon!, backgroundColor: CardBackgroundColor.gray)
                  card.delegate = self
                  let cardWithSubtitle = Card(simplifiedStyle: style, title: "Title that is very very very very long", subtitle: "Subtitle", icon: demoIcon!, backgroundColor: CardBackgroundColor.gray)
                  cardWithSubtitle.delegate = self
                  let cardWithLongText = Card(simplifiedStyle: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very very very very long", icon: demoIcon!, backgroundColor: CardBackgroundColor.gray)
                  cardWithLongText.delegate = self

                  addRow(items: [card, cardWithSubtitle], itemSpacing: 20)
                  addRow(items: [cardWithLongText, cardWithLongText], itemSpacing: 20)
            }
        }

        container.addArrangedSubview(UIView())
    }
}

extension CardStyle {
    var description: String {
        switch self {
        case .medium:
            return "Medium"
        case .small:
            return "Small"
        case .xSmallHorizontal:
            return "Extra Small - Horizontal"
        case .xSmallVertical:
            return "Extra Small - Vertical"
        case .announcement:
            return "Announcement"
        }
    }
}

// MARK: - CardDemoController: CardDelegate

extension CardDemoController: CardDelegate {
    func didTapCard(_ card: Card) {
        let alert = UIAlertController(title: "Card was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
