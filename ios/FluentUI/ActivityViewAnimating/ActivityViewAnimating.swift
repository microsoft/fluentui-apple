//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// An interface for implementing activity view's animations
protocol ActivityViewAnimating: AnyObject {
    var hidesWhenStopped: Bool { get set }
    var isAnimating: Bool { get }

    func startAnimating()
    func stopAnimating()
}
