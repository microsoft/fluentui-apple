//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "ShimmerLinesView")
public typealias MSShimmerLinesView = ShimmerLinesView

/**
 Specialized ShimmerView that shows 1 or more shimmering lines.
 */
@objc(MSFShimmerLinesView)
open class ShimmerLinesView: ShimmerView {
    @objc public static func sizeThatFits(_ size: CGSize, appearance: ShimmerLinesViewAppearance) -> CGSize {
        let desiredLineCount = CGFloat(ShimmerLinesView.lineCount(for: appearance, availableHeight: size.height))
        let height = desiredLineCount * appearance.lineHeight + (desiredLineCount - 1) * appearance.lineSpacing
        return CGSize(width: size.width, height: height)
    }

    @objc private static func lineCount(for appearance: ShimmerLinesViewAppearance, availableHeight: CGFloat) -> Int {
        if appearance.lineCount == 0 {
            // Deduce lines count based on available height
            return Int(floor((availableHeight + appearance.lineSpacing) / (appearance.lineHeight + appearance.lineSpacing)))
        } else {
            // Hardcoded lines count
            return appearance.lineCount
        }
    }

    @objc public var shimmerLinesViewAppearance = ShimmerLinesViewAppearance() {
        didSet {
            setNeedsLayout()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        var currentTop: CGFloat = 0
        for (index, linelayer) in viewCoverLayers.enumerated() {
            let fillPercent: CGFloat = {
                if index == 0 && viewCoverLayers.count > 2 {
                    return shimmerLinesViewAppearance.firstLineFillPercent
                } else if index == viewCoverLayers.count - 1 {
                    return shimmerLinesViewAppearance.lastLineFillPercent
                } else {
                    return 1
                }
            }()

            linelayer.frame = CGRect(x: 0, y: currentTop, width: fillPercent * frame.width, height: shimmerLinesViewAppearance.lineHeight)

            currentTop += shimmerLinesViewAppearance.lineHeight + shimmerLinesViewAppearance.lineSpacing
        }

        shimmeringLayer.frame = CGRect(x: -shimmerAppearance.width, y: 0.0, width: frame.width + 2 * shimmerAppearance.width, height: frame.height)

        viewCoverLayers.forEach { $0.frame = flipRectForRTL($0.frame) }

        updateShimmeringLayer()
        updateShimmeringAnimation()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return ShimmerLinesView.sizeThatFits(size, appearance: shimmerLinesViewAppearance)
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: sizeThatFits(CGSize(width: frame.width, height: .infinity)).height)
    }

    override func updateViewCoverLayers() {
        var newLineLayers = [CALayer]()
        let desiredLineCount = ShimmerLinesView.lineCount(for: shimmerLinesViewAppearance, availableHeight: frame.height)

        for i in 0..<desiredLineCount {
            let lineLayer = i < viewCoverLayers.count ? viewCoverLayers[i] : CALayer()

            lineLayer.cornerRadius = appearance.labelCornerRadius >= 0 ? appearance.labelCornerRadius : appearance.cornerRadius
            lineLayer.backgroundColor = appearance.tintColor.cgColor

            // Add layer
            newLineLayers.append(lineLayer)
            layer.addSublayer(lineLayer)
        }

        Set(viewCoverLayers).subtracting(Set(newLineLayers)).forEach { $0.removeFromSuperlayer() }

        viewCoverLayers = newLineLayers
    }
}
