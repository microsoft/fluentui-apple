//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// A visual Avatar icon for a user, cropped to a circle that either displays the user's
/// image if available or the user's initials if an image is not available
@objc(MSFAvatarView)
open class AvatarView: NSView {
	/// Initializes the avatar view with a name, email, image, and size. If
	/// an image is provided, the avatar view will show the image. If no image is
	/// provided but a name is provided, the avatar view will show the initials of
	/// the name if initials can be extracted. Finally, if an email is provided but
	/// no name is provided, the first two characters of the email are used as
	/// initials.
	///	- Parameters:
	/// 	- avatarSize: the size in points for both the width and height
	/// 				of the avatar view
	/// 	- contactName: the name of the contact with the
	///				format “<First Name> <Last Name>”
	/// 	- contactEmail: the name of the contact with the
	///				format “<person>@<service>.<domain>”
	/// 	- contactImage: the image of the contact
    @objc public init(avatarSize: CGFloat,
                      contactName: String? = nil,
                      contactEmail: String? = nil,
                      contactImage: NSImage? = nil) {

		let color = AvatarView.getInitialsColorSet(fromPrimaryText: contactName, secondaryText: contactEmail)
		avatarBackgroundColor = color.background.resolvedColor()
		initialsFontColor = color.foreground.resolvedColor()
		self.contactName = contactName
		self.contactEmail = contactEmail
		self.contactImage = contactImage
		self.avatarSize = avatarSize

		displayStyle = contactImage == nil ? .initials : .image

		super.init(frame: .zero)

		let circularPath = CGPath.circularPath(withCircleDiameter: diameterForContentCircle())
		circleMask.path = circularPath
		contentView.layer?.mask = circleMask

		let widthConstraint = widthAnchor.constraint(equalToConstant: avatarSize)
		let heightConstraint = heightAnchor.constraint(equalToConstant: avatarSize)
		NSLayoutConstraint.activate([widthConstraint, heightConstraint])

		self.widthConstraint = widthConstraint
		self.heightConstraint = heightConstraint

		updateViewStyle()
		updateAvatarViewContents()
	}

	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}

	open override func updateLayer() {
		CATransaction.begin()
		defer {
			CATransaction.commit()
		}
		// Disable animations for this change
		CATransaction.setDisableActions(true)
	}

	/// The background color of the avatar view when no image is provided.
	/// Setting this property will override the default provided color.
	@objc open var avatarBackgroundColor: NSColor {
		didSet {
			guard oldValue != avatarBackgroundColor else {
				return
			}
			isCustomAvatarBackgroundColorConfigured = true
			needsDisplay = true
			initialsView.layer?.backgroundColor = avatarBackgroundColor.cgColor
		}
	}

	/// The initials font color of the avatar view when no image is provided.
	/// Setting this property will override the default provided color.
	@objc open var initialsFontColor: NSColor {
		didSet {
			guard oldValue != initialsFontColor else {
				return
			}
			isCustomAvatarInitialColorConfigured = true
			needsDisplay = true
			initialsTextField.textColor = initialsFontColor
		}
	}

	/// The image to be displayed in the AvatarView. If nil, the avatar’s initials
	/// will be displayed instead
	@objc open var contactImage: NSImage? {
		didSet {
			guard oldValue != contactImage else {
				return
			}

			contactImageView.image = contactImage

			// Update our display style and content
			updateAvatarViewContents()
		}
	}

	/// The contact's name
	@objc open var contactName: String? {
		didSet {
			guard oldValue != contactName else {
				return
			}
			updateAvatarViewContents()
		}
	}

	/// The contact's email
	@objc open var contactEmail: String? {
		didSet {
			guard oldValue != contactEmail else {
				return
			}
			updateAvatarViewContents()
		}
	}

	/// Storage of the size of this avatar view in points
	@objc open var avatarSize: CGFloat {
		didSet {
			if let widthConstraint = widthConstraint, let heightConstraint = heightConstraint {
				widthConstraint.constant = avatarSize
				heightConstraint.constant = avatarSize
			} else {
				assertionFailure()
			}

			updateHeight()
		}
	}

	@objc open var borderColor: NSColor = AvatarView.defaultBorderColor {
		didSet {
			guard oldValue != borderColor, hasBorder else {
				return
			}

			borderView.strokeColor = borderColor
			borderView.needsDisplay = true
		}
	}

	@objc open var hasBorder: Bool = false {
		didSet {
			guard oldValue != hasBorder else {
				return
			}

			borderView.isHidden = !hasBorder
			updateHeight()
		}
	}

	/// Set to true to not have inside gap between content of the avatarView to its border
	@objc public var hideInsideGapForBorder: Bool = false {
		didSet {
			guard oldValue != hideInsideGapForBorder else {
				return
			}

			updateHeight()
		}
	}

	/// The width constraint giving this view its size
	private var widthConstraint: NSLayoutConstraint?

	/// The height constraint giving this view its size
	private var heightConstraint: NSLayoutConstraint?

	/// The height constraint for the initials sizing view which should update on font size changes
	private var initialsSizingViewHeightConstraint: NSLayoutConstraint?

	/// The width constraint of contentView
	private var  contentViewWidthConstraint: NSLayoutConstraint?

	/// The height constraint of contentView
	private var  contentViewHeightConstraint: NSLayoutConstraint?

	/// The layer used to mask the overall AvatarView to a circle
	private let circleMask = CAShapeLayer()

	/// The apperance observer to update colors when theme is changed
	private var appearanceObserver: NSKeyValueObservation?

	/// A property for the display style based on whether an image exists or not.
	private var displayStyle: DisplayStyle {
		didSet {
			guard oldValue != displayStyle else {
				return
			}
			updateViewStyle()
		}
	}

	private var isCustomAvatarBackgroundColorConfigured: Bool = false
	private var isCustomAvatarInitialColorConfigured: Bool = false

	private lazy var contentView: NSView = {
		let contentView = NSView()
		contentView.wantsLayer = true
		contentView.translatesAutoresizingMaskIntoConstraints = false
		return contentView
	}()

	/// When an image is provided, this view is added to the view hierarchy
	private lazy var contactImageView: NSImageView = {
		let contactImageView = NSImageView()
		contactImageView.translatesAutoresizingMaskIntoConstraints = false
		contactImageView.image = contactImage
		contactImageView.imageScaling = .scaleProportionallyUpOrDown
		return contactImageView
	}()

	/// When no image is provided, this view is added to the view hierarchy
	private lazy var initialsView: NSView = {
		let initialsView = NSView()
		initialsView.wantsLayer = true
		initialsView.translatesAutoresizingMaskIntoConstraints = false

		let textView = initialsTextField
		initialsView.addSubview(textView)

		var constraints = [
			textView.leadingAnchor.constraint(equalTo: initialsView.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: initialsView.trailingAnchor)
		]

		// If we have a font, use that to accurately center the initials, not letting diacritics and descenders/ascenders
		// impact the centering
		let capHeight = font(forCircleDiameter: diameterForContentCircle()).capHeight
		// Create an empty view that gives reasonable sizing information on the actual text of our text view
		let initialsTextSizingView = NSView(frame: .zero)
		initialsView.addSubview(initialsTextSizingView)
		initialsTextSizingView.translatesAutoresizingMaskIntoConstraints = false

		let initialsSizingViewHeightConstraint = initialsTextSizingView.heightAnchor.constraint(equalToConstant: ceil(capHeight))
		self.initialsSizingViewHeightConstraint = initialsSizingViewHeightConstraint
		constraints.append(contentsOf: [
			initialsTextSizingView.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
			initialsTextSizingView.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
			initialsTextSizingView.centerYAnchor.constraint(equalTo: initialsView.centerYAnchor),
			initialsTextSizingView.bottomAnchor.constraint(equalTo: textView.firstBaselineAnchor),
			initialsSizingViewHeightConstraint
		])

		NSLayoutConstraint.activate(constraints)

		return initialsView
	}()

	/// The text field used for displaying the initials within the initialsView
	private lazy var initialsTextField: NSTextField = {
		let textView = NSTextField(labelWithString: AvatarView.initialsWithFallback(name: contactName, email: contactEmail))
		textView.alignment = .center
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = font(forCircleDiameter: diameterForContentCircle())
		textView.textColor = initialsFontColor
		return textView
	}()

	/// The view that draws the border stroke around the edge of the AvatarView
	private lazy var borderView: BorderView = {
		let rect = CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)
		let borderView = BorderView(frame: rect, strokeColor: borderColor, strokeWidth: AvatarView.borderWidth)
		borderView.translatesAutoresizingMaskIntoConstraints = false
		borderView.isHidden = !hasBorder
		return borderView
	}()

	/// Update this view to use the proper style when switching from Image to Initials or vice-versa
	private func updateViewStyle() {
		let currentView: NSView
		switch displayStyle {
		case .initials:
			initialsView.isHidden = false
			contactImageView.isHidden = true
			currentView = initialsView
		case .image:
			contactImageView.isHidden = false
			initialsView.isHidden = true
			currentView = contactImageView
		}
		contentView.addSubview(currentView)

		// Replace all existing subviews with the proper ones, ensuring the correct z-ordering
		subviews = [
			contentView,
			borderView
		]

		let diameter = diameterForContentCircle()
		let contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: diameter)
		let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: diameter)
		self.contentViewWidthConstraint = contentViewWidthConstraint
		self.contentViewHeightConstraint = contentViewHeightConstraint

		let constraints = [
			contentViewWidthConstraint,
			contentViewHeightConstraint,
			contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			currentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			currentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			currentView.topAnchor.constraint(equalTo: contentView.topAnchor),
			currentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			borderView.topAnchor.constraint(equalTo: self.topAnchor),
			borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]

		NSLayoutConstraint.activate(constraints)
	}

	/// Update avatar view contents based on the latest values in properties
	private func updateAvatarViewContents() {
		let hasImage: Bool = contactImage != nil

		// Set up accessibility values if we have any information to return
		if let bestDescription = contactName ?? contactEmail {
			toolTip = bestDescription
			setAccessibilityElement(true)
			setAccessibilityLabel(bestDescription)
			setAccessibilityRole(.image)
		} else {
			toolTip = nil
			setAccessibilityLabel(nil)
			if !hasImage {
				setAccessibilityElement(false)
				setAccessibilityRole(.unknown)
			}
		}

		initialsTextField.stringValue = AvatarView.initialsWithFallback(name: contactName, email: contactEmail)
		displayStyle = hasImage ? .image : .initials
		updateAppearance(window?.effectiveAppearance)
	}

	private func updateAppearance(_ appearance: NSAppearance? = nil) {
		if displayStyle != .initials {
			return
		}

		var updatedBackgroundColor = avatarBackgroundColor
		var updatedInitialsColor = initialsFontColor
		if !isCustomAvatarBackgroundColorConfigured || !isCustomAvatarInitialColorConfigured {
			let defaultColorSet = AvatarView.getInitialsColorSet(fromPrimaryText: contactName, secondaryText: contactEmail)

			if !isCustomAvatarBackgroundColorConfigured {
				updatedBackgroundColor = defaultColorSet.background.resolvedColor(appearance)
			}

			if !isCustomAvatarInitialColorConfigured {
				updatedInitialsColor = defaultColorSet.foreground.resolvedColor(appearance)
			}
		}

		initialsView.layer?.backgroundColor = updatedBackgroundColor.cgColor
		initialsTextField.textColor = updatedInitialsColor
		needsDisplay = true
	}

	private func updateHeight() {
		let diameter = diameterForContentCircle()
		let circularPath = CGPath.circularPath(withCircleDiameter: diameter)
		circleMask.path = circularPath

		let textFieldFont = font(forCircleDiameter: diameter)
		initialsTextField.font = textFieldFont

		// This constraint will only exist if we're using the sizing view approach to center our initials
		initialsSizingViewHeightConstraint?.constant = ceil(textFieldFont.capHeight)
		contentViewHeightConstraint?.constant = diameter
		contentViewWidthConstraint?.constant = diameter
	}

	private func diameterForContentCircle() -> CGFloat {
		// When showing the border but there isn't inside gap between contentView and the borderView,
		// making the content circle exactly the size of avatarSize - (AvatarView.borderWidth * 2) may cause pixel gaps in the cicle edges
		return hasBorder && !hideInsideGapForBorder ? avatarSize - (AvatarView.borderWidth * 2) - (AvatarView.contentInset * 2) : avatarSize
	}

	/// Get the ColorSet associated with a given index
	/// - parameter index: the index into the color table
	///
	/// - returns: the color table entry for the given index
	@objc(getColorForIndex:)
	@available(*, deprecated, message: "Use getInitialsColorSetFromPrimaryText:secondaryText: instead")
	public static func getColor(for index: Int) -> LegacyColorSet {
		let avatarBackgroundColors = AvatarView.avatarColors
		return avatarBackgroundColors[index % avatarBackgroundColors.count]
	}

	/// Returns a hash value for `identifyingString` that can be mapped to a legacy color asset catalog
	/// - parameter identifyingString:the  identifying string for the user
	///
	/// - Returns: a hashed valued that needs to be mapped using `getLegacyBackgroundColorForHash` to retrieve a color for avatar view rendering
	///
	/// - note: API method avaiable for legacy support only, This will be removed in future release
	@objc(colorHashForIdentifyingString:)
	@available(*, deprecated, message: "Use getInitialsColorSetFromPrimaryText:secondaryText: instead")
	public static func colorHash(for identifyingString: String) -> Int {
		return identifyingString.utf16.enumerated().reversed().reduce(0) { (hashCode, enumeratedCodePoints) -> Int in
			// upcast our UInt16s to standard Ints as that's how the hashing algorithm works in other codebases
			let integerCodePoint = Int(enumeratedCodePoints.element)
			let shift = enumeratedCodePoints.offset % 8
			return hashCode ^ Int((integerCodePoint << shift) + (integerCodePoint >> (8 - shift)))
		}
	}

	/// Get the legacy color associated with a given hash value using `colorHashForIdentifyingString`
	/// - parameter hashValue: the hash value represting user identfying string.
	///
	/// - returns: the color table entry for the given hashed value
	///
	/// - note: API method avaiable for legacy support only, This will be removed in future release
	@objc(getLegacyBackgroundColorForHash:)
	@available(*, deprecated, message: "Use getInitialsColorSetFromPrimaryText:secondaryText: instead")
	public static func getLegacyColor(for hashValue: Int) -> NSColor {
		let legacyAvatarBackgroundColors = AvatarView.legacyAvatarViewBackgroundColor
		return legacyAvatarBackgroundColors[abs(hashValue % legacyAvatarBackgroundColors.count)]
	}

	/// the font size in the initials view will be scaled to this fraction of the avatarSize passed in
	static let fontSizeScalingDefault: CGFloat = 0.4

	/// fall back to this text in the initials view when no usable name or email is provided
	static let fallbackInitial: String = "#"

	/// the maximum number of initials to be displayed when we don't have an image
	static let maximumNumberOfInitials: Int = 2

	/// the color used for the border
	static let defaultBorderColor: NSColor = .init(named: "AvatarView/borderColor", bundle: FluentUIResources.resourceBundle)!

	static let borderWidth: CGFloat = 2.0

	/// inset of the contentView from the borderView
	static let contentInset: CGFloat = 2.0

	/// Extract the initials to display from a name and email combo, providing a fallback otherwise
	///
	/// - Parameters:
	/// 	- name: the name of the contact with the format “<First Name> <Last Name>”
	/// 	- email: the name of the contact with the format “<person>@<service>.<domain>"
	///
	/// - Returns: if a name is passed in, return the first character of the first two names separated
	/// by a space if the first character is a letter. If no usable name is passed in
	/// return the first character of the email address passed in. If no usable email address is passed
	/// in, return the character `#`.
	static func initialsWithFallback(name: String?, email: String?) -> String {
		return initials(name: name, email: email) ?? fallbackInitial
	}

	/// Extract the initials to display from a name and email combo
	///
	/// - Parameters:
	/// 	- name: the name of the contact with the format “<First Name> <Last Name>”
	/// 	- email: the name of the contact with the format “<person>@<service>.<domain>"
	///
	/// - Returns: if a name is passed in, return the first character of the first two names separated
	/// by a space if the first character is a letter. If no usable name is passed in
	/// return the first character of the email address passed in. If no usable email address is passed
	/// in, return nil.
	@objc public static func initials(name: String?, email: String?) -> String? {
		var initials: String?

		// Create a character set that includes standard whitespace and newlines as well as the zero width space
		var whitespaceNewlineAndZeroWidthSpace = CharacterSet.whitespacesAndNewlines
		whitespaceNewlineAndZeroWidthSpace.update(with: .zeroWidthSpace)

		if let name = name, !name.isEmpty {
			let components = name.split(separator: " ").map { $0.trimmingCharacters(in: whitespaceNewlineAndZeroWidthSpace) }
			let nameComponentsWithUnicodeLetterFirstCharacters = components.filter {
				!$0.isEmpty && $0[$0.startIndex].isValidInitialsCharacter
			}

			if !nameComponentsWithUnicodeLetterFirstCharacters.isEmpty {
				initials = String(nameComponentsWithUnicodeLetterFirstCharacters.prefix(AvatarView.maximumNumberOfInitials).map { $0[$0.startIndex] })
			}
		}

		if initials == nil,
			let email = email?.trimmingCharacters(in: whitespaceNewlineAndZeroWidthSpace),
			!email.isEmpty {
			let emailComponentsWithUnicodeLetterFirstCharacters = email.filter {
				$0.isValidInitialsCharacter
			}

			// Find the first valid unicode character in the email address and use that
			if let initial = emailComponentsWithUnicodeLetterFirstCharacters.first {
				initials = String(initial)
			}
		}

		return initials?.localizedUppercase
	}

	/// Function to return a color set for display in an `AvatarView` instance based on the Avatar's display text.
	///
	/// The values of the two optional text parameters are combined together and fed through a hash algorithm to
	/// generate an index into our shared color table. Thus, any given pairing of primary and secondary text (usually
	/// expected to be a name and an email address, respectively) will always produce the same color.
	///
	/// - Parameters:
	///     - primaryText: Primary text to use to calculate color. Usually a name. Optional.
	///     - secondaryText: Secondary text to use to calculate color. Usually an email address. Optional.
	///
	/// - Returns: The calculated `ColorSet` for the provided text values.
	@objc(getInitialsColorSetFromPrimaryText:secondaryText:)
	public static func getInitialsColorSet(fromPrimaryText primaryText: String?, secondaryText: String?) -> LegacyColorSet {
		// Set the color based on the primary text and secondary text
		let combined = (primaryText ?? "") + (secondaryText ?? "")
		let combinedHashable = combined as NSString
		let hashCode = Int(abs(hashCode(combinedHashable)))

		let colors = AvatarView.avatarColors
		return colors[hashCode % colors.count]
	}

	/// Hash algorithm to determine Avatar color.
	/// Referenced from: https://github.com/microsoft/fluentui/blob/master/packages/react-components/react-avatar/src/components/Avatar/useAvatar.tsx#L200
	/// - Returns: Hash code
	private static func hashCode(_ text: NSString) -> Int32 {
		var hash: Int32 = 0
		for len in (0..<text.length).reversed() {
			// Convert from `unichar` to `Int32` to avoid potential arithmetic overflow in the next few lines.
			// Note that JavaScript does the upconversion automatically, but we need to be explicit in Swift.
			let ch = Int32(text.character(at: len))
			let shift = len % 8
			hash ^= Int32((ch << shift) + (ch >> (8 - shift)))
		}

		return hash
	}

	open override func viewWillMove(toWindow newWindow: NSWindow?) {
		super.viewWillMove(toWindow: newWindow)
		updateAppearance(newWindow?.effectiveAppearance)

		guard let window = newWindow else {
			appearanceObserver = nil
			return
		}
		appearanceObserver = window.observe(\.effectiveAppearance) { [weak self] (window, _) in
			guard let strongSelf = self else {
				return
			}
			strongSelf.updateAppearance(window.effectiveAppearance)
		}
	}
}

