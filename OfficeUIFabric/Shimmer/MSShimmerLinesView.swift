//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 Specialized MSShimmerView that shows 1 or more shimmering lines.
 */
@objcMembers
open class MSShimmerLinesView: MSShimmerView {
    public static func sizeThatFits(_ size: CGSize, appearance: MSShimmerLinesViewAppearance) -> CGSize {
        let desiredLineCount = CGFloat(MSShimmerLinesView.lineCount(for: appearance, availableHeight: size.height))
        let height = desiredLineCount * appearance.lineHeight + (desiredLineCount - 1) * appearance.lineSpacing
        return CGSize(width: size.width, height: height)
    }

    private static func lineCount(for appearance: MSShimmerLinesViewAppearance, availableHeight: CGFloat) -> Int {
        if appearance.lineCount == 0 {
            // Deduce lines count based on available height
            return Int(floor((availableHeight + appearance.lineSpacing) / (appearance.lineHeight + appearance.lineSpacing)))
        } else {
            // Hardcoded lines count
            return appearance.lineCount
        }
    }

    public var shimmerLinesViewAppearance = MSShimmerLinesViewAppearance() {
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

            linelayer.frame = CGRect(x: 0, y: currentTop, width: fillPercent * width, height: shimmerLinesViewAppearance.lineHeight)

            currentTop += shimmerLinesViewAppearance.lineHeight + shimmerLinesViewAppearance.lineSpacing
        }

        shimmeringLayer.frame = CGRect(x: -shimmerAppearance.width, y: 0.0, width: width + 2 * shimmerAppearance.width, height: height)

        viewCoverLayers.forEach { $0.frame = flipRectForRTL($0.frame) }

        updateShimmeringLayer()
        updateShimmeringAnimation()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return MSShimmerLinesView.sizeThatFits(size, appearance: shimmerLinesViewAppearance)
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: sizeThatFits(CGSize(width: width, height: .infinity)).height)
    }

    override func updateViewCoverLayers() {
        var newLineLayers = [CALayer]()
        let desiredLineCount = MSShimmerLinesView.lineCount(for: shimmerLinesViewAppearance, availableHeight: height)

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
