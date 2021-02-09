//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension MSFBasePanel {
    /// Modifier to update cummulative width of the panel.
    /// - Parameter `width`:  defaults to screen size
    /// - Returns: `MSFSlideOverPanel`
    func width(_ width: CGFloat) -> MSFBasePanel {
        return MSFBasePanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 content: content,
                                 transitionState: $transitionState,
                                 size: CGSize(width: width, height: size.height),
                                 actionOnBackgroundTap: actionOnBackgroundTap,
                                 backgroundDimmed: backgroundDimmed,
                                 direction: direction,
                                 transitionCompletion: transitionCompletion)
    }

    /// Add action or callback to be executed when background view is Tapped
    /// - Parameter `performOnBackgroundTap`:  defaults to no-op
    /// - Returns: `MSFSlideOverPanel`
    func performOnBackgroundTap(_ performOnBackgroundTap: (() -> Void)?) -> MSFBasePanel {
        return MSFBasePanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            size: size,
                            actionOnBackgroundTap: performOnBackgroundTap,
                            backgroundDimmed: backgroundDimmed,
                            direction: direction,
                            transitionCompletion: transitionCompletion)
    }

    /// Add opacity to background view
    /// - Parameter `opacity`: defaults to clear with no opacity
    /// - Returns: `MSFSlideOverPanel`
    func isBackgroundDimmed(_ value: Bool) -> MSFBasePanel {
        return MSFBasePanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            size: size,
                            actionOnBackgroundTap: actionOnBackgroundTap,
                            backgroundDimmed: value,
                            direction: direction,
                            transitionCompletion: transitionCompletion)
    }

    /// Change opening direction for slideout
    /// - Parameter `direction`: defaults to left
    /// - Returns: `MSFSlideOverPanel`
    func direction(_ slideOutDirection: MSFDrawerDirection) -> MSFBasePanel {
        return MSFBasePanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            size: size,
                            actionOnBackgroundTap: actionOnBackgroundTap,
                            backgroundDimmed: backgroundDimmed,
                            direction: slideOutDirection,
                            transitionCompletion: transitionCompletion)
    }

    /// Add action or callback to be executed transition is completed
    /// - Parameter `animationCompletion`:  defaults to no-op
    /// - Returns: `MSFSlideOverPanel`
    func transitionCompletion(_ action: (() -> Void)?) -> MSFBasePanel {
        return MSFBasePanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            size: size,
                            actionOnBackgroundTap: actionOnBackgroundTap,
                            backgroundDimmed: backgroundDimmed,
                            direction: direction,
                            transitionCompletion: action)
    }
}
