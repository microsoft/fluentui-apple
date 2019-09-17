//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSPersona

@objc public protocol MSPersona: MSAvatar {
    var avatarImage: UIImage? { get }
    var email: String { get }
    var name: String { get }
    var subtitle: String { get }
}

// MARK: - MSPersonaData

open class MSPersonaData: NSObject, MSPersona {
    public var avatarImage: UIImage?
    public var email: String
    public var name: String
    public var subtitle: String

    public var primaryText: String { return name }
    public var secondaryText: String { return email }
    public var image: UIImage? { return avatarImage }

    @objc public init(name: String = "", email: String = "", subtitle: String = "", avatarImage: UIImage? = nil) {
        self.name = name
        self.email = email
        self.subtitle = subtitle
        self.avatarImage = avatarImage
    }
}
