//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFSeparatorStyle)
public enum SeparatorStyle: Int {
    case `default`
    case shadow

    fileprivate var color: NSColor {
        switch self {
        case .default:
			return NSColor.systemBlue
        case .shadow:
			return NSColor.systemGray
        }
    }
}


@objc(MSFSeparatorOrientation)
public enum SeparatorOrientation: Int {
    case horizontal
    case vertical
}


@objc(MSFSeparator)
open class Separator: NSView {
	private var orientation: SeparatorOrientation = .horizontal
	
	private var style: SeparatorStyle = .default

	@objc public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		initialize()
	}
	
	@objc public init(orientation: SeparatorOrientation = .horizontal) {
		super.init(frame: .zero)
		initialize(orientation: orientation)
	}

	@objc public init(style: SeparatorStyle = .default, orientation: SeparatorOrientation = .horizontal) {
		super.init(frame: .zero)
		initialize(style: style, orientation: orientation)
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) {
		preconditionFailure()
	}

	private func initialize(style: SeparatorStyle = .default, orientation: SeparatorOrientation = .horizontal) {
		wantsLayer = true
		self.style = style
		self.orientation = orientation
		switch orientation {
		case .horizontal:
			frame.size.height = 1.0
			autoresizingMask = .width
		case .vertical:
			frame.size.width = 1.0
			autoresizingMask = .height
		}
		}
	
	open override var wantsUpdateLayer: Bool {
		return true
	}
	
	open override func updateLayer() {
		if let layer = layer {
			layer.backgroundColor = style.color.cgColor
		}
	}
	
	open override func isAccessibilityElement() -> Bool {
		return false
	}

	open override var intrinsicContentSize: CGSize {
		switch orientation {
		case .horizontal:
			return CGSize(width: NSView.noIntrinsicMetric, height: frame.height)
		case .vertical:
			return CGSize(width: frame.width, height: NSView.noIntrinsicMetric)
		}
	}
}
