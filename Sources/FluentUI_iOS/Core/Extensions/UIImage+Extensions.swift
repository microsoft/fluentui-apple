//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIImage {
    class func staticImageNamed(_ name: String) -> UIImage? {
        guard let image = UIImage(named: name,
                                  in: FluentUIFramework.resourceBundle,
                                  compatibleWith: nil) else {
            preconditionFailure("Missing image asset with name: \(name)")
        }
        return image
    }
}
