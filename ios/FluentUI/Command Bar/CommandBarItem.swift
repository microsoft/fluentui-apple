//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public typealias CommandBarItemGroup = [CommandBarItem]

open class CommandBarItem: NSObject {
    public init(
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

    public var iconImage: UIImage?
    public var isEnabled: Bool

    /// If `isPersistSelection` is `true`, this value would be changed to reflect the selection state of the button. Setting this value before providing to `CommandBar` would set the initial selection state.
    public var isSelected: Bool {
        didSet {
            if isSelected, !isPersistSelection {
                isSelected = false
            }
        }
    }

    /// Whether the selection state is persisted. If this is set to `false`, the button would be deselected immediately after selection.
    public var isPersistSelection: Bool
}
