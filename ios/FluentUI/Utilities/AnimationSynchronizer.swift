//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "AnimationSynchronizerProtocol")
public typealias MSAnimationSynchronizerProtocol = AnimationSynchronizerProtocol

/// An animation synchronizer syncs homogeneous layer animations by calculating the appropriate timeOffset
/// of a referenceLayer so that newly added animations can stay in sync with existing animations.
@objc(MSFAnimationSynchronizerProtocol)
public protocol AnimationSynchronizerProtocol: class {
    /// Current reference layer to compare timing against.
    @objc var referenceLayer: CALayer? { get set }

    /// Get the time offset for the given layer in order to sync the given layer
    /// with the referenceLayer.
    /// - Parameter layer: Layer to get the time offset for to sync with the referenceLayer.
    @objc func timeOffset(for layer: CALayer) -> CFTimeInterval
}

@available(*, deprecated, renamed: "AnimationSynchronizer")
public typealias MSAnimationSynchronizer = AnimationSynchronizer

@objc(MSFAnimationSynchronizer)
public class AnimationSynchronizer: NSObject, AnimationSynchronizerProtocol {
    @objc public init(referenceLayer: CALayer? = nil) {
        self.referenceLayer = referenceLayer
        super.init()
    }

    // MARK: AnimationSynchronizerProtocol

    @objc public weak var referenceLayer: CALayer?

    @objc public func timeOffset(for layer: CALayer) -> CFTimeInterval {
        guard let referenceLayer = referenceLayer else {
            return 0
        }

        return referenceLayer.convertTime(CACurrentMediaTime(), to: layer)
    }
}
