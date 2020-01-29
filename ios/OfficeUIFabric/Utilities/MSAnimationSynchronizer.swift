//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// An animation synchronizer syncs homogeneous layer animations by calculating the appropriate timeOffset
/// of a referenceLayer so that newly added animations can stay in sync with existing animations.
public protocol MSAnimationSynchronizerProtocol: class {
    /// Current reference layer to compare timing against.
    var referenceLayer: CALayer? { get set }

    /// Get the time offset for the given layer in order to sync the given layer
    /// with the referenceLayer.
    /// - Parameter forLayer: Layer to get the time offset for to sync with the referenceLayer.
    func timeOffset(for layer: CALayer) -> CFTimeInterval
}

@objcMembers
public class MSAnimationSynchronizer: NSObject, MSAnimationSynchronizerProtocol {
    public init(referenceLayer: CALayer? = nil) {
        self.referenceLayer = referenceLayer
        super.init()
    }

    // MARK: MSAnimationSynchronizerProtocol

    public weak var referenceLayer: CALayer?

    public func timeOffset(for layer: CALayer) -> CFTimeInterval {
        guard let referenceLayer = referenceLayer else {
            return 0
        }

        return referenceLayer.convertTime(CACurrentMediaTime(), to: layer)
    }
}
