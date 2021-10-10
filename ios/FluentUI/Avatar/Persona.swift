//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Persona

@objc(MSFPersona)
public protocol Persona {
    /// The image that represents the persona.
    /// Used in the Avatar to replace the initials if provided.
    var image: UIImage? { get }

    /// The color that represents this persona.
    /// This color will override the initials view's background color.
    /// If the avatar view is configured to display a ring, this will be the rings's color.
    /// The colored ring will not be displayed if the imageBasedRingColor property is not set to nil.
    var color: UIColor? { get }

    /// An image that can be used the color for the avatar ring.
    var imageBasedRingColor: UIImage? { get }

    /// The e-mail address of the persona. This value is used to calculate the Avatar initials.
    var email: String { get }

    /// Defines whether the gap between the ring and the avatar content is rendered in case the avatar has a ring.
    var hasRingInnerGap: Bool { get }

    /// The name of the Persona. This value is used to calculate the Avatar initials.
    var name: String { get }

    /// The presence status of the persona.
    var presence: MSFAvatarPresence { get }

    /// Sets whether the persona is out of office. This value will be used to calculate the presence image accordingly.
    var isOutOfOffice: Bool { get set }

    /// Defines whether the ring is displayed around the Avatar.
    var isRingVisible: Bool { get }

    /// The subtitle value for the persona.
    var subtitle: String { get }
}

extension Persona {
    func isEqual(to persona: Persona) -> Bool {
        // Preferred method is to check name and email
        return name == persona.name && email == persona.email
    }
}

// MARK: - PersonaData

@objc(MSFPersonaData)
open class PersonaData: NSObject, Persona, ObservableObject {
    /// The image that represents the persona.
    /// Used in the Avatar to replace the initials if provided.
    @Published @objc public var image: UIImage?

    /// The e-mail address of the persona. This value is used to calculate the Avatar initials.
    @Published @objc public var email: String

    /// An image that can be used the color for the avatar ring.
    @Published @objc public var imageBasedRingColor: UIImage?

    /// Defines whether the gap between the ring and the avatar content is rendered in case the avatar has a ring.
    @Published @objc public var hasRingInnerGap: Bool = true

    /// Defines whether the ring is displayed around the Avatar.
    @Published @objc public var isRingVisible: Bool = false

    /// Sets whether the persona is out of office. This value will be used to calculate the presence image accordingly.
    @Published @objc public var isOutOfOffice: Bool = false

    /// The color that represents this persona.
    /// This color will override the initials view's background color.
    /// If the avatar view is configured to display a ring, this will be the rings's color.
    /// The colored ring will not be displayed if the imageBasedRingColor property is not set to nil.
    @Published @objc public var color: UIColor?

    /// The name of the Persona. This value is used to calculate the Avatar initials.
    @Published @objc public var name: String

    /// The subtitle value for the persona.
    @Published @objc public var subtitle: String

    /// First name and last name combined in a single property.
    @Published public var composedName: (String, String)?

    /// The presence status of the persona.
    @Published @objc public var presence: MSFAvatarPresence

    /// Initializer for PersonaData
    /// - Parameter name: The persona's name.
    /// - Parameter email: The persona's email.
    /// - Parameter subtitle: The persona's subtitle.
    /// - Parameter image: The persona's image.
    /// - Parameter presence: The persona's presence status.
    /// - Parameter color: The persona's color.
    @objc public init(name: String = "",
                      email: String = "",
                      subtitle: String = "",
                      image: UIImage? = nil,
                      presence: MSFAvatarPresence = .none,
                      color: UIColor? = nil) {
        self.name = name
        self.email = email
        self.subtitle = subtitle
        self.image = image
        self.presence = presence
        self.color = color
    }

    /// Initializer for PersonaData
    /// - Parameter name: The persona's name.
    /// - Parameter email: The persona's email.
    /// - Parameter subtitle: The persona's subtitle.
    /// - Parameter image: The persona's image.
    /// - Parameter presence: The persona's presence status.
    /// - Parameter color: The persona's color.
    /// - Parameter isRingVisible: Whether to show a ring.
    @objc public init(name: String = "",
                      email: String = "",
                      subtitle: String = "",
                      image: UIImage? = nil,
                      presence: MSFAvatarPresence = .none,
                      color: UIColor? = nil,
                      isRingVisible: Bool = false) {
        self.name = name
        self.email = email
        self.subtitle = subtitle
        self.image = image
        self.presence = presence
        self.color = color
        self.isRingVisible = isRingVisible
    }

    /// Initializer for PersonaData
    /// - Parameter firstName: The persona's first name.
    /// - Parameter lastName: The persona's last name.
    /// - Parameter email: The persona's email.
    /// - Parameter subtitle: The persona's subtitle.
    /// - Parameter image: The persona's image.
    /// - Parameter presence: The persona's presence status.
    /// - Parameter color: The persona's color.
    @objc public init(firstName: String = "",
                      lastName: String = "",
                      email: String = "",
                      subtitle: String = "",
                      image: UIImage? = nil,
                      presence: MSFAvatarPresence = .none,
                      color: UIColor? = nil) {
        self.name = firstName
        self.email = email
        self.subtitle = subtitle
        self.composedName = (firstName, lastName)
        self.image = image
        self.presence = presence
        self.color = color
    }
}
