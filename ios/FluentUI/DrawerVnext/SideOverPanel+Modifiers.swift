//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension SlideOverPanel {
    /// Modifier to update cummulative width of the panel. 
    /// - Parameter `width`:  defaults to screen size
    /// - Returns: `SlideOverPanel`
    func width(_ width: CGFloat) -> SlideOverPanel {
        return SlideOverPanel(slideOutPanelWidth: width,
                              actionOnBackgroundTap: actionOnBackgroundTap,
                              content: content,
                              backgroundLayerOpacity: backgroundLayerOpacity,
                              direction: direction,
                              isOpen: $isOpen,
                              preferredContentOffset: $preferredContentOffset,
                              tokens: tokens)
    }

    /// Update or replace content on panel
    /// - Parameter `drawerContent`: View to replace content
    /// - Returns: `SlideOverPanel`
    func withContent(_ drawerContent: Content) -> SlideOverPanel {
        return SlideOverPanel(slideOutPanelWidth: slideOutPanelWidth,
                              actionOnBackgroundTap: actionOnBackgroundTap,
                              content: drawerContent,
                              backgroundLayerOpacity: backgroundLayerOpacity,
                              direction: direction,
                              isOpen: $isOpen,
                              preferredContentOffset: $preferredContentOffset,
                              tokens: tokens)
    }

    /// Add action or callback to be executed when background view is Tapped
    /// - Parameter `performOnBackgroundTap`:  defaults to no-op
    /// - Returns: `SlideOverPanel`
    func performOnBackgroundTap(_ performOnBackgroundTap: (() -> Void)?) -> SlideOverPanel {
        return SlideOverPanel(slideOutPanelWidth: slideOutPanelWidth,
                              actionOnBackgroundTap: performOnBackgroundTap,
                              content: content,
                              backgroundLayerOpacity: backgroundLayerOpacity,
                              direction: direction,
                              isOpen: $isOpen,
                              preferredContentOffset: $preferredContentOffset,
                              tokens: tokens)
    }

    /// Add opacity to background view
    /// - Parameter `opacity`: defaults to clear with no opacity
    /// - Returns: `SlideOverPanel`
    func backgroundOpactiy(_ opacity: Double) -> SlideOverPanel {
        return SlideOverPanel(slideOutPanelWidth: slideOutPanelWidth,
                              actionOnBackgroundTap: actionOnBackgroundTap,
                              content: content,
                              backgroundLayerOpacity: opacity,
                              direction: direction,
                              isOpen: $isOpen,
                              preferredContentOffset: $preferredContentOffset,
                              tokens: tokens)
    }

    /// Change opening direction for slideout
    /// - Parameter `direction`: defaults to left
    /// - Returns: `SlideOverPanel`
    func direction(_ slideOutDirection: SlideOverDirection) -> SlideOverPanel {
        return SlideOverPanel(slideOutPanelWidth: slideOutPanelWidth,
                              actionOnBackgroundTap: actionOnBackgroundTap,
                              content: content,
                              backgroundLayerOpacity: backgroundLayerOpacity,
                              direction: slideOutDirection,
                              isOpen: $isOpen,
                              preferredContentOffset: $preferredContentOffset,
                              tokens: tokens)
    }
}
