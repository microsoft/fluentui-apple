//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Avatar

@available(*, deprecated, renamed: "Avatar")
public typealias MSAvatar = Avatar

@objc(MSFAvatar)
public protocol Avatar {
    var primaryText: String { get }
    var secondaryText: String { get }
    var image: UIImage? { get }

    /// An image that can be used as a frame (outer wide border) for the avatar view
    var customBorderImage: UIImage? { get }

    /// If the avatar view is configured to display a border, this will be the border's color.
    /// Note that the colored border will not be displayed if a custom border image is provided.
    var borderColor: UIColor? { get }

   /// The presence state
    var presence: Presence { get }
}

// MARK: - AvatarData

@available(*, deprecated, renamed: "AvatarData")
public typealias MSAvatarData = AvatarData

@objc(MSFAvatarData)
open class AvatarData: NSObject, Avatar {
    public var primaryText: String
    public var secondaryText: String
    public var image: UIImage?

    @objc public var customBorderImage: UIImage?

    @objc public var borderColor: UIColor?

    /// The presence state
    @objc public var presence: Presence

    @objc public init(primaryText: String = "", secondaryText: String = "", image: UIImage? = nil, presence: Presence = .none) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.presence = presence
    }
}
