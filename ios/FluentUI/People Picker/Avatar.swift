//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - Avatar Presence

@objc(MSFAvatarPresence)
public enum AvatarPresence: Int, CaseIterable {
    case none
    case available
    case away
    case busy
    case doNotDisturb
    case outOfOffice
    case offline
    case unknown
    case blocked
}

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

    /// The avatar's presence status
    var presence: AvatarPresence { get }
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

    /// The avatar's presence status
    @objc public var presence: AvatarPresence

    @objc public init(primaryText: String = "", secondaryText: String = "", image: UIImage? = nil, presence: AvatarPresence = .none) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.presence = presence
    }
}
