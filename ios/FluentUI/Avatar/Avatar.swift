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

    /// The color that represents this avatar.
    /// This color will override the initials view's background color.
    /// If the avatar view is configured to display a border, this will be the border's color.
    /// The colored border will not be displayed if a custom border image is provided.
    var color: UIColor? { get }

    /// An image that can be used as a frame (outer wide border) for the avatar view
    var customBorderImage: UIImage? { get }

    /// The presence state
    var presence: Presence { get }

    /// Whether to show a border
    var showsBorder: Bool { get }
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

    @objc public var color: UIColor?

    @objc public var presence: Presence

    @objc public var showsBorder: Bool

    @objc public init(primaryText: String = "", secondaryText: String = "", image: UIImage? = nil, presence: Presence = .none, color: UIColor? = nil, showsBorder: Bool = false) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.presence = presence
        self.color = color
        self.showsBorder = showsBorder
    }

    @objc public convenience init(primaryText: String = "", secondaryText: String = "", image: UIImage? = nil, presence: Presence = .none, color: UIColor? = nil) {
        self.init(primaryText: primaryText, secondaryText: secondaryText, image: image, presence: presence, color: color, showsBorder: false)
    }
}
