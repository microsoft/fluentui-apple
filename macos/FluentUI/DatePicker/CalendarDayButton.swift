//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
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
		dualMode = self.day.secondaryLabel != nil
		upperLabel = NSTextField(labelWithString: self.day.primaryLabel)
		
		let frame = NSRect.init(x: 0, y: 0, width: size, height: size)
		super.init(frame: frame)
		
		wantsLayer = true
		setButtonType(.onOff)
		
		// Setting title to an empty string to ensure the placeholder is not displayed (happens on High Sierra).
		// We use our own labels instead (upperLabel and lowerLabel).
		title = ""
		
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
		
		upperLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(upperLabel)
		
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: size),
			heightAnchor.constraint(equalToConstant: size),
			upperLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
		
		setAccessibilityLabel(day?.accessibilityLabel)
		
		updateViewStyle()
	}
	
	@available(*, unavailable)
	required init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	override func updateLayer() {
		switch state {
		case .on:
			NSAnimationContext.runAnimationGroup({ context in
				context.allowsImplicitAnimation = true
				layer?.addSublayer(highlightLayer)
			})
			
			highlightLayer.backgroundColor = customSelectionColor?.cgColor ?? NSColor.controlAccentColor.cgColor
		case .off:
			if highlightLayer.superlayer != nil {
				highlightLayer.removeFromSuperlayer()
			}
		default:
			break
		}
		
		upperLabel.font = upperLabelFont
		upperLabel.textColor = upperLabelFontColor
			
		if dualMode, let lowerLabel = lowerLabel {
			lowerLabel.font = lowerLabelFont
			lowerLabel.textColor = lowerLabelFontColor
		}
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
			upperLabel.stringValue = day.primaryLabel
			if let secondaryLabel = day.secondaryLabel {
				dualMode = true
				lowerLabel?.stringValue = secondaryLabel
			} else {
				dualMode = false
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
			needsDisplay = true
		}
	}
	
	/// Updates the layout depending on whether we are in dualMode or not
	private func updateViewStyle() {
		if dualMode {
			upperLabelCenterYConstraint.isActive = false
			upperLabelDualModeCenterYConstraint.isActive = true
			
			if let lowerLabel = lowerLabel {
				assert(lowerLabel.superview != nil, "lowerLabel should be in the view hierarchy at this point.")
				lowerLabel.isHidden = false
			} else {
				lowerLabel = NSTextField(labelWithString: day.secondaryLabel ?? "")
				if let lowerLabel = lowerLabel {
					lowerLabel.translatesAutoresizingMaskIntoConstraints = false
					addSubview(lowerLabel)
					lowerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
					let lowerLabelConstraint = NSLayoutConstraint(item: lowerLabel,
																  attribute: .centerY,
																  relatedBy: .equal,
																  toItem: self,
																  attribute: .centerY,
																  multiplier: CalendarDayButton.lowerHalfCenteringMultiplier,
																  constant: -CalendarDayButton.dualModeMargin)
					lowerLabelConstraint.isActive = true
				}
			}
		} else {
			upperLabelDualModeCenterYConstraint.isActive = false
			upperLabelCenterYConstraint.isActive = true
			lowerLabel?.isHidden = true
		}
	}
	
	/// Diameter of the button
	private let size: CGFloat
	
	/// Indicates whether the button should display two labels
	private var dualMode: Bool {
		didSet {
			guard dualMode != oldValue else {
				return
			}
			updateViewStyle()
		}
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
	
	/// Text field used to display the primary day label in both dual and single calendar mode
	private var upperLabel: NSTextField
	
	/// Text field used to display the secondary day label in dual mode
	private var lowerLabel: NSTextField?
	
	/// Constraint used for the upperLabel when dualMode == false
	private lazy var upperLabelCenterYConstraint: NSLayoutConstraint =
		upperLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
	
	/// Constraint used for the upperLabel when dualMode == true
	private lazy var upperLabelDualModeCenterYConstraint: NSLayoutConstraint =
		NSLayoutConstraint(item: upperLabel,
						   attribute: .centerY,
						   relatedBy: .equal,
						   toItem: self,
						   attribute: .centerY,
						   multiplier: CalendarDayButton.upperHalfCenteringMultiplier,
						   constant: CalendarDayButton.dualModeMargin)
	
	private var isDarkMode: Bool {
		var isInDarkAppearance = false
		if effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua {
			isInDarkAppearance  = true
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
	
	/// Multiplier for centering in the lower half of the view
	static let lowerHalfCenteringMultiplier: CGFloat = 1.5
	
	/// Multiplier for centering in the upper half of the view
	static let upperHalfCenteringMultiplier: CGFloat = 0.5
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
