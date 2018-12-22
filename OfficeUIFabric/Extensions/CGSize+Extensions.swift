//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

public extension CGSize {
    static var max: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
}
