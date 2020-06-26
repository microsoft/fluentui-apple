//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFContactView)
open class ContactView: UIView {
    private struct Constants {
        static let contactWidth: CGFloat = 70.0
        static let avatarViewWidth: CGFloat = 70.0
        static let avatarViewHeight: CGFloat = 70.0
        static let titleLabelMinimumHeight: CGFloat = 12.0
        static let spacingBetweenAvatarAndFirstLabel: CGFloat = 13.0
    }

    @objc public var avatarImage: UIImage? {
        didSet {
            setupAvatarView(with: titleLabel?.text, and: subtitleLabel?.text, or: nil)
        }
    }

    private let avatarView: AvatarView
    private var titleLabel: UILabel?
    private var subtitleLabel: UILabel?

    /// Initializes the contact view by creating an avatar view with a first name and last name
    ///
    /// - Parameters:
    ///   - title: String that will be the text of the top label
    ///   - subtitle: String that will be the text of the bottom label
    @objc public convenience init(title: String, subtitle: String) {
        self.init(title: title, subtitle: subtitle, identifier: nil)
    }

    /// Initializes the contact view by creating an avatar view with an identifier
    ///
    /// - Parameters:
    ///   - identifier: String that will be used to identify the contact (e.g. email, phone number, first name)
    @objc public convenience init(identifier: String) {
        self.init(title: nil, subtitle: nil, identifier: identifier)
    }

    private init(title: String?, subtitle: String?, identifier: String?) {
        avatarView = AvatarView(avatarSize: .extraExtraLarge, withBorder: false, style: .circle)
        super.init(frame: .zero)

        if let title = title, let subtitle = subtitle {
            subtitleLabel = UILabel()
            setupAvatarView(with: title, and: subtitle, or: nil)
            setupTitleLabel(using: title)
            setupSubtitleLabel(using: subtitle)
        } else if let identifier = identifier {
            setupAvatarView(with: nil, and: nil, or: identifier)
            setupTitleLabel(using: identifier)
        }

        backgroundColor = Colors.surfacePrimary
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

        if let titleLabel = titleLabel {
            if let subtitleLabel = subtitleLabel {
                constraints.append(contentsOf: titleLabelLayoutConstraints())
                constraints.append(contentsOf: subtitleLabelLayoutConstraints())
                addSubview(subtitleLabel)
            } else {
                constraints.append(contentsOf: identifierLayoutConstraints())
            }
            addSubview(titleLabel)
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

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        if let titleLabel = titleLabel {
            constraints.append(subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor))
        }

        return constraints
    }

    private func identifierLayoutConstraints() -> [NSLayoutConstraint] {
        guard let titleLabel = titleLabel else {
            return []
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return [
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }

    private func setupTitleLabel(using firstName: String) {
        titleLabel = UILabel(frame: .zero)

        if let titleLabel = titleLabel {
            titleLabel.adjustsFontForContentSizeCategory = true
            titleLabel.font = Fonts.subhead
            titleLabel.text = firstName
            titleLabel.textAlignment = .center
            titleLabel.textColor = Colors.Contact.title

            if subtitleLabel == nil {
                titleLabel.numberOfLines = 2
                titleLabel.textAlignment = .natural
            }
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
}
