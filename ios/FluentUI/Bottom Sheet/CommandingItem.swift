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
    @objc open var action: (CommandingItem) -> Void

    /// The title of the command item.
    @objc open var title: String {
        didSet {
            if title != oldValue {
                delegate?.commandingItem(self, didChangeTitleTo: title)
            }
        }
    }

    /// A `UIImage` to be displayed with the command.
    @objc open var image: UIImage {
        didSet {
            if image != oldValue {
                delegate?.commandingItem(self, didChangeImageTo: image)
            }
        }
    }

    /// A `UIImage` used when the command is represented as a button in selected state.
    @objc open var selectedImage: UIImage? {
        didSet {
            if selectedImage != oldValue {
                delegate?.commandingItem(self, didChangeSelectedImageTo: selectedImage)
            }
        }
    }

    /// Used in large content viewer if this command is represented using a view that cannot scale with Dynamic Type.
    ///
    /// When this is `nil`, `image` will be used instead.
    @objc open var largeImage: UIImage? {
        didSet {
            if largeImage != oldValue {
                delegate?.commandingItem(self, didChangeLargeImageTo: largeImage)
            }
        }
    }

    /// Indicates whether the command is currently on.
    ///
    /// When `commandType` is set to `.toggle`, the item toggles this automatically before calling `action`.
    @objc open var isOn: Bool {
        didSet {
            if isOn != oldValue {
                delegate?.commandingItem(self, didChangeOnTo: isOn)
            }
        }
    }

    /// Indicates whether the command is enabled.
    @objc open var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                delegate?.commandingItem(self, didChangeEnabledTo: isEnabled)
            }
        }
    }

    /// Determines the behavior of this command when its triggered.
    @objc open var commandType: CommandType {
        didSet {
            if commandType != oldValue {
                delegate?.commandingItem(self, didChangeCommandTypeTo: commandType)
            }
        }
    }

    @objc public init(title: String,
                      image: UIImage,
                      action: @escaping (CommandingItem) -> Void,
                      selectedImage: UIImage? = nil,
                      largeImage: UIImage? = nil,
                      isSelected: Bool = false,
                      isEnabled: Bool = true,
                      commandType: CommandType = .simple) {
        self.title = title
        self.action = action
        self.image = image
        self.selectedImage = selectedImage
        self.largeImage = largeImage
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
    func commandingItem(_ item: CommandingItem, didChangeTitleTo value: String)
    func commandingItem(_ item: CommandingItem, didChangeImageTo value: UIImage)
    func commandingItem(_ item: CommandingItem, didChangeLargeImageTo value: UIImage?)
    func commandingItem(_ item: CommandingItem, didChangeSelectedImageTo value: UIImage?)
    func commandingItem(_ item: CommandingItem, didChangeCommandTypeTo value: CommandingItem.CommandType)
    func commandingItem(_ item: CommandingItem, didChangeOnTo value: Bool)
    func commandingItem(_ item: CommandingItem, didChangeEnabledTo value: Bool)
}
