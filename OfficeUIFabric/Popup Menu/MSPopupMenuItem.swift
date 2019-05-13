//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/**
 `MSPopupMenuItem` represents a menu item inside `MSPopupMenuController`.
 */
@objcMembers
open class MSPopupMenuItem: NSObject {
    /// Defines the timing for the call of the onSelected closure/block
    public enum ExecutionMode: Int {
        case onSelection
        case afterPopupMenuDismissal
    }

    public let image: UIImage?
    public let selectedImage: UIImage?
    public let title: String
    public let subtitle: String?

    public let executionMode: ExecutionMode

    public var isEnabled: Bool = true
    public var isSelected: Bool = false

    public let onSelected: (() -> Void)?

    public init(image: UIImage? = nil, selectedImage: UIImage? = nil, title: String, subtitle: String? = nil, isEnabled: Bool = true, isSelected: Bool = false, executes executionMode: ExecutionMode = .onSelection, onSelected: (() -> Void)? = nil) {
        self.image = image
        self.selectedImage = selectedImage ?? image
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
        let selectedImage = generateSelectedImage ? image?.image(withPrimaryColor: MSColors.PopupMenu.Item.imageSelected) : nil
        self.init(image: image, selectedImage: selectedImage, title: title, subtitle: subtitle, isEnabled: isEnabled, isSelected: isSelected, executes: executionMode, onSelected: onSelected)
    }
}
