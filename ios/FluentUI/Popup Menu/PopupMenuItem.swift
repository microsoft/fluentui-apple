//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `PopupMenuItem` represents a menu item inside `PopupMenuController`.
 */
@objc(MSFPopupMenuItem)
open class PopupMenuItem: NSObject, PopupMenuTemplateItem {

    @objc public var cellClass: PopupMenuItemTemplateCell.Type

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
    @objc public lazy var titleColor: UIColor = UIColor(dynamicColor: tokenSet[.titleColor].dynamicColor)
    /// `subtitle` color
    @objc public lazy var subtitleColor: UIColor = UIColor(dynamicColor: tokenSet[.subtitleColor].dynamicColor)
    /// `image` tint color if it is rendered as template
    @objc public lazy var imageColor: UIColor = UIColor(dynamicColor: tokenSet[.imageColor].dynamicColor)
    /// `title` color when`isSelected` is true. If unset, PopupMenuItemTokenSet.mainBrandColor will be used
    @objc public var titleSelectedColor: UIColor?
    /// `subtitle` color when`isSelected` is true.  If unset,PopupMenuItemTokenSet.mainBrandColor will be used
    @objc public var subtitleSelectedColor: UIColor?
    /// tint color if `selectedImage` is rendered as template and `isSelected` is true.  Is unset, PopupMenuItemTokenSet.mainBrandColor will be used
    @objc public var imageSelectedColor: UIColor?
    /// background color of PopupMenuItem corresponding cell
    @objc public lazy var backgroundColor: UIColor = UIColor(dynamicColor: tokenSet[.cellBackgroundColor].dynamicColor)
    /// checkmark color `isAccessoryCheckmarkVisible` and `isSelected` is true. If unset, PopupMenuItemTokenSet.mainBrandColor will be used
    @objc public var accessoryCheckmarkColor: UIColor?

    @objc public let onSelected: (() -> Void)?

    @objc public let isAccessoryCheckmarkVisible: Bool

    @objc public init(image: UIImage? = nil, selectedImage: UIImage? = nil, accessoryImage: UIImage? = nil, title: String, subtitle: String? = nil, accessoryView: UIView? = nil, isEnabled: Bool = true, isSelected: Bool = false, executes executionMode: ExecutionMode = .onSelection, onSelected: (() -> Void)? = nil, isAccessoryCheckmarkVisible: Bool = true) {
        self.cellClass = PopupMenuItemCell.self
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

    lazy var tokenSet: PopupMenuItemTokenSet = {
        PopupMenuItemTokenSet(customViewSize: { self.image != nil ? .small : .zero })
    }()
}
