//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Modifier that provides a completion closure for an animation on a given animatable value.
struct AnimationCompletionModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    func body(content: Content) -> some View {
        content
    }

    init(animatableValue: Value, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self.animatableData = animatableValue
        targetValue = animatableValue
    }

    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    private var onComplete: () -> Void
    private var targetValue: Value

    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else {
            return
        }

        DispatchQueue.main.async {
            self.onComplete()
        }
    }
}

extension View {

    /// Executes the `onComplete` closure when an animation is completed for a given animatable value.
    /// - Parameters:
    ///   - animatableValue: The animatable value that is bound to the animation.
    ///   - completion: Closure that will be executed once the animation is completed.
    /// - Returns: A modified `View` with the completion mechanism. No changes are made to the layout or rendering of the view.
    func onAnimationComplete<Value: VectorArithmetic>(for animatableValue: Value,
                                                      onComplete: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionModifier<Value>> {
        modifier(AnimationCompletionModifier(animatableValue: animatableValue,
                                             onComplete: onComplete))
    }
}
