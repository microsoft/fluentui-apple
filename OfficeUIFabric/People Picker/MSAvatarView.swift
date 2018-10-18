//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSAvatarSize

@objc public enum MSAvatarSize: Int {
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge

    // TODO: Replace with conformance to CaseIterable after switch to Swift 4.2
    public static var allCases: [MSAvatarSize] = [.xSmall, .small, .medium, .large, .xLarge, .xxLarge]

    var font: UIFont {
        switch self {
        case .xSmall:
            return UIFont.systemFont(ofSize: 9)
        case .small:
            return UIFont.systemFont(ofSize: 12)
        case .medium:
            return UIFont.systemFont(ofSize: 13)
        case .large:
            return UIFont.systemFont(ofSize: 15)
        case .xLarge:
            return UIFont.systemFont(ofSize: 15)
        case .xxLarge:
            return UIFont.systemFont(ofSize: 28)
        }
    }

    var size: CGSize {
        switch self {
        case .xSmall:
            return CGSize(width: 18, height: 18)
        case .small:
            return CGSize(width: 25, height: 25)
        case .medium:
            return CGSize(width: 30, height: 30)
        case .large:
            return CGSize(width: 35, height: 35)
        case .xLarge:
            return CGSize(width: 40, height: 40)
        case .xxLarge:
            return CGSize(width: 70, height: 70)
        }
    }
}

// MARK: - MSAvatarView

/**
 `MSAvatarView` is used to present an image or initials view representing an entity such as a person.
 If an image is provided the image is presented in a circular UIView with the initials view presented
 as a fallback. The initials used in the initials view are generated from the provided name or email address
 used to initialize the avatar view.
 */

open class MSAvatarView: UIView {
    private struct Constants {
        static let borderWidth: CGFloat = 2
        static let xxLargeBorderWidth: CGFloat = 4
        static let animationDuration: TimeInterval = 0.2
    }

    private struct SetupData: Equatable {
        let name: String?
        let email: String?

        init(avatarView: MSAvatarView) {
            self.name = avatarView.name
            self.email = avatarView.email
        }
    }

    open var avatarSize: MSAvatarSize {
        didSet {
            frame.size = avatarSize.size
            initialsView.avatarSize = avatarSize
        }
    }
    open var avatarBackgroundColor: UIColor {
        didSet {
            initialsView.backgroundColor = avatarBackgroundColor
        }
    }
    private var name: String?
    private var email: String?
    private var initialsView: MSInitialsView
    private let imageView: UIImageView
    // Use a view as a border to avoid leaking pixels on corner radius
    private let borderView: UIView

    /// Initializes the avatar view with a size and an optional border
    ///
    /// - Parameters:
    ///   - avatarSize: The MSAvatarSize to configure the avatar view with
    ///   - hasBorder: Boolean describing whether or not to show a border around the avatarView
    @objc public init(avatarSize: MSAvatarSize, withBorder hasBorder: Bool = false) {
        self.avatarSize = avatarSize
        avatarBackgroundColor = UIColor.clear

        initialsView = MSInitialsView(avatarSize: avatarSize)
        initialsView.isHidden = true

        imageView = UIImageView()
        imageView.isHidden = true
        imageView.clipsToBounds = true

        borderView = UIView(frame: .zero)
        borderView.backgroundColor = .white
        borderView.isHidden = !hasBorder

        super.init(frame: CGRect(origin: .zero, size: avatarSize.size))

        addSubview(borderView)
        addSubview(initialsView)
        addSubview(imageView)
    }

    @objc public required init(coder aDecoder: NSCoder) { fatalError() }

    override open var intrinsicContentSize: CGSize {
        return avatarSize.size
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return avatarSize.size
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds
        imageView.layer.cornerRadius = imageView.width / 2

        initialsView.frame = bounds
        initialsView.layer.cornerRadius = initialsView.width / 2

        if !borderView.isHidden {
            let borderWidth = avatarSize == .xxLarge ? Constants.xxLargeBorderWidth : Constants.borderWidth
            borderView.frame = bounds.insetBy(dx: -borderWidth, dy: -borderWidth)
            borderView.layer.cornerRadius = borderView.width / 2
        }
    }

    // MARK: Setup

    /// Sets up the avatarView to show an image or initials based on if an image is provided
    ///
    /// - Parameters:
    ///   - name: The name to create initials with
    ///   - email: The email to create initials with if name is not provided
    ///   - image: The image to be displayed
    public func setup(withName name: String?, email: String?, image: UIImage?) {
        self.name = name
        self.email = email

        if let image = image {
            setupWithImage(image)
        } else {
            setupWithInitials()
        }
    }

    /// Sets up the avatarView with an image
    ///
    /// - Parameters:
    ///   - image: The image to be displayed
    public func setup(withImage image: UIImage) {
        name = nil
        email = nil

        setupWithImage(image)
    }

    private func setupWithInitials() {
        initialsView.setup(withName: name, email: email)
        initialsView.isHidden = false
        imageView.isHidden = true
        if let initialsViewBackgroundColor = initialsView.backgroundColor {
            avatarBackgroundColor = initialsViewBackgroundColor
        }
    }

    private func setupWithImage(_ image: UIImage, animated: Bool = false) {
        let setupImageViewBlock: () -> Void = {
            self.imageView.image = image
            self.initialsView.isHidden = true
            self.imageView.isHidden = false
        }

        // Avoid to dispatch to next runloop, this leads to blinks if we need to reload an avatar view.
        if Thread.isMainThread {
            setupImageViewBlock()
        } else {
            let setupData = SetupData(avatarView: self)
            DispatchQueue.main.async { [weak self] in
                guard let this = self else {
                    return
                }

                // Avatar view was concurrently setup with different values
                if setupData != SetupData(avatarView: this) {
                    return
                }

                if animated {
                    UIView.transition(with: this, duration: Constants.animationDuration, options: [.transitionCrossDissolve], animations: setupImageViewBlock)
                } else {
                    setupImageViewBlock()
                }
            }
        }
    }

    // MARK: Accessibility

    override open var accessibilityLabel: String? { get { return name ?? email } set {} }
    override open var accessibilityTraits: UIAccessibilityTraits { get { return UIAccessibilityTraitImage } set {} }
}
