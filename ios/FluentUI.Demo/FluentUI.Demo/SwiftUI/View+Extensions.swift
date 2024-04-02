//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension View {
    /// Abstracts away differences in pre-iOS 17 `onChange(of:perform:)` versus post-iOS 17 `onChange(of:_:)`.
    ///
    /// This function will be removed once FluentUI moves to iOS 17 as a minimum target.
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action when the specified value changes.
    func onChange_iOS17<V>(of value: V, _ action: @escaping (V) -> Void) -> some View where V: Equatable {
#if os(visionOS)
        // Known bug when using #available and self.onChange together in visionOS: it'll crash!
        // So for this OS, just use the new .onChange unconditionally.
        return self.onChange(of: value) { _, newValue in
            return action(newValue)
        }
#else
        if #available(iOS 17, *) {
            return self.onChange(of: value) { _, newValue in
                return action(newValue)
            }
        } else {
            return self.onChange(of: value, perform: action)
        }
#endif
    }
}
