//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFCommandingSection)
open class CommandingSection: NSObject {
    public let title: String?
    public var items: [CommandingItem]

    public init(title: String?, items: [CommandingItem] = []) {
        self.title = title
        self.items = items
    }
}
