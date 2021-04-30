//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFCommandingItem)
open class CommandingItem: NSObject {
    @objc public enum CommandType: Int {
        case simple // Calls action on tap without modifying the item
        case toggle // Toggles isOn on tap before calling action
    }

    @objc public var action: (CommandingItem) -> Void

    @objc public let image: UIImage

    @objc public let selectedImage: UIImage?

    @objc public let title: String

    @objc public let subtitle: String?

    @objc public var isOn: Bool {
        didSet {
            if isOn != oldValue {
                handlePropertyChange?(self, .isOn)
            }
        }
    }

    @objc public var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                handlePropertyChange?(self, .isEnabled)
            }
        }
    }

    @objc public let commandType: CommandType

    @objc public init(title: String, image: UIImage, action: @escaping (CommandingItem) -> Void, selectedImage: UIImage? = nil, subtitle: String? = nil, isSelected: Bool = false, isEnabled: Bool = true, commandType: CommandType = .simple) {
        self.title = title
        self.action = action
        self.image = image
        self.selectedImage = selectedImage
        self.subtitle = subtitle
        self.isOn = isSelected
        self.isEnabled = isEnabled
        self.commandType = commandType
        super.init()
    }

    var handlePropertyChange: ((_ item: CommandingItem, _ property: MutableProperty) -> Void)?

    enum MutableProperty {
        case isOn
        case isEnabled
    }
}
