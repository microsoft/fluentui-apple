//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: AvatarSize

@available(*, deprecated, renamed: "AvatarSize")
public typealias MSAvatarSize = AvatarSize

/// `AvatarSize` detemines the size, font, and corner radius for `AvatarView`
@objc(MSFAvatarSize)
public enum AvatarSize: Int, CaseIterable {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
    case extraExtraLarge

    public var font: UIFont {
        switch self {
        case .extraSmall:
            return UIFont.systemFont(ofSize: 9)
        case .small:
            return UIFont.systemFont(ofSize: 12)
        case .medium:
            return UIFont.systemFont(ofSize: 13)
        case .large:
            return UIFont.systemFont(ofSize: 15)
        case .extraLarge:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        case .extraExtraLarge:
            return UIFont.systemFont(ofSize: 28, weight: .medium)
        }
    }

    public var size: CGSize {
        switch self {
        case .extraSmall:
            return CGSize(width: 18, height: 18)
        case .small:
            return CGSize(width: 24, height: 24)
        case .medium:
            return CGSize(width: 30, height: 30)
        case .large:
            return CGSize(width: 40, height: 40)
        case .extraLarge:
            return CGSize(width: 52, height: 52)
        case .extraExtraLarge:
            return CGSize(width: 70, height: 70)
        }
    }

    /// only used for `MSAvatarView` with `MSAvatarStyle.square`
    var squareCornerRadius: CGFloat {
        switch self {
        case .extraSmall, .small, .medium:
            return 2
        case .large, .extraLarge:
            return 4
        case .extraExtraLarge:
            return 8
        }
    }
}

// MARK: - AvatarStyle

@available(*, deprecated, renamed: "AvatarStyle")
public typealias MSAvatarStyle = AvatarStyle

@objc(MSFAvatarStyle)
public enum AvatarStyle: Int {
    case circle
    case square
}

// MARK: - AvatarView

@available(*, deprecated, renamed: "AvatarView")
public typealias MSAvatarView = AvatarView

/**
 `AvatarView` is used to present an image or initials view representing an entity such as a person.
 If an image is provided the image is presented in either a circular or a square view based on the `AvatarStyle` provided with the initials view presented as a fallback.
 The initials used in the initials view are generated from the provided primary text (e.g. a name) or secondary text (e.g. an email address) used to initialize the avatar view.
 */
@objc(MSFAvatarView)
open class AvatarView: UIView {
    private struct Constants {
        static let borderWidth: CGFloat = 2
        static let extraExtraLargeBorderWidth: CGFloat = 4
        static let animationDuration: TimeInterval = 0.2

        /// If a customBorderImage is set, a custom border of this width will be added to the avatar view.
        static let customBorderWidth: CGFloat = 3
    }

    private struct SetupData: Equatable {
        let primaryText: String?
        let secondaryText: String?

        init(avatarView: AvatarView) {
            self.primaryText = avatarView.primaryText
            self.secondaryText = avatarView.secondaryText
        }
    }

    @objc open var avatarSize: AvatarSize {
        didSet {
            frame.size = avatarSize.size
            initialsView.avatarSize = avatarSize
            invalidateIntrinsicContentSize()
        }
    }

    @objc open var avatarBackgroundColor: UIColor {
        didSet {
            initialsView.setBackgroundColor(avatarBackgroundColor)
        }
    }

    /// Image to be used as border around the avatar. It will be used as a pattern image color,
    /// but It will be scaled to fit the avatar size. If set, the hasBorder initializer value will be ignored,
    /// since it's assumed that the client intends to have a custom border.
    @objc open var customBorderImage: UIImage? {
        didSet {
            if customBorderImage != nil {
                hasCustomBorder = true
                borderView.isHidden = false
                updateCustomBorder()
            } else {
                hasCustomBorder = false
                borderView.isHidden = !hasBorder
                updateBorder()
            }
        }
    }

    @objc open var style: AvatarStyle {
        didSet {
            if style != oldValue {
                setNeedsLayout()
            }
        }
    }

    private var hasBorder: Bool = false
    private var hasCustomBorder: Bool = false
    private var customBorderImageSize: CGSize = .zero
    private var primaryText: String?
    private var secondaryText: String?

    private var initialsView: InitialsView
    private let imageView: UIImageView
    // Use a view as a border to avoid leaking pixels on corner radius
    private let borderView: UIView

