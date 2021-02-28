//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension MSFSlideOutPanel {
    /// Modifier to update cummulative size of the panel.
    /// - Parameter `size`:  defaults to screen size
    /// - Returns: `MSFSlideOverPanel`
    func size(_ size: CGSize) -> MSFSlideOutPanel {
        return MSFSlideOutPanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 content: content,
                                 transitionState: $transitionState,
                                 panelSize: size,
                                 actionOnBackgroundTap: actionOnBackgroundTap,
                                 backgroundDimmed: backgroundDimmed,
                                 direction: direction,
                                 transitionCompletion: transitionCompletion)
    }

    /// Add action or callback to be executed when background view is Tapped
    /// - Parameter `performOnBackgroundTap`:  defaults to no-op
    /// - Returns: `MSFSlideOverPanel`
    func performOnBackgroundTap(_ performOnBackgroundTap: (() -> Void)?) -> MSFSlideOutPanel {
        return MSFSlideOutPanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            panelSize: panelSize,
                            actionOnBackgroundTap: performOnBackgroundTap,
                            backgroundDimmed: backgroundDimmed,
                            direction: direction,
                            transitionCompletion: transitionCompletion)
    }

    /// Add opacity to background view
    /// - Parameter `opacity`: defaults to clear with no opacity
    /// - Returns: `MSFSlideOverPanel`
    func isBackgroundDimmed(_ value: Bool) -> MSFSlideOutPanel {
        return MSFSlideOutPanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            panelSize: panelSize,
                            actionOnBackgroundTap: actionOnBackgroundTap,
                            backgroundDimmed: value,
                            direction: direction,
                            transitionCompletion: transitionCompletion)
    }

    /// Change opening direction for slideout
    /// - Parameter `direction`: defaults to left
    /// - Returns: `MSFSlideOverPanel`
    func direction(_ slideOutDirection: MSFDrawerDirection) -> MSFSlideOutPanel {
        return MSFSlideOutPanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            panelSize: panelSize,
                            actionOnBackgroundTap: actionOnBackgroundTap,
                            backgroundDimmed: backgroundDimmed,
                            direction: slideOutDirection,
                            transitionCompletion: transitionCompletion)
    }

    /// Add action or callback to be executed transition is completed
    /// - Parameter `animationCompletion`:  defaults to no-op
    /// - Returns: `MSFSlideOverPanel`
    func transitionCompletion(_ action: (() -> Void)?) -> MSFSlideOutPanel {
        return MSFSlideOutPanel(percentTransition: $percentTransition,
                            tokens: tokens,
                            content: content,
                            transitionState: $transitionState,
                            panelSize: panelSize,
                            actionOnBackgroundTap: actionOnBackgroundTap,
                            backgroundDimmed: backgroundDimmed,
                            direction: direction,
                            transitionCompletion: action)
    }
}
