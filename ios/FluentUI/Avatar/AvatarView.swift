//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - AvatarSize

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
            return CGSize(width: 16, height: 16)
        case .small:
            return CGSize(width: 24, height: 24)
        case .medium:
            return CGSize(width: 32, height: 32)
        case .large:
            return CGSize(width: 40, height: 40)
        case .extraLarge:
            return CGSize(width: 52, height: 52)
        case .extraExtraLarge:
            return CGSize(width: 72, height: 72)
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

    /// Inner stroke lining the avatar view for the border option
    var insideBorder: CGFloat {
        switch self {
        case .extraSmall:
            return 1
        case .small:
            return 1.5
        case .medium, .large, .extraLarge:
            return 2
        case .extraExtraLarge:
            return 4
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .extraSmall, .small, .medium, .large, .extraLarge:
            return 2
        case .extraExtraLarge:
            return 4
        }
    }

    var presenceSize: PresenceSize {
        switch self {
        case .extraSmall, .small, .medium:
            return PresenceSize.normal
        case .large, .extraLarge:
            return PresenceSize.large
        case .extraExtraLarge:
            return PresenceSize.extraLarge
        }
    }

    var presenceCornerOffset: CGFloat {
        switch self {
        case .extraSmall, .large, .medium:
            return 0
        case .small:
            return -1
        case .extraLarge:
            return 2
        case .extraExtraLarge:
            return 3
        }
    }

    var personImageSize: CGFloat {
        switch self {
        case .extraSmall:
            return 12
        case .small:
            return 16
        case .medium:
            return 20
        case .large:
            return 24
        case .extraLarge:
            return 28
        case .extraExtraLarge:
            return 48
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

// MARK: - AvatarFallbackImageStyle

@objc(MSFAvatarFallbackImageStyle)
public enum AvatarFallbackImageStyle: Int {
    case onAccentFilled
    case outlined
    case primaryFilled
    case primaryOutlined

    func backgroundColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outlined:
            return UIColor(light: Colors.gray50, dark: Colors.gray600)
        case .onAccentFilled:
            return Colors.primary(for: window)
        case .primaryFilled:
            return UIColor(light: .white, dark: Colors.primary(for: window))
        case .primaryOutlined:
            return UIColor(light: Colors.primaryTint40(for: window), dark: Colors.gray600)
        }
    }

    func imageColor(for window: UIWindow) -> UIColor {
        switch self {
        case .outlined:
            return UIColor(light: Colors.gray500, dark: Colors.gray200)
        case .onAccentFilled:
            return Colors.iconOnAccent
        case .primaryFilled:
            return UIColor(light: Colors.primary(for: window), dark: Colors.iconOnAccent)
        case .primaryOutlined:
            return UIColor(light: Colors.primary(for: window), dark: Colors.gray200)
        }
    }

    func imageName(size: AvatarSize) -> String {
        let personImageSize = size.personImageSize
        switch self {
        case .outlined, .primaryOutlined:
            return "person_\(Int(personImageSize))_regular"
        case .onAccentFilled, .primaryFilled:
            return "person_\(Int(personImageSize))_filled"
        }
    }
}

// MARK: - Avatar Colors

public extension Colors {
    struct Avatar {
        // Should use physical color because this text is shown on physical avatar background
        public static var text: UIColor = textOnAccent
        public static var border = UIColor(light: gray300, dark: gray900, darkElevated: gray800)
    }
}

// MARK: - AvatarView

@available(*, deprecated, renamed: "AvatarView")
public typealias MSAvatarView = AvatarView

/**
 `AvatarView` is used to present an image or initials view representing an entity such as a person.
 If an image is provided the image is presented in either a circular or a square view based on the `AvatarStyle` provided with the initials view presented as a fallback.
 The initials used in the initials view are generated from the provided primary text (e.g. a name) or secondary text (e.g. an email address) used to initialize the avatar view.
 To show fallback person icon image, `AvatarFallbackImageStyle` can be passed in `setup()`.
 */
@objc(MSFAvatarView)
open class AvatarView: UIView {
    @objc open var avatarSize: AvatarSize {
        didSet {
            updatePresenceImage()

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
            if oldValue != customBorderImage {
                if customBorderImage != nil {
                    hasCustomBorder = true
                    borderView.isHidden = false
                    updateCustomBorder()
                } else {
                    customBorderImageSize = .zero
                    hasCustomBorder = false
                    borderView.isHidden = !hasBorder
                    updateBorder()
                }
                setNeedsLayout()
            }
        }
    }

