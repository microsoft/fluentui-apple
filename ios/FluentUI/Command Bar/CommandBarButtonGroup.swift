//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class CommandBarButtonGroup: UIView {
    let buttons: [CommandBarButton]

    var buttonBackgroundStyle: CommandBarButton.BackgroundStyle = .default {
        didSet {
            buttons.forEach { $0.backgroundStyle = buttonBackgroundStyle }
        }
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constants.buttonPadding

        return stackView
    }()

    public init(buttons: [CommandBarButton]) {
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
}

private extension CommandBarButtonGroup {
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
