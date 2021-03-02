//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

private struct Constants {
    static let defaultContentSize = CGSize(width: 360, height: 400)
    static let cornerRadius: CGFloat = 20
    static let initialContentWidthPercent: CGFloat = 0.9
    static let initialContentHeightPercent: CGFloat = 0.5
}

/// `MSFSlideOutPanel` in the drawer's  undelrying layer that expands and collapsed on x/y axis of the drawer.
/// `View` consist of content view placed on top on panel and transparent background layer
// MARK: - Base Panel
struct MSFSlideOutPanel<Content: View>: View, MSFPanelContent, MSFPanelTransition {

    /// Only effective when panel is in transition, valid range [0,1]
    @Binding public var percentTransition: Double?

    /// Configure the apperance of drawer
    @ObservedObject public var tokens = MSFDrawerTokens()

    /// Content view is visible when slide over panel is expanded
    var content: Content

    /// Interactive state of panel
    @Binding var transitionState: MSFDrawerTransitionState

    /// content size the panel's attempt to set if within bounds
    var preferredContentSize: CGSize {
        var preferredWidth = panelSize.width * Constants.initialContentWidthPercent
        if preferredWidth >= Constants.defaultContentSize.width {
            preferredWidth = Constants.defaultContentSize.width
        }

        var preferredHeight = panelSize.height * Constants.initialContentHeightPercent
        if preferredHeight >= Constants.defaultContentSize.height {
            preferredHeight = Constants.defaultContentSize.height
        }
        return CGSize(width: preferredWidth, height: preferredHeight)
    }

    /// size of the base panel
    var panelSize: CGSize = UIScreen.main.bounds.size

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
                .cornerRadius(Constants.cornerRadius, direction: direction)
                .offset(x: contentOffset.dx, y: contentOffset.dy)
                .frame(width: contentWidth, height: contentHeight)
                .cornerRadius(Constants.cornerRadius, direction: direction)
                .elevation(with: tokens, alignment: direction)
                .onAnimationComplete(value: valueObserved, completion: transitionCompletion)

            if direction == .left || direction == .top {
                MSFInteractiveSpacer(defaultBackgroundColor: $tokens.backgroundClearColor)
                    .onTapGesture (perform: actionOnBackgroundTap ?? {})
            }
        }
        .orientation(!direction.isHorizontal())
        .background(backgroundColor)
    }

    /// Read-only property for contentWidth to resize content size use `contentSizeRatio` instead
    var contentWidth: CGFloat {
        return direction.isHorizontal() ? preferredContentSize.width : panelSize.width
    }

    /// Read-only property for contentHeight to resize content size use `contentSizeRatio` instead
    var contentHeight: CGFloat {
        return direction.isHorizontal() ? panelSize.height : preferredContentSize.height
    }

    var contentOffset: CGVector {
        switch transitionState {
        case .collapsed:
            return collapsedContentOffset
        case .expanded:
            return expandedContentOffset
        case .inTransisiton:
            return percentTransistionOffset
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

    private var percentTransistionOffset: CGVector {
        var delta = CGVector.zero

        guard let percentDriveTransition = percentTransition, percentDriveTransition >= 0 && percentDriveTransition <= 1 else {
            return delta
        }

        let floatPercent = CGFloat(1 - percentDriveTransition)
        if direction.isHorizontal() {
            delta = CGVector (dx: expandedContentOffset.dx + collapsedContentOffset.dx * floatPercent,
                              dy: delta.dy)
        } else {
            delta = CGVector (dx: delta.dx,
                              dy: expandedContentOffset.dy + collapsedContentOffset.dy * floatPercent)
        }
        return delta
    }

    private var expandedContentOffset: CGVector {
        return CGVector.zero
    }

    private var collapsedContentOffset: CGVector {
        switch direction {
        case .left:
            return CGVector(dx: -1 * preferredContentSize.width, dy: CGFloat.zero)
        case .right:
            return CGVector(dx: preferredContentSize.width, dy: CGFloat.zero)
        case .bottom:
            return CGVector(dx: CGFloat.zero, dy: preferredContentSize.height)
        case .top:
            return CGVector(dx: CGFloat.zero, dy: -1 * preferredContentSize.height)
        }
    }

    private var valueObserved: Double {
        return Double(direction.isHorizontal() ? contentOffset.dx : contentOffset.dy)
    }
}

// MARK: - Preview

struct BasePanelLeft_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MockBackgroundView()
            MSFSlideOutPanel<MockContent>(
                percentTransition: Binding.constant(nil),
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
            MSFSlideOutPanel<MockContent>(
                percentTransition: Binding.constant(nil),
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
            MSFSlideOutPanel<MockContent>(
                percentTransition: Binding.constant(0.4),
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
            MSFSlideOutPanel<MockContent>(
                percentTransition: Binding.constant(nil),
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
            MSFSlideOutPanel<MockContent>(
                percentTransition: Binding.constant(nil),
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
