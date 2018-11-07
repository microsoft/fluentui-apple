//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

/**
 `MSPopupMenuSection` represents a section of menu items inside `MSPopupMenuController`.
 */
@objcMembers
open class MSPopupMenuSection: NSObject {
    public let title: String?
    public var items: [MSPopupMenuItem]

    public init(title: String?, items: [MSPopupMenuItem]) {
        self.title = title
        self.items = items
        super.init()
    }
}
