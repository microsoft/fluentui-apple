//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButtonGroupView: UIView {
    let buttons: [CommandBarButton]

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constants.buttonPadding

        return stackView
    }()

    init(buttons: [CommandBarButton]) {
        self.buttons = buttons

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
        if #available(iOS 13, *) {
            layer.cornerCurve = .continuous
        }

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAppearance(_ appearance: CommandBarButtonAppearance) {
        buttons.forEach { $0.updateAppearance(appearance) }
    }
}

private extension CommandBarButtonGroupView {
    struct Constants {
        static let cornerRadius: CGFloat = 8
        static let buttonPadding: CGFloat = 2
    }

    func configureHierarchy() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}
