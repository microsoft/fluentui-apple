//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

@objc public extension UINavigationBar {
    @objc func hideBottomBorder() {
        shadowImage = UIImage()
    }
}
