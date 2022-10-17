//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ShadowTokensDemoController: DemoController {
    var cards: [CardView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        container.backgroundColor = UIColor(dynamicColor: view.fluentTheme.aliasTokens.colors[.stencil2])

        container.alignment = .center
        container.spacing = Constants.spacing

        initCards()

        container.addArrangedSubview(UIView())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateShadows()
    }

    private func initCards() {
        let demoIcon = UIImage(named: "flag-24x24")

        for shadow in AliasTokens.ShadowTokens.allCases {
            let card = CardView(size: .large, title: shadow.title, icon: demoIcon!, colorStyle: .neutral)
            cards.append(card)
            container.addArrangedSubview(card)
        }
    }

    private func updateShadows() {
        for index in 0..<AliasTokens.ShadowTokens.allCases.count {
            let shadowInfo = view.fluentTheme.aliasTokens.shadow[AliasTokens.ShadowTokens.allCases[index]]
            ShadowUtil.applyShadow(shadowInfo, for: cards[index])
        }
    }

    private struct Constants {
        static let spacing: CGFloat = 120
    }
}

private extension AliasTokens.ShadowTokens {
    var title: String {
        switch self {
        case .clear:
            return "Clear"
        case .shadow02:
            return "Shadow02"
        case .shadow04:
            return "Shadow04"
        case .shadow08:
            return "Shadow08"
        case .shadow16:
            return "Shadow16"
        case .shadow28:
            return "Shadow28"
        case .shadow64:
            return "Shadow64"
        }
    }
}