    /// Initializes the avatar view with a size and an optional border
    ///
    /// - Parameters:
    ///   - avatarSize: The AvatarSize to configure the avatar view with
    ///   - hasBorder: Boolean describing whether or not to show a border around the avatarView
    ///   - style: The `MSAvatarStyle` to indicate whether the avatar should be displayed as a circle or a square
    @objc public init(avatarSize: AvatarSize, withBorder hasBorder: Bool = false, style: AvatarStyle = .circle) {
        self.avatarSize = avatarSize
        self.style = style
        self.hasBorder = hasBorder
        avatarBackgroundColor = UIColor.clear

        initialsView = InitialsView(avatarSize: avatarSize)
        initialsView.isHidden = true

        imageView = UIImageView()
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        borderView = UIView(frame: .zero)
        borderView.isHidden = !hasBorder

        super.init(frame: CGRect(origin: .zero, size: avatarSize.size))

        addSubview(borderView)
        addSubview(initialsView)
        addSubview(imageView)
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override var intrinsicContentSize: CGSize {
        return avatarSize.size
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return avatarSize.size
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds
        initialsView.frame = imageView.frame

        imageView.layer.cornerRadius = cornerRadius(for: imageView.frame.width)
        initialsView.layer.cornerRadius = imageView.layer.cornerRadius

        if hasCustomBorder {
            updateCustomBorder()
        } else if hasBorder {
           updateBorder()
        }
    }

    private func cornerRadius(for width: CGFloat) -> CGFloat {
        return style == .circle ? width / 2 : avatarSize.squareCornerRadius
    }

    // MARK: Setup

    /// Sets up the avatarView to show an image or initials based on if an image is provided
    ///
    /// - Parameters:
    ///   - primaryText: The primary text to create initials with (e.g. a name)
    ///   - secondaryText: The secondary text to create initials with if primary text is not provided (e.g. an email address)
    ///   - image: The image to be displayed
    @objc public func setup(primaryText: String?, secondaryText: String?, image: UIImage?) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText

        if let image = image {
            setupWithImage(image)
        } else {
            setupWithInitials()
        }

        accessibilityLabel = primaryText ?? secondaryText
    }

    /// Sets up the avatarView with an image
    ///
    /// - Parameters:
    ///   - image: The image to be displayed
    @objc public func setup(image: UIImage) {
        primaryText = nil
        secondaryText = nil

        setupWithImage(image)
    }

    /// Sets up the avatar view with a data from the avatar object.
    /// - Parameter avatar: The avatar object to get content from
    @objc public func setup(avatar: Avatar?) {
        setup(primaryText: avatar?.primaryText, secondaryText: avatar?.secondaryText, image: avatar?.image)
        customBorderImage = avatar?.customBorderImage
    }

    private func setupWithInitials() {
        initialsView.setup(primaryText: primaryText, secondaryText: secondaryText)
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

    private func updateBorder() {
        let borderWidth = avatarSize == .extraExtraLarge ? Constants.extraExtraLargeBorderWidth : Constants.borderWidth
        borderView.frame = bounds.insetBy(dx: -borderWidth, dy: -borderWidth)
        borderView.layer.cornerRadius = cornerRadius(for: borderView.frame.width)
        borderView.backgroundColor = Colors.Avatar.border
    }

    private func updateCustomBorder() {
        guard let customBorderImage = customBorderImage else {
            return
        }

        let expectedFrame = bounds.insetBy(dx: -Constants.customBorderWidth, dy: -Constants.customBorderWidth)
        if customBorderImageSize == expectedFrame.size {
            return
        }

        borderView.frame = expectedFrame
        let size = expectedFrame.size
        customBorderImageSize = size
        borderView.layer.cornerRadius = cornerRadius(for: size.width)

        var image = customBorderImage
        if customBorderImage.size != size {
            let renderer = UIGraphicsImageRenderer(size: size)
            image = renderer.image { _ in
                customBorderImage.draw(in: CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height)))
            }.withRenderingMode(.alwaysOriginal)
        }

        borderView.backgroundColor = UIColor(patternImage: image)
    }

    // MARK: Accessibility

    open override var isAccessibilityElement: Bool { get { return true } set { } }
    open override var accessibilityLabel: String? { get { return primaryText ?? secondaryText } set { } }
    open override var accessibilityTraits: UIAccessibilityTraits { get { return .image } set { } }
}
