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
        static let labelMinimumHeight: CGFloat = 16.0
        static let titleLabelMaximumHeight: CGFloat = 28.0
        static let subtitleMaximumHeight: CGFloat = 24.0
        static let spacingBetweenAvatarAndLabelContainer: CGFloat = 13.0
        static let numberOfLinesForSingleLabel: Int = 2

        static let extraSmallContentContactHeight: CGFloat = 115.0
        static let smallContentContactHeight: CGFloat = 117.0
        static let mediumContentContactHeight: CGFloat = 118.0
        static let largeContentContactHeight: CGFloat = 121.0
        static let extraLargeContentContactHeight: CGFloat = 125.0
        static let extraExtraLargeContentContactHeight: CGFloat = 129.0
        static let extraExtraExtraLargeContentContactHeight: CGFloat = 135.0
    }

    @objc public var avatarImage: UIImage? {
        didSet {
            if let subtitleLabel = subtitleLabel {
                setupAvatarView(with: titleLabel.text ?? "", and: subtitleLabel.text ?? "")
            } else {
                setupAvatarView(with: titleLabel.text ?? "")
            }
        }
    }

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

        if let title = title, let subtitle = subtitle {
            setupAvatarView(with: title, and: subtitle)
            setupSubtitleLabel(using: subtitle)
            setupTitleLabel(using: title)
        } else if let identifier = identifier {
            setupAvatarView(with: identifier)
            setupTitleLabel(using: identifier)
        }

        if #available(iOS 13, *) {
            showsLargeContentViewer = true
            largeContentTitle = titleLabel.text
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
        constraints.append(widthAnchor.constraint(equalToConstant: Constants.contactWidth))
        constraints.append(contentsOf: avatarLayoutConstraints())

        avatarView.translatesAutoresizingMaskIntoConstraints = false
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
        constraints.append(contentsOf: pressedStateOverlayLayoutConstraints())

        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.addSubview(titleLabel)
        addSubview(labelContainer)
        constraints.append(contentsOf: labelContainerLayoutConstraints())

        NSLayoutConstraint.activate(constraints)
    }

    private func avatarLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarViewHeight),
            avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarViewWidth),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }

    private func labelContainerLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            labelContainer.widthAnchor.constraint(equalToConstant: Constants.contactWidth),
            labelContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
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

    private func pressedStateOverlayLayoutConstraints() -> [NSLayoutConstraint] {
        return [
            pressedStateOverlay.widthAnchor.constraint(equalTo: avatarView.widthAnchor),
            pressedStateOverlay.heightAnchor.constraint(equalTo: avatarView.heightAnchor),
            pressedStateOverlay.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            pressedStateOverlay.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            pressedStateOverlay.topAnchor.constraint(equalTo: avatarView.topAnchor),
            pressedStateOverlay.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor)
        ]
    }

    private func setupTitleLabel(using title: String) {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.font = Fonts.subhead
        label.text = title
        label.textAlignment = .center
        label.textColor = Colors.Contact.title

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
        label.textColor = Colors.Contact.subtitle

        subtitleLabel = label
    }

    private func categoryHeight() -> CGFloat {
        switch UIApplication.shared.preferredContentSizeCategory {
        case .extraSmall:
            return Constants.extraSmallContentContactHeight
        case .small:
            return Constants.smallContentContactHeight
        case .medium:
            return Constants.mediumContentContactHeight
        case .large:
            return Constants.largeContentContactHeight
        case .extraLarge:
            return Constants.extraLargeContentContactHeight
        case .extraExtraLarge:
            return Constants.extraExtraLargeContentContactHeight
        case .extraExtraExtraLarge:
            return Constants.extraExtraExtraLargeContentContactHeight
        default:
            return Constants.extraExtraExtraLargeContentContactHeight
        }
    }

    private func setupPressedStateOverlay() {
        pressedStateOverlay.clipsToBounds = true
        pressedStateOverlay.frame = avatarView.frame
        pressedStateOverlay.layer.cornerRadius = avatarView.frame.width / 2
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pressedStateOverlay.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.6)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        pressedStateOverlay.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pressedStateOverlay.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    }
}
