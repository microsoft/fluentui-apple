//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: - Optional Array Concatenation
/// Adds two optional arrays together without the need to unwrap
///
/// - Parameters:
///   - lhs: an optional Array where Element: T
///   - rhs: an optional Array where Element: T
/// - Returns: an optional Array where Element: T
func + <T>(lhs: [T]?, rhs: [T]?) -> [T]? {
    switch (lhs, rhs) {
    case (nil, nil):
        return nil
    case (nil, _):
        return rhs
    case (_, nil):
        return lhs
    default:
        return lhs! + rhs!
    }
}
