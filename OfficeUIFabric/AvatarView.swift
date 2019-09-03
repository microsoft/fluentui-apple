//
// Copyright Microsoft Corporation
//

import AppKit

/// Constants to be used in this file
fileprivate struct Constants {
	/// the font size in the initials view will be scaled to this fraction of the avatarSize passed in
	static let fontSizeScalingDefault: CGFloat = 0.4

	/// the text color of the text in the initials view
	///
	/// - note: this value doesn't change for dark mode by design as our default background color table
	/// only provides colors designed to be used with white text, even on dark mode
	static let initialsViewTextColor = NSColor.white

	/// fall back to this text in the initials view when no usable name or email is provided
	static let fallbackInitial = "#"

	/// the maximum number of initials to be displayed when we don't have an image
	static let maximumNumberOfInitials = 2

	/// the unicode representation of the zero-width space character
	static let zeroWidthSpaceUnicodeCharacter = "\u{200B}"

	/// the table of background colors for the initials views
	static let avatarBackgroundColors: [NSColor] = [
		#colorLiteral(red: 0.6, green: 0.71, blue: 0.2, alpha: 1),
		#colorLiteral(red: 0.42, green: 0.65, blue: 0.91, alpha: 1),
		#colorLiteral(red: 0.91, green: 0.45, blue: 0.74, alpha: 1),
		#colorLiteral(red: 0.0, green: 0.64, blue: 0.0, alpha: 1),
		#colorLiteral(red: 0.12, green: 0.44, blue: 0.27, alpha: 1),
		#colorLiteral(red: 1.0, green: 0.0, blue: 0.59, alpha: 1),
		#colorLiteral(red: 0.49, green: 0.22, blue: 0.47, alpha: 1),
		#colorLiteral(red: 0.38, green: 0.24, blue: 0.73, alpha: 1),
		#colorLiteral(red: 0.0, green: 0.67, blue: 0.66, alpha: 1),
		#colorLiteral(red: 0.18, green: 0.54, blue: 0.94, alpha: 1),
		#colorLiteral(red: 0.17, green: 0.34, blue: 0.59, alpha: 1),
		#colorLiteral(red: 0.85, green: 0.32, blue: 0.17, alpha: 1),
		#colorLiteral(red: 0.72, green: 0.11, blue: 0.28, alpha: 1),
		#colorLiteral(red: 0.93, green: 0.07, blue: 0.07, alpha: 1),
	]

	/// make the init method private so clients don't unintentionally instantiate this struct
	private init() {}
}

/// The various display styles of the Avatar View
fileprivate enum DisplayStyle {
	/// Display the initials extracted via `initials(name: String?, email: String?)` inside a colorful circular background
	case initials
	/// Display the user's image cropped to a circular shape
	case image
}

/// A visual Avatar icon for a user, cropped to a circle that either displays the user's
/// image if available or the user's initials if an image is not available
open class AvatarView : NSView {

	/// Initializes the avatar view with a name, email, image, and size. If
	/// an image is provided, the avatar view will show the image. If no image is
	/// provided but a name is provided, the avatar view will show the initials of
	/// the name if initials can be extracted. Finally, if an email is provided but
	/// no name is provided, the first two characters of the email are used as
	/// initials.
	///
	/// @param avatarSize: the size in points for both the width and height
	/// 				of the avatar view
	/// @param contactName: the name of the contact with the
	///				format “<First Name> <Last Name>”
	/// @param contactEmail: the name of the contact with the
	///				format “<person>@<service>.<domain>”
	/// @param contactImage: the image of the contact
	@objc public init(avatarSize: CGFloat,
					  contactName: String?,
					  contactEmail: String?,
					  contactImage: NSImage?) {

		// Prefer contactEmail to contactName for uniqueness
		avatarBackgroundColor = backgroundColor(for: colorIndex(for: contactEmail ?? contactName ?? ""))
		self.contactName = contactName
		self.contactEmail = contactEmail
		self.contactImage = contactImage
		self.avatarSize = avatarSize
		
		displayStyle = contactImage == nil ? .initials : .image
		
		super.init(frame: .zero)

		wantsLayer = true
		circleMask.path = circularPath(withCircleDiameter: avatarSize)
		layer?.mask = circleMask

		let widthConstraint = widthAnchor.constraint(equalToConstant: avatarSize)
		let heightConstraint = heightAnchor.constraint(equalToConstant: avatarSize)
		NSLayoutConstraint.activate([widthConstraint, heightConstraint])
		
		self.widthConstraint = widthConstraint
		self.heightConstraint = heightConstraint

		updateViewStyle()
		updateAvatarViewContents()
	}
	
