//
//  SlideOutPanel.swift
//  FluentUI
//
//  Created by Kunal Balani on 12/30/20.
//  Copyright © 2020 Microsoft Corporation. All rights reserved.
//

import SwiftUI

@objc enum SlideOverDirection: Int, CaseIterable {
    /// Drawer animated right from a left base
    case left
    /// Drawer animated right from a right base
    case right
}

/// SlidePanel in the drawer's horizontal layer that expands and collapsed on x axis of the drawer.
/// `View` consist of content view placed on top on panel and transparent background layer
struct SlideOverPanel<Content: View>: View {

    // Width occupied by content and spacer combined
    internal var slideOutPanelWidth: CGFloat = UIScreen.main.bounds.width

    // action executed with background transperent view is tapped
    internal var actionOnBackgroundTap: (() -> Void)?

    // content view is visible when slide over panel is expanded
    internal var content: Content

    // opacity used to dim the transparent layer
    internal var backgroundLayerOpacity: Double = 0.0

    // slide out direction
    internal var direction: SlideOverDirection = .left

    // content is visible when set to `true`
    @Binding internal var isOpen: Bool

    // width content view needs to be occupied
    @Binding internal var preferredContentOffset: CGFloat?

    // configure the apperance of drawer
    @ObservedObject public var tokens = DrawerTokens()

    private let backgroundLayerColor: Color = .black

    private let contentWidthSizeRatio: CGFloat = 0.9

    public var body: some View {
        HStack {
            if direction == .right {
                InteractiveSpacer().onTapGesture (count: 1, perform: actionOnBackgroundTap ?? {})
            }

            content
                .frame(width: contentWidth())
                .shadow(color: tokens.shadowColor.opacity(isOpen ? tokens.shadowOpacity : 0),
                        radius: tokens.shadowBlur,
                        x: tokens.shadowDepthX,
                        y: tokens.shadowDepthY)
                .offset(x: resolvedContentOffset())

            if direction == .left {
                InteractiveSpacer().onTapGesture (count: 1, perform: actionOnBackgroundTap ?? {})
            }
        }
        .background(isOpen ? backgroundLayerColor.opacity(backgroundLayerOpacity) : Color.clear)
    }

    private func resolvedContentOffset() -> CGFloat {
        // override offset if required
        if let preferredContentWidth = preferredContentOffset {  // parent view wants to take over primarily to conform to user drag gesture
            return preferredContentWidth
        }

        let offset = isOpen ? expandedConentOffset() : collapsedContentOffset()
        if direction == .left {
            return -offset
        } else {
            return offset
        }
    }

    private func expandedConentOffset() -> CGFloat {
        return CGSize.zero.width
    }

    private func collapsedContentOffset() -> CGFloat {
        return slideOutPanelWidth * contentWidthSizeRatio
    }

    private func contentWidth() -> CGFloat {
        return slideOutPanelWidth * contentWidthSizeRatio
    }
}

// MARK: - Composite View

public struct InteractiveSpacer: View {
    public var body: some View {
        ZStack {
            Color.black.opacity(0.001)
        }
    }
}

// MARK: - Preview

struct SlideOverPanelLeft_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            SlideOverPanel<MockContent>(
                slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundLayerOpacity: 0.5,
                direction: .left,
                isOpen: Binding.constant(true),
                preferredContentOffset: Binding.constant(nil))
        }
    }
}

struct SlideOverPanelRight_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            SlideOverPanel<MockContent>(
                slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundLayerOpacity: 0.5,
                direction: .right,
                isOpen: Binding.constant(true),
                preferredContentOffset: Binding.constant(nil))
        }
    }
}

struct SlideOverPanelCollapsed_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            SlideOverPanel<MockContent>(
                slideOutPanelWidth: UIScreen.main.bounds.width,
                actionOnBackgroundTap: nil,
                content: MockContent(),
                backgroundLayerOpacity: 0.5,
                direction: .left,
                isOpen: Binding.constant(false),
                preferredContentOffset: Binding.constant(nil))
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
