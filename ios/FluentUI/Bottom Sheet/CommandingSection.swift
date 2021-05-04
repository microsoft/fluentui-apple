//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// A named container of `CommandingItem` objects.
@objc(MSFCommandingSection)
open class CommandingSection: NSObject {

    /// The title of the section.
    public let title: String?

    /// An `Array` of `CommandingItem` objects.
    public var items: [CommandingItem]

    /// Initializes a commanding section.
    public init(title: String?, items: [CommandingItem] = []) {
        self.title = title
        self.items = items
    }
}