	@available(*, unavailable) required public init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open func updateLayer() {
		CATransaction.begin()
		defer {
			CATransaction.commit()
		}
		// Disable animations for this change
		CATransaction.setDisableActions(true)
		if displayStyle == .initials {
			circleLayer.fillColor = avatarBackgroundColor.cgColor
		}
	}

	/// The background color of the avatar view when no image is provided.
	/// Setting this property will override the default provided color.
	@objc open var avatarBackgroundColor: NSColor {
		didSet {
			guard oldValue != avatarBackgroundColor else {
				return
			}
			needsDisplay = true
			initialsTextField.backgroundColor = avatarBackgroundColor
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

			// Update our display style
			displayStyle = contactImage == nil ? .initials : .image
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
			let path = circularPath(withCircleDiameter: avatarSize)
			circleMask.path = path
			circleLayer.path = path

			initialsTextField.font = NSFont.systemFont(ofSize:fontSize(forCircleDiameter: avatarSize))
		}
	}
	
	/// The width constraint giving this view its size
	private var widthConstraint: NSLayoutConstraint?
	
	/// The height constraint giving this view its size
	private var heightConstraint: NSLayoutConstraint?

	/// The layer used to draw the colorful circle underneath the initials in the initials view
	private let circleLayer = CAShapeLayer()

	/// The layer used to mask the overall AvatarView to a circle
	private let circleMask = CAShapeLayer()

	/// A property for the display style based on whether an image exists or not.
	private var displayStyle: DisplayStyle {
		didSet {
			guard oldValue != displayStyle else {
				return
			}
			updateViewStyle()
		}
	}

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

		circleLayer.path = circularPath(withCircleDiameter: avatarSize)
		circleLayer.fillColor = avatarBackgroundColor.cgColor
		initialsView.layer?.addSublayer(circleLayer)

		let textView = initialsTextField
		initialsView.addSubview(textView)

		let constraints = [
			textView.centerXAnchor.constraint(equalTo: initialsView.centerXAnchor),
			textView.centerYAnchor.constraint(equalTo: initialsView.centerYAnchor),
			]

		NSLayoutConstraint.activate(constraints)

		return initialsView
	}()
	
	/// The text field used for displaying the initials within the initialsView
	private lazy var initialsTextField: NSTextField = {
		let textView = NSTextField(labelWithString: initials(name: contactName, email: contactEmail))
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = NSFont.systemFont(ofSize:fontSize(forCircleDiameter: avatarSize))
		textView.textColor = Constants.initialsViewTextColor
		textView.drawsBackground = true
		textView.backgroundColor = avatarBackgroundColor
		return textView
	}()
	
	/// Update this view to use the proper style when switching from Image to Initials or vice-versa
	private func updateViewStyle() {
		// Remove all subviews as we will re-add the proper one below
		subviews = []
		
		let currentView = self.currentView()
		
		addSubview(currentView)
		let constraints = [
			currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			currentView.topAnchor.constraint(equalTo: self.topAnchor),
			currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		]
		
		NSLayoutConstraint.activate(constraints)
	}

	/// Get the internal view we should be using to represent this avatar
	///
	/// @return `initialsView` if `displayStyle` is `.initials`, `contactImageView` if it is `.image`
	private func currentView() -> NSView {
		switch displayStyle {
		case .initials:
			return initialsView
		case .image:
			return contactImageView
		}
	}
	
	/// Update avatar view contents based on the latest values in properties
	private func updateAvatarViewContents() {
		// Set up accessibility values if we have any information to return
		if let bestDescription = contactName ?? contactEmail {
			toolTip = bestDescription
			setAccessibilityElement(true)
			setAccessibilityLabel(bestDescription)
			setAccessibilityRole(.image)
		} else {
			toolTip = nil
			setAccessibilityElement(false)
			setAccessibilityLabel(nil)
			setAccessibilityRole(.unknown)
		}
		
		initialsTextField.stringValue = initials(name: contactName, email: contactEmail)
		avatarBackgroundColor = backgroundColor(for: colorIndex(for: contactEmail ?? contactName ?? ""))
	}
}

