//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ShadowTokensDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(dynamicColor: view.fluentTheme.aliasTokens.colors[.stencil2])

        container.alignment = .center
        container.spacing = 120
        initCards()

        container.addArrangedSubview(UIView())
    }

    private func initCards() {
        for shadow in AliasTokens.ShadowTokens.allCases {
            let view = ShadowView(shadowInfo: container.fluentTheme.aliasTokens.shadow[shadow],
                                  title: shadow.title)
            container.addArrangedSubview(view)
        }
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

class ShadowView: UIView, Shadowable {
    var shadow1: CALayer?
    var shadow2: CALayer?

    let shadowInfo: ShadowInfo
    let label = Label()

    init(shadowInfo: ShadowInfo, title: String) {
        self.shadowInfo = shadowInfo

        super.init(frame: .zero)

        layer.borderWidth = 0.1
        layer.cornerRadius = 8.0

        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
        addSubview(label)

        backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background2])
        setupLayoutConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadows()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateShadows() {
        shadowInfo.applyShadow(to: self)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 150),
            heightAnchor.constraint(equalToConstant: 70),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
