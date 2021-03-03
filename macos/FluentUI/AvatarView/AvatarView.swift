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

		// Prefer contactEmail to contactName for uniqueness
		let color = AvatarView.getColor(for: AvatarView.colorIndex(for: contactEmail ?? contactName ?? ""))
		avatarBackgroundColor = color.resolvedBackgroundColor()
		initialsFontColor = color.resolvedForegroundColor()
		self.contactName = contactName
		self.contactEmail = contactEmail
		self.contactImage = contactImage
		self.avatarSize = avatarSize

		displayStyle = contactImage == nil ? .initials : .image

		super.init(frame: .zero)

		wantsLayer = true
		let circularPath = CGPath.circularPath(withCircleDiameter: avatarSize)
		circleMask.path = circularPath
		outlineLayer.path = circularPath
		outlineLayer.lineWidth = 1.0
		outlineLayer.strokeColor = AvatarView.outlineColor.cgColor
		outlineLayer.fillColor = nil
		layer?.mask = circleMask

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
		outlineLayer.strokeColor = AvatarView.outlineColor.cgColor
		if displayStyle == .initials {
			initialsView.layer?.backgroundColor = avatarBackgroundColor.cgColor
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

	/// The initials font color of the avatar view when no image is provided.
	/// Setting this property will override the default provided color.
	@objc open var initialsFontColor: NSColor {
		didSet {
			guard oldValue != initialsFontColor else {
				return
			}
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

			let path = CGPath.circularPath(withCircleDiameter: avatarSize)
			circleMask.path = path
			outlineLayer.path = path

			let textFieldFont = font(forCircleDiameter: avatarSize)
			initialsTextField.font = textFieldFont

			// This constraint will only exist if we're using the sizing view approach to center our initials
			initialsSizingViewHeightConstraint?.constant = ceil(textFieldFont.capHeight)
		}
	}

	/// The width constraint giving this view its size
	private var widthConstraint: NSLayoutConstraint?

	/// The height constraint giving this view its size
	private var heightConstraint: NSLayoutConstraint?

	/// The height constraint for the initials sizing view which should update on font size changes
	private var initialsSizingViewHeightConstraint: NSLayoutConstraint?

	/// The layer used to draw the colorful circle underneath the initials in the initials view
	private let outlineLayer = CAShapeLayer()

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
		initialsView.layer?.backgroundColor = avatarBackgroundColor.cgColor

		let textView = initialsTextField
		initialsView.addSubview(textView)

		var constraints = [
			textView.leadingAnchor.constraint(equalTo: initialsView.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: initialsView.trailingAnchor)
		]

		// If we have a font, use that to accurately center the initials, not letting diacritics and descenders/ascenders
		// impact the centering
		let capHeight = font(forCircleDiameter: avatarSize).capHeight
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
		textView.font = font(forCircleDiameter: avatarSize)
		textView.textColor = initialsFontColor
		textView.drawsBackground = true
		textView.backgroundColor = avatarBackgroundColor
		return textView
	}()

	/// The view that draws the outline stroke around the edge of the AvatarView
	private lazy var outlineView: NSView = {
		let outlineView = NSView()
		outlineView.translatesAutoresizingMaskIntoConstraints = false
		outlineView.wantsLayer = true
		outlineView.layer?.addSublayer(outlineLayer)
		return outlineView
	}()

	/// Update this view to use the proper style when switching from Image to Initials or vice-versa
	private func updateViewStyle() {
		let currentView = self.currentView()
		let accessibilityRingView = self.outlineView

		// Replace all existing subviews with the proper ones, ensuring the correct z-ordering
		subviews = [
			currentView,
			accessibilityRingView
		]

		let constraints = [
			currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			currentView.topAnchor.constraint(equalTo: self.topAnchor),
			currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			accessibilityRingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			accessibilityRingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			accessibilityRingView.topAnchor.constraint(equalTo: self.topAnchor),
			accessibilityRingView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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

		initialsTextField.stringValue = AvatarView.initialsWithFallback(name: contactName, email: contactEmail)
		updateAppearance()
	}

	private func updateAppearance(_ appreance: NSAppearance = NSAppearance.current) {
		let color = AvatarView.getColor(for: AvatarView.colorIndex(for: contactEmail ?? contactName ?? ""))
		avatarBackgroundColor = color.resolvedBackgroundColor(appreance)
		initialsFontColor = color.resolvedForegroundColor(appreance)
	}

	/// Get the color associated with a given index
	/// - parameter index: the index into the color table
	///
	/// - returns: the color table entry for the given index
	///
	/// - note: Internal visibility exists only for unit testing
	@objc public static func getColor(for index: Int) -> DynamicColor {
		let avatarBackgroundColors = NSColor.avatarColors
		return avatarBackgroundColors[index % avatarBackgroundColors.count]
	}

	/// the font size in the initials view will be scaled to this fraction of the avatarSize passed in
	static let fontSizeScalingDefault: CGFloat = 0.4

	/// fall back to this text in the initials view when no usable name or email is provided
	static let fallbackInitial: String = "#"

	/// the maximum number of initials to be displayed when we don't have an image
	static let maximumNumberOfInitials: Int = 2

	/// the color used for the outline view
	static let outlineColor = NSColor(named: "AvatarView/outlineColor", bundle: FluentUIResources.resourceBundle)!

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
			let initialCharacter = email[email.startIndex]
			if initialCharacter.isValidInitialsCharacter {
				initials = String(initialCharacter)
			}
		}

		return initials?.localizedUppercase
	}

	/// Returns a color table index for a given display name
	/// - parameter identifyingString: the unique identifying string for the user
	///
	/// - Returns: a unique index generated by walking backwards through the letters in the \p identifyingString
	/// creating a cumulative hash
	///
	/// - note: the returned index is not limited to any size and should not be considered safe for indexing into an array without
	/// first checking the size of the array in question
	@objc(colorIndexForIdentifyingString:)
	public static func colorIndex(for identifyingString: String) -> Int {
		return identifyingString.utf16.enumerated().reversed().reduce(0) { (hashCode, enumeratedCodePoints) -> Int in
			// upcast our UInt16s to standard Ints as that's how the hashing algorithm works in other codebases
			let integerCodePoint = Int(enumeratedCodePoints.element)
			let shift = enumeratedCodePoints.offset % 8
			return hashCode ^ Int((integerCodePoint << shift) + (integerCodePoint >> (8 - shift)))
		}
	}

	open override func viewWillMove(toWindow newWindow: NSWindow?) {
		super.viewWillMove(toWindow: newWindow)
		if let window = newWindow {
			appearanceObserver = window.observe(\.effectiveAppearance) { [weak self] (window, value) in
				guard let strongSelf = self else {
					return
				}
				print("window \(window), value:\(value)")

				strongSelf.updateAppearance(window.appearance ?? NSAppearance.current)
			}
		} else {
			appearanceObserver = nil
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
	static let zeroWidthSpace = Unicode.Scalar(0x200B)!
}

fileprivate extension NSColor {
	/// the text color of the text in the initials view

	/// the table of background colors for the initials views
	static let avatarColors: [DynamicColor] = [
		DynamicColor(background: Colors.Palette.darkRedTint40.color, foreground: Colors.Palette.darkRedShade30.color),
		DynamicColor(background: Colors.Palette.cranberryTint40.color, foreground: Colors.Palette.cranberryShade30.color),
		DynamicColor(background: Colors.Palette.redTint40.color, foreground: Colors.Palette.redShade30.color),
		DynamicColor(background: Colors.Palette.pumpkinTint40.color, foreground: Colors.Palette.pumpkinShade30.color),
		DynamicColor(background: Colors.Palette.peachTint40.color, foreground: Colors.Palette.peachShade30.color),
		DynamicColor(background: Colors.Palette.marigoldTint40.color, foreground: Colors.Palette.marigoldShade30.color),
		DynamicColor(background: Colors.Palette.goldTint40.color, foreground: Colors.Palette.goldShade30.color),
		DynamicColor(background: Colors.Palette.brassTint40.color, foreground: Colors.Palette.brassShade30.color),
		DynamicColor(background: Colors.Palette.brownTint40.color, foreground: Colors.Palette.brownShade30.color),
		DynamicColor(background: Colors.Palette.forestTint40.color, foreground: Colors.Palette.forestShade30.color),
		DynamicColor(background: Colors.Palette.seafoamTint40.color, foreground: Colors.Palette.seafoamShade30.color),
		DynamicColor(background: Colors.Palette.darkGreenTint40.color, foreground: Colors.Palette.darkGreenShade30.color),
		DynamicColor(background: Colors.Palette.lightTealTint40.color, foreground: Colors.Palette.lightTealShade30.color),
		DynamicColor(background: Colors.Palette.tealTint40.color, foreground: Colors.Palette.tealShade30.color),
		DynamicColor(background: Colors.Palette.steelTint40.color, foreground: Colors.Palette.steelShade30.color),
		DynamicColor(background: Colors.Palette.blueTint40.color, foreground: Colors.Palette.blueShade30.color),
		DynamicColor(background: Colors.Palette.royalBlueTint40.color, foreground: Colors.Palette.royalBlueShade30.color),
		DynamicColor(background: Colors.Palette.cornFlowerTint40.color, foreground: Colors.Palette.cornFlowerShade30.color),
		DynamicColor(background: Colors.Palette.navyTint40.color, foreground: Colors.Palette.navyShade30.color),
		DynamicColor(background: Colors.Palette.lavenderTint40.color, foreground: Colors.Palette.lavenderShade30.color),
		DynamicColor(background: Colors.Palette.purpleTint40.color, foreground: Colors.Palette.purpleShade30.color),
		DynamicColor(background: Colors.Palette.grapeTint40.color, foreground: Colors.Palette.grapeShade30.color),
		DynamicColor(background: Colors.Palette.lilacTint40.color, foreground: Colors.Palette.lilacShade30.color),
		DynamicColor(background: Colors.Palette.pinkTint40.color, foreground: Colors.Palette.pinkShade30.color),
		DynamicColor(background: Colors.Palette.magentaTint40.color, foreground: Colors.Palette.magentaShade30.color),
		DynamicColor(background: Colors.Palette.plumTint40.color, foreground: Colors.Palette.plumShade30.color),
		DynamicColor(background: Colors.Palette.beigeTint40.color, foreground: Colors.Palette.beigeShade30.color),
		DynamicColor(background: Colors.Palette.minkTint40.color, foreground: Colors.Palette.minkShade30.color),
		DynamicColor(background: Colors.Palette.platinumTint40.color, foreground: Colors.Palette.platinumShade30.color),
		DynamicColor(background: Colors.Palette.anchorTint40.color, foreground: Colors.Palette.anchorShade30.color)
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
