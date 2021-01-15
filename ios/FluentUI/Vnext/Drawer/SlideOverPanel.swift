//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

@objc enum MSFDrawerSlideOverDirection: Int, CaseIterable {
    /// Drawer animated right from a left base
    case left
    /// Drawer animated right from a right base
    case right
}

enum SlideOverTransitionState: Int, CaseIterable {
    /// Panel is expanded and content view is available for interaction
    case expanded
    /// Panel is collapsed and background view is available for interaction
    case collapsed
    /// Panel is currently being dragged
    case inTransisiton
}

/// SlidePanel in the drawer's horizontal layer that expands and collapsed on x axis of the drawer.
/// `View` consist of content view placed on top on panel and transparent background layer
struct MSFSlideOverPanel<Content: View>: View {

    /// Only effective when panel is in transition, valid range [0,1]
    /// @see `SlideOverTransitionState`
    @Binding public var percentTransition: Double?

    /// Configure the apperance of drawer
    @ObservedObject public var tokens = MSFDrawerTokens()

    /// Width occupied by content and spacer combined
    internal var slideOutPanelWidth: CGFloat = UIScreen.main.bounds.width

    /// Action executed with background transperent view is tapped
    internal var actionOnBackgroundTap: (() -> Void)?

    /// Content view is visible when slide over panel is expanded
    internal var content: Content

    /// If set to `true` then token with dimmed bacground value is used
    internal var backgroundDimmed: Bool = false

    /// Slide out direction
    internal var direction: MSFDrawerSlideOverDirection = .left

    /// Interactive state of panel
    @Binding internal var transitionState: SlideOverTransitionState

    var body: some View {
        HStack {
            if direction == .right {
                MSFInteractiveSpacer(defaultBackgroundColor: $tokens.backgroundClearColor)
                    .onTapGesture (perform: actionOnBackgroundTap ?? {})
            }

            content
                .frame(width: contentWidth)
                .shadow(color: resolvedShadowColor,
                        radius: tokens.shadowBlur,
                        x: tokens.shadowDepthX,
                        y: tokens.shadowDepthY)
                .offset(x: resolvedContentOffset)

            if direction == .left {
                MSFInteractiveSpacer(defaultBackgroundColor: $tokens.backgroundClearColor)
                    .onTapGesture (perform: actionOnBackgroundTap ?? {})
            }
        }
        .background(resolvedBackgroundColor)
    }

    private let contentWidthSizeRatio: CGFloat = 0.9

    /// Read-only property for contentWidth to resize content size use `contentWidthSizeRatio` instead
    private var contentWidth: CGFloat {
        return slideOutPanelWidth * contentWidthSizeRatio
    }

    private var resolvedContentOffset: CGFloat {

        var offset: CGFloat
        switch transitionState {
        case .collapsed:
            offset = collapsedContentOffset
        case .expanded:
            offset = expandedContentOffset
        case .inTransisiton:
            offset = percentTransistionOffset
        }

        if direction == .left {
            return -offset
        } else {
            return offset
        }
    }

    private var resolvedBackgroundColor: Color {
        guard backgroundDimmed else {
            return tokens.backgroundClearColor
        }
        let opacity = resolvedPanelStateValue(tokens.backgroundClearOpacity, tokens.backgroundDimmedOpacity)
        return tokens.backgroundDimmedColor.opacity(opacity)
    }

    private var resolvedShadowColor: Color {
        let opacity = resolvedPanelStateValue(0.0, tokens.shadowOpacity)
        return tokens.shadowColor.opacity(opacity)
    }

    private var percentTransistionOffset: CGFloat {
        // Override offset if required
        if let percentDriveTransition = percentTransition {
            // parent view wants to take over primarily to conform user drag gesture
            if percentDriveTransition >= 0 && percentDriveTransition <= 1 {
                return expandedContentOffset + collapsedContentOffset * CGFloat(1 - percentDriveTransition)
            }
        }
        return CGFloat.zero
    }

    private var expandedContentOffset: CGFloat {
        return CGSize.zero.width
    }

    private var collapsedContentOffset: CGFloat {
        return slideOutPanelWidth * contentWidthSizeRatio
    }

    private func resolvedPanelStateValue(_ clear: Double, _ opaque: Double) -> Double {
        switch transitionState {
        case .collapsed:
            return clear
        case .expanded:
            return opaque
        case .inTransisiton:
            if let percent = percentTransition {
                return opaque * percent
            }
        }
        return clear
    }
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

// MARK: - Preview

struct SlideOverPanelLeft_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFSlideOverPanel<MockContent>(
                percentTransition: Binding.constant(0),
                tokens: MSFDrawerTokens(),
                slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundDimmed: true,
                direction: .left,
                transitionState: Binding.constant(SlideOverTransitionState.expanded))
        }
    }
}

struct SlideOverPanelRight_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFSlideOverPanel<MockContent>(
                percentTransition: Binding.constant(0),
                tokens: MSFDrawerTokens(),
                slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundDimmed: true,
                direction: .right,
                transitionState: Binding.constant(SlideOverTransitionState.expanded))
        }
    }
}

struct SlideOverPanelInTransition_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFSlideOverPanel<MockContent>(
                percentTransition: Binding.constant(0.4),
                tokens: MSFDrawerTokens(),
                slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundDimmed: true,
                direction: .left,
                transitionState: Binding.constant(SlideOverTransitionState.inTransisiton))
        }
    }
}

struct SlideOverPanelCollapsed_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFSlideOverPanel<MockContent>(
                percentTransition: Binding.constant(100),
                tokens: MSFDrawerTokens(), slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundDimmed: true,
                direction: .left,
                transitionState: Binding.constant(SlideOverTransitionState.collapsed))
        }
    }
}

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
