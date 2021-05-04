//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// An object representing a command.
///
/// `CommandingItem` defines the high level properties and behavior of a command. Its visual representation is determined by
/// the `BottomCommandingController`.
@objc(MSFCommandingItem)
open class CommandingItem: NSObject {

    /// A closure that's called when the command is triggered
    @objc public var action: (CommandingItem) -> Void

    /// The title of the command item.
    @objc public var title: String {
        didSet {
            if title != oldValue {
                delegate?.commandingItem(self, didChangeTitleFrom: oldValue)
            }
        }
    }

    /// A `UIImage` to be displayed with the command.
    @objc public var image: UIImage {
        didSet {
            if image != oldValue {
                delegate?.commandingItem(self, didChangeImageFrom: oldValue)
            }
        }
    }

    /// A `UIImage` used when the command is represented as a button in selected state.
    @objc public var selectedImage: UIImage? {
        didSet {
            if selectedImage != oldValue {
                delegate?.commandingItem(self, didChangeSelectedImageFrom: oldValue)
            }
        }
    }

    /// Indicates whether the command is currently on.
    ///
    /// When `commandType` is set to `.toggle`, the item toggles this automatically before calling `action`.
    @objc public var isOn: Bool {
        didSet {
            if isOn != oldValue {
                delegate?.commandingItem(self, didChangeOnFrom: oldValue)
            }
        }
    }

    /// Indicates whether the command is enabled.
    @objc public var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                delegate?.commandingItem(self, didChangeEnabledFrom: oldValue)
            }
        }
    }

    /// Determines the behavior of this command when its triggered.
    @objc public var commandType: CommandType {
        didSet {
            if commandType != oldValue {
                delegate?.commandingItem(self, didChangeCommandTypeFrom: oldValue)
            }
        }
    }

    @objc public init(title: String, image: UIImage, action: @escaping (CommandingItem) -> Void, selectedImage: UIImage? = nil, isSelected: Bool = false, isEnabled: Bool = true, commandType: CommandType = .simple) {
        self.title = title
        self.action = action
        self.image = image
        self.selectedImage = selectedImage
        self.isOn = isSelected
        self.isEnabled = isEnabled
        self.commandType = commandType
    }

    @objc public enum CommandType: Int {
        /// Calls `action` on tap without modifying the item.
        case simple

        /// Toggles `isOn` on tap before calling `action`.
        case toggle
    }

    weak var delegate: CommandingItemDelegate?
}

protocol CommandingItemDelegate: class {
    func commandingItem(_ item: CommandingItem, didChangeTitleFrom oldValue: String)
    func commandingItem(_ item: CommandingItem, didChangeImageFrom oldValue: UIImage)
    func commandingItem(_ item: CommandingItem, didChangeSelectedImageFrom oldValue: UIImage?)
    func commandingItem(_ item: CommandingItem, didChangeCommandTypeFrom oldValue: CommandingItem.CommandType)
    func commandingItem(_ item: CommandingItem, didChangeOnFrom oldValue: Bool)
    func commandingItem(_ item: CommandingItem, didChangeEnabledFrom oldValue: Bool)
}
