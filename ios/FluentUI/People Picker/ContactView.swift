//
//  ContactView.swift
//  FluentUI
//
//  Created by Jonathan Wang on 2020-06-08.
//  Copyright © 2020 Microsoft Corporation. All rights reserved.
//

import UIKit

open class ContactView: UIView {
    private struct Constants {
        static let cardWidth: CGFloat = 70.0
        static let font: UIFont = Fonts.button4
        static let spacingBetweenAvatarAndFirstLabel: CGFloat = 13.0
        static let XSCardHeight: CGFloat = 115.0
        static let SCardHeight: CGFloat = 117.0
        static let MCardHeight: CGFloat = 118.0
        static let LCardHeight: CGFloat = 121.0
        static let XLCardHeight: CGFloat = 125.0
        static let XXLCardHeight: CGFloat = 129.0
        static let XXXLCardHeight: CGFloat = 135.0
    }

    public enum CardSize {
        case extraSmall
        case small
        case medium
        case large
        case extraLarge
        case extraExtraLarge
        case extraExtraExtraLarge
    }

    private var avatarView: AvatarView
    private var firstNameLabel: UILabel?
    private var lastNameLabel: UILabel?
    private var identifierLabel: UILabel?
    private var cardSize: CardSize

    // Provide both a first name and a last name
    public init(avatarView: AvatarView, firstName: String, lastName: String) {
        self.avatarView = avatarView
        self.firstNameLabel = UILabel()
        self.lastNameLabel = UILabel()
        self.cardSize = CardSize.large
        super.init(frame: .zero)
        setupFirstNameLabel(firstName: firstName)
        setupLastNameLabel(lastName: lastName)
        setupLayout()
    }

    // Only provide a name (could be first + last separated by a space or just a first name)
    public init(avatarView: AvatarView, name: String, cardSize: CardSize) {
        self.avatarView = avatarView
        self.cardSize = CardSize.large
        super.init(frame: .zero)
        setupIdentifierLabel(identifier: name)
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setupAvatarLayout() {
        addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        avatarView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        avatarView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    private func setupFirstNameLayout() {
        if let firstNameLabel = firstNameLabel {
            addSubview(firstNameLabel)
            firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
            firstNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel).isActive = true
            firstNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            firstNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            firstNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            firstNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }
    }

    private func setupLastNameLayout() {
        if let lastNameLabel = lastNameLabel {
            addSubview(lastNameLabel)
            lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
            lastNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

            if let firstNameLabel = firstNameLabel {
                lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
            }

            lastNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            lastNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            lastNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

            switch self.cardSize {
            case .extraSmall:
                lastNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            case .small:
                // TODO: Replace with something in constants struct (refactor)
                lastNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1).isActive = true
            case .medium, .large, .extraLarge, .extraExtraExtraLarge:
                lastNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
            case .extraExtraLarge:
                lastNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
            }
        }
    }

    private func setupIdentifierLayout() {
        if let identifierLabel = identifierLabel {
            addSubview(identifierLabel)
            identifierLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            identifierLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            identifierLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndFirstLabel).isActive = true
            identifierLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            identifierLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            identifierLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }

    private func setupLayout() {
        self.widthAnchor.constraint(equalToConstant: Constants.cardWidth).isActive = true

        setupAvatarLayout()

        if let _ = firstNameLabel, let _ = lastNameLabel {
            setupFirstNameLayout()
            setupLastNameLayout()
        } else {
            setupIdentifierLayout()
        }
    }

    private func setupFirstNameLabel(firstName: String) {
        firstNameLabel = UILabel(frame: .zero)

        if let firstNameLabel = firstNameLabel {
            firstNameLabel.text = firstName
            firstNameLabel.textAlignment = .center
            // TODO: Font style
            if let window = window {
                firstNameLabel.textColor = Colors.primary(for: window)
            }
        }
    }

    private func setupLastNameLabel(lastName: String) {
        lastNameLabel = UILabel(frame: .zero)

        if let lastNameLabel = lastNameLabel {
            lastNameLabel.text = lastName
            lastNameLabel.textAlignment = .center
            // TODO: Font style
            if let window = window {
                lastNameLabel.textColor = Colors.primary(for: window)
            }
        }
    }

    private func setupIdentifierLabel(identifier: String) {
        identifierLabel = UILabel(frame: .zero)

        if let identifierLabel = identifierLabel {
            identifierLabel.text = identifier
            identifierLabel.textAlignment = .natural
            identifierLabel.numberOfLines = 2
            // TODO: Font style
            if let window = window {
                identifierLabel.textColor = Colors.primary(for: window)
            }
        }
    }

    // TODO: Look at     public var size: CGSize { in AvatarView.swift
    private func getCardWidthAndHeight(cardSize: CardSize) -> (CGFloat, CGFloat) {
        switch cardSize {
        case .extraSmall:
            return (Constants.cardWidth, Constants.XSCardHeight)
        case .small:
            return (Constants.cardWidth, Constants.SCardHeight)
        case .medium:
            return (Constants.cardWidth, Constants.MCardHeight)
        case .large:
            return (Constants.cardWidth, Constants.LCardHeight)
        case .extraLarge:
            return (Constants.cardWidth, Constants.XLCardHeight)
        case .extraExtraLarge:
            return (Constants.cardWidth, Constants.XXLCardHeight)
        case .extraExtraExtraLarge:
            return (Constants.cardWidth, Constants.XXXLCardHeight)
        }
    }
}
