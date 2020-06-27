//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFSeparatorOrientation)
public enum SeparatorOrientation: Int {
    case horizontal // Separator with no intrinic width
    case vertical // Separator with no intrinic height
}

@objc(MSFSeparator)
open class Separator: NSView {
	private let orientation: SeparatorOrientation
	
	/// Initializes a separator in the specified orientation
	/// - Parameter orientation: The orientation of the separator, vertical or horizontal
	@objc public init(orientation: SeparatorOrientation) {
		self.orientation = orientation
		super.init(frame: .zero)
		wantsLayer = true
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) {
		preconditionFailure()
	}
	
	open override var wantsUpdateLayer: Bool {
		return true
	}

	open override func updateLayer() {
		if let layer = layer {
			layer.backgroundColor = Separator.separatorColor.cgColor
		}
	}
	
	open override var intrinsicContentSize: CGSize {
		switch orientation {
		case .horizontal:
			return CGSize(width: NSView.noIntrinsicMetric, height: Separator.separatorThickness)
		case .vertical:
			return CGSize(width: Separator.separatorThickness, height: NSView.noIntrinsicMetric)
		}
	}
	
	private static var separatorColor: NSColor {
		if #available(OSX 10.14, *) {
			return .separatorColor
		} else {
			return.gridColor
		}
	}
	
	private static let separatorThickness: CGFloat = 1.0
}