/// Extract the initials to display from a name and email combo
///
/// param contactName the name of the contact with the format “<First Name> <Last Name>”
/// param contactEmail the name of the contact with the format “<person>@<service>.<domain>"
///
/// @return if a name is passed in, return the first character of the first two names separated
/// by a space if the first character is a letter. If no usable name is passed in
/// return the first character of the email address passed in. If no usable email address is passed
/// in, return the character `#`.
func initials(name: String?, email: String?) -> String {
	var initials: String? = nil
	
	// Add the zero width space character to the standard whitespace and new lines character set
	let whitespaceNewlineAndZeroWidthSpace = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: Constants.zeroWidthSpaceUnicodeCharacter))
	
	if let name = name {
		let components = name.split(separator: " ")
		let nameComponentsWithUnicodeLetterFirstCharacters = components.filter {
			let trimmedString = $0.trimmingCharacters(in: whitespaceNewlineAndZeroWidthSpace)
			let unicodeScalars = trimmedString[trimmedString.startIndex].unicodeScalars
			let initialUnicodeScalar = unicodeScalars[unicodeScalars.startIndex]
			return CharacterSet.letters.contains(initialUnicodeScalar)
		}
		if nameComponentsWithUnicodeLetterFirstCharacters.count > 0 {
			initials = String(nameComponentsWithUnicodeLetterFirstCharacters.prefix(Constants.maximumNumberOfInitials).map { $0[$0.startIndex] })
		}
	}
	
	if initials == nil, let email = email?.trimmingCharacters(in: whitespaceNewlineAndZeroWidthSpace) {
		let unicodeScalars = email[email.startIndex].unicodeScalars
		let initialUnicodeScalar = unicodeScalars[unicodeScalars.startIndex]
		if CharacterSet.letters.contains(initialUnicodeScalar) {
			initials = String(initialUnicodeScalar)
		}
	}

	// default to `Constants.fallbackInitial` when we have nothing to base our initials off of
	return initials?.localizedUppercase ?? Constants.fallbackInitial
}

/// Returns a color table index for a given display name
/// - parameter identifyingString: the unique identifying string for the user
///
/// - returns: a unique index generated by walking backwards through the letters in the \p identifyingString
/// creating a cumulative hash
///
/// - note: the returned index is not limited to any size and should not be considered safe for indexing into an array without
/// first checking the size of the array in question
func colorIndex(for identifyingString: String) -> Int {
	return identifyingString.utf16.enumerated().reversed().reduce(0) { (hashCode, enumeratedCodePoints) -> Int in
		// upcast our UInt16s to standard Ints as that's how the hashing algorithm works in other codebases
		let integerCodePoint = Int(enumeratedCodePoints.element)
		let shift = enumeratedCodePoints.offset % 8
		return hashCode ^ Int((integerCodePoint << shift) + (integerCodePoint >> (8 - shift)))
	}
}

/// Get the color associated with a given index
/// - parameter index: the index into the color table
///
/// - returns: the color table entry for the given index
func backgroundColor(for index: Int) -> NSColor {
	let avatarBackgroundColors = Constants.avatarBackgroundColors
	return avatarBackgroundColors[index % avatarBackgroundColors.count]
}

/// Return a CGPath containing a circle of a given size, inset by a given inset
///
/// - Parameters:
///   - diameter: the diameter of the circle to return a path of
///   - inset: the amount the circle should be inset by inside the
/// - Returns: a path centered within the given size inset by the given amount
fileprivate func circularPath(withCircleDiameter diameter: CGFloat) -> CGPath {
	return CGPath(ellipseIn: NSRect(x: 0, y: 0, width: diameter, height: diameter), transform: nil)
}

/// Return a font size to fit the maximumNumberOfInitials inside a cirlce of the given size
///
/// - Parameter diameter: the diameter of the circle for which to determine a font size
/// - Returns: the appropriate font size to fit within a circle of the given size
/// - note: font sizes will be rounded to the nearest 0.5 point for rendering fidelity
fileprivate func fontSize(forCircleDiameter diameter: CGFloat) -> CGFloat {
	return floor(diameter * Constants.fontSizeScalingDefault * 2) / 2
}
