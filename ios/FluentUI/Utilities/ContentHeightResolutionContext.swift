//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFContentHeightResolutionContext)
public class ContentHeightResolutionContext: NSObject {
    init(maximumHeight: CGFloat, containerTraitCollection: UITraitCollection) {
        self.maximumHeight = maximumHeight
        self.containerTraitCollection = containerTraitCollection
    }

    /// Maximum height of the content.
    @objc public let maximumHeight: CGFloat

    /// Trait collection of the content container.
    @objc public let containerTraitCollection: UITraitCollection
}
