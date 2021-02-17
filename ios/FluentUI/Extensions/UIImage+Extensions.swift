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
        return self.withTintColor(primaryColor, renderingMode: .alwaysOriginal)
    }
}
