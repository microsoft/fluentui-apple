//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Defines the timing for the call of the onSelected closure/block
@objc(MSFPopupMenuItemExecutionMode)
public enum ExecutionMode: Int {
    /// `onSelected` is called right after item is tapped, before popup menu dismissal
    case onSelection
    /// `onSelected` is called right after item is tapped, but prevent popup menu dismissal
    case onSelectionWithoutDismissal
    /// `onSelected` is called after popup menu is dismissed, but before its `onDismissCompleted` is called
    case afterPopupMenuDismissal
    /// `onSelected` is called after popup menu is dismissed and its `onDismissCompleted` is called
    case afterPopupMenuDismissalCompleted
}

/**
`PopupMenuTemplateItem` represents a template item protocol inside `PopupMenuController`.
 The built-in type is `PopupMenuItem`.
 You can use object conforms to this protocol for customization.
*/
@objc(MSFPopupMenuTemplateItem)
public protocol PopupMenuTemplateItem: AnyObject {
    /// The custom cell class for `PopupMenuController`
    @objc var cellClass: PopupMenuItemTemplateCell.Type { get set}
    @objc var executionMode: ExecutionMode { get }
    @objc var isSelected: Bool { get set }
    @objc var onSelected: (() -> Void)? { get }
}

/**
`PopupMenuItemTemplateCell` represents a template cell protocol inside `PopupMenuController`.
 The built-in type is `PopupMenuItemCell`.
 If you are making a custom object conform to this protocol, it must be a `UITableViewCell` for the Pop Up Menu to work properly
*/
@objc(MSFPopupMenuItemTemplateCell)
public protocol PopupMenuItemTemplateCell {
    /// `PopupMenuController` will notify that one or more items in the list contain image(s)
    @objc var preservesSpaceForImage: Bool { get set }
    /// `PopupMenuController` will notify the custom separatorColor.
    /// For custom cell, you should add your own separator.
    @objc var customSeparatorColor: UIColor? { get set }
    /// `PopupMenuController` will notify the expected bottom separatorType.
    /// For `PopupMenuItemCell`, the separator is at the bottom.
    @objc var bottomSeparatorType: TableViewCell.SeparatorType { get set }

    /// Called when `PopupMenuController` setup the cell with the item
    @objc func setup(item: PopupMenuTemplateItem)

    @objc static func preferredWidth(for item: PopupMenuTemplateItem, preservingSpaceForImage preserveSpaceForImage: Bool) -> CGFloat
    @objc static func preferredHeight(for item: PopupMenuTemplateItem) -> CGFloat
}
