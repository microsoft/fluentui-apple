//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// Custom view for displaying a template style image that can be filled with a specified color. This takes in an image with a corresponding
/// overlay mask that is used for drawing the fill. The image and its corresponding fillMask need to line up appropriately so that when
/// the image is drawn over its mask, its outline will perfectly overlap the edges of the mask to achieve the desired fill effect.
@objc(MSFFilledTemplateImageView)
open class FilledTemplateImageView: NSImageView {

	/// Creates a custom template style image view with a fill.
	/// - Parameters:
	///   - image: the template style image or icon to be drawn.
	///   - fillMask: the mask image used to draw the fill color.
	///   - contentTintColor: the color to use for the main image outline.
	///   - fillColor: the color to use for the image fill. When set to nil or clear, the fill won't be drawn.
	@objc(initWithImage:fillMask:contentTintColor:FillColor:)
	public init(
		image: NSImage,
		fillMask: NSImage,
		contentTintColor: NSColor,
		fillColor: NSColor?
	) {
		self.fillMask = fillMask
		self.fillColor = fillColor
		super.init(frame: .zero)
		self.image = image
		self.contentTintColor = contentTintColor
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

	/// The color used to draw the fill of the fillMask image. When set to nil (or .clear), the fill won't be drawn.
	@objc public var fillColor: NSColor? {
		didSet {
			guard oldValue != fillColor else {
				return
			}
			needsDisplay = true
		}
	}

	/// Public override used to draw the icon with the right border and fill.
	public override func draw(_ dirtyRect: NSRect) {

		// Draw the image using the specified fill and border color
		// Don't use a fillMask if the color is nil or clear
		if let fillColor = fillColor {
			if fillColor != .clear {
				draw(image: fillMask, with: fillColor)
			}
		}
		if let contentTintColor = contentTintColor,
		   let image = image {
			draw(image: image, with: contentTintColor)
		}
	}

	/// Helper to draw the opaque pixels of the image into a transparency layer.
	private func draw(image: NSImage, with color: NSColor) {
		if let localContext = NSGraphicsContext.current?.cgContext {
			localContext.beginTransparencyLayer(in: bounds, auxiliaryInfo: nil)
			image.draw(in: bounds, from: .zero, operation: .sourceOver, fraction: 1.0, respectFlipped: true, hints: nil)
			color.setFill()
			bounds.fill(using: .sourceAtop)
			localContext.endTransparencyLayer()
		}
	}
}
