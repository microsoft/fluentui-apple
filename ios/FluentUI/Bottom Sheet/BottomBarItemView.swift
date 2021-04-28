//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BottomBarItemView: UIView {
    init(item: CommandingItem) {
        self.item = item
        super.init(frame: .zero)

        addSubview(container)
        container.addArrangedSubview(imageView)

        titleLabel.text = item.title
        container.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            widthAnchor.constraint(equalToConstant: 48),
            heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    let item: CommandingItem

    private lazy var container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alignment = .center
        container.distribution = .fill
        container.axis = .vertical

        return container
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: item.image)
        imageView.contentMode = .center
        imageView.tintColor = Constants.unselectedColor

        return imageView
    }()

    private lazy var titleLabel: Label = {
        let titleLabel = Label()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        titleLabel.textColor = Constants.unselectedColor

        return titleLabel
    }()

    private struct Constants {
        static let unselectedColor: UIColor = Colors.textSecondary
    }
}
