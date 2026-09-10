//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import AppKit

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
///
/// Uses AppKit's glass bezel on macOS 26+, falling back to FluentUI's translucent capsule.
@objc(MSFGlassButton)
open class GlassButton: Button {
	/// Swift-only designated initializer accepting ButtonFormat struct.
	/// - Parameters:
	///   - title: String displayed in the button, default empty string
	///   - image: The NSImage to diplay in the button, default nil
	///   - imagePosition: The position of the image, relative to the title, default imageLeading
	///   - format: The ButtonFormat including size, style and accentColor, with all applicable defaults
	override public init(
		title: String = "",
		image: NSImage? = nil,
		imagePosition: NSControl.ImagePosition = .imageLeading,
		format: ButtonFormat = ButtonFormat()
	) {
		super.init(title: title, image: image, imagePosition: imagePosition, format: format)

		// Expose the button, since custom layout clears the cell's accessible content.
		setAccessibilityElement(true)
		setAccessibilityRole(.button)

		if usesSystemGlassBezel, #available(macOS 26.0, *) {
			configureSystemGlassBezel()

			// Refresh colors now that the bezel is configured.
			setColorValues(forStyle: style, accentColor: accentColor)
			setSizeParameters(GlassButton.systemBezelSizeParameters)
		}
	}

	open override func setAccessibilityLabel(_ accessibilityLabel: String?) {
		explicitAccessibilityLabel = accessibilityLabel
		super.setAccessibilityLabel(accessibilityLabel)
	}

	open override func accessibilityLabel() -> String? {
		let label: String?
		if let explicitAccessibilityLabel = explicitAccessibilityLabel {
			label = explicitAccessibilityLabel
		} else if !title.isEmpty {
			label = title
		} else if imagePosition != .noImage, let description = image?.accessibilityDescription {
			label = description
		} else {
			label = super.accessibilityLabel()
		}
		return label
	}

	open override var image: NSImage? {
		get {
			return usesOwnContentLayout ? logicalImage : super.image
		}
		set {
			logicalImage = newValue
			guard usesOwnContentLayout else {
				super.image = newValue
				return
			}
			super.image = nil
			configureOwnContentViewsIfNeeded()
			primaryImageView?.image = newValue
			updateOwnContentLayout()
			invalidateIntrinsicContentSize()
		}
	}

	open override var title: String {
		get {
			return usesOwnContentLayout ? logicalTitle : super.title
		}
		set {
			logicalTitle = newValue
			guard usesOwnContentLayout else {
				super.title = newValue
				return
			}
			super.title = ""
			configureOwnContentViewsIfNeeded()
			titleLabel?.stringValue = newValue
			updateOwnContentLayout()
			invalidateIntrinsicContentSize()
		}
	}

	open override var imagePosition: NSControl.ImagePosition {
		didSet {
			guard usesOwnContentLayout, oldValue != imagePosition else {
				return
			}
			updateOwnContentLayout()
			invalidateIntrinsicContentSize()
		}
	}

	open override var trailingImage: NSImage? {
		didSet {
			let wasOwnLayout = usesSystemGlassBezel && oldValue != nil
			guard wasOwnLayout != usesOwnContentLayout else {
				// Button's observer already updated the trailing image view.
				return
			}

			let currentImagePosition = imagePosition
			if usesOwnContentLayout {
				// Move AppKit's content into our subviews.
				let currentImage = super.image
				let currentTitle = super.title
				logicalImage = currentImage
				logicalTitle = currentTitle
				super.image = nil
				super.title = ""
				configureOwnContentViewsIfNeeded()
				primaryImageView?.image = currentImage
				titleLabel?.stringValue = currentTitle
			} else {
				// Restore AppKit's content.
				super.image = logicalImage
				super.title = logicalTitle
				primaryImageView?.isHidden = true
				titleLabel?.isHidden = true
			}
			// AppKit may change imagePosition when restoring its image and title.
			imagePosition = currentImagePosition
			if usesOwnContentLayout {
				updateOwnContentLayout()
			}
			// Tint handling changes with content ownership.
			setColorValues(forStyle: style, accentColor: accentColor)
			invalidateIntrinsicContentSize()
		}
	}

	open override var intrinsicContentSize: CGSize {
		guard usesSystemGlassBezel else {
			return super.intrinsicContentSize
		}

		// AppKit's control sizes add too much padding for Fluent's compact 28pt capsule.
		// Compute our own size while leaving bezel drawing to AppKit.
		let imageSize = (imagePosition != .noImage) ? (image?.size ?? .zero) : .zero
		let hasImage = imageSize != .zero
		let hasTitle = imagePosition != .imageOnly && !title.isEmpty

		// We use a narrower padding when it's icon-only to make the button look round.
		let horizontalPadding: CGFloat
		if hasImage && !hasTitle && trailingImage == nil {
			horizontalPadding = 4.0
		} else {
			horizontalPadding = (cell as? ButtonCell)?.horizontalPadding ?? GlassButton.systemBezelSizeParameters.horizontalPadding
		}

		var width: CGFloat = 0
		if hasImage {
			width += imageSize.width
		}
		if hasTitle {
			width += title.size(withAttributes: [.font: font as Any]).width
		}
		if hasImage, hasTitle, let cell = cell as? ButtonCell {
			width += cell.titleToImageSpacing
		}
		width += horizontalPadding * 2

		// Custom content layout needs trailing-image space on only one side.
		if let trailingImage = trailingImage, let cell = cell as? ButtonCell {
			width += trailingImage.size.width + cell.titleToImageSpacing
		}

		return CGSize(width: ceil(width), height: GlassButton.standardSizeParameters.minButtonHeight)
	}

	override public var style: ButtonStyle {
		get {
			return super.style
		}
		set {
			// Only primary and secondary are supported on GlassButton
			super.style = newValue == .primary ? .primary : .secondary
		}
	}

	/// Glass buttons use fixed metrics regardless of `ButtonSize`.
	override func setSizeParameters(_ parameters: ButtonSizeParameters) {
		super.setSizeParameters(usesSystemGlassBezel ? GlassButton.systemBezelSizeParameters : GlassButton.standardSizeParameters)
	}

	override func updateContentTintColor() {
		super.updateContentTintColor()
		guard usesOwnContentLayout else {
			return
		}
		primaryImageView?.contentTintColor = contentTintColor
		titleLabel?.textColor = contentTintColor
	}

	override func setColorValues(forStyle: ButtonStyle, accentColor: NSColor) {
		guard forStyle == .primary || forStyle == .secondary else {
			preconditionFailure("Unsupported style for GlassButton: \(forStyle)")
		}

		if #available(macOS 26.0, *), usesSystemGlassBezel {
			// AppKit owns background and border drawing in both content layouts.
			let clearColorSet = ButtonColorSet(rest: .clear, pressed: .clear, hovered: .clear, disabled: .clear)
			backgroundColorSet = clearColorSet
			borderColorSet = clearColorSet
			updateSystemGlassBezelTint()

			if !usesOwnContentLayout {
				// Avoid applying Fluent tints over AppKit's content.
				contentTintColorSet = .init(rest: nil, pressed: nil, hovered: nil, disabled: nil)
				updateContentTintColor()
				return
			}
			// Custom content uses Fluent tints below; AppKit still draws the background and border.
		}

		// Use System Colors which respond correctly to accessibility settings like increase contrast
		// https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors
		let increaseContrastBorderColor: NSColor = .textColor
		let clearAlphaComponent: CGFloat = 0.5

		switch forStyle {
		case .primary:
			let contentTintRestColor = isWindowInactive ? fluentTheme.nsColor(.glassForeground1) : fluentTheme.nsColor(.foregroundLightStatic)
			contentTintColorSet = .init(
				rest: contentTintRestColor,
				pressed: contentTintRestColor.withSystemEffect(.pressed),
				hovered: contentTintRestColor.withSystemEffect(.rollover),
				disabled: ButtonColor.brandForegroundDisabled
			)
			let backgroundRestColor = isWindowInactive ? fluentTheme.nsColor(.background2) : accentColor
			let alphaComponent = isWindowInactive ? clearAlphaComponent : 1.0
			backgroundColorSet = .init(
				rest: backgroundRestColor.withAlphaComponent(alphaComponent),
				pressed: accentColor.withSystemEffect(.pressed),
				hovered: backgroundRestColor.withSystemEffect(.rollover).withAlphaComponent(alphaComponent),
				disabled: ButtonColor.brandBackgroundDisabled,
			)
			borderColorSet = .init(
				rest: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				pressed: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				hovered: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				disabled: increaseContrastEnabled ? increaseContrastBorderColor : .clear
			)
		case .secondary:
			let foreground = fluentTheme.nsColor(isWindowInactive ? .glassForeground1 : .foreground1)
			contentTintColorSet = .init(
				rest: foreground,
				pressed: foreground.withSystemEffect(.pressed),
				hovered: foreground.withSystemEffect(.rollover),
				disabled: foreground.withSystemEffect(.disabled)
			)
			let background = fluentTheme.nsColor(.background2)
			backgroundColorSet = .init(
				rest: background.withAlphaComponent(clearAlphaComponent),
				pressed: background.withSystemEffect(.pressed).withAlphaComponent(clearAlphaComponent),
				hovered: background.withSystemEffect(.rollover).withAlphaComponent(clearAlphaComponent),
				disabled: background.withSystemEffect(.disabled).withAlphaComponent(clearAlphaComponent)
			)
			borderColorSet = .init(
				rest: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				pressed: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				hovered: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				disabled: increaseContrastEnabled ? increaseContrastBorderColor : .clear
			)
		default:
			preconditionFailure("Unsupported style for GlassButton: \(forStyle)")
		}
		updateContentTintColor()
	}

	override var usesFluentBezelDrawing: Bool {
		return !usesSystemGlassBezel
	}

	override var cornerRadius: CGFloat {
		get {
			return (bounds.size.height / 2.0)
		}
		set {
			// No-op; we always calculate cornerRadius here
		}
	}

	/// Pin content to the leading edge to reserve trailing-image space.
	/// Avoid NSStackView's fitting constraints, which can widen the button beyond its intrinsic size.
	private func configureOwnContentViewsIfNeeded() {
		guard primaryImageView == nil else {
			return
		}
		guard let cell = cell as? ButtonCell else {
			return
		}

		let imageView = NSImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.imageScaling = .scaleNone
		imageView.setAccessibilityElement(false)
		// Ignoring a control does not ignore its cell.
		imageView.cell?.setAccessibilityElement(false)
		addSubview(imageView)
		primaryImageView = imageView

		let label = NSTextField(labelWithString: "")
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = font
		label.lineBreakMode = .byClipping
		label.setAccessibilityElement(false)
		label.cell?.setAccessibilityElement(false)
		addSubview(label)
		titleLabel = label

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cell.horizontalPadding),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			label.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	private func updateOwnContentLayout() {
		guard let imageView = primaryImageView, let label = titleLabel, let cell = cell as? ButtonCell else {
			return
		}

		let hideImage = imagePosition == .noImage || logicalImage == nil
		imageView.isHidden = hideImage
		label.isHidden = shouldHideTitleLabel

		titleLeadingConstraint?.isActive = false
		titleLeadingConstraint = hideImage
			? label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cell.horizontalPadding)
			: label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: cell.titleToImageSpacing)
		titleLeadingConstraint?.isActive = true
	}

	@available(macOS 26.0, *)
	private func configureSystemGlassBezel() {
		// A bordered push-in button enables system bezel drawing and highlighting.
		isBordered = true
		bezelStyle = .glass
		borderShape = .capsule
		setButtonType(.momentaryPushIn)

		imageHugsTitle = true

		// Use compact system metrics; intrinsicContentSize supplies the 28pt height.
		controlSize = .regular

		// Restore system disabled-image treatment, which Button opts out of.
		(cell as? ButtonCell)?.imageDimsWhenDisabled = true

		updateSystemGlassBezelTint()
	}

	@available(macOS 26.0, *)
	private func updateSystemGlassBezelTint() {
		switch style {
		case .primary:
			bezelColor = accentColor
			tintProminence = .primary
		default:
			bezelColor = nil
			tintProminence = .automatic
		}
	}

	private static let standardSizeParameters = ButtonSizeParameters(
		fontSize: 13,  // line height: 17
		cornerRadius: 0.0, // unused
		verticalPadding: 4.0, // overall height: 28
		horizontalPadding: 5.0,
		titleVerticalPositionAdjustment: 0,
		titleToImageSpacing: 4.0,
		titleToImageVerticalSpacingAdjustment: 7,
		minButtonHeight: 28
	)

	private static let systemBezelSizeParameters = ButtonSizeParameters(
		fontSize: NSFont.systemFontSize(for: .regular),
		cornerRadius: 0.0, // unused
		verticalPadding: 0.0, // unused
		horizontalPadding: 8.0,
		titleVerticalPositionAdjustment: 0,
		titleToImageSpacing: 4.0,
		titleToImageVerticalSpacingAdjustment: 0,
		minButtonHeight: 0
	)

	private lazy var usesSystemGlassBezel: Bool = {
		guard #available(macOS 26.0, *) else {
			return false
		}
		return true
	}()

	/// AppKit's glass content drawing ignores cell layout overrides and `trailingImage`.
	/// Clear its image/title and use subviews when a trailing image needs reserved space.
	private var usesOwnContentLayout: Bool {
		return usesSystemGlassBezel && trailingImage != nil
	}

	/// Preserve image/title while custom layout keeps AppKit's storage empty.
	private var logicalImage: NSImage?
	private var logicalTitle: String = ""

	private var primaryImageView: NSImageView?
	private var titleLabel: NSTextField?

	private var explicitAccessibilityLabel: String?

	private var titleLeadingConstraint: NSLayoutConstraint?

	/// `.imageOnly` can hide the title without clearing it.
	private var shouldHideTitleLabel: Bool {
		return logicalTitle.isEmpty || imagePosition == .imageOnly
	}
}
