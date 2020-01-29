//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UINavigationBar {
    private struct Constants {
        static let compactHeight: CGFloat = 32
        static let normalHeight: CGFloat = 44
    }

    var systemHeight: CGFloat {
        if traitCollection.verticalSizeClass == .compact && traitCollection.horizontalSizeClass == .compact {
            return Constants.compactHeight
        } else {
            return Constants.normalHeight
        }
    }

    func hideBottomBorder() {
        shadowImage = UIImage()
    }
}
