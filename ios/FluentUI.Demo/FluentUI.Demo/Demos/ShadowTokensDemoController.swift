//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ShadowTokensDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = view.fluentTheme.color(.stencil2)

        container.alignment = .center
        container.spacing = 120

        initializeShadowViews()

        container.addArrangedSubview(UIView())
    }

    private func initializeShadowViews() {
        for shadowToken in FluentTheme.ShadowToken.allCases {
            let shadowView = ShadowView(shadowInfo: container.fluentTheme.shadow(shadowToken),
                                        title: shadowToken.title)
            container.addArrangedSubview(shadowView)
        }
    }
}

// Custom View thats needs to conform to the Shadowable protocol to apply Fluent shadow tokens
private class ShadowView: UIView, Shadowable {

    init(shadowInfo: ShadowInfo, title: String) {
        self.shadowInfo = shadowInfo

        super.init(frame: .zero)

        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.cornerRadius

        backgroundColor = fluentTheme.color(.background2)

        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = fluentTheme.color(.foreground1)
        addSubview(label)

        setupLayoutConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Make sure shadows are applied in the view's layoutSubviews function
        updateShadows()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var ambientShadow: CALayer?
    var keyShadow: CALayer?

    private func updateShadows() {
        shadowInfo.applyShadow(to: self)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Constants.width),
            heightAnchor.constraint(equalToConstant: Constants.height),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private struct Constants {
        static let borderWidth: CGFloat = 0.1
        static let cornerRadius: CGFloat = 8.0
        static let width: CGFloat = 200
        static let height: CGFloat = 70
    }

    private let shadowInfo: ShadowInfo
    private let label = Label()
}

private extension FluentTheme.ShadowToken {
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