    @objc open var style: AvatarStyle {
        didSet {
            if style != oldValue {
                updatePresenceImage()
                setNeedsLayout()
            }
        }
    }
    
    @objc open var shouldCalculateRingColor: Bool = false {
        didSet {
            updateBorderColor()
        }
    }
    
    @objc open var borderColor: UIColor? {
        didSet {
            if hasBorder && !hasCustomBorder {
                updateBorderColor()
            }
        }
    }

    /// The avatar view's presence state.
    /// The presence state is only shown when the style is set to AvatarStyle.circle.
    @objc open var presence: Presence = .none {
        didSet {
            if oldValue != presence {
                updatePresenceImage()
            }
        }
    }

    /// When true, the presence status border is opaque. Otherwise, it is transparent.
    @objc open var useOpaquePresenceBorder: Bool = false {
        didSet {
            updatePresenceImage()
        }
    }

    /// Set this to override the avatar view's default accessibility label.
    @objc open var overrideAccessibilityLabel: String?

    /// Used when avatarView doesn't have image or can't generate initials string
    @objc open var preferredFallbackImageStyle: AvatarFallbackImageStyle = .outlined {
        didSet {
            if preferredFallbackImageStyle != oldValue {
                if let fallbackImageStyle = fallbackImageStyle, fallbackImageStyle == oldValue {
                    updateImageViewWithFallbackImage(style: preferredFallbackImageStyle)
                }
            }
        }
    }

