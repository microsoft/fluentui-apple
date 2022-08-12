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

    open override func layoutSubviews() {
        super.layoutSubviews()

        var currentTop: CGFloat = 0
        for (index, linelayer) in viewCoverLayers.enumerated() {
            let fillPercent: CGFloat = {
                if index == 0 && viewCoverLayers.count > 2 {
                    guard let firstLineFillPercent = firstLineFillPercent else {
                        return 1
                    }

                    return firstLineFillPercent
                } else if index == viewCoverLayers.count - 1 {
                    guard let lastLineFillPercent = lastLineFillPercent else {
                        return 1
                    }

                    return lastLineFillPercent
                } else {
                    return 1
                }
            }()

            let labelHeight = tokenSet[.labelHeight].float
            linelayer.frame = CGRect(x: 0, y: currentTop, width: fillPercent * frame.width, height: labelHeight)

            currentTop += labelHeight + tokenSet[.labelSpacing].float
        }

        shimmeringLayer.frame = CGRect(x: -tokenSet[.shimmerWidth].float, y: 0.0, width: frame.width + 2 * tokenSet[.shimmerWidth].float, height: frame.height)
        viewCoverLayers.forEach { $0.frame = flipRectForRTL($0.frame) }

        updateShimmeringLayer()
        updateShimmeringAnimation()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let desiredLineCount = CGFloat(lineCount(for: size.height))
        let height = desiredLineCount * tokenSet[.labelHeight].float + (desiredLineCount - 1) * tokenSet[.labelSpacing].float
        return CGSize(width: size.width, height: height)
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: sizeThatFits(CGSize(width: frame.width, height: .infinity)).height)
    }

    /// Creates the ShimmerLinesView
    /// - Parameters:
    ///   - lineCount: Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
    @objc public init(lineCount: Int) {
        self.lineCount = lineCount

        super.init()
    }

    /// Creates the ShimmerLinesView
    /// - Parameters:
    ///   - lineCount: Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
    ///   - firstLineFillPercent: The percent the first line (if 2+ lines) should fill the available horizontal space.
    ///   - lastLineFillPercent: The percent the last line should fill the available horizontal space.
    @objc public convenience init(lineCount: Int = 3,
                                  firstLineFillPercent: CGFloat = 0.94,
                                  lastLineFillPercent: CGFloat = 0.6) {
        self.init(lineCount: lineCount)

        self.firstLineFillPercent = firstLineFillPercent
        self.lastLineFillPercent = lastLineFillPercent
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func updateViewCoverLayers() {
        var newLineLayers = [CALayer]()
        let desiredLineCount = lineCount(for: frame.height)

        for i in 0..<desiredLineCount {
            let lineLayer = i < viewCoverLayers.count ? viewCoverLayers[i] : CALayer()
            lineLayer.cornerRadius = tokenSet[.labelCornerRadius].float >= 0 ? tokenSet[.labelCornerRadius].float : tokenSet[.cornerRadius].float
            lineLayer.backgroundColor = UIColor(dynamicColor: tokenSet[.tintColor].dynamicColor).cgColor

            // Add layer
            newLineLayers.append(lineLayer)
            layer.addSublayer(lineLayer)
        }

        Set(viewCoverLayers).subtracting(Set(newLineLayers)).forEach { $0.removeFromSuperlayer() }

        viewCoverLayers = newLineLayers
    }

    @objc private func lineCount(for availableHeight: CGFloat) -> Int {
        if lineCount == 0 {
            let lineSpacing = tokenSet[.labelSpacing].float
            // Deduce lines count based on available height
            return Int(floor((availableHeight + lineSpacing) / (tokenSet[.labelHeight].float + lineSpacing)))
        } else {
            // Hardcoded lines count
            return lineCount
        }
    }

    private var lineCount: Int
    private var firstLineFillPercent: CGFloat?
    private var lastLineFillPercent: CGFloat?
}
