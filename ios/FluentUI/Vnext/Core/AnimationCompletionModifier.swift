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

    init(targetValue: Double, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = targetValue
        valueOnCompletion = targetValue
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
        // do not modify content here, this is only for observing values during animation
        return content
    }
}

extension View {

    /// Allows a closure to be executed upon animation completion.
    func onAnimationComplete(value: Double, completion: (() -> Void)?) -> ModifiedContent<Self, AnimationCompletionModifier> {
        return modifier(AnimationCompletionModifier(targetValue: value, completion: completion ?? {}))
    }
}
