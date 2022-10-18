//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics
import UIKit

/// Represents a two-part shadow as used by FluentUI.
public struct ShadowInfo: Equatable {
    /// Initializes a shadow struct to be used in Fluent.
    ///
    /// - Parameters:
    ///   - colorOne: The color of the shadow for shadow 1.
    ///   - blurOne: The blur of the shadow for shadow 1.
    ///   - xOne: The horizontal offset of the shadow for shadow 1.
    ///   - yOne: The vertical offset of the shadow for shadow 1.
    ///   - colorTwo: The color of the shadow for shadow 2.
    ///   - blurTwo: The blur of the shadow for shadow 2.
    ///   - xTwo: The horizontal offset of the shadow for shadow 2.
    ///   - yTwo: The vertical offset of the shadow for shadow 2.
    public init(colorOne: DynamicColor,
                blurOne: CGFloat,
                xOne: CGFloat,
                yOne: CGFloat,
                colorTwo: DynamicColor,
                blurTwo: CGFloat,
                xTwo: CGFloat,
                yTwo: CGFloat) {
        self.colorOne = colorOne
        self.blurOne = blurOne / blurDivisor
        self.xOne = xOne
        self.yOne = yOne
        self.colorTwo = colorTwo
        self.blurTwo = blurTwo / blurDivisor
        self.xTwo = xTwo
        self.yTwo = yTwo
    }

    /// The color of the shadow for shadow 1.
    public let colorOne: DynamicColor

    /// The blur of the shadow for shadow 1.
    public let blurOne: CGFloat

    /// The horizontal offset of the shadow for shadow 1.
    public let xOne: CGFloat

    /// The vertical offset of the shadow for shadow 1.
    public let yOne: CGFloat

    /// The color of the shadow for shadow 2.
    public let colorTwo: DynamicColor

    /// The blur of the shadow for shadow 2.
    public let blurTwo: CGFloat

    /// The horizontal offset of the shadow for shadow 2.
    public let xTwo: CGFloat

    /// The vertical offset of the shadow for shadow 2.
    public let yTwo: CGFloat

    /// The number that the figma blur needs to be divided by to properly display shadows
    private let blurDivisor: CGFloat = 2.0
}

public class ShadowUtil {

    public static func applyShadow(_ shadowInfo: ShadowInfo, for view: UIView) {
        guard let superview = view.superview else {
            return
        }
        var shadowable: Shadowable

        if view as? Shadowable != nil {
            shadowable = view as! Shadowable
        } else if view.superview as? Shadowable != nil {
            shadowable = view.superview as! Shadowable
        } else {
            return
        }

        let shadowView = UIView()

        shadowable.shadowView?.removeFromSuperview()
        shadowable.shadowView = shadowView

        shadowView.frame = view.frame
        shadowView.layer.cornerRadius = view.layer.cornerRadius

        superview.insertSubview(shadowView, belowSubview: view)

        let shadow1 = CALayer()
        let shadow2 = CALayer()

        initializeShadowLayer(layer: shadow1, shadow: shadowInfo, view: view, isShadowOne: true)
        initializeShadowLayer(layer: shadow2, shadow: shadowInfo, view: view)

        shadowView.layer.insertSublayer(shadow1, at: 0)
        shadowView.layer.insertSublayer(shadow2, below: shadow1)
    }

    private static func initializeShadowLayer(layer: CALayer,
                                              shadow: ShadowInfo,
                                              view: UIView,
                                              isShadowOne: Bool = false) {
        layer.frame = view.bounds
        layer.shadowColor = UIColor(dynamicColor: isShadowOne ? shadow.colorOne : shadow.colorTwo).cgColor
        layer.shadowRadius = isShadowOne ? shadow.blurOne : shadow.blurTwo
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: isShadowOne ? shadow.xOne : shadow.xTwo,
                                    height: isShadowOne ? shadow.yOne : shadow.yTwo)
        layer.needsDisplayOnBoundsChange = true
        layer.cornerRadius = view.layer.cornerRadius
        layer.backgroundColor = view.backgroundColor?.cgColor
    }
}

public protocol Shadowable {
    var shadowView: UIView? { get set }
}
