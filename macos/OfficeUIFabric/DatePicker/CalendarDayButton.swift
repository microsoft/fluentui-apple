//
// Copyright Microsoft Corporation
//

import AppKit

/// A circular button with a day label centered inside of it. This is meant to be used in a grid-like calendar view.
class CalendarDayButton: NSButton {
	
	enum DayButtonType {
		case primary
		case secondary
	}
	
	/// Initializes a calendar day button with size and a CalendarDay
	///
	/// - Parameters:
	///   - size: Diameter of the circular button
	///   - day: Day that should be displayed
	init(size: CGFloat, day: CalendarDay?) {
		self.size = size
		self.day = day ?? CalendarDay(date: Date(), primaryLabel: "", accessibilityLabel: "", secondaryLabel: nil)
		
		let frame = NSRect.init(x: 0, y: 0, width: size, height: size)
		super.init(frame: frame)
		
		wantsLayer = true
		setButtonType(.onOff)
		
		// Needed to support .compositingFilter on the highlightLayer
		layerUsesCoreImageFilters = true
		
		// Mask used to create the circular shape.
		// layer?.cornerRadius could replace this, but it is causing visual artifacts
		//  when layerUsesCoreImageFilters = true (10.14.4)
		maskLayer.frame = frame
		maskLayer.path = CGPath(ellipseIn: frame, transform: nil)
		maskLayer.contentsScale = window?.backingScaleFactor ?? 1.0
		layer?.mask = maskLayer

		// Layer with a compositing filter used to 'subtract' the text from the highlight circle
		highlightLayer.frame = frame
		highlightLayer.compositingFilter = CIFilter(name: "CISourceOutCompositing")
		highlightLayer.contentsScale = window?.backingScaleFactor ?? 1.0
		
		// Ensures that the highlight layer is always on top, so the compositingFilter works properly
		// Using Float.greatestFiniteMagnitude instead of CGFloat so CoreAnimation doesn't complain
		// This only seems to be necessary when presented in an NSMenu
		highlightLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
		
		let upperLabelContainer = NSView()
		let lowerLabelContainer = NSView()
		
		upperLabelContainer.translatesAutoresizingMaskIntoConstraints = false
		lowerLabelContainer.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(centeredLabel)
		upperLabelContainer.addSubview(upperLabel)
		lowerLabelContainer.addSubview(lowerLabel)
		
		addSubview(upperLabelContainer)
		addSubview(lowerLabelContainer)
		
		let constraints = [
			widthAnchor.constraint(equalToConstant: size),
			heightAnchor.constraint(equalToConstant: size),
			centeredLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			centeredLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			
			upperLabelContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
			upperLabelContainer.widthAnchor.constraint(equalTo: widthAnchor),
			upperLabelContainer.topAnchor.constraint(equalTo: topAnchor, constant: CalendarDayButton.dualModeMargin),
			
			lowerLabelContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
			lowerLabelContainer.widthAnchor.constraint(equalTo: widthAnchor),
			lowerLabelContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CalendarDayButton.dualModeMargin),
			
			upperLabel.centerXAnchor.constraint(equalTo: upperLabelContainer.centerXAnchor),
			upperLabel.centerYAnchor.constraint(equalTo: upperLabelContainer.centerYAnchor),
			lowerLabel.centerXAnchor.constraint(equalTo: lowerLabelContainer.centerXAnchor),
			lowerLabel.centerYAnchor.constraint(equalTo: lowerLabelContainer.centerYAnchor)
		]
		NSLayoutConstraint.activate(constraints)
		
		if DatePickerView.accessibilityTemporarilyRestricted {
			cell?.setAccessibilityElement(false)
		}
		setAccessibilityLabel(day?.accessibilityLabel)
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateLayer() {
		switch state {
		case .on:
			NSAnimationContext.runAnimationGroup({ context in
				context.allowsImplicitAnimation = true
				layer?.addSublayer(highlightLayer)
			})
			
			if #available(OSX 10.14, *) {
				highlightLayer.backgroundColor = customSelectionColor?.cgColor ?? NSColor.controlAccentColor.cgColor
			} else {
				highlightLayer.backgroundColor = customSelectionColor?.cgColor ?? NSColor.systemBlue.cgColor
			}
		case .off:
			if highlightLayer.superlayer != nil {
				highlightLayer.removeFromSuperlayer()
			}
		default:
			break
		}
		
		centeredLabel.font = upperLabelFont
		upperLabel.font = upperLabelFont
		lowerLabel.font = lowerLabelFont

		centeredLabel.textColor = upperLabelFontColor
		upperLabel.textColor = upperLabelFontColor
		lowerLabel.textColor = lowerLabelFontColor

