//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

/**
 `MSPopupMenuItem` represents a menu item inside `MSPopupMenuController`.
 */
@objcMembers
open class MSPopupMenuItem: NSObject {
    public let image: UIImage?
    public let selectedImage: UIImage?
    public let title: String
    public let subtitle: String?

    public var isEnabled: Bool = true
    public var isSelected: Bool = false

    public let onSelected: (() -> Void)?

    public init(image: UIImage? = nil, selectedImage: UIImage? = nil, title: String, subtitle: String? = nil, isEnabled: Bool = true, isSelected: Bool = false, onSelected: (() -> Void)? = nil) {
        self.image = image
        self.selectedImage = selectedImage ?? image
        self.title = title
        self.subtitle = subtitle
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.onSelected = onSelected
        super.init()
    }

    public convenience init(imageName: String, generateSelectedImage: Bool = true, title: String, subtitle: String? = nil, isEnabled: Bool = true, isSelected: Bool = false, onSelected: (() -> Void)? = nil) {
        let image = UIImage.staticImageNamed(imageName, in: nil)
        let selectedImage = generateSelectedImage ? image?.image(withPrimaryColor: MSColors.PopupMenu.Item.imageSelected) : nil
        self.init(image: image, selectedImage: selectedImage, title: title, subtitle: subtitle, isEnabled: isEnabled, isSelected: isSelected, onSelected: onSelected)
    }
}
