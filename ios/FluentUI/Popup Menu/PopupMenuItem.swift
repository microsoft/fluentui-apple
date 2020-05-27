//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "PopupMenuItem")
public typealias MSPopupMenuItem = PopupMenuItem

/**
 `PopupMenuItem` represents a menu item inside `PopupMenuController`.
 */
@objc(MSFPopupMenuItem)
open class PopupMenuItem: NSObject {
    /// Defines the timing for the call of the onSelected closure/block
    @objc(MSFPopupMenuItemExecutionMode)
    public enum ExecutionMode: Int {
        /// `onSelected` is called right after item is tapped, before popup menu dismissal
        case onSelection
        /// `onSelected` is called after popup menu is dismissed, but before its `onDismissCompleted` is called
        case afterPopupMenuDismissal
        /// `onSelected` is called after popup menu is dismissed and its `onDismissCompleted` is called
        case afterPopupMenuDismissalCompleted
    }

    @objc public let image: UIImage?
    @objc public let selectedImage: UIImage?
    @objc public let accessoryImage: UIImage?
    @objc public let title: String
    @objc public let subtitle: String?
    @objc public let accessoryView: UIView?

    @objc public let executionMode: ExecutionMode

    @objc public var isEnabled: Bool = true
    @objc public var isSelected: Bool = false

    /// `title` color
    @objc public var titleColor: UIColor = Colors.Table.Cell.title
    /// `subtitle` color
    @objc public var subtitleColor: UIColor = Colors.Table.Cell.subtitle
    /// `image` tint color if it is rendered as template
    @objc public var imageColor: UIColor = Colors.Table.Cell.image
    /// `title` color when`isSelected` is true
    @objc public var titleSelectedColor: UIColor = Colors.PopupMenu.Item.titleSelected
    /// `subtitle` color when`isSelected` is true
    @objc public var subtitleSelectedColor: UIColor = Colors.PopupMenu.Item.subtitleSelected
    /// tint color if `selectedImage` is rendered as template and `isSelected` is true
    @objc public var imageSelectedColor: UIColor = Colors.PopupMenu.Item.imageSelected
    /// background color of PopupMenuItem corresponding cell
    @objc public var backgroundColor: UIColor = Colors.Table.Cell.background
    /// checkmark color `isAccessoryCheckmarkVisible` and `isSelected` is true
    @objc public var accessoryCheckmarkColor: UIColor = Colors.Table.Cell.accessoryCheckmark

    @objc public let onSelected: (() -> Void)?

    @objc public let isAccessoryCheckmarkVisible: Bool

    @objc public init(image: UIImage? = nil, selectedImage: UIImage? = nil, accessoryImage: UIImage? = nil, title: String, subtitle: String? = nil, accessoryView: UIView? = nil, isEnabled: Bool = true, isSelected: Bool = false, executes executionMode: ExecutionMode = .onSelection, onSelected: (() -> Void)? = nil, isAccessoryCheckmarkVisible: Bool = true) {
        self.image = image?.renderingMode == .automatic ? image?.withRenderingMode(.alwaysTemplate) : image
        self.selectedImage = selectedImage ?? image?.withRenderingMode(.alwaysTemplate)
        self.accessoryImage = accessoryImage
        self.title = title
        self.subtitle = subtitle
        self.accessoryView = accessoryView
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.executionMode = executionMode
        self.onSelected = onSelected
        self.isAccessoryCheckmarkVisible = isAccessoryCheckmarkVisible
        super.init()
    }

    @objc public convenience init(imageName: String, generateSelectedImage: Bool = true, title: String, subtitle: String? = nil, isEnabled: Bool = true, isSelected: Bool = false, executes executionMode: ExecutionMode = .onSelection, onSelected: (() -> Void)? = nil, isAccessoryCheckmarkVisible: Bool = true) {
        let image = UIImage(named: imageName)
        let selectedImage = generateSelectedImage ? nil : image
        self.init(image: image, selectedImage: selectedImage, title: title, subtitle: subtitle, isEnabled: isEnabled, isSelected: isSelected, executes: executionMode, onSelected: onSelected, isAccessoryCheckmarkVisible: isAccessoryCheckmarkVisible)
    }
}
