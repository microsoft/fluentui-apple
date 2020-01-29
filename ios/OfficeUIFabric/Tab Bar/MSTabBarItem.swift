//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objcMembers
open class MSTabBarItem: NSObject {
    public let title: String
    let image: UIImage
    let selectedImage: UIImage?
    let landscapeImage: UIImage?
    let landscapeSelectedImage: UIImage?
    let largeContentImage: UIImage?

    /// Initializes `MSTabBarItem
    /// - Parameter title: Used for tabbar item view's label and for its accessibilityLabel.
    /// - Parameter image: Used for tabbar item view's imageView and for its accessibility largeContentImage unless `largeContentImage` is specified.
    /// - Parameter selectedImage: Used for imageView when tabbar item view is selected.  If it is nil, it will use `image`.
    /// - Parameter landscapeImage: Used for imageView when tabbar item view in landscape. If it is nil, it will use `image`.
    /// - Parameter landscapeSelectedImage: Used for imageView when tabbar item view is selected in landscape. If it is nil, it will use `selectedImage`.
    /// - Parameter largeContentImage: Used for tabbar item view's accessibility largeContentImage.
    public init(title: String, image: UIImage, selectedImage: UIImage? = nil, landscapeImage: UIImage? = nil, landscapeSelectedImage: UIImage? = nil, largeContentImage: UIImage? = nil) {
        self.image = image
        self.selectedImage = selectedImage
        self.title = title
        self.largeContentImage = largeContentImage
        self.landscapeImage = landscapeImage
        self.landscapeSelectedImage = landscapeSelectedImage
        super.init()
    }

    func selectedImage(isInPortraitMode: Bool) -> UIImage? {
        if isInPortraitMode {
            return selectedImage ?? image
        } else {
            return landscapeSelectedImage ?? selectedImage ?? image
        }
    }

    func unselectedImage(isInPortraitMode: Bool) -> UIImage? {
        if isInPortraitMode {
            return image
        } else {
            return landscapeImage ?? image
        }
    }
}
