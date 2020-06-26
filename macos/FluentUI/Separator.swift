//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFSeparatorOrientation)
public enum SeparatorOrientation: Int {
    case horizontal
    case vertical
}


@objc(MSFSeparator)
open class Separator: NSView {
	let orientation: SeparatorOrientation
	
	/// Initializes a separator in the specified orientation
	/// - Parameter orientation: The orientation of the separator, vertical or horizontal
	@objc public init(orientation: SeparatorOrientation) {
		self.orientation = orientation
		super.init(frame: .zero)
		wantsLayer = true
		if let layer = layer {
			layer.backgroundColor = separatorColor.cgColor
		}
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
			layer.backgroundColor = separatorColor.cgColor
		}
	}
	
	open override var intrinsicContentSize: CGSize {
		switch orientation {
		case .horizontal:
			return CGSize(width: NSView.noIntrinsicMetric, height: separatorThickness)
		case .vertical:
			return CGSize(width: separatorThickness, height: NSView.noIntrinsicMetric)
		}
	}
	
	private var separatorColor: NSColor {
		if #available(OSX 10.14, *) {
			return .separatorColor
		} else {
			return.gridColor
		}
	}
}

// MARK: - Constants

fileprivate let separatorThickness: CGFloat = 1.0
