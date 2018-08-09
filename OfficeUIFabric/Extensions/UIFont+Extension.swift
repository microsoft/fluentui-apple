//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        return UIFont(descriptor: fontDescriptor.withWeight(weight), size: pointSize)
    }
}
