//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `MSPopupMenuItem` represents a menu item inside `MSPopupMenuController`.
 */
@objcMembers
open class MSPopupMenuItem: NSObject {
    /// Defines the timing for the call of the onSelected closure/block
    @objc(MSPopupMenuItemExecutionMode)
    public enum ExecutionMode: Int {
        /// `onSelected` is called right after item is tapped, before popup menu dismissal
        case onSelection
        /// `onSelected` is called after popup menu is dismissed, but before its `onDismissCompleted` is called
        case afterPopupMenuDismissal
        /// `onSelected` is called after popup menu is dismissed and its `onDismissCompleted` is called
        case afterPopupMenuDismissalCompleted
    }

    public let image: UIImage?
    public let selectedImage: UIImage?
    public let accessoryImage: UIImage?
    public let title: String
    public let subtitle: String?

    public let executionMode: ExecutionMode

    public var isEnabled: Bool = true
    public var isSelected: Bool = false

    public let onSelected: (() -> Void)?

    public init(image: UIImage? = nil, selectedImage: UIImage? = nil, accessoryImage: UIImage? = nil, title: String, subtitle: String? = nil, isEnabled: Bool = true, isSelected: Bool = false, executes executionMode: ExecutionMode = .onSelection, onSelected: (() -> Void)? = nil) {
        self.image = image?.renderingMode == .automatic ? image?.withRenderingMode(.alwaysTemplate) : image
        self.selectedImage = selectedImage ?? image?.image(withPrimaryColor: MSColors.PopupMenu.Item.imageSelected)
        self.accessoryImage = accessoryImage
        self.title = title
        self.subtitle = subtitle
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.executionMode = executionMode
        self.onSelected = onSelected
        super.init()
    }

    public convenience init(imageName: String, generateSelectedImage: Bool = true, title: String, subtitle: String? = nil, isEnabled: Bool = true, isSelected: Bool = false, executes executionMode: ExecutionMode = .onSelection, onSelected: (() -> Void)? = nil) {
        let image = UIImage.staticImageNamed(imageName, in: nil)
        let selectedImage = generateSelectedImage ? nil : image
        self.init(image: image, selectedImage: selectedImage, title: title, subtitle: subtitle, isEnabled: isEnabled, isSelected: isSelected, executes: executionMode, onSelected: onSelected)
    }
}
