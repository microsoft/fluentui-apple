//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

/// An object representing a command.
///
/// `CommandingItem` defines the high level properties and behavior of a command. Its visual representation is determined by
/// the `BottomCommandingController`.
@objc(MSFCommandingItem)
open class CommandingItem: NSObject {

    /// A closure that's called when the command is triggered
    @objc open var action: ((CommandingItem) -> Void)?

    /// The title of the command item.
    @objc open var title: String? {
        didSet {
            if title != oldValue {
                delegate?.commandingItem(self, didChangeTitleTo: title)
            }
        }
    }

    /// A `UIImage` to be displayed with the command.
    @objc open var image: UIImage? {
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

    /// A `UIView` to be displayed on the trailing end.
    @objc open var trailingView: UIView? {
        didSet {
            if trailingView != oldValue {
                delegate?.commandingItem(self, didChangeTrailingViewTo: trailingView)
            }
        }
    }

    /// Indicates whether the command is currently on.
    ///
    /// When `isToggleable` is `true`, this property is toggled automatically before `action` is called.
    @objc open var isOn: Bool = false {
        didSet {
            if isOn != oldValue {
                delegate?.commandingItem(self, didChangeOnTo: isOn)
            }
        }
    }

    /// Indicates whether the command is enabled.
    @objc open var isEnabled: Bool = true {
        didSet {
            if isEnabled != oldValue {
                delegate?.commandingItem(self, didChangeEnabledTo: isEnabled)
            }
        }
    }

    /// Indicates whether the command is hidden.
    @objc open var isHidden: Bool = false {
        didSet {
            if isHidden != oldValue {
                delegate?.commandingItem(self, didChangeHiddenTo: isHidden)
            }
        }
    }

    /// The accessibility identifier of the command item.
    @objc open var accessibilityIdentifier: String?

    /// Applications can use this to keep track of items.
    @objc public var tag: Int = 0

    /// Indicates whether `isOn` should be toggled automatically before `action` is called.
    @objc public let isToggleable: Bool

    @objc public init(title: String, image: UIImage, action: @escaping (CommandingItem) -> Void, isToggleable: Bool = false) {
        self.title = title
        self.image = image
        self.action = action
        self.isToggleable = isToggleable
    }

    @objc public init(isToggleable: Bool = false) {
        self.isToggleable = isToggleable
    }

    weak var delegate: CommandingItemDelegate?
}

protocol CommandingItemDelegate: AnyObject {
    /// Called after the `title` property changed.
    func commandingItem(_ item: CommandingItem, didChangeTitleTo value: String?)

    /// Called after the `image` property changed.
    func commandingItem(_ item: CommandingItem, didChangeImageTo value: UIImage?)

    /// Called after the `largeImage` property changed.
    func commandingItem(_ item: CommandingItem, didChangeLargeImageTo value: UIImage?)

    /// Called after the `selectedImage` property changed.
    func commandingItem(_ item: CommandingItem, didChangeSelectedImageTo value: UIImage?)

    /// Called after the `trailingView` property changed.
    func commandingItem(_ item: CommandingItem, didChangeTrailingViewTo value: UIView?)

    /// Called after the `isOn` property changed.
    func commandingItem(_ item: CommandingItem, didChangeOnTo value: Bool)

    /// Called after the `isEnabled` property changed.
    func commandingItem(_ item: CommandingItem, didChangeEnabledTo value: Bool)

    /// Called after the `isHidden` property changed.
    func commandingItem(_ item: CommandingItem, didChangeHiddenTo value: Bool)
}
