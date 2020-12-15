//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public typealias CommandBarItemGroup = [CommandBarItem]

open class CommandBarItem: NSObject {
    public var iconImage: UIImage?
    public var isEnabled: Bool
    public var isSelected: Bool {
        didSet {
            if isSelected, !isPersistSelection {
                isSelected = false
            }
        }
    }
    public var isPersistSelection: Bool

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
}
