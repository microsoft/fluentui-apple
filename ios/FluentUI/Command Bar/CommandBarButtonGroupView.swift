//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButtonGroupView: UIView {
    let buttons: [CommandBarButton]

    init(buttons: [CommandBarButton], tokenSet: CommandBarTokenSet) {
        self.buttons = buttons
        self.tokenSet = tokenSet

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        clipsToBounds = true
        layer.cornerRadius = tokenSet[.groupBorderRadius].float
        layer.cornerCurve = .continuous

        configureHierarchy()
        applyInsets()
        hideGroupIfNeeded()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Hides the group view if all the views inside the `stackView` are hidden
    func hideGroupIfNeeded() {
        var allViewsHidden = true
        for view in stackView.arrangedSubviews {
            if !view.isHidden {
                allViewsHidden = false
                break
            }
        }

        isHidden = allViewsHidden
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBarTokenSet.itemInterspace

        return stackView
    }()

    private func configureHierarchy() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    private func applyInsets() {
        if #available(iOS 15.0, *) {
            buttons.first?.configuration?.contentInsets.leading += CommandBarTokenSet.leftRightBuffer
            buttons.last?.configuration?.contentInsets.trailing += CommandBarTokenSet.leftRightBuffer
        } else {
            buttons.first?.contentEdgeInsets.left += CommandBarTokenSet.leftRightBuffer
            buttons.last?.contentEdgeInsets.right += CommandBarTokenSet.leftRightBuffer
        }
    }

    private var tokenSet: CommandBarTokenSet
}
