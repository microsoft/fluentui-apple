//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Persona

@available(*, deprecated, renamed: "Persona")
public typealias MSPersona = Persona

@objc(MSFPersona)
public protocol Persona: Avatar {
    var avatarImage: UIImage? { get }
    var email: String { get }
    var name: String { get }
    var subtitle: String { get }
}

extension Persona {
    func isEqual(to persona: Persona) -> Bool {
        // Preferred method is to check name and email
        return name == persona.name && email == persona.email
    }
}

// MARK: - PersonaData

@available(*, deprecated, renamed: "PersonaData")
public typealias MSPersonaData = PersonaData

@objc(MSFPersonaData)
open class PersonaData: NSObject, Persona {
    public var avatarImage: UIImage?
    public var email: String

    /// An image that can be used as a frame (outer wide border) for the avatar view
    @objc public var customBorderImage: UIImage?
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