/// The various display styles of the Avatar View
private enum DisplayStyle {
	/// Display the initials extracted via `initials(name: String?, email: String?)` inside a colorful circular background
	case initials
	/// Display the user's image cropped to a circular shape
	case image
}

/// Return a font size to fit the maximumNumberOfInitials inside a cirlce of the given size
///
/// - Parameter diameter: the diameter of the circle for which to determine a font size
/// - Returns: the appropriate font size to fit within a circle of the given size
/// - note: font sizes will be rounded to the nearest 0.5 point for rendering fidelity
private func fontSize(forCircleDiameter diameter: CGFloat) -> CGFloat {
	return floor(diameter * AvatarView.fontSizeScalingDefault * 2) / 2
}

/// Return a font for an AvatarView of a given size
///
/// - Parameters:
///   - diameter: the diameter of the circle for which to return a font
/// - Returns: the appropriate font
/// - note: the font size is handled by `fontSize`
private func font(forCircleDiameter diameter: CGFloat) -> NSFont {
	return NSFont.systemFont(ofSize: fontSize(forCircleDiameter: diameter))
}

// Internal visibility only for unit testing
extension Character {
	/// Determines whether this `Character` is valid for use as an initial
	var isValidInitialsCharacter: Bool {
		let isMacOSRoman = String(self).canBeConverted(to: .macOSRoman)
		let letters = CharacterSet.letters
		return isMacOSRoman && unicodeScalars.reduce(true) { $0 && letters.contains($1) }
	}
}

