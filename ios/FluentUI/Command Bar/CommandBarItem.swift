//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public typealias CommandBarItemGroup = [CommandBarItem]

@objc(MSFCommandBarItem)
open class CommandBarItem: NSObject {
    public typealias ItemTappedHandler = ((UIButton, CommandBarItem) -> Void)

    @objc public init(
        iconImage: UIImage?,
        title: String? = nil,
        titleFont: UIFont? = nil,
        isEnabled: Bool = true,
        isSelected: Bool = false,
        itemTappedHandler: @escaping ItemTappedHandler = defaultItemTappedHandler,
        accessbilityLabel: String? = nil
    ) {
        self.iconImage = iconImage
        self.title = title
        self.titleFont = titleFont
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.itemTappedHandler = itemTappedHandler

        super.init()

        self.accessibilityLabel = accessbilityLabel
    }

    @available(iOS 14.0, *)
    @objc public init(
        iconImage: UIImage?,
        title: String? = nil,
        titleFont: UIFont? = nil,
        isEnabled: Bool = true,
        isSelected: Bool = false,
        itemTappedHandler: @escaping ItemTappedHandler = defaultItemTappedHandler,
        menu: UIMenu,
        showsMenuAsPrimaryAction: Bool = false,
        accessbilityLabel: String? = nil
    ) {
        self.iconImage = iconImage
        self.title = title
        self.titleFont = titleFont
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.itemTappedHandler = itemTappedHandler

        super.init()

        self.menu = menu
        self.showsMenuAsPrimaryAction = showsMenuAsPrimaryAction
        self.accessibilityLabel = accessbilityLabel
    }

    @objc public var iconImage: UIImage?

    /// Title for the item. Only valid when `iconImage` is `nil`.
    @objc public var title: String?

    @objc public var titleFont: UIFont?

    @objc public var isEnabled: Bool

    /// If `isPersistSelection` is `true`, this value would be changed to reflect the selection state of the button. Setting this value before providing to `CommandBar` would set the initial selection state.
    @objc public var isSelected: Bool

    /// Set `isSelected` to desired value in this handler. Default implementation is toggling `isSelected` property.
    @objc public var itemTappedHandler: ItemTappedHandler

    @available(iOS 14.0, *)
    @objc public lazy var menu: UIMenu? = nil // Only lazy property can be used with @available

    @available(iOS 14.0, *)
    @objc public lazy var showsMenuAsPrimaryAction: Bool = false

    public static let defaultItemTappedHandler: ItemTappedHandler = { button, item in
        item.isSelected.toggle()
    }

	func handleTapped(_ sender: CommandBarButton) {
        itemTappedHandler(sender, self)
    }
}
