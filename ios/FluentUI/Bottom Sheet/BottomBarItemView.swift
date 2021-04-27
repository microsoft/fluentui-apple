//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BottomBarItemView: UIView {
    init(item: CommandingItem) {
        self.item = item
        super.init(frame: .zero)

        let testLabel = UILabel()
        testLabel.text = item.title
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(testLabel)

        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalToConstant: 45),
            heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    let item: CommandingItem
}
