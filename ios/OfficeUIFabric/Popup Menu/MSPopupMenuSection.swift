//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `MSPopupMenuSection` represents a section of menu items inside `MSPopupMenuController`.
 */
open class MSPopupMenuSection: NSObject {
    @objc public let title: String?
    @objc public var items: [MSPopupMenuItem]

    @objc public init(title: String?, items: [MSPopupMenuItem]) {
        self.title = title
        self.items = items
        super.init()
    }
}