    /// Set to true to enable the pointer interaction on the avatar view, false by default.
    @objc open var hasPointerInteraction: Bool = false {
        didSet {
            if oldValue != hasPointerInteraction {
                if #available(iOS 13.4, *) {
                    // Workaround check for beta iOS versions missing the Pointer Interactions API
                    if arePointerInteractionAPIsAvailable() {
                        if hasPointerInteraction {
                            let pointerInteraction = UIPointerInteraction(delegate: self)
                            addInteraction(pointerInteraction)

                            self.pointerInteraction = pointerInteraction
                        } else if let pointerInteraction = pointerInteraction as? UIPointerInteraction {
                            removeInteraction(pointerInteraction)
                            self.pointerInteraction = nil
                        }
                    }
                }
            }
        }
    }

    /// Set to true to not have inside gap between content of the avatarView to its border
    @objc open var hideInsideGapForBorder: Bool = false {
        didSet {
            if oldValue != hideInsideGapForBorder && (hasBorder || hasCustomBorder) {
                setNeedsLayout()
            }
        }
    }

    /// Initializes the avatar view with a size and an optional border
    ///
    /// - Parameters:
    ///   - avatarSize: The AvatarSize to configure the avatar view with
    ///   - hasBorder: Boolean describing whether or not to show a border around the avatarView
    ///   - style: The `MSAvatarStyle` to indicate whether the avatar should be displayed as a circle or a square
    @objc public convenience init(avatarSize: AvatarSize, withBorder hasBorder: Bool = false, style: AvatarStyle = .circle) {
        self.init(avatarSize: avatarSize, withBorder: hasBorder, style: style, preferredFallbackImageStyle: .outlined)
    }

    /// Initializes the avatar view with a size and an optional border
    ///
    /// - Parameters:
    ///   - avatarSize: The AvatarSize to configure the avatar view with
    ///   - hasBorder: Boolean describing whether or not to show a border around the avatarView
    ///   - style: The `MSAvatarStyle` to indicate whether the avatar should be displayed as a circle or a square
    ///   - preferredFallbackImageStyle: `AvatarFallbackImageStyle` used when avatarView doesn't have an image or can't show initials text
    @objc public init(avatarSize: AvatarSize, withBorder hasBorder: Bool = false, style: AvatarStyle = .circle, preferredFallbackImageStyle: AvatarFallbackImageStyle = .outlined) {
        self.avatarSize = avatarSize
        self.style = style
        self.hasBorder = hasBorder
        self.preferredFallbackImageStyle = preferredFallbackImageStyle
        avatarBackgroundColor = UIColor.clear

        initialsView = InitialsView(avatarSize: avatarSize)
        initialsView.isHidden = true

        imageView = UIImageView(frame: .zero)
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        borderView = UIView(frame: .zero)
        borderView.isHidden = !hasBorder

        containerView = UIView(frame: CGRect(origin: .zero, size: avatarSize.size))
        containerView.addSubview(borderView)
        containerView.addSubview(initialsView)
        containerView.addSubview(imageView)

        super.init(frame: containerView.frame)

        accessibilityTraits = .image

        addSubview(containerView)
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

        imageView.frame = imageFrame()
        initialsView.frame = imageView.frame

        if let presenceImageView = presenceImageView, let presenceBorderView = presenceBorderView {
            presenceImageView.frame = presenceFrame()
            presenceBorderView.frame = presenceBorderFrame()

            presenceImageView.layer.cornerRadius = presenceImageView.frame.width / 2
            presenceBorderView.layer.cornerRadius = presenceBorderView.frame.width / 2

            updatePresenceMask()
        }

        imageView.layer.cornerRadius = cornerRadius(for: imageView.frame.width)
        initialsView.layer.cornerRadius = imageView.layer.cornerRadius

        if hasCustomBorder {
            updateCustomBorder()
        } else if hasBorder {
            updateBorder()
        }

        if let fallbackImageStyle = fallbackImageStyle {
            updateImageViewWithFallbackImage(style: fallbackImageStyle)
        }
    }

    open override func didMoveToWindow() {
         super.didMoveToWindow()

         if let fallbackImageStyle = fallbackImageStyle {
             updateImageViewWithFallbackImage(style: fallbackImageStyle)
         }
     }

    // MARK: Setup

    /// Sets up the avatarView to show an image or initials based on if an image is provided. If client fails to provide image or text to generate initials, fallback person icon will be shown.
    ///
    /// - Parameters:
    ///   - primaryText: The primary text to create initials with (e.g. a name)
    ///   - secondaryText: The secondary text to create initials with if primary text is not provided (e.g. an email address)
    ///   - image: The image to be displayed
    ///   - presence: The presence state
    ///   - convertTextToInitials: If true, the provided text values will be converted to initials when shown in the avatar view. If false, the text is directly displayed. Primary text is prioritized over secondary text.
    @objc public func setup(primaryText: String?,
                            secondaryText: String?,
                            image: UIImage?,
                            presence: Presence = .none,
                            convertTextToInitials: Bool = true) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.presence = presence
        self.fallbackImageStyle = nil
        if let image = image {
            setupWithImage(image)
        } else if !convertTextToInitials || isInitialsAvailable() {
            setupWithInitialsView(convertTextToInitials: convertTextToInitials)
        } else {
            updateImageViewWithFallbackImage(style: preferredFallbackImageStyle)
        }

        accessibilityLabel = primaryText ?? secondaryText
    }

    /// Sets up the avatarView with an image
    ///
    /// - Parameters:
    ///   - image: The image to be displayed
    ///   - presence: The presence state
    @objc public func setup(image: UIImage, presence: Presence = .none) {
        primaryText = nil
        secondaryText = nil
        self.presence = presence
        self.fallbackImageStyle = nil
        setupWithImage(image)
    }

    /// Sets up the avatar view with a data from the avatar object.
    /// - Parameter avatar: The avatar object to get content from
    @objc public func setup(avatar: Avatar?) {
        setup(primaryText: avatar?.primaryText, secondaryText: avatar?.secondaryText, image: avatar?.image, presence: avatar?.presence ?? .none)
        customBorderImage = avatar?.customBorderImage
        hideInsideGapForBorder = avatar?.hideInsideGapForBorder ?? false

        if let color = avatar?.color {
            borderColor = color
            avatarBackgroundColor = color
        }
    }

    /// Sets up the avatarView with a fallback image of a person
    ///
    /// - Parameters:
    ///   - fallbackStyle: The image style to be displayed
    ///   - presence: The presence state
    @objc public func setup(fallbackStyle: AvatarFallbackImageStyle, presence: Presence = .none) {
        primaryText = nil
        secondaryText = nil
        self.presence = presence

        updateImageViewWithFallbackImage(style: fallbackStyle)
    }

    private var hasBorder: Bool = false
    private var hasCustomBorder: Bool = false
    private var fallbackImageStyle: AvatarFallbackImageStyle?
    private var customBorderImageSize: CGSize = .zero
    private var primaryText: String?
    private var secondaryText: String?

    fileprivate var initialsView: InitialsView
    private let imageView: UIImageView
    private let containerView: UIView

    // Use a view as a border to avoid leaking pixels on corner radius
    private let borderView: UIView

    private var presenceImageView: UIImageView?
    private var presenceBorderView: UIView?

    private var pointerInteraction: Any?

    private struct Constants {
        static let borderWidth: CGFloat = 2
        static let extraExtraLargeBorderWidth: CGFloat = 4
        static let animationDuration: TimeInterval = 0.2

        /// The width for the presence status border.
        static let presenceBorderWidth: CGFloat = 2
    }

    private struct SetupData: Equatable {
        let primaryText: String?
        let secondaryText: String?

        init(avatarView: AvatarView) {
            self.primaryText = avatarView.primaryText
            self.secondaryText = avatarView.secondaryText
        }
    }

    private func setupWithInitialsView(convertTextToInitials: Bool) {
        if convertTextToInitials {
            initialsView.setup(primaryText: primaryText, secondaryText: secondaryText)
        } else {
            initialsView.setup(initialsText: primaryText ?? secondaryText)
        }

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
        borderView.layer.borderWidth = avatarSize.borderWidth
        borderView.frame = bounds
        borderView.layer.cornerRadius = cornerRadius(for: borderView.frame.width)
        updateBorderColor()
    }

    private func updateBorderColor() {
        if let borderColor = borderColor {
            borderView.layer.borderColor = borderColor.cgColor
        } else {
            borderView.layer.borderColor = shouldCalculateRingColor ?
                InitialsView.initialsColorSet(fromPrimaryText: primaryText, secondaryText: secondaryText).background.cgColor : Colors.Avatar.border.cgColor
        }
    }

    private func updateCustomBorder() {
        guard let customBorderImage = customBorderImage else {
            return
        }

        let size = bounds.size
        borderView.frame = bounds
        customBorderImageSize = size
        borderView.layer.cornerRadius = cornerRadius(for: size.width)

        var image = customBorderImage
        if customBorderImage.size != size {
            let renderer = UIGraphicsImageRenderer(size: size)
            image = renderer.image { _ in
                customBorderImage.draw(in: CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height)))
            }.withRenderingMode(.alwaysOriginal)
        }

        borderView.layer.borderWidth = avatarSize.borderWidth
        borderView.layer.borderColor = UIColor(patternImage: image).cgColor
    }

    private func updatePresenceImage() {
        if isDisplayingPresence() {
            if presenceImageView == nil {
                presenceImageView = UIImageView(frame: .zero)
                presenceBorderView = UIView(frame: .zero)

                let presenceBorderColor = UIColor(named: "presenceBorder", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
                presenceBorderView?.backgroundColor = presenceBorderColor

                addSubview(presenceBorderView!)
                addSubview(presenceImageView!)
            }

            presenceBorderView?.isHidden = !useOpaquePresenceBorder

            let image = presence.image(size: avatarSize.presenceSize)
            if let image = image {
                presenceImageView?.image = image
            }
        } else if presenceImageView != nil {
            presenceImageView?.removeFromSuperview()
            presenceBorderView?.removeFromSuperview()
            presenceImageView = nil
            presenceBorderView = nil
        }

        updatePresenceMask()
    }

    private func imageFrame() -> CGRect {
        var suggestedRect = bounds
        if style == .circle && (hasBorder || hasCustomBorder) {
            var delta = avatarSize.borderWidth
            if !hideInsideGapForBorder {
                delta += avatarSize.insideBorder
            }
            suggestedRect = suggestedRect.insetBy(dx: delta, dy: delta)
        }
        return suggestedRect
    }

    private func presenceFrame() -> CGRect {
        let presenceSize = avatarSize.presenceSize.sizeValue
        let presenceCornerOffset = style == .circle ? avatarSize.presenceCornerOffset : 0.0

        var presenceXOrigin = presenceCornerOffset
        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            presenceXOrigin = bounds.width - presenceSize - presenceXOrigin
        }

        return CGRect(x: presenceXOrigin,
                      y: bounds.height - presenceSize - presenceCornerOffset,
                      width: presenceSize,
                      height: presenceSize)
    }

    private func presenceBorderFrame() -> CGRect {
        var frame = presenceFrame()
        frame.origin.x -= Constants.presenceBorderWidth
        frame.origin.y -= Constants.presenceBorderWidth
        frame.size.width += Constants.presenceBorderWidth * 2
        frame.size.height += Constants.presenceBorderWidth * 2

        return frame
    }

    private func updatePresenceMask() {
        if !useOpaquePresenceBorder && isDisplayingPresence() {
            let borderWidth = avatarSize.borderWidth
            var maskFrame = bounds
            maskFrame.origin.x -= borderWidth
            maskFrame.origin.y -= borderWidth
            maskFrame.size.width += borderWidth * 4
            maskFrame.size.height += borderWidth * 4

            var presenceFrame = presenceBorderFrame()
            presenceFrame.origin.x += borderWidth
            presenceFrame.origin.y += borderWidth

            let path = UIBezierPath(rect: maskFrame)
            path.append(UIBezierPath(ovalIn: presenceFrame))

            let maskLayer = CAShapeLayer()
            maskLayer.frame = maskFrame
            maskLayer.fillRule = .evenOdd
            maskLayer.path = path.cgPath

            containerView.layer.mask = maskLayer
        } else {
            containerView.layer.mask = nil
        }
    }

    private func updateImageViewWithFallbackImage(style: AvatarFallbackImageStyle = .primaryFilled) {
        let imageName = style.imageName(size: avatarSize)
        if let image = UIImage.staticImageNamed(imageName) {
            let containerSize = avatarSize.size
            let renderer = UIGraphicsImageRenderer(size: containerSize)

            let personImage = renderer.image { _ in
                let personImageSize = avatarSize.personImageSize
                image.draw(at: CGPoint(x: floor((containerSize.width - personImageSize) / 2), y: floor((containerSize.height - personImageSize) / 2)))
            }.withRenderingMode(.alwaysTemplate)
            setupWithImage(personImage)

            if let window = window {
                imageView.backgroundColor = style.backgroundColor(for: window)
                imageView.tintColor = style.imageColor(for: window)
            }

            fallbackImageStyle = style
        }
    }

    private func isInitialsAvailable() -> Bool {
        let initials = InitialsView.initialsText(fromPrimaryText: primaryText, secondaryText: secondaryText)
        return initials.count > 0
    }

    private func isDisplayingPresence() -> Bool {
        return presence != .none && avatarSize != .extraSmall && style == .circle
    }

    fileprivate func cornerRadius(for width: CGFloat) -> CGFloat {
        return style == .circle ? width / 2 : avatarSize.squareCornerRadius
    }

    // MARK: Accessibility

    open override var isAccessibilityElement: Bool { get { return true } set { } }

    open override var accessibilityLabel: String? {
        get {
            if let overrideAccessibilityLabel = overrideAccessibilityLabel {
                return overrideAccessibilityLabel
            }

            var label = primaryText ?? secondaryText
            if let presenceString = presence.string {
                if label?.count ?? 0 > 0 {
                    label = String(format: "Accessibility.AvatarView.LabelFormat".localized, label!, presenceString)
                } else {
                    label = presenceString
                }
            }

            return label
        }
        set { }
    }
}

