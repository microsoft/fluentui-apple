//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSAvatar

@objc public protocol MSAvatar {
    var primaryText: String { get }
    var secondaryText: String { get }
    var image: UIImage? { get }
}

// MARK: - MSAvatarData

open class MSAvatarData: NSObject, MSAvatar {
    public var primaryText: String
    public var secondaryText: String
    public var image: UIImage?

    @objc public init(primaryText: String = "", secondaryText: String = "", image: UIImage? = nil) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
    }
}
