//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public typealias CommandBarItemGroup = [CommandBarItem]

@objc(MSFCommandBarItem)
open class CommandBarItem: NSObject {
    @objc public init(
        iconImage: UIImage?,
        isEnabled: Bool = true,
        isSelected: Bool = false,
        isPersistSelection: Bool = true,
        accessbilityLabel: String? = nil
    ) {
        self.iconImage = iconImage
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.isPersistSelection = isPersistSelection

        super.init()

        self.accessibilityLabel = accessbilityLabel
    }

    @available(iOS 14.0, *)
    @objc public init(
        iconImage: UIImage?,
        isEnabled: Bool = true,
        isSelected: Bool = false,
        isPersistSelection: Bool = true,
        menu: UIMenu,
        showsMenuAsPrimaryAction: Bool = false,
        accessbilityLabel: String? = nil
    ) {
        self.iconImage = iconImage
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.isPersistSelection = isPersistSelection

        super.init()

        self.menu = menu
        self.showsMenuAsPrimaryAction = showsMenuAsPrimaryAction
        self.accessibilityLabel = accessbilityLabel
    }

    @objc public var iconImage: UIImage?
    @objc public var isEnabled: Bool

    /// If `isPersistSelection` is `true`, this value would be changed to reflect the selection state of the button. Setting this value before providing to `CommandBar` would set the initial selection state.
    @objc public var isSelected: Bool {
        didSet {
            if isSelected, !isPersistSelection {
                isSelected = false
            }
        }
    }

    /// Whether the selection state is persisted. If this is set to `false`, the button would be deselected immediately after selection.
    @objc public var isPersistSelection: Bool

    @available(iOS 14.0, *)
    @objc public lazy var menu: UIMenu? = nil // Only lazy property can be used with @available

    @available(iOS 14.0, *)
    @objc public lazy var showsMenuAsPrimaryAction: Bool = false
}
