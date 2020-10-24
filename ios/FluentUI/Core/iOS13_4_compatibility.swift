//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - Pointer Interaction APIs check

/// Some beta versions of iOS 13.4 and later don't include the pointer interaction APIs.
/// Checking the UIButton's isPointerInteractionEnabled property is a workaround that prevents a crash due to an
/// exception thrown while trying to add the UIPointerInteraction instance while running on those iOS versions:
/// "uncaught ObjC exception, reason: Invalid parameter not satisfying: interaction"
/// - Returns: true if Pointer Interaction APIs are available, otherwise false
@available(iOS 13.4, *)
func arePointerInteractionAPIsAvailable() -> Bool {
    return UIButton.instancesRespond(to: Selector(("isPointerInteractionEnabled")))
}
