//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Contains all information necessary to determine desired height of content inside of a container.
@objc(MSFContentHeightResolutionContext)
public class ContentHeightResolutionContext: NSObject {

    /// Init the resolution context.
    /// - Parameters:
    ///   - maximumHeight: Maximum height of the content.
    ///   - containerTraitCollection: Trait collection of the content container.
    init(maximumHeight: CGFloat, containerTraitCollection: UITraitCollection) {
        self.maximumHeight = maximumHeight
        self.containerTraitCollection = containerTraitCollection
    }

    /// Maximum height of the content.
    @objc public let maximumHeight: CGFloat

    /// Trait collection of the content container.
    @objc public let containerTraitCollection: UITraitCollection
}
