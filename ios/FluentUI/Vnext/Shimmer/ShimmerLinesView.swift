//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 Specialized ShimmerView that shows 1 or more shimmering lines.
 */
@objc(MSFShimmerLinesView)
open class ShimmerLinesView: ShimmerView {

	/// Creates the ShimmerLinesView
	/// - Parameters:
	///   - lineCount: Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
	///   - lineHeight: Height of shimmering line
	///   - lineSpacing: Spacing between lines (if lines > 1)
	///   - firstLineFillPercent: The percent the first line (if 2+ lines) should fill the available horizontal space
	///   - lastLineFillPercent: The percent the last line should fill the available horizontal space.
	@objc public init(lineCount: Int,
					  lineHeight: CGFloat,
					  lineSpacing: CGFloat,
					  firstLineFillPercent: CGFloat,
					  lastLineFillPercent: CGFloat) {
		self.lineCount = lineCount
		self.lineHeight = lineHeight
		self.lineSpacing = lineSpacing
		self.firstLineFillPercent = firstLineFillPercent
		self.lastLineFillPercent = lastLineFillPercent

		super.init()
	}

	required public init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	open override func layoutSubviews() {
		super.layoutSubviews()

		var currentTop: CGFloat = 0
		for (index, linelayer) in viewCoverLayers.enumerated() {
			let fillPercent: CGFloat = {
				if index == 0 && viewCoverLayers.count > 2 {
					return firstLineFillPercent
				} else if index == viewCoverLayers.count - 1 {
					return lastLineFillPercent
				} else {
					return 1
				}
			}()

			linelayer.frame = CGRect(x: 0, y: currentTop, width: fillPercent * frame.width, height: lineHeight)

			currentTop += lineHeight + lineSpacing
		}

		shimmeringLayer.frame = CGRect(x: -tokens.shimmerWidth, y: 0.0, width: frame.width + 2 * tokens.shimmerWidth, height: frame.height)
		viewCoverLayers.forEach { $0.frame = flipRectForRTL($0.frame) }

		updateShimmeringLayer()
		updateShimmeringAnimation()
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let desiredLineCount = CGFloat(lineCount(for: size.height))
		let height = desiredLineCount * lineHeight + (desiredLineCount - 1) * lineSpacing
		return CGSize(width: size.width, height: height)
	}

	open override var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: sizeThatFits(CGSize(width: frame.width, height: .infinity)).height)
	}

	override func updateViewCoverLayers() {
		var newLineLayers = [CALayer]()
		let desiredLineCount = lineCount(for: frame.height)

		for i in 0..<desiredLineCount {
			let lineLayer = i < viewCoverLayers.count ? viewCoverLayers[i] : CALayer()
			lineLayer.cornerRadius = tokens.labelCornerRadius >= 0 ? tokens.labelCornerRadius : tokens.cornerRadius
			lineLayer.backgroundColor = UIColor(dynamicColor: tokens.tintColor).cgColor

			// Add layer
			newLineLayers.append(lineLayer)
			layer.addSublayer(lineLayer)
		}

		Set(viewCoverLayers).subtracting(Set(newLineLayers)).forEach { $0.removeFromSuperlayer() }

		viewCoverLayers = newLineLayers
	}

	@objc private func lineCount(for availableHeight: CGFloat) -> Int {
		if lineCount == 0 {
			// Deduce lines count based on available height
			return Int(floor((availableHeight + lineSpacing) / (lineHeight + lineSpacing)))
		} else {
			// Hardcoded lines count
			return lineCount
		}
	}

	private var lineCount: Int {
		didSet {
			setNeedsLayout()
		}
	}

	private var lineHeight: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}

	private var lineSpacing: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}

	private var firstLineFillPercent: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}

	private var lastLineFillPercent: CGFloat {
		didSet {
			setNeedsLayout()
		}
	}
}
