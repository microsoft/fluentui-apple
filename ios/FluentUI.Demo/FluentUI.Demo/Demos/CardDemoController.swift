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
				let card = CardView(style: style, title: "Title", subtitle: "Subtitle that can be 2 lines if there isn't enough room", image: demoBackgroundImage, backgroundStyle: .appColor, buttonTitle: "Button Title")
                card.delegate = self

                addRow(items: [card])
            case .medium:
				let card = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, image: demoBackgroundImage, backgroundStyle: .appColor)
                card.delegate = self

                addRow(items: [card])
            case .small:
				let card = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, image: demoBackgroundImage, backgroundStyle: .appColor)
                card.delegate = self
				let cardWithCustomBackground = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, image: demoBackgroundImage, backgroundStyle: .custom)
				cardWithCustomBackground.cardBackgroundColor = Colors.Badge.backgroundWarning
                card.delegate = self

				addRow(items: [card, cardWithCustomBackground], itemSpacing: Constants.itemSpacing)
            case .xSmallHorizontal:
				let card = CardView(style: style, title: "Title", icon: demoIcon, backgroundStyle: .neutral)
                card.delegate = self
				let cardWithSubtitle = CardView(style: style, title: "Title", subtitle: "Subtitle", icon: demoIcon, backgroundStyle: .appColor)
				cardWithSubtitle.cardBackgroundColor = Colors.Button.background
                cardWithSubtitle.delegate = self
				// Card with a custom background color without setting cardBackgroundColor so the defualt background is used
				let cardWithLongText = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very very very very long", icon: demoIcon, backgroundStyle: .custom)
                cardWithLongText.delegate = self

				addRow(items: [card, cardWithSubtitle], itemSpacing: Constants.itemSpacing)
                addRow(items: [cardWithLongText])
            case .xSmallVertical:
				let card = CardView(style: style, title: "Title", icon: demoIcon, backgroundStyle: .appColor)
                  card.delegate = self
				let cardWithSubtitle = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle", icon: demoIcon, backgroundStyle: .neutral)
                  cardWithSubtitle.delegate = self
				let cardWithLongText = CardView(style: style, title: "Title that is very very very very long", subtitle: "Subtitle that is very very very very long", icon: demoIcon, backgroundStyle: .appColor)
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
