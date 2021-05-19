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
    @objc public var hideInsideGapForBorder: Bool = false

    /// The color associated to this persona.
    @objc public var color: UIColor?

    public var name: String
    public var subtitle: String
    public var composedName: (String, String)?
    public var image: UIImage? { return avatarImage }
    public var presence: Presence

    public var primaryText: String {
        if let composedName = composedName {
            return composedName.0
        }

        return name
    }

    public var secondaryText: String {
        if let composedName = composedName {
            return composedName.1
        }

        return email
    }

    /// Initializer for PersonaData
    /// - Parameter name: The persona's name.
    /// - Parameter email: The persona's email.
    /// - Parameter subtitle: The persona's subtitle.
    /// - Parameter avatarImage: The persona's image.
    /// - Parameter presence: The persona's presence status.
    /// - Parameter color: The persona's color.
    @objc public init(name: String = "",
                      email: String = "",
                      subtitle: String = "",
                      avatarImage: UIImage? = nil,
                      presence: Presence = .none,
                      color: UIColor? = nil) {
        self.name = name
        self.email = email
        self.subtitle = subtitle
        self.avatarImage = avatarImage
        self.presence = presence
        self.color = color
    }

    /// Initializer for PersonaData
    /// - Parameter firstName: The persona's first name.
    /// - Parameter lastName: The persona's last name.
    /// - Parameter email: The persona's email.
    /// - Parameter subtitle: The persona's subtitle.
    /// - Parameter avatarImage: The persona's image.
    /// - Parameter presence: The persona's presence status.
    /// - Parameter color: The persona's color.
    @objc public init(firstName: String = "",
                      lastName: String = "",
                      email: String = "",
                      subtitle: String = "",
                      avatarImage: UIImage? = nil,
                      presence: Presence = .none,
                      color: UIColor? = nil) {
        self.name = firstName
        self.email = email
        self.subtitle = subtitle
        self.composedName = (firstName, lastName)
        self.avatarImage = avatarImage
        self.presence = presence
        self.color = color
    }
}
