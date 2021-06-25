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

    /// Indicates whether the command is currently on.
    ///
    /// When `isToggleable` is `true`, this property is toggled automatically before `action` is called.
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

    /// Applications can use this to keep track of items.
	@objc public var tag: Int

    /// Indicates whether `isOn` should be toggled automatically before `action` is called.
    @objc public let isToggleable: Bool

    @objc public init(title: String? = nil,
                      image: UIImage? = nil,
                      action: ((CommandingItem) -> Void)? = nil,
                      isToggleable: Bool = false,
                      selectedImage: UIImage? = nil,
                      largeImage: UIImage? = nil,
                      isOn: Bool = false,
                      isEnabled: Bool = true,
                      tag: Int = 0) {
        self.title = title
        self.action = action
        self.isToggleable = isToggleable
        self.image = image
        self.selectedImage = selectedImage
        self.largeImage = largeImage
        self.isOn = isOn
        self.isEnabled = isEnabled
        self.tag = tag
    }

    // ObjC-only convenience inits

    @available(*, unavailable)
    @objc public convenience init(title: String?, image: UIImage?, action: ((CommandingItem) -> Void)?) {
        self.init(title: title, image: image, action: action)
    }

    @available(*, unavailable)
    @objc public override convenience init() {
        self.init()
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

    /// Called after the `isOn` property changed.
    func commandingItem(_ item: CommandingItem, didChangeOnTo value: Bool)

    /// Called after the `isEnabled` property changed.
    func commandingItem(_ item: CommandingItem, didChangeEnabledTo value: Bool)
}
