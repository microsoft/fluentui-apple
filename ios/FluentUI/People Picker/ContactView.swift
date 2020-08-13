//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Contact Colors

public extension Colors {
    struct Contact {
        public static let pressedState: UIColor = Colors.gray200.withAlphaComponent(0.6)
    }
}

// MARK: ContactViewDelegate
@objc(MSFContactViewDelegate)
public protocol ContactViewDelegate: AnyObject {
    @objc optional func didTapContactView(_ contact: ContactView)
}

// MARK: ContactView

@objc(MSFContactView)
open class ContactView: UIControl {
    @objc public var avatarImage: UIImage? {
        didSet {
            if let subtitleLabel = subtitleLabel {
                setupAvatarView(with: titleLabel.text ?? "", and: subtitleLabel.text ?? "")
            } else {
                setupAvatarView(with: titleLabel.text ?? "")
            }
        }
    }

    open weak var contactViewDelegate: ContactViewDelegate?

    private let avatarView: AvatarView
    private var titleLabel: UILabel
    private var subtitleLabel: UILabel?
    private var labelContainer: UIView
    private let pressedStateOverlay: UIView

    /// Initializes the contact view by creating an avatar view with a primary and secondary text
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
        labelContainer = UIView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        pressedStateOverlay = UIView(frame: .zero)
        super.init(frame: .zero)

        addTarget(self, action: #selector(touchDownHandler), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideHandler), for: .touchUpInside)
        addTarget(self, action: #selector(touchMovedHandler), for: .touchDragInside)

        if let title = title, let subtitle = subtitle {
            setupAvatarView(with: title, and: subtitle)
            setupSubtitleLabel(using: subtitle)
            setupTitleLabel(using: title)
        } else if let identifier = identifier {
            setupAvatarView(with: identifier)
            setupTitleLabel(using: identifier)
        }

        backgroundColor = Colors.surfacePrimary
        setupPressedStateOverlay()
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setupAvatarView(with title: String, and subtitle: String) {
        let identifier = title + " " + subtitle
        avatarView.setup(primaryText: identifier, secondaryText: nil, image: avatarImage)
    }

    private func setupAvatarView(with identifier: String) {
        avatarView.setup(primaryText: identifier, secondaryText: nil, image: avatarImage)
    }

    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: avatarLayoutConstraints())

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.isUserInteractionEnabled = false
        addSubview(avatarView)

        if let subtitleLabel = subtitleLabel {
            constraints.append(contentsOf: titleLabelLayoutConstraints())
            constraints.append(contentsOf: subtitleLabelLayoutConstraints())
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.addSubview(subtitleLabel)
        } else {
            constraints.append(contentsOf: identifierLayoutConstraints())
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        pressedStateOverlay.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(pressedStateOverlay)
        constraints.append(contentsOf: [
            pressedStateOverlay.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            pressedStateOverlay.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            pressedStateOverlay.topAnchor.constraint(equalTo: avatarView.topAnchor),
            pressedStateOverlay.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor)
        ])

        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.isUserInteractionEnabled = false
        labelContainer.addSubview(titleLabel)
        addSubview(labelContainer)
        constraints.append(contentsOf: labelContainerLayoutConstraints())

        NSLayoutConstraint.activate(constraints)
    }

    private func avatarLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            avatarView.heightAnchor.constraint(equalToConstant: AvatarSize.extraExtraLarge.size.height),
            avatarView.widthAnchor.constraint(equalToConstant: AvatarSize.extraExtraLarge.size.width),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }

    private func labelContainerLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            labelContainer.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndLabelContainer),
            labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 2.0 * Constants.labelMinimumHeight)
        ]
    }

    private func titleLabelLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: labelContainer.widthAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelMinimumHeight)
        ]
    }

    private func subtitleLabelLayoutConstraints() -> [NSLayoutConstraint] {
        guard let subtitleLabel = subtitleLabel else {
            return []
        }

        return [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelMinimumHeight)
        ]
    }

    private func identifierLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.widthAnchor.constraint(equalTo: labelContainer.widthAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.spacingBetweenAvatarAndLabelContainer),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor)
        ]
    }

    private func setupTitleLabel(using title: String) {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.subhead
        label.text = title
        label.textAlignment = .center
        label.textColor = Colors.textPrimary

        if subtitleLabel == nil {
            label.numberOfLines = Constants.numberOfLinesForSingleLabel
        }

        titleLabel = label
    }

    private func setupSubtitleLabel(using subtitle: String) {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.footnote
        label.text = subtitle
        label.textAlignment = .center
        label.textColor = Colors.textSecondary

        subtitleLabel = label
    }

    private func setupPressedStateOverlay() {
        pressedStateOverlay.backgroundColor = Colors.Contact.pressedState
        pressedStateOverlay.clipsToBounds = true
        pressedStateOverlay.frame = avatarView.frame
        pressedStateOverlay.isHidden = true
        pressedStateOverlay.isUserInteractionEnabled = false
        pressedStateOverlay.layer.cornerRadius = avatarView.frame.width / 2
    }

    @objc private func touchDownHandler() {
        pressedStateOverlay.isHidden = false
    }

    @objc private func touchUpInsideHandler() {
        contactViewDelegate?.didTapContactView?(self)
        pressedStateOverlay.isHidden = true
    }

    @objc private func touchMovedHandler() {
        pressedStateOverlay.isHidden = true
    }

    private struct Constants {
        static let labelMinimumHeight: CGFloat = 16.0
        static let spacingBetweenAvatarAndLabelContainer: CGFloat = 13.0
        static let numberOfLinesForSingleLabel: Int = 2
    }
}
