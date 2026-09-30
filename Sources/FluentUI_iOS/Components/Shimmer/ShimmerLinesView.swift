//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

/**
 Specialized ShimmerView that shows 1 or more shimmering lines.

 The view supports two modes of configuration:
 1.  Use `lineConfigs` to define individual line heights, widths, and corner radii
 2. Use `lineCount`, `firstLineFillPercent`, and `lastLineFillPercent` for uniform line heights

 When `lineConfigs` is set, it takes precedence over the `lineCount` and other properties.
 */
@objc(MSFShimmerLinesView)
open class ShimmerLinesView: ShimmerView {

    /// Array of line configurations defining each shimmer line's appearance.
    /// When set, this takes precedence over `lineCount`, `firstLineFillPercent`, and `lastLineFillPercent`.
    @objc open var lineConfigs: [ShimmerLineConfiguration]? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    /// Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
    /// Note: This property is ignored when `lineConfigs` is set.
    @objc open var lineCount: Int = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    /// The percent the first line (if 2+ lines) should fill the available horizontal space
    /// Note: This property is ignored when `lineConfigs` is set.
    @objc open var firstLineFillPercent: CGFloat = 0.94 {
        didSet {
            setNeedsLayout()
        }
    }

    /// The percent the last line should fill the available horizontal space.
    /// Note: This property is ignored when `lineConfigs` is set.
    @objc open var lastLineFillPercent: CGFloat = 0.6 {
        didSet {
            setNeedsLayout()
        }
    }

    /// Custom spacing between lines in points. If nil, uses the default token spacing (typically 12pt).
    /// Set this to customize the vertical spacing between shimmer lines.
    @objc open var lineSpacing: NSNumber? {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Initializers

    /// Creates a ShimmerLinesView with specific line configurations.
    /// - Parameters:
    ///   - lineConfigs: Optional array of line configurations defining each line's appearance.
    ///   - lineSpacing: Optional custom spacing between lines in points. If nil, uses default token spacing.
    ///   - animationSynchronizer: Optional synchronizer to coordinate animations across multiple shimmer views.
    @objc public convenience init(
        lineConfigs: [ShimmerLineConfiguration]? = nil,
        lineSpacing: NSNumber? = nil,
        animationSynchronizer: AnimationSynchronizerProtocol? = nil
    ) {
        self.init(containerView: nil, excludedViews: [], animationSynchronizer: animationSynchronizer)
        self.lineConfigs = lineConfigs
        self.lineSpacing = lineSpacing
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        var currentTop: CGFloat = 0

        // Get spacing value (custom or token-based)
        let spacing: CGFloat = lineSpacing.map { CGFloat(truncating: $0) } ?? tokenSet[.labelSpacing].float

        // Use line configs mode if available
        if let configs = lineConfigs {
            for (index, linelayer) in viewCoverLayers.enumerated() {
                guard index < configs.count else { break }

                let config = configs[index]
                let lineWidth = config.widthPercent * frame.width
                linelayer.frame = CGRect(x: 0, y: currentTop, width: lineWidth, height: config.height)

                currentTop += config.height + spacing
            }
        } else {
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

                let labelHeight = tokenSet[.labelHeight].float
                linelayer.frame = CGRect(x: 0, y: currentTop, width: fillPercent * frame.width, height: labelHeight)

                currentTop += labelHeight + spacing
            }
        }

        shimmeringLayer.frame = CGRect(x: -tokenSet[.shimmerWidth].float, y: 0.0, width: frame.width + 2 * tokenSet[.shimmerWidth].float, height: frame.height)
        viewCoverLayers.forEach { $0.frame = flipRectForRTL($0.frame) }

        updateShimmeringLayer()
        updateShimmeringAnimation()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Get spacing value (custom or token-based)
        let spacing: CGFloat = lineSpacing.map { CGFloat(truncating: $0) } ?? tokenSet[.labelSpacing].float

        // Use line configs mode if available
        let height: CGFloat
        if let configs = lineConfigs {
            height = configs.enumerated().reduce(0) { total, element in
                let (index, config) = element
                let lineSpacing = index > 0 ? spacing : 0
                return total + config.height + lineSpacing
            }
        } else {
            let desiredLineCount = CGFloat(lineCount(for: size.height))
            height = desiredLineCount * tokenSet[.labelHeight].float + (desiredLineCount - 1) * spacing
        }
        return CGSize(width: size.width, height: height)
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: sizeThatFits(CGSize(width: frame.width, height: .infinity)).height)
    }

    override func updateViewCoverLayers() {
        var newLineLayers = [CALayer]()

        // Use line configs mode if available
        if let configs = lineConfigs {
            for i in 0..<configs.count {
                let lineLayer = i < viewCoverLayers.count ? viewCoverLayers[i] : CALayer()

                // Use config's corner radius if specified, otherwise use token
                if let configCornerRadius = configs[i].cornerRadius {
                    lineLayer.cornerRadius = CGFloat(truncating: configCornerRadius)
                } else {
                    lineLayer.cornerRadius = tokenSet[.labelCornerRadius].float >= 0 ? tokenSet[.labelCornerRadius].float : tokenSet[.cornerRadius].float
                }

                lineLayer.backgroundColor = tokenSet[.tintColor].uiColor.cgColor

                // Add layer
                newLineLayers.append(lineLayer)
                layer.addSublayer(lineLayer)
            }
        } else {
            let desiredLineCount = lineCount(for: frame.height)

            for i in 0..<desiredLineCount {
                let lineLayer = i < viewCoverLayers.count ? viewCoverLayers[i] : CALayer()
                lineLayer.cornerRadius = tokenSet[.labelCornerRadius].float >= 0 ? tokenSet[.labelCornerRadius].float : tokenSet[.cornerRadius].float
                lineLayer.backgroundColor = tokenSet[.tintColor].uiColor.cgColor

                // Add layer
                newLineLayers.append(lineLayer)
                layer.addSublayer(lineLayer)
            }
        }

        Set(viewCoverLayers).subtracting(Set(newLineLayers)).forEach { $0.removeFromSuperlayer() }

        viewCoverLayers = newLineLayers
    }

    @objc private func lineCount(for availableHeight: CGFloat) -> Int {
        if lineCount == 0 {
            // Get spacing value (custom or token-based)
            let spacing: CGFloat = lineSpacing.map { CGFloat(truncating: $0) } ?? tokenSet[.labelSpacing].float
            // Deduce lines count based on available height.
            return Int(floor((availableHeight + spacing) / (tokenSet[.labelHeight].float + spacing)))
        } else {
            // Hardcoded lines count.
            return lineCount
        }
    }
}