// MARK: - OverflowAvatarView

class OverflowAvatarView: AvatarView {
    @objc public init(overflowCount: UInt, avatarSize: AvatarSize, withBorder hasBorder: Bool = false) {
        super.init(avatarSize: avatarSize, withBorder: hasBorder, style: .circle, preferredFallbackImageStyle: .outlined)

        let overflowCountString = NumberFormatter.localizedString(from: NSNumber(value: overflowCount), number: .none)

        setup(primaryText: overflowCountString, secondaryText: nil, image: nil, convertTextToInitials: false)
        avatarBackgroundColor = .clear
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateColors()
    }

    private func updateColors() {
        initialsView.setFontColor(UIColor(light: Colors.gray500, dark: Colors.gray100))
        initialsView.setBackgroundColor(UIColor(light: Colors.gray50, dark: Colors.gray600))
        borderColor = UIColor(light: Colors.gray200, dark: Colors.gray500)
    }
}

// MARK: - AvatarView UIPointerInteractionDelegate

extension AvatarView: UIPointerInteractionDelegate {
    @available(iOS 13.4, *)
    public func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        guard let superview = window else {
            return nil
        }

        let frame = superview.convert(bounds, from: self)
        let target = UIPreviewTarget(container: superview, center: CGPoint(x: frame.midX, y: frame.midY))
        let preview = UITargetedPreview(view: self, parameters: UIPreviewParameters(), target: target)
        let pointerEffect = UIPointerEffect.lift(preview)

        return UIPointerStyle(effect: pointerEffect, shape: nil)
    }
}
