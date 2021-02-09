//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFBasePanel` in the drawer's  undelrying layer that expands and collapsed on x/y axis of the drawer.
/// `View` consist of content view placed on top on panel and transparent background layer
// MARK: - Base Panel
struct MSFBasePanel<Content: View>: View, MSFPanelContent, MSFPanelTransition {

    /// Only effective when panel is in transition, valid range [0,1]
    @Binding public var percentTransition: Double?

    /// Configure the apperance of drawer
    @ObservedObject public var tokens = MSFDrawerTokens()

    /// Content view is visible when slide over panel is expanded
    var content: Content

    /// Interactive state of panel
    @Binding var transitionState: MSFDrawerTransitionState

    /// default content size ratio (percentage of drawer size occupied) when drawer is expanded, valid range [0,1]
    var contentSizeRatio: CGSize {  return CGSize(width: 0.9, height: 0.5) }

    /// size of the base panel
    var size: CGSize = UIScreen.main.bounds.size

    /// Action executed with background transperent view is tapped
    var actionOnBackgroundTap: (() -> Void)?

    /// If set to `true` then token with dimmed bacground value is used
    var backgroundDimmed: Bool = false

    /// Slide out direction
    var direction: MSFDrawerDirection = .left

    /// Action executed with transiton state is completed
    var transitionCompletion: (() -> Void)?

    var body: some View {
        AnyStack {
            if direction == .right || direction == .bottom {
                MSFInteractiveSpacer(defaultBackgroundColor: $tokens.backgroundClearColor)
                    .onTapGesture (perform: actionOnBackgroundTap ?? {})
            }

            content
                .frame(width: contentWidth, height: contentHeight)
                .offset(x: contentOffset)
                .shadow(color: tokens.shadow1Color,
                        radius: tokens.shadow1Blur,
                        x: tokens.shadow1DepthX,
                        y: tokens.shadow1DepthY)
                .shadow(color: tokens.shadow2Color,
                        radius: tokens.shadow2Blur,
                        x: tokens.shadow2DepthX,
                        y: tokens.shadow2DepthY)
                .onAnimationComplete(value: Double(contentOffset), completion: transitionCompletion)

            if direction == .left || direction == .top {
                MSFInteractiveSpacer(defaultBackgroundColor: $tokens.backgroundClearColor)
                    .onTapGesture (perform: actionOnBackgroundTap ?? {})
            }
        }
        .orientation(!direction.isVertical())
        .background(backgroundColor)
    }

    /// Read-only property for contentWidth to resize content size use `contentSizeRatio` instead
    var contentWidth: CGFloat {
        return  size.width * (direction.isVertical() ?  contentSizeRatio.width : 1)
    }

    /// Read-only property for contentHeight to resize content size use `contentSizeRatio` instead
    var contentHeight: CGFloat {
        return  size.height * (direction.isVertical() ? 1 : contentSizeRatio.height)
    }

    var contentOffset: CGFloat {

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

    var backgroundColor: Color {
        guard backgroundDimmed else {
            return tokens.backgroundClearColor
        }

        // animate opacity
        var opacity: Double = 0.0
        switch transitionState {
        case .collapsed:
            opacity = 0
        case .expanded:
            opacity = 1
        case .inTransisiton:
            opacity = percentTransition ?? 0
        }

        return tokens.backgroundDimmedColor.opacity(opacity)
    }

    var percentTransistionOffset: CGFloat {
        // Override offset if required
        if let percentDriveTransition = percentTransition {
            // parent view wants to take over primarily to conform user drag gesture
            if percentDriveTransition >= 0 && percentDriveTransition <= 1 {
                return expandedContentOffset + collapsedContentOffset * CGFloat(1 - percentDriveTransition)
            }
        }
        return CGFloat.zero
    }

    var expandedContentOffset: CGFloat {
        return CGSize.zero.width
    }

    var collapsedContentOffset: CGFloat {
        if direction.isVertical() {
            return size.width * contentSizeRatio.width
        } else {
            return size.height * contentSizeRatio.height
        }
    }
}

// MARK: - Preview

struct BasePanelLeft_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFBasePanel<MockContent>(percentTransition: Binding.constant(nil),
                                      tokens: MSFDrawerTokens(),
                                      content: MockContent(),
                                      transitionState: Binding.constant(MSFDrawerTransitionState.expanded),
                                      actionOnBackgroundTap: nil,
                                      backgroundDimmed: true,
                                      direction: .left,
                                      transitionCompletion: nil)
        }
    }
}

struct BasePanelRight_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFBasePanel<MockContent>(percentTransition: Binding.constant(nil),
                                      tokens: MSFDrawerTokens(),
                                      content: MockContent(),
                                      transitionState: Binding.constant(MSFDrawerTransitionState.expanded),
                                      actionOnBackgroundTap: nil,
                                      backgroundDimmed: true,
                                      direction: .right,
                                      transitionCompletion: nil)
        }
    }
}

struct BasePanelInTransition_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFBasePanel<MockContent>(percentTransition: Binding.constant(0.4),
                                      tokens: MSFDrawerTokens(),
                                      content: MockContent(),
                                      transitionState: Binding.constant(MSFDrawerTransitionState.inTransisiton),
                                      actionOnBackgroundTap: nil,
                                      backgroundDimmed: true,
                                      direction: .left,
                                      transitionCompletion: nil)
        }
    }
}

struct BasePanelCollapsed_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFBasePanel<MockContent>(percentTransition: Binding.constant(nil),
                                      tokens: MSFDrawerTokens(),
                                      content: MockContent(),
                                      transitionState: Binding.constant(MSFDrawerTransitionState.collapsed),
                                      actionOnBackgroundTap: nil,
                                      backgroundDimmed: true,
                                      direction: .left,
                                      transitionCompletion: nil)
        }
    }
}

struct BasePanelTop_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFBasePanel<MockContent>(percentTransition: Binding.constant(nil),
                                      tokens: MSFDrawerTokens(),
                                      content: MockContent(),
                                      transitionState: Binding.constant(MSFDrawerTransitionState.expanded),
                                      actionOnBackgroundTap: nil,
                                      backgroundDimmed: true,
                                      direction: .top,
                                      transitionCompletion: nil)
        }
    }
}
