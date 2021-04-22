//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ContactViewDelegate

@objc(MSFContactViewDelegate)
public protocol ContactViewDelegate: AnyObject {
    @objc optional func didTapContactView(_ contact: ContactView)
}

// MARK: ContactView

@objc(MSFContactView)
open class ContactView: UIControl {
    @objc(MSFContactViewSize)
    public enum Size: Int {
        case large
        case small

        var avatarSize: MSFAvatarSize {
            switch self {
            case .large:
                return .xxlarge
            case .small:
                return .xlarge
            }
        }

        var canShowSubtitle: Bool {
            switch self {
            case .large:
                return true
            case .small:
                return false
            }
        }

        var width: CGFloat {
            var width = self.avatarSize.size

            switch UITraitCollection.current.preferredContentSizeCategory {
            case .accessibilityMedium:
                width += 20
            case .accessibilityLarge:
                width += 50
            case .accessibilityExtraLarge:
                width += 60
            case .accessibilityExtraExtraLarge:
                width += 70
            case .accessibilityExtraExtraExtraLarge:
                width += 100
            default:
                break
            }

            return width
        }
    }

    @objc public var avatarImage: UIImage? {
        didSet {
            avatar.state.image = avatarImage
        }
    }

    /// The contact view's delegate. If the delegate is nil, the contact view will not display an overlay for touch down events.
    @objc open weak var contactViewDelegate: ContactViewDelegate?

    /// The size of the contact view.
    @objc public let size: Size

    /// Initializes the contact view by creating an avatar view with a primary and secondary text
    /// - Parameter title: String that will be the text of the top label
    /// - Parameter subtitle: String that will be the text of the bottom label
    /// - Parameter size: The size of the contact view.
    @objc public convenience init(title: String, subtitle: String, size: Size = .large) {
        self.init(title: title, subtitle: subtitle, identifier: nil, size: size)
    }

    /// Initializes the contact view by creating an avatar view with an identifier
    /// - Parameter identifier: String that will be used to identify the contact (e.g. email, phone number, first name)
    /// - Parameter size: The size of the contact view.
    @objc public convenience init(identifier: String, size: Size = .large) {
        self.init(title: nil, subtitle: nil, identifier: identifier, size: size)
    }

    private init(title: String?, subtitle: String?, identifier: String?, size: Size = .large) {
        avatar = MSFAvatar(style: .accent, size: size.avatarSize)
        labelContainer = UIView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        pressedStateOverlay = UIView(frame: .zero)
        self.size = size
        super.init(frame: .zero)

        addTarget(self, action: #selector(touchDownHandler), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideHandler), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragExitHandler), for: .touchDragExit)

        if let title = title, let subtitle = subtitle {
            setupAvatarView(with: title, and: subtitle)

            if size == .large {
                setupSubtitleLabel(using: subtitle)
            }

            setupTitleLabel(using: title, numberOfLines: 1)
        } else if let identifier = identifier {
            setupAvatarView(with: identifier)
            setupTitleLabel(using: identifier, numberOfLines: (size == .large ? 2 : 1))
        }

        backgroundColor = Colors.surfacePrimary
        setupPressedStateOverlay()
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private let avatar: MSFAvatar
    private var titleLabel: UILabel
    private var subtitleLabel: UILabel?
    private var labelContainer: UIView
    private let pressedStateOverlay: UIView

    private lazy var labelHeightConstraint: NSLayoutConstraint = {
        return labelContainer.heightAnchor.constraint(equalToConstant: 0)
    }()

    private lazy var widthConstraint: NSLayoutConstraint = {
        return widthAnchor.constraint(equalToConstant: 0)
    }()

    private func setupAvatarView(with title: String, and subtitle: String) {
        let identifier = title + " " + subtitle
        let avatarState = avatar.state
        avatarState.primaryText = identifier
        avatarState.image = avatarImage
    }

    private func setupAvatarView(with identifier: String) {
        let avatarState = avatar.state
        avatarState.primaryText = identifier
        avatarState.image = avatarImage
    }

    private func setupLayout() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: avatarLayoutConstraints())

        let avatarView = avatar.view
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
            widthConstraint,
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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSizeConstraints),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)

        updateSizeConstraints()
    }

    @objc private func updateSizeConstraints() {
        updateLabelHeight()
        widthConstraint.constant = size.width
    }

    private func updateLabelHeight() {
        let contactHeight = traitCollection.preferredContentSizeCategory.contactHeight(size: size)
        labelHeightConstraint.constant = contactHeight - size.avatarSize.size - Constants.spacingBetweenAvatarAndLabelContainer
    }

    private func avatarLayoutConstraints() -> [NSLayoutConstraint] {
        let avatarView = avatar.view
        return [
            avatarView.heightAnchor.constraint(equalToConstant: size.avatarSize.size),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
    }

    private func labelContainerLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            labelContainer.topAnchor.constraint(equalTo: avatar.view.bottomAnchor, constant: Constants.spacingBetweenAvatarAndLabelContainer),
            labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelHeightConstraint
        ]
    }

    private func titleLabelLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
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
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelMinimumHeight)
        ]
    }

    private func identifierLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.topAnchor.constraint(equalTo: avatar.view.bottomAnchor, constant: Constants.spacingBetweenAvatarAndLabelContainer),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor)
        ]
    }

    private func setupTitleLabel(using title: String, numberOfLines: Int = 2) {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.subhead
        label.text = title
        label.textAlignment = .center
        label.textColor = Colors.textPrimary
        label.numberOfLines = numberOfLines

        titleLabel = label
    }

    private func setupSubtitleLabel(using subtitle: String) {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.footnote
        label.text = subtitle
        label.textAlignment = .center
        label.textColor = Colors.textSecondary
        label.numberOfLines = 1

        subtitleLabel = label
    }

    private func setupPressedStateOverlay() {
        let avatarView = avatar.view
        pressedStateOverlay.backgroundColor = Colors.Contact.pressedState
        pressedStateOverlay.clipsToBounds = true
        pressedStateOverlay.frame = avatarView.frame
        pressedStateOverlay.isHidden = true
        pressedStateOverlay.isUserInteractionEnabled = false
        pressedStateOverlay.layer.cornerRadius = size.avatarSize.size / 2
    }

    @objc private func touchDownHandler() {
        if contactViewDelegate != nil {
            pressedStateOverlay.isHidden = false
        }
    }

    @objc private func touchUpInsideHandler() {
        contactViewDelegate?.didTapContactView?(self)
        pressedStateOverlay.isHidden = true
    }

    @objc private func touchDragExitHandler() {
        pressedStateOverlay.isHidden = true
    }

    private struct Constants {
        static let labelMinimumHeight: CGFloat = 16.0
        static let spacingBetweenAvatarAndLabelContainer: CGFloat = 13.0
    }
}

// MARK: Contact Colors

private extension Colors {
    struct Contact {
        static let pressedState: UIColor = Colors.gray200.withAlphaComponent(0.6)
    }
}
