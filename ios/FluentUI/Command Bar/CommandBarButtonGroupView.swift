//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButtonGroupView: UIView {
    let buttons: [CommandBarButton]

    init(buttons: [CommandBarButton]) {
        self.buttons = buttons

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        clipsToBounds = true
        layer.cornerRadius = CommandBarButtonGroupView.cornerRadius
        if #available(iOS 13, *) {
            layer.cornerCurve = .continuous
        }

        configureHierarchy()
        applyInsets()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBarButtonGroupView.buttonPadding

        return stackView
    }()
}

private extension CommandBarButtonGroupView {
    func configureHierarchy() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    func applyInsets() {
        buttons.first?.contentEdgeInsets.left += CommandBarButtonGroupView.leftRightBuffer
        buttons.last?.contentEdgeInsets.right += CommandBarButtonGroupView.leftRightBuffer
    }

    static let cornerRadius: CGFloat = 8
    static let buttonPadding: CGFloat = 2
    static let leftRightBuffer: CGFloat = 2
}