fileprivate extension Unicode.Scalar {
	/// Unicode representation of a  zero width space
	static let zeroWidthSpace: Unicode.Scalar = .init(0x200B)!
}

extension AvatarView {

	static let legacyAvatarViewBackgroundColor: [NSColor] = [
		Colors.Palette.cyanBlue10.color,
		Colors.Palette.red10.color,
		Colors.Palette.magenta20.color,
		Colors.Palette.green10.color,
		Colors.Palette.magentaPink10.color,
		Colors.Palette.cyanBlue20.color,
		Colors.Palette.orange20.color,
		Colors.Palette.cyan20.color,
		Colors.Palette.orangeYellow20.color,
		Colors.Palette.red20.color,
		Colors.Palette.blue10.color,
		Colors.Palette.magenta10.color,
		Colors.Palette.gray40.color,
		Colors.Palette.green20.color,
		Colors.Palette.blueMagenta20.color,
		Colors.Palette.pinkRed10.color,
		Colors.Palette.gray30.color,
		Colors.Palette.blueMagenta30.color,
		Colors.Palette.gray20.color,
		Colors.Palette.cyan30.color,
		Colors.Palette.orange30.color
	]

	/// Table of background and text colors for the AvatarView
	static let avatarColors: [LegacyColorSet] = [
		.init(background: .init(light: Colors.Palette.darkRedTint40.color,
								dark: Colors.Palette.darkRedShade30.color),
			  foreground: .init(light: Colors.Palette.darkRedShade30.color,
								dark: Colors.Palette.darkRedTint40.color)),
		.init(background: .init(light: Colors.Palette.cranberryTint40.color,
								dark: Colors.Palette.cranberryShade30.color),
			  foreground: .init(light: Colors.Palette.cranberryShade30.color,
								dark: Colors.Palette.cranberryTint40.color)),
		.init(background: .init(light: Colors.Palette.redTint40.color,
								dark: Colors.Palette.redShade30.color),
			  foreground: .init(light: Colors.Palette.redShade30.color,
								dark: Colors.Palette.redTint40.color)),
		.init(background: .init(light: Colors.Palette.pumpkinTint40.color,
								dark: Colors.Palette.pumpkinShade30.color),
			  foreground: .init(light: Colors.Palette.pumpkinShade30.color,
								dark: Colors.Palette.pumpkinTint40.color)),
		.init(background: .init(light: Colors.Palette.peachTint40.color,
								dark: Colors.Palette.peachShade30.color),
			  foreground: .init(light: Colors.Palette.peachShade30.color,
								dark: Colors.Palette.peachTint40.color)),
		.init(background: .init(light: Colors.Palette.marigoldTint40.color,
								dark: Colors.Palette.marigoldShade30.color),
			  foreground: .init(light: Colors.Palette.marigoldShade30.color,
								dark: Colors.Palette.marigoldTint40.color)),
		.init(background: .init(light: Colors.Palette.goldTint40.color,
								dark: Colors.Palette.goldShade30.color),
			  foreground: .init(light: Colors.Palette.goldShade30.color,
								dark: Colors.Palette.goldTint40.color)),
		.init(background: .init(light: Colors.Palette.brassTint40.color,
								dark: Colors.Palette.brassShade30.color),
			  foreground: .init(light: Colors.Palette.brassShade30.color,
								dark: Colors.Palette.brassTint40.color)),
		.init(background: .init(light: Colors.Palette.brownTint40.color,
								dark: Colors.Palette.brownShade30.color),
			  foreground: .init(light: Colors.Palette.brownShade30.color,
								dark: Colors.Palette.brownTint40.color)),
		.init(background: .init(light: Colors.Palette.forestTint40.color,
								dark: Colors.Palette.forestShade30.color),
			  foreground: .init(light: Colors.Palette.forestShade30.color,
								dark: Colors.Palette.forestTint40.color)),
		.init(background: .init(light: Colors.Palette.seafoamTint40.color,
								dark: Colors.Palette.seafoamShade30.color),
			  foreground: .init(light: Colors.Palette.seafoamShade30.color,
								dark: Colors.Palette.seafoamTint40.color)),
		.init(background: .init(light: Colors.Palette.darkGreenTint40.color,
								dark: Colors.Palette.darkGreenShade30.color),
			  foreground: .init(light: Colors.Palette.darkGreenShade30.color,
								dark: Colors.Palette.darkGreenTint40.color)),
		.init(background: .init(light: Colors.Palette.lightTealTint40.color,
								dark: Colors.Palette.lightTealShade30.color),
			  foreground: .init(light: Colors.Palette.lightTealShade30.color,
								dark: Colors.Palette.lightTealTint40.color)),
		.init(background: .init(light: Colors.Palette.tealTint40.color,
								dark: Colors.Palette.tealShade30.color),
			  foreground: .init(light: Colors.Palette.tealShade30.color,
								dark: Colors.Palette.tealTint40.color)),
		.init(background: .init(light: Colors.Palette.steelTint40.color,
								dark: Colors.Palette.steelShade30.color),
			  foreground: .init(light: Colors.Palette.steelShade30.color,
								dark: Colors.Palette.steelTint40.color)),
		.init(background: .init(light: Colors.Palette.blueTint40.color,
								dark: Colors.Palette.blueShade30.color),
			  foreground: .init(light: Colors.Palette.blueShade30.color,
								dark: Colors.Palette.blueTint40.color)),
		.init(background: .init(light: Colors.Palette.royalBlueTint40.color,
								dark: Colors.Palette.royalBlueShade30.color),
			  foreground: .init(light: Colors.Palette.royalBlueShade30.color,
								dark: Colors.Palette.royalBlueTint40.color)),
		.init(background: .init(light: Colors.Palette.cornFlowerTint40.color,
								dark: Colors.Palette.cornFlowerShade30.color),
			  foreground: .init(light: Colors.Palette.cornFlowerShade30.color,
								dark: Colors.Palette.cornFlowerTint40.color)),
		.init(background: .init(light: Colors.Palette.navyTint40.color,
								dark: Colors.Palette.navyShade30.color),
			  foreground: .init(light: Colors.Palette.navyShade30.color,
								dark: Colors.Palette.navyTint40.color)),
		.init(background: .init(light: Colors.Palette.lavenderTint40.color,
								dark: Colors.Palette.lavenderShade30.color),
			  foreground: .init(light: Colors.Palette.lavenderShade30.color,
								dark: Colors.Palette.lavenderTint40.color)),
		.init(background: .init(light: Colors.Palette.purpleTint40.color,
								dark: Colors.Palette.purpleShade30.color),
			  foreground: .init(light: Colors.Palette.purpleShade30.color,
								dark: Colors.Palette.purpleTint40.color)),
		.init(background: .init(light: Colors.Palette.grapeTint40.color,
								dark: Colors.Palette.grapeShade30.color),
			  foreground: .init(light: Colors.Palette.grapeShade30.color,
								dark: Colors.Palette.grapeTint40.color)),
		.init(background: .init(light: Colors.Palette.lilacTint40.color,
								dark: Colors.Palette.lilacShade30.color),
			  foreground: .init(light: Colors.Palette.lilacShade30.color,
								dark: Colors.Palette.lilacTint40.color)),
		.init(background: .init(light: Colors.Palette.pinkTint40.color,
								dark: Colors.Palette.pinkShade30.color),
			  foreground: .init(light: Colors.Palette.pinkShade30.color,
								dark: Colors.Palette.pinkTint40.color)),
		.init(background: .init(light: Colors.Palette.magentaTint40.color,
								dark: Colors.Palette.magentaShade30.color),
			  foreground: .init(light: Colors.Palette.magentaShade30.color,
								dark: Colors.Palette.magentaTint40.color)),
		.init(background: .init(light: Colors.Palette.plumTint40.color,
								dark: Colors.Palette.plumShade30.color),
			  foreground: .init(light: Colors.Palette.plumShade30.color,
								dark: Colors.Palette.plumTint40.color)),
		.init(background: .init(light: Colors.Palette.beigeTint40.color,
								dark: Colors.Palette.beigeShade30.color),
			  foreground: .init(light: Colors.Palette.beigeShade30.color,
								dark: Colors.Palette.beigeTint40.color)),
		.init(background: .init(light: Colors.Palette.minkTint40.color,
								dark: Colors.Palette.minkShade30.color),
			  foreground: .init(light: Colors.Palette.minkShade30.color,
								dark: Colors.Palette.minkTint40.color)),
		.init(background: .init(light: Colors.Palette.platinumTint40.color,
								dark: Colors.Palette.platinumShade30.color),
			  foreground: .init(light: Colors.Palette.platinumShade30.color,
								dark: Colors.Palette.platinumTint40.color)),
		.init(background: .init(light: Colors.Palette.anchorTint40.color,
								dark: Colors.Palette.anchorShade30.color),
			  foreground: .init(light: Colors.Palette.anchorShade30.color,
								dark: Colors.Palette.anchorTint40.color))
	]
}

fileprivate extension CGPath {
	/// Return a CGPath containing a circle of a given size, inset by a given inset
	///
	/// - Parameters:
	///   - diameter: the diameter of the circle to return a path of
	///   - inset: the amount the circle should be inset by inside the
	/// - Returns: a path centered within the given size inset by the given amount
	///
	/// - note: this can't be an initializer since Swift doesn't allow CF/CG types to have convenience initialer extensions
	static func circularPath(withCircleDiameter diameter: CGFloat) -> CGPath {
		return CGPath(ellipseIn: NSRect(x: 0, y: 0, width: diameter, height: diameter), transform: nil)
	}
}

class BorderView: NSView {
	var strokeColor: NSColor
	var strokeWidth: CGFloat
	private var path: NSBezierPath?

	init(frame: CGRect, strokeColor: NSColor, strokeWidth: CGFloat) {
		self.strokeColor = strokeColor
		self.strokeWidth = strokeWidth
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	override func draw(_ dirtyRect: NSRect) {
		let pathFrame = bounds.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
		path = NSBezierPath(ovalIn: pathFrame)
		path?.lineWidth = strokeWidth
		strokeColor.set()
		path?.stroke()
	}

}
