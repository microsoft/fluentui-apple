//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - Animation Completion

/// Tracks animation
struct AnimationCompletionModifier: AnimatableModifier {

    var animatableData: Double {
        didSet {
            animationDidComplete()
        }
    }

    private var valueOnCompletion: Double

    private var completion: () -> Void

    init(value: Double, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = value
        valueOnCompletion = value
    }

    private func animationDidComplete() {
        guard animatableData == valueOnCompletion else {
            return
        }

        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// do not modify content here, this is only for observing values during animation
        return content
    }
}

extension View {

    // callback when animation is completed
    func animationCompletion(value: Double, completion: (() -> Void)?) -> ModifiedContent<Self, AnimationCompletionModifier> {
        return modifier(AnimationCompletionModifier(value: value, completion: completion ?? {}))
    }
}
