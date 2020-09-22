//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UIImage {
    internal class func staticImageNamed(_ name: String) -> UIImage? {
        guard let image = UIImage(named: name, in: FluentUIFramework.resourceBundle, compatibleWith: nil) else {
            preconditionFailure("Missing image asset with name: \(name)")
        }
        return image
    }

    @objc func image(withPrimaryColor primaryColor: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(primaryColor, renderingMode: .alwaysOriginal)
        } else {
            let size = self.size
            let renderer = UIGraphicsImageRenderer(size: size)
            let coloredImage = renderer.image { (context) in
                primaryColor.setFill()
                context.fill(CGRect(origin: .zero, size: size))
                self.draw(at: .zero, blendMode: .destinationIn, alpha: 1.0)
            }
            return coloredImage.withRenderingMode(.alwaysOriginal)
        }
    }
}
