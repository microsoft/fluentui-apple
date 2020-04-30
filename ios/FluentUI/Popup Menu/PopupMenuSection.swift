//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "PopupMenuSection")
public typealias MSPopupMenuSection = PopupMenuSection

/**
 `PopupMenuSection` represents a section of menu items inside `PopupMenuController`.
 */
@objc(MSFPopupMenuSection)
open class PopupMenuSection: NSObject {
    @objc public let title: String?
    @objc public var items: [PopupMenuItem]

    @objc public init(title: String?, items: [PopupMenuItem]) {
        self.title = title
        self.items = items
        super.init()
    }
}
