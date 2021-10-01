//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// Custom view for displaying a templated style image that can be filled with a specified color. This takes in an image with a corresponding
/// overlay mask that is used for drawing the fill. Therefore, the image and its corresponding fillMask need to line up appropriately such that
/// when the image is drawn over it's mask, its outline will perfectly overlap the edges of the mask to achieve the desired fill effect.
@objc(MSFFilledTemplateImageView)
open class FilledTemplateImageView: NSImageView {

	/// Creates a custom template style image view with a fill
	/// - Parameters:
	///   - image: the template style image or icon to be drawn
	///   - fillMask: the  mask image used to draw the fill color
	///   - borderColor: the color to use for the main image outline
	///   - fillColor: the color to use for the image fill
	@objc(initWithImage:fillMask:borderColor:FillColor:)
	public init(
		image: NSImage,
		fillMask: NSImage,
		borderColor: NSColor,
		fillColor: NSColor
	) {
		self.fillMask = fillMask
		self.borderColor = borderColor
		self.fillColor = fillColor
		super.init(frame: .zero)
		self.image = image
		self.contentTintColor = borderColor
	}

	@available(*, unavailable) required public init?(coder: NSCoder) {
		preconditionFailure()
	}
	@available(*, unavailable) override init(frame: NSRect) {
		preconditionFailure()
	}

	/// The  mask overlay image used to draw the fill.
	@objc public var fillMask: NSImage {
		didSet {
			guard oldValue != fillMask else {
				return
			}
			needsDisplay = true
		}
	}

	/// The color used to draw the border of the templated image.
	@objc public var borderColor: NSColor {
		didSet {
			guard oldValue != borderColor else {
				return
			}
			needsDisplay = true
		}
	}

	/// The color used to draw the fill of the fillMask image,.
	@objc public var fillColor: NSColor {
		didSet {
			guard oldValue != fillColor else {
				return
			}
			needsDisplay = true
		}
	}

	/// Public override used to draw the icon with the right border and fill
	public override func draw(_ dirtyRect: NSRect) {

		// Draw the image using the specified fill and border color
		// Don't use a fillMask if it's set to clear
		if fillColor != NSColor.clear {
			draw(image: fillMask, isFillMask: true)
		}
		draw(image: image!, isFillMask: false)
	}

	/// Helper to draw the opaque pixels of the image into a transparency layer
	private func draw(image: NSImage, isFillMask: Bool) {
		if let localContext = NSGraphicsContext.current?.cgContext {
			localContext.beginTransparencyLayer(in: bounds, auxiliaryInfo: nil)
			image.draw(in: bounds, from: .zero, operation: .sourceOver, fraction: 1.0, respectFlipped: true, hints: nil)
			isFillMask ? fillColor.setFill() : borderColor.setFill()
			bounds.fill(using: .sourceAtop)
			localContext.endTransparencyLayer()
		}
	}
}
