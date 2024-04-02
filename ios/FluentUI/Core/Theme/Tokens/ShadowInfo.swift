//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreGraphics
import UIKit

/// Represents a two-part shadow as used by FluentUI.
@objc(MSFShadowInfo)
public class ShadowInfo: NSObject {
    /// Initializes a shadow struct to be used in Fluent.
    ///
    /// - Parameters:
    ///   - keyColor: The color of the key shadow.
    ///   - keyBlur: The blur of the key shadow.
    ///   - xKey: The horizontal offset of the key shadow.
    ///   - yKey: The vertical offset of the key shadow.
    ///   - ambientColor: The color of the ambient shadow.
    ///   - ambientBlur: The blur of the ambient shadow.
    ///   - xAmbient: The horizontal offset of the ambient shadow.
    ///   - yAmbient: The vertical offset of the ambient shadow.
    public init(keyColor: UIColor,
                keyBlur: CGFloat,
                xKey: CGFloat,
                yKey: CGFloat,
                ambientColor: UIColor,
                ambientBlur: CGFloat,
                xAmbient: CGFloat,
                yAmbient: CGFloat) {
        self.keyColor = keyColor
        self.keyBlur = keyBlur * shadowBlurAdjustment
        self.xKey = xKey
        self.yKey = yKey
        self.ambientColor = ambientColor
        self.ambientBlur = ambientBlur * shadowBlurAdjustment
        self.xAmbient = xAmbient
        self.yAmbient = yAmbient
    }

    /// The color of the key shadow.
    @objc public let keyColor: UIColor

    /// The blur of the key shadow.
    @objc public let keyBlur: CGFloat

    /// The horizontal offset of the key shadow.
    @objc public let xKey: CGFloat

    /// The vertical offset of the key shadow.
    @objc public let yKey: CGFloat

    /// The color of the ambient shadow.
    @objc public let ambientColor: UIColor

    /// The blur of the ambient shadow.
    @objc public let ambientBlur: CGFloat

    /// The horizontal offset of the ambient shadow.
    @objc public let xAmbient: CGFloat

    /// The vertical offset of the ambient shadow.
    @objc public let yAmbient: CGFloat

    /// The number that the figma blur needs to be adjusted by to properly display shadows. See https://github.com/microsoft/apple-ux-guide/blob/gh-pages/Shadows.md
    private let shadowBlurAdjustment: CGFloat = 0.5
}

public extension ShadowInfo {
    /// Applies a key and an ambient shadow on a `UIView`.
    /// - Parameters:
    ///   - view: The view on which the shadows will be applied.
    ///   - parentController: The view controller responsible for the view on which the shadows will be applied.
    func applyShadow(to view: UIView, parentController: UIViewController? = nil) {
        guard var shadowable = (view as? Shadowable) ?? (view.superview as? Shadowable) ?? (parentController as? Shadowable) else {
            assertionFailure("Cannot apply Fluent shadows to a non-Shadowable view")
            return
        }

        shadowable.ambientShadow?.removeFromSuperlayer()
        shadowable.keyShadow?.removeFromSuperlayer()

        let ambientShadow = initializeShadowLayer(view: view, isAmbientShadow: true)
        let keyShadow = initializeShadowLayer(view: view)

        shadowable.ambientShadow = ambientShadow
        shadowable.keyShadow = keyShadow

        view.layer.insertSublayer(ambientShadow, at: 0)
        view.layer.insertSublayer(keyShadow, below: ambientShadow)
    }

    /// Initializes a `CALayer` with the relevant `ShadowInfo` values.
    /// - Parameters:
    ///   - view: The view on which the shadow layer will be applied.
    ///   - isAmbientShadow: Determines whether to apply ambient or key shadow values on the layer.
    /// - Returns: The modified `CALayer`.
    func initializeShadowLayer(view: UIView, isAmbientShadow: Bool = false) -> CALayer {
        let layer = CALayer()

        layer.frame = view.bounds
        layer.shadowColor = (isAmbientShadow ? ambientColor : keyColor).cgColor
        layer.shadowRadius = isAmbientShadow ? ambientBlur : keyBlur

        // The shadowOpacity needs to be set to 1 since the alpha is already set through shadowColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: isAmbientShadow ? xAmbient : xKey,
                                    height: isAmbientShadow ? yAmbient : yKey)
        layer.needsDisplayOnBoundsChange = true
        layer.cornerRadius = view.layer.cornerRadius
        layer.backgroundColor = view.backgroundColor?.cgColor

        return layer
    }
}

/// Public protocol that, when implemented, allows any UIView or one of its subviews to implement fluent shadows
public protocol Shadowable {
    /// The layer on which the ambient shadow is implemented
    var ambientShadow: CALayer? { get set }

    /// The layer on which the key shadow is implemented
    var keyShadow: CALayer? { get set }
}
