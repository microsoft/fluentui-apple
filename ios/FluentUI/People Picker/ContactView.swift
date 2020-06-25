//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

open class ContactView: UIView {
    private struct Constants {
        static let contactWidth: CGFloat = 70.0
        static let avatarViewWidth: CGFloat = 70.0
        static let avatarViewHeight: CGFloat = 70.0
        static let titleLabelMinimumHeight: CGFloat = 12.0
        static let spacingBetweenAvatarAndFirstLabel: CGFloat = 13.0
    }

    // TODO: Set it as the default image (pawn)
    @objc public var avatarImage: UIImage? {
        didSet {
            if let avatarImage = avatarImage {
                avatarView.setup(image: avatarImage)
            }
        }
    }
    private let avatarView: AvatarView
    private var titleLabel: UILabel?
    private var subtitleLabel: UILabel?
    private var identifierLabel: UILabel?

    /// Initializes the contact view by creating an avatar view with a first name and last name
    ///
    /// - Parameters:
    ///   - title: String that will be the text of the top label
    ///   - subtitle: String that will be the text of the bottom label
    @objc public init(title: String, subtitle: String) {
        avatarView = AvatarView(avatarSize: .extraExtraLarge, withBorder: false, style: .circle)
        titleLabel = UILabel()
        subtitleLabel = UILabel()
        super.init(frame: .zero)
        setupAvatarView(with: title, and: subtitle, or: nil)
        backgroundColor = Colors.surfacePrimary
        setupTitleLabel(using: title)
        setupSubtitleLabel(using: subtitle)
        setupLayout()
    }

    /// Initializes the contact view by creating an avatar view with an identifier
    ///
    /// - Parameters:
    ///   - identifier: String that will be used to identify the contact (e.g. email, phone number, first name)
    @objc public init(identifier: String) {
        avatarView = AvatarView(avatarSize: .extraExtraLarge, withBorder: false, style: .circle)
        super.init(frame: .zero)
        // TODO: Should 'nil' be used here?
        setupAvatarView(with: nil, and: nil, or: identifier)
        backgroundColor = Colors.surfacePrimary
        setupIdentifierLabel(using: identifier)
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setupAvatarView(with firstName: String?, and lastName: String?, or identifier: String?) {
        if let firstName = firstName, let lastName = lastName {
            let fullName = firstName + " " + lastName
            avatarView.setup(primaryText: fullName, secondaryText: identifier, image: avatarImage)
        } else {
            avatarView.setup(primaryText: identifier, secondaryText: "", image: avatarImage)
        }
    }

    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(widthAnchor.constraint(equalToConstant: Constants.contactWidth))
        constraints.append(contentsOf: avatarLayoutConstraints())

        if let titleLabel = titleLabel, let subtitleLabel = subtitleLabel {
            constraints.append(contentsOf: titleLabelLayoutConstraints())
            constraints.append(contentsOf: subtitleLabelLayoutConstraints())
            addSubview(titleLabel)
            addSubview(subtitleLabel)
        } else if let identifierLabel = identifierLabel {
            constraints.append(contentsOf: identifierLayoutConstraints())
            addSubview(identifierLabel)
        }

        addSubview(avatarView)

        NSLayoutConstraint.activate(constraints)
    }

    private func avatarLayoutConstraints() -> [NSLayoutConstraint] {
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        return [
            avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarViewHeight),
            avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarViewWidth),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }

    private func titleLabelLayoutConstraints() -> [NSLayoutConstraint] {
        guard let titleLabel = titleLabel else {
            return []
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return [
            titleLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.titleLabelMinimumHeight)
        ]
    }

    private func subtitleLabelLayoutConstraints() -> [NSLayoutConstraint] {
        guard let subtitleLabel = subtitleLabel else {
            return []
        }

        var constraints = [NSLayoutConstraint]()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        if let titleLabel = titleLabel {
            constraints.append(subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor))
        }
        constraints.append(subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
        constraints.append(subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor))
        constraints.append(subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor))
        return constraints
    }

    private func identifierLayoutConstraints() -> [NSLayoutConstraint] {
        guard let identifierLabel = identifierLabel else {
            return []
        }

        identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        return [
            identifierLabel.widthAnchor.constraint(equalTo: widthAnchor),
            identifierLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            identifierLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel),
            identifierLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            identifierLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            identifierLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }

    private func setupTitleLabel(using firstName: String) {
        titleLabel = UILabel(frame: .zero)

        if let titleLabel = titleLabel {
            titleLabel.adjustsFontForContentSizeCategory = true
            titleLabel.font = Fonts.subhead
            titleLabel.text = firstName
            titleLabel.textColor = Colors.Contact.title
            titleLabel.textAlignment = .center
        }
    }

    private func setupSubtitleLabel(using lastName: String) {
        subtitleLabel = UILabel(frame: .zero)

        if let subtitleLabel = subtitleLabel {
            subtitleLabel.adjustsFontForContentSizeCategory = true
            subtitleLabel.font = Fonts.footnote
            subtitleLabel.text = lastName
            subtitleLabel.textAlignment = .center
            subtitleLabel.textColor = Colors.Contact.subtitle
        }
    }

    private func setupIdentifierLabel(using identifier: String) {
        identifierLabel = UILabel(frame: .zero)

        if let identifierLabel = identifierLabel {
            identifierLabel.adjustsFontForContentSizeCategory = true
            identifierLabel.font = Fonts.subhead
            identifierLabel.numberOfLines = 2
            identifierLabel.text = identifier
            identifierLabel.textAlignment = .natural
            identifierLabel.textColor = Colors.Contact.title
        }
    }
}
