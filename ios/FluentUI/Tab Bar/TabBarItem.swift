//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "TabBarItem")
public typealias MSTabBarItem = TabBarItem

@objc(MSFTabBarItem)
open class TabBarItem: NSObject {
    @objc public let title: String
    let image: UIImage
    let selectedImage: UIImage?
    let landscapeImage: UIImage?
    let landscapeSelectedImage: UIImage?
    let largeContentImage: UIImage?
    let accessibilityLabelBadgeFormatString: String?

    /// Initializes `TabBarItem
    /// - Parameter title: Used for tabbar item view's label and for its accessibilityLabel.
    /// - Parameter image: Used for tabbar item view's imageView and for its accessibility largeContentImage unless `largeContentImage` is specified.
    /// - Parameter selectedImage: Used for imageView when tabbar item view is selected.  If it is nil, it will use `image`.
    /// - Parameter landscapeImage: Used for imageView when tabbar item view in landscape. If it is nil, it will use `image`. The image will be used in portrait mode if the tab bar item shows a label.
    /// - Parameter landscapeSelectedImage: Used for imageView when tabbar item view is selected in landscape. If it is nil, it will use `selectedImage`. The image will be used in portrait mode if the tab bar item shows a label.
    /// - Parameter largeContentImage: Used for tabbar item view's accessibility largeContentImage.
    /// - Parameter accessibilityLabelBadgeFormatString: Format string to use for the tabbar item's accessibility label when the badge number is greater than zero. When the badge number is zero, the accessibility label is set to the item's title. By default, when the badge number is greater than zero, the following format is used to builds the accessibility label: "%@, %ld items" where the item's title and the badge number are used to populate the format specifiers. If a format string is provided through this parameter, it must contain "%@" and "%ld" in the same order and will be populated with the title and badge number.
    @objc public init(title: String,
                      image: UIImage,
                      selectedImage: UIImage? = nil,
                      landscapeImage: UIImage? = nil,
                      landscapeSelectedImage: UIImage? = nil,
                      largeContentImage: UIImage? = nil,
                      accessibilityLabelBadgeFormatString: String? = nil) {
        self.image = image
        self.selectedImage = selectedImage
        self.title = title
        self.largeContentImage = largeContentImage
        self.landscapeImage = landscapeImage
        self.landscapeSelectedImage = landscapeSelectedImage
        self.accessibilityLabelBadgeFormatString = accessibilityLabelBadgeFormatString
        super.init()
    }

    func selectedImage(isInPortraitMode: Bool, labelIsHidden: Bool) -> UIImage? {
        if isInPortraitMode {
            return (labelIsHidden ? selectedImage : landscapeSelectedImage) ?? selectedImage ?? image
        } else {
            return landscapeSelectedImage ?? selectedImage ?? image
        }
    }

    func unselectedImage(isInPortraitMode: Bool, labelIsHidden: Bool) -> UIImage? {
        if isInPortraitMode {
            return (labelIsHidden ? image : landscapeImage) ?? image
        } else {
            return landscapeImage ?? image
        }
    }
}
