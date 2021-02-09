//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - Base Panel

@objc public enum MSFDrawerDirection: Int, CaseIterable {
    /// Drawer originates from left
    case left
    /// Drawer originates from right
    case right
    /// Drawer originates from left
    case bottom
    /// Drawer originates from right
    case top

    /// determines if direction is along x-axis
    func isVertical() -> Bool {
        return self == .left || self == .right
    }
}

/// 'MSFPanelContent' is the functional protocol  for `Drawer` content. It can be configured via any axis as desired
protocol MSFPanelContent {

    /// default content size ratio (percentage of drawer size occupied) when drawer is expanded, valid range [0,1]
    var contentSizeRatio: CGSize { get }

    /// size of the base panel
    var size: CGSize { get set }

    /// Action executed with background transperent view is tapped
    var actionOnBackgroundTap: (() -> Void)? { get  set}

    /// If set to `true` then token with dimmed bacground value is used
    var backgroundDimmed: Bool { get set }

    /// Slide out direction
    var direction: MSFDrawerDirection { get set }
}

// MARK: - SwiftUI Transition

@objc public enum MSFDrawerTransitionState: Int, CaseIterable {
    /// Panel is expanded and content view is available for interaction
    case expanded
    /// Panel is collapsed and background view is available for interaction
    case collapsed
    /// Panel is currently being dragged
    case inTransisiton
}

/// BasePanel is the model layer for `Drawer`. It can be configured via any axis as desired
protocol MSFPanelTransition {

    /// Action executed with transiton state is completed
    var transitionCompletion: (() -> Void)? { get set }

    /// Only effective when panel is in transition, valid range [0,1] else the value is nil
    /// @see `MSFDrawerTransitionState`
    var percentTransition: Double? { get set }

    /// state representating drawer's visibility of content.
    var transitionState: MSFDrawerTransitionState { get set }

    /// offset for panel state, dependent of the `transitionState`
    var contentOffset: CGFloat { get }

    /// background color for `transitionState`
    var backgroundColor: Color { get }
}

// MARK: - Composite View

public struct MSFInteractiveSpacer: View {
    @Binding public var defaultBackgroundColor: Color

    public var body: some View {
        ZStack {
            defaultBackgroundColor
        }.contentShape(Rectangle())
    }
}

struct AnyStack<Content: View>: View {
    var isVertical: Bool = false
    let content: () -> Content

    var body: some View {
        if isVertical {
            VStack {
                content()
            }
        } else {
            HStack {
                content()
            }
        }
    }

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    init(isVertical: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isVertical = isVertical
        self.content = content
    }

    func orientation(_ vertical: Bool) -> AnyStack {
        return AnyStack(isVertical: vertical, content: content)
    }
}

// MARK: - Preview

struct MockContent: View {
    var body: some View {
        ZStack {
            Color.red
            Text("Tap outside to collapse.")
        }
    }
}

struct MockBackgroundView: View {
    var body: some View {
        Group {
            Color.white
            Text("This is background View")
        }
    }
}
