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

    @objc public var title: String {
        didSet {
            if title != oldValue {
                delegate?.commandingItem(self, didChangeTitleFrom: oldValue)
            }
        }
    }

    @objc public var image: UIImage {
        didSet {
            if image != oldValue {
                delegate?.commandingItem(self, didChangeImageFrom: oldValue)
            }
        }
    }

    @objc public var selectedImage: UIImage? {
        didSet {
            if selectedImage != oldValue {
                delegate?.commandingItem(self, didChangeSelectedImageFrom: oldValue)
            }
        }
    }

    @objc public var isOn: Bool {
        didSet {
            if isOn != oldValue {
                delegate?.commandingItem(self, didChangeOnFrom: oldValue)
            }
        }
    }

    @objc public var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                delegate?.commandingItem(self, didChangeEnabledFrom: oldValue)
            }
        }
    }

    @objc public var commandType: CommandType {
        didSet {
            if commandType != oldValue {
                delegate?.commandingItem(self, didChangeCommandTypeFrom: oldValue)
            }
        }
    }

    weak var delegate: CommandingItemDelegate?

    @objc public init(title: String, image: UIImage, action: @escaping (CommandingItem) -> Void, selectedImage: UIImage? = nil, isSelected: Bool = false, isEnabled: Bool = true, commandType: CommandType = .simple) {
        self.title = title
        self.action = action
        self.image = image
        self.selectedImage = selectedImage
        self.isOn = isSelected
        self.isEnabled = isEnabled
        self.commandType = commandType
        super.init()
    }
}

protocol CommandingItemDelegate: class {
    func commandingItem(_ item: CommandingItem, didChangeTitleFrom oldValue: String)
    func commandingItem(_ item: CommandingItem, didChangeImageFrom oldValue: UIImage)
    func commandingItem(_ item: CommandingItem, didChangeSelectedImageFrom oldValue: UIImage?)
    func commandingItem(_ item: CommandingItem, didChangeCommandTypeFrom oldValue: CommandingItem.CommandType)
    func commandingItem(_ item: CommandingItem, didChangeOnFrom oldValue: Bool)
    func commandingItem(_ item: CommandingItem, didChangeEnabledFrom oldValue: Bool)
}
