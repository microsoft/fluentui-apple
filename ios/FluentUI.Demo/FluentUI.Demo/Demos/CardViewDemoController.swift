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

        for size in CardSize.allCases {
            addTitle(text: size.description)

            switch size {
            case .small:
                if let demoIcon = demoIcon {
                    let card = CardView(
                        size: size,
                        title: "Title",
                        icon: demoIcon,
                        colorStyle: .neutral)
                    card.delegate = self
                    let cardWithSubtitle = CardView(
                        size: size,
                        title: "Title",
                        subtitle: "Subtitle",
                        icon: demoIcon,
                        colorStyle: .appColor)
                    cardWithSubtitle.customBackgroundColor = Colors.Button.background
                    cardWithSubtitle.delegate = self
                    let cardWithLongTitle = CardView(
                        size: size,
                        title: "Title that is very very very very long",
                        icon: demoIcon,
                        colorStyle: .appColor)
                    cardWithLongTitle.twoLineTitle = true
                    cardWithLongTitle.delegate = self
                    // Card with a custom background color without setting customBackgroundColor so the default background color is used
                    let cardLongTitleAndSubtitle = CardView(
                        size: size,
                        title: "Title that is very very very very long",
                        subtitle: "Subtitle that is very long",
                        icon: demoIcon,
                        colorStyle: .custom)
                    cardLongTitleAndSubtitle.delegate = self

                    addRow(items: [card, cardWithSubtitle], itemSpacing: Constants.itemSpacing)
                    addRow(items: [cardWithLongTitle, cardLongTitleAndSubtitle], itemSpacing: Constants.itemSpacing)
                }
            case .large:
                if let demoIcon = demoIcon {
                    let card = CardView(
                        size: size,
                        title: "Title",
                        icon: demoIcon,
                        colorStyle: .appColor)
                    card.delegate = self
                    let cardWithSubtitle = CardView(
                        size: size,
                        title: "Title",
                        subtitle: "Subtitle",
                        icon: demoIcon,
                        colorStyle: .neutral)
                    cardWithSubtitle.delegate = self
                    let cardWithLongTitle = CardView(
                        size: size,
                        title: "Title that is very very very very very long",
                        icon: demoIcon,
                        colorStyle: .custom)
                    cardWithLongTitle.twoLineTitle = true
                    cardWithLongTitle.delegate = self
                    let cardWithLongTitleAndSubtitle = CardView(
                        size: size,
                        title: "Title that is very very very very long",
                        subtitle: "Subtitle that is very long",
                        icon: demoIcon,
                        colorStyle: .appColor)
                    cardWithLongTitleAndSubtitle.delegate = self

                    addRow(items: [card])
                    addRow(items: [cardWithSubtitle])
                    addRow(items: [cardWithLongTitle])
                    addRow(items: [cardWithLongTitleAndSubtitle])
                }
            }
        }

        container.addArrangedSubview(UIView())
    }

    private struct Constants {
        static let itemSpacing: CGFloat = 20
    }
}

extension CardSize {
    var description: String {
        switch self {
        case .small:
            return "Small Card"
        case .large:
            return "Large Card"
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
