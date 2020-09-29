//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// An interface for implementing activity view's animations
@objc(MSFActivityViewAnimating)
public protocol ActivityViewAnimating: AnyObject {
    @objc var hidesWhenStopped: Bool { get set }
    @objc var isAnimating: Bool { get }

    @objc func startAnimating()
    @objc func stopAnimating()
}
