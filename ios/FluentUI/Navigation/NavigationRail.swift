//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: NavigationRail

@objc(MSFNavigationRail)
open class NavigationRail: UIView {
	@objc(MSFHorizontalPosition)
    public enum HorizontalPosition: Int {
        case leading
        case trailing
    }

	private struct Constants {
		static let viewWidth: CGFloat = 62.0
    }

	@objc open var horizontalPosition: HorizontalPosition = .leading {
		didSet {
			setNeedsDisplay()
		}
	}

	@objc public init(with horizontalPosition: HorizontalPosition) {
		super.init(frame: .zero)
		self.horizontalPosition = horizontalPosition

        initialize()
	}

	@objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

	@objc public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

	/// Helper method to insert the view in a superview.
	/// Set horizontalPosition before calling this.
	@objc public func insert(in superView: UIView) {
		superView.addSubview(self)

		let horizontalAnchor = horizontalPosition == .leading ? leadingAnchor : trailingAnchor
		let superViewHorizontalAnchor = horizontalPosition == .leading ? superView.leadingAnchor : superView.trailingAnchor

		NSLayoutConstraint.activate([
			horizontalAnchor.constraint(equalTo: superViewHorizontalAnchor),
			topAnchor.constraint(equalTo: superView.topAnchor),
			bottomAnchor.constraint(equalTo: superView.bottomAnchor)
		])
	}

	private func initialize() {
		backgroundColor = Colors.gray25
		translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: Constants.viewWidth)])
	}

	override open func draw(_ rect: CGRect) {
		// Draw border
		let path = UIBezierPath()

		var x: CGFloat = 0.0
		let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
		if ((horizontalPosition == .leading && !isRTL) || (horizontalPosition == .trailing && isRTL)) {
			x = bounds.width
		}

		path.move(to: CGPoint(x: x, y: 0.0))
		path.addLine(to: CGPoint(x: x, y: bounds.height))

		path.close()

		Colors.gray200.set()
		path.lineWidth = 1.0
		path.stroke()
	}
}
