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
        self.blurOne = blurOne * shadowBlurAdjustment
        self.xOne = xOne
        self.yOne = yOne
        self.colorTwo = colorTwo
        self.blurTwo = blurTwo * shadowBlurAdjustment
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

    /// The number that the figma blur needs to be adjusted by to properly display shadows. See https://github.com/microsoft/apple-ux-guide/blob/gh-pages/Shadows.md
    private let shadowBlurAdjustment: CGFloat = 0.5
}

public extension ShadowInfo {

    func applyShadow(to view: UIView, parentController: UIViewController? = nil) {
        guard var shadowable = (view as? Shadowable) ?? (view.superview as? Shadowable) ?? (parentController as? Shadowable) else {
            assertionFailure("Cannot apply Fluent shadows to a non-Shadowable view")
            return
        }

        shadowable.shadow1?.removeFromSuperlayer()
        shadowable.shadow2?.removeFromSuperlayer()

        let shadow1 = initializeShadowLayer(view: view, isShadowOne: true)
        let shadow2 = initializeShadowLayer(view: view)

        shadowable.shadow1 = shadow1
        shadowable.shadow2 = shadow2

        view.layer.insertSublayer(shadow1, at: 0)
        view.layer.insertSublayer(shadow2, below: shadow1)
    }

    private func initializeShadowLayer(view: UIView,
                                       isShadowOne: Bool = false) -> CALayer {
        let layer = CALayer()

        layer.frame = view.bounds
        layer.shadowColor = UIColor(dynamicColor: isShadowOne ? colorOne : colorTwo).cgColor
        layer.shadowRadius = isShadowOne ? blurOne : blurTwo

        // The shadowOpacity needs to be set to 1 since the alpha is already set through shadowColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: isShadowOne ? xOne : xTwo,
                                    height: isShadowOne ? yOne : yTwo)
        layer.needsDisplayOnBoundsChange = true
        layer.cornerRadius = view.layer.cornerRadius
        layer.backgroundColor = view.backgroundColor?.cgColor

        return layer
    }
}

/// Public protocol that, when implemented, allows any UIView or one of its subviews to implement fluent shadows
public protocol Shadowable {

    /// The layer on which the perimeter shadow is implemented
    var shadow1: CALayer? { get set }

    /// The layer on which the key shadow is implemented
    var shadow2: CALayer? { get set }
}
