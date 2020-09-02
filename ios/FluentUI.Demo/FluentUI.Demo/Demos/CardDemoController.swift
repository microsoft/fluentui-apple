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
                let card = CardView(style: style, title: "Title", subtitle: "Subtitle that can be 2 lines if there isn't enough room", image: demoBackgroundImage, colorTheme: .appColor, buttonTitle: "Button Title")
                card.delegate = self

                addRow(items: [card])
            case .medium:
                let card = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, image: demoBackgroundImage, colorTheme: .appColor)
                card.delegate = self

                addRow(items: [card])
            case .small:
                let card = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, image: demoBackgroundImage, colorTheme: .appColor)
                card.delegate = self
                let cardWithCustomColors = CardView(style: style, title: "Title", subtitle: "Custom color theme", icon: demoIcon, image: demoBackgroundImage, colorTheme: .custom)
                cardWithCustomColors.customBorderColor = UIColor(light: .black, dark: .white)
                cardWithCustomColors.customSubtitleColor = Colors.textPrimary
                card.delegate = self

                addRow(items: [card, cardWithCustomColors], itemSpacing: Constants.itemSpacing)
            case .xSmallHorizontal:
                let card = CardView(style: style, title: "Title", icon: demoIcon, colorTheme: .neutral)
                card.delegate = self
                let cardWithSubtitle = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, colorTheme: .appColor)
                cardWithSubtitle.customBackgroundColor = Colors.Button.background
                cardWithSubtitle.delegate = self
                // Card with a custom background color without setting customBackgroundColor so the default background color is used
                let cardWithLongText = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very very very very long", icon: demoIcon, colorTheme: .custom)
                cardWithLongText.delegate = self

                addRow(items: [card, cardWithSubtitle], itemSpacing: Constants.itemSpacing)
                addRow(items: [cardWithLongText])
            case .xSmallVertical:
                let card = CardView(style: style, title: "Title", icon: demoIcon, colorTheme: .appColor)
                card.delegate = self
                let cardWithSubtitle = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle", icon: demoIcon, colorTheme: .neutral)
                cardWithSubtitle.delegate = self
                let cardWithLongText = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very very very very long", icon: demoIcon, colorTheme: .appColor)
                cardWithLongText.delegate = self

                addRow(items: [card, cardWithSubtitle], itemSpacing: Constants.itemSpacing)
                addRow(items: [cardWithLongText, cardWithLongText], itemSpacing: Constants.itemSpacing)
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
    func didTapCard(_ card: CardView) {
        let alert = UIAlertController(title: "Card was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
