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
        static let firstNameLabelMinimumHeight: CGFloat = 12.0
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
    private var firstNameLabel: UILabel?
    private var lastNameLabel: UILabel?
    private var identifierLabel: UILabel?

    /// Initializes the contact view by creating an avatar view with a first name and last name
    ///
    /// - Parameters:
    ///   - firstName: String that will be the text of the top label
    ///   - lastName: String that will be the text of the bottom label
    @objc public init(firstName: String, lastName: String) {
        avatarView = AvatarView(avatarSize: .extraExtraLarge, withBorder: false, style: .circle)
        firstNameLabel = UILabel()
        lastNameLabel = UILabel()
        super.init(frame: .zero)
        setupAvatarView(with: firstName, and: lastName, or: nil)
        backgroundColor = Colors.surfacePrimary
        setupFirstNameLabel(using: firstName)
        setupLastNameLabel(using: lastName)
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

        if firstNameLabel != nil && lastNameLabel != nil {
            constraints.append(contentsOf: firstNameLayoutConstraints())
            constraints.append(contentsOf: lastNameLayoutConstraints())
        } else {
            constraints.append(contentsOf: identifierLayoutConstraints())
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func avatarLayoutConstraints() -> [NSLayoutConstraint] {
        addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        constraints.append(avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarViewHeight))
        constraints.append(avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarViewWidth))
        constraints.append(avatarView.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(avatarView.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(avatarView.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(avatarView.trailingAnchor.constraint(equalTo: trailingAnchor))
        return constraints
    }

    private func firstNameLayoutConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let firstNameLabel = firstNameLabel {
            addSubview(firstNameLabel)
            firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(firstNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel))
            constraints.append(firstNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(firstNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(firstNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(firstNameLabel.widthAnchor.constraint(equalTo: widthAnchor))
            constraints.append(firstNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.firstNameLabelMinimumHeight))
        }
        return constraints
    }

    private func lastNameLayoutConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let lastNameLabel = lastNameLabel {
            addSubview(lastNameLabel)
            lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(lastNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor))

            if let firstNameLabel = firstNameLabel {
                constraints.append(lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor))
            }

            constraints.append(lastNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(lastNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(lastNameLabel.widthAnchor.constraint(equalTo: widthAnchor))
            constraints.append(lastNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor))
        }
        return constraints
    }

    private func identifierLayoutConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let identifierLabel = identifierLabel {
            addSubview(identifierLabel)
            identifierLabel.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(identifierLabel.widthAnchor.constraint(equalTo: widthAnchor))
            constraints.append(identifierLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(identifierLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel))
            constraints.append(identifierLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(identifierLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(identifierLabel.bottomAnchor.constraint(equalTo: bottomAnchor))
        }
        return constraints
    }

    private func setupFirstNameLabel(using firstName: String) {
        firstNameLabel = UILabel(frame: .zero)

        if let firstNameLabel = firstNameLabel {
            firstNameLabel.adjustsFontForContentSizeCategory = true
            firstNameLabel.font = Fonts.subhead
            firstNameLabel.text = firstName
            firstNameLabel.textColor = Colors.Contact.firstName
            firstNameLabel.textAlignment = .center
        }
    }

    private func setupLastNameLabel(using lastName: String) {
        lastNameLabel = UILabel(frame: .zero)

        if let lastNameLabel = lastNameLabel {
            lastNameLabel.adjustsFontForContentSizeCategory = true
            lastNameLabel.font = Fonts.footnote
            lastNameLabel.text = lastName
            lastNameLabel.textAlignment = .center
            lastNameLabel.textColor = Colors.Contact.lastName
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
            identifierLabel.textColor = Colors.Contact.firstName
        }
    }
}
