//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ShadowTokensDemoController: DemoController {
    var cards: [CardView] = []

    private lazy var segmentedControl: SegmentedControl = {
        let tabTitles = Constants.titles
        let segmentedControl = SegmentedControl(items: tabTitles.map({ return SegmentItem(title: $0) }),
                                                style: .primaryPill)
        segmentedControl.addTarget(self,
                                   action: #selector(updateShadows),
                                   for: .valueChanged)
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        container.backgroundColor = UIColor(dynamicColor: view.fluentTheme.aliasTokens.colors[.stencil2])

        navigationItem.titleView = segmentedControl
        container.alignment = .center
        container.spacing = Constants.spacing

        initCards()
        updateShadows()

        container.addArrangedSubview(UIView())
    }

    private func initCards() {
        let demoIcon = UIImage(named: "flag-24x24")

        for shadow in AliasTokens.ShadowTokens.allCases {
            let card = CardView(size: .large, title: shadow.title, icon: demoIcon!, colorStyle: .neutral)
            cards.append(card)
            container.addArrangedSubview(card)
        }
    }

    @objc private func updateShadows() {
        for index in 0..<AliasTokens.ShadowTokens.allCases.count {
            let shadowInfo = view.fluentTheme.aliasTokens.shadow[AliasTokens.ShadowTokens.allCases[index]]
            applyShadow(shadowInfo, for: cards[index], isShadowOne: segmentedControl.selectedSegmentIndex == 0)
        }
    }

    private func applyShadow(_ shadow: ShadowInfo, for view: UIView, isShadowOne: Bool = false) {
        view.layer.shadowColor = UIColor(dynamicColor: isShadowOne ? shadow.colorOne : shadow.colorTwo).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = isShadowOne ? shadow.blurOne : shadow.blurTwo
        view.layer.shadowOffset = CGSize(width: isShadowOne ? shadow.xOne : shadow.xTwo,
                                         height: isShadowOne ? shadow.yOne : shadow.yTwo)
    }

    private struct Constants {
        static let titles: [String] = ["Shadow 1", "Shadow 2"]
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