		centeredLabel.isHidden = dualMode
		upperLabel.isHidden = !dualMode
		lowerLabel.isHidden = !dualMode
	}
	
	override func viewDidChangeBackingProperties() {
		super.viewDidChangeBackingProperties()

		// Update the layer content scales to the current window backingScaleFactor
		guard let scale = window?.backingScaleFactor else {
			return
		}

		[highlightLayer, maskLayer].forEach {
			if $0.contentsScale != scale {
				$0.contentsScale = scale
			}
		}
	}
	
	// Draws circular focus ring
	override func drawFocusRingMask() {
		let rect = bounds;
		let circlePath = NSBezierPath()
		
		circlePath.appendOval(in: rect)
		circlePath.fill()
	}
	
	override var wantsUpdateLayer: Bool {
		get {
			return true
		}
	}
	
	/// The day that is being displayed
	var day: CalendarDay {
		didSet {
			centeredLabel.stringValue = day.primaryLabel
			upperLabel.stringValue = day.primaryLabel
			
			if let label = day.secondaryLabel {
				lowerLabel.stringValue = label
			}
			setAccessibilityLabel(day.accessibilityLabel)
			needsDisplay = true
		}
	}
	
	/// Type of the button
	var type: DayButtonType = .primary {
		didSet {
			if type != oldValue {
				needsDisplay = true
			}
		}
	}
	
	/// A custom color for this CalendarDayButton highlight
	/// - note: Setting this to nil results in using a default color
	var customSelectionColor: NSColor? {
		didSet {
			setNeedsDisplay()
		}
	}
	
	/// Diameter of the button
	private let size: CGFloat
	
	/// Indicates whether the button should display two labels
	private var dualMode: Bool {
		return day.secondaryLabel != nil
	}
	
	/// Primary font size calculated relative to the button size
	private var primaryFontSize: CGFloat {
		return CalendarDayButton.primaryFontSizeScalingDefault * size
	}
	
	/// Secondary font size calculated relative to the button size
	private var secondaryFontSize: CGFloat {
		return CalendarDayButton.secondaryFontSizeScalingDefault * size
	}
	
	/// Font used in the upper label
	private var upperLabelFont: NSFont {
		if state == .on {
			return .boldSystemFont(ofSize: primaryFontSize)
		} else {
			return .systemFont(ofSize: primaryFontSize)
		}
	}
	
	/// Font used in the lower label
	private var lowerLabelFont: NSFont {
		if state == .on {
			return .boldSystemFont(ofSize: secondaryFontSize)
		} else {
			return .systemFont(ofSize: secondaryFontSize)
		}
	}
	
	/// Font color of the upper label
	private var upperLabelFontColor: NSColor {
		switch type {
		case .primary:
			return isDarkMode ? .primaryLabelColorDarkMode : .primaryLabelColorLightMode
		case .secondary:
			return isDarkMode ? .secondaryLabelColorDarkMode : .secondaryLabelColorLightMode
		}
	}
	
	/// Font color of the lower label
	private var lowerLabelFontColor: NSColor {
		switch type {
		case .primary:
			if state == .on {
				return isDarkMode ? .primaryLabelColorDarkMode : .primaryLabelColorLightMode
			} else {
				return isDarkMode ? .secondaryLabelColorDarkMode : .secondaryLabelColorLightMode
			}
		case .secondary:
			return isDarkMode ? .tertiaryLabelColorDarkMode : .tertiaryLabelColorLightMode
		}
	}
	
	/// Text field used to display the day label in single mode
	private lazy var centeredLabel: NSTextField = {
		var textField = NSTextField(labelWithString: "")
		textField.wantsLayer = true
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	/// Text field used to display the primary day label in dual mode
	private lazy var upperLabel: NSTextField = {
		var textField = NSTextField(labelWithString: "")
		textField.wantsLayer = true
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	/// Text field used to display the secondary day label in dual mode
	private lazy var lowerLabel: NSTextField = {
		var textField = NSTextField(labelWithString: "")
		textField.wantsLayer = true
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private var isDarkMode: Bool {
		var isInDarkAppearance = false
		if #available(OSX 10.14, *) {
			if effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua {
				isInDarkAppearance  = true
			}
		}
		return isInDarkAppearance
	}
	
	/// Layer used to draw the selected day highlight
	private let highlightLayer = CALayer()
	
	/// Layer used as a mask to the backing layer to create the circular shape
	private let maskLayer = CAShapeLayer()
	
	/// Font size of the primary label will be scaled to this fraction of the diameter
	static let primaryFontSizeScalingDefault: CGFloat = 0.45
	
	/// Font size of the secondary label will be scaled to this fraction of the diameter
	static let secondaryFontSizeScalingDefault: CGFloat = 0.29
	
	/// Top/Bottom margin for visual balance in dual mode
	static let dualModeMargin: CGFloat = 1.75
}

fileprivate extension NSColor {
	
	/// Primary label font color in dark mode
	static let primaryLabelColorDarkMode = NSColor.white.withAlphaComponent(0.9)
	
	/// Primary label font color in light mode
	static let primaryLabelColorLightMode = NSColor.black.withAlphaComponent(0.9)
	
	/// Secondary label font color in dark mode
	static let secondaryLabelColorDarkMode = NSColor.white.withAlphaComponent(0.5)
	
	/// Secondary label font color in light mode
	static let secondaryLabelColorLightMode = NSColor.black.withAlphaComponent(0.5)
	
	/// Tertiary label font color in dark mode
	static let tertiaryLabelColorDarkMode = NSColor.white.withAlphaComponent(0.25)
	
	/// Tertiary label font color in light mode
	static let tertiaryLabelColorLightMode = NSColor.black.withAlphaComponent(0.25)
}
