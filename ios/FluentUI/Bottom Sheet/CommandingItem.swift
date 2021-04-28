//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFCommandingItem)
open class CommandingItem: NSObject {
    @objc public let image: UIImage
    @objc public let selectedImage: UIImage?
    @objc public let title: String
    @objc public let subtitle: String?
    @objc public var selected: Bool {
        didSet {
            if selected != oldValue {
                delegate?.commandingItem(self, didSetSelectedTo: selected)
            }
        }
    }

    @objc public var enabled: Bool {
        didSet {
            if enabled != oldValue {
                delegate?.commandingItem(self, didSetEnabledTo: enabled)
            }
        }
    }

    @objc public var action: () -> Void

    @objc public init(title: String, image: UIImage, action: @escaping () -> Void, selectedImage: UIImage? = nil, subtitle: String? = nil, selected: Bool = false, enabled: Bool = true) {
        self.title = title
        self.action = action
        self.image = image
        self.selectedImage = selectedImage
        self.subtitle = subtitle
        self.selected = selected
        self.enabled = enabled
        super.init()
    }

    var itemLocation: CommandingItemLocation?
    weak var delegate: CommandingItemDelegate?
}

enum CommandingItemLocation {
    case hero
    case grid
    case list
}

protocol CommandingItemDelegate: class {
    func commandingItem(_ item: CommandingItem, didSetSelectedTo value: Bool)
    func commandingItem(_ item: CommandingItem, didSetEnabledTo value: Bool)
}
