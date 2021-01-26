//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension MSFSlideOverPanel {
    /// Modifier to update cummulative width of the panel.
    /// - Parameter `width`:  defaults to screen size
    /// - Returns: `MSFSlideOverPanel`
    func width(_ width: CGFloat) -> MSFSlideOverPanel {
        return MSFSlideOverPanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 slideOutPanelWidth: width,
                                 actionOnBackgroundTap: actionOnBackgroundTap,
                                 content: content,
                                 backgroundDimmed: backgroundDimmed,
                                 direction: direction,
                                 transitionState: $transitionState)
    }

    /// Add action or callback to be executed when background view is Tapped
    /// - Parameter `performOnBackgroundTap`:  defaults to no-op
    /// - Returns: `MSFSlideOverPanel`
    func performOnBackgroundTap(_ performOnBackgroundTap: (() -> Void)?) -> MSFSlideOverPanel {
        return MSFSlideOverPanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 slideOutPanelWidth: slideOutPanelWidth,
                                 actionOnBackgroundTap: performOnBackgroundTap,
                                 content: content,
                                 backgroundDimmed: backgroundDimmed,
                                 direction: direction,
                                 transitionState: $transitionState)
    }

    /// Add opacity to background view
    /// - Parameter `opacity`: defaults to clear with no opacity
    /// - Returns: `MSFSlideOverPanel`
    func isBackgroundDimmed(_ value: Bool) -> MSFSlideOverPanel {
        return MSFSlideOverPanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 slideOutPanelWidth: slideOutPanelWidth,
                                 actionOnBackgroundTap: actionOnBackgroundTap,
                                 content: content,
                                 backgroundDimmed: value,
                                 direction: direction,
                                 transitionState: $transitionState)
    }

    /// Change opening direction for slideout
    /// - Parameter `direction`: defaults to left
    /// - Returns: `MSFSlideOverPanel`
    func direction(_ slideOutDirection: MSFDrawerSlideOverDirection) -> MSFSlideOverPanel {
        return MSFSlideOverPanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 slideOutPanelWidth: slideOutPanelWidth,
                                 actionOnBackgroundTap: actionOnBackgroundTap,
                                 content: content,
                                 backgroundDimmed: backgroundDimmed,
                                 direction: slideOutDirection,
                                 transitionState: $transitionState)
    }

    /// Add action or callback to be executed transition is completed
    /// - Parameter `animationCompletion`:  defaults to no-op
    /// - Returns: `MSFSlideOverPanel`
    func transitionCompletion(_ action: (() -> Void)?) -> MSFSlideOverPanel {
        return MSFSlideOverPanel(percentTransition: $percentTransition,
                                 tokens: tokens,
                                 slideOutPanelWidth: slideOutPanelWidth,
                                 actionOnBackgroundTap: actionOnBackgroundTap,
                                 transitionCompletion: action,
                                 content: content,
                                 backgroundDimmed: backgroundDimmed,
                                 direction: direction,
                                 transitionState: $transitionState)
    }
}
