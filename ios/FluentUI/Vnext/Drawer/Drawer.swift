//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFDrawerState` assist to configure drawer functional properties via UIKit components.
@objc public class MSFDrawerState: NSObject, ObservableObject {

    /// A callback executed after the drawer is expanded/collapsed
    public var onStateChange: ((Bool?) -> Void)?

    /// Set `isExpanded` to `true` to maximize the drawer's width to fill the device screen horizontally minus the safe areas.
    /// Set to `false` to restore it to the normal size.
    @Published public var isExpanded: Bool = false

    @objc public var presentationDirection: MSFDrawerDirection = .left {
        didSet {
            presentationOrigin = .zero
        }
    }

    /// Set `backgroundDimmed` to `true` to dim the spacer area between drawer and base view.
    /// If set to `false` it restores to `clear` color
    @objc @Published public var backgroundDimmed: Bool = false

    /// Anitmation duration when drawer is collapsed/expanded
    @objc public var animationDuration: Double = 0.0

    /// Parameter presentationOrigin: The offset (in screen coordinates) from which to show a slideover.
    /// If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.
    @objc public var presentationOrigin: CGPoint = .zero

    /// Override this value to explicity set drag offset for the drawer
    @Published public var translation: (state: UIGestureRecognizer.State, point: CGPoint)?

    /// Set `presentingGesture` before calling `present` to provide a gesture recognizer that resulted in the presentation of the drawer and to allow this presentation to be interactive.
    public var presentingGesture: UIPanGestureRecognizer? {
        didSet {
            if presentingGesture == oldValue {
                return
            }
            oldValue?.removeTarget(self, action: #selector(handlePresentingPan))
            presentingGesture?.addTarget(self, action: #selector(handlePresentingPan))
        }
    }

    @objc private func handlePresentingPan(gesture: UIPanGestureRecognizer) {
        translation = (state: gesture.state, point: gesture.translation(in: gesture.view))
    }
}

// MARK: - Drawer

/// `MSFDrawerView` is used to present a overlay a content partially on another view.
/// `MSFDrawerView`  support horizontal axis and is expanded by default from left side of the screen unless explicitly specified
///  Set `Content` to provide content for the drawer.
public struct MSFDrawerView<Content: View>: View {

    /// Content view on top of `Drawer`
    public var content: Content

    /// Configure the behavior of drawer
    @ObservedObject public var state = MSFDrawerState()

    /// Configure the apperance of drawer
    @ObservedObject public var tokens = MSFDrawerTokens()

    /// Flag is set when pangesture is started
    public var isPresentationGestureActive: Bool {
        guard let gesture = state.presentingGesture else {
            return false
        }

        let state = gesture.state
        return state == .began || state == .changed
    }

    public var body: some View {
        GeometryReader { proxy in
            MSFSlideOutPanel(
                percentTransition: $panelTransitionPercent,
                tokens: tokens,
                content: content,
                transitionState: $panelTransitionState)
                .isBackgroundDimmed(state.backgroundDimmed)
                .direction(state.presentationDirection)
                .size(proxy.size)
                .performOnBackgroundTap {
                    state.isExpanded = false
                }
                .transitionCompletion {
                    guard !isPresentationGestureActive else {
                        return
                    }
                    state.onStateChange?(state.isExpanded)
                }
                .offset(x: state.presentationOrigin.x, y: state.presentationOrigin.y)
                .gesture(dragGesture(screenWidth: proxy.size.width))
                .onReceive(state.$isExpanded, perform: { value in
                    withAnimation(presentationAnimation) {
                        if value {
                            panelTransitionState = .expanded
                        } else {
                            panelTransitionState = .collapsed
                        }
                    }
                    if !isPresentationGestureActive {
                        // end drag
                        panelTransitionPercent = nil
                    }
                })
                .onDisappear {
                    state.isExpanded = false
                }
                .onReceive(state.$translation) { value in
                    if let translation = value {
                        switch translation.state {
                        case .ended:
                            endTransition()
                        default:
                            let maxOffset = proxy.size.width
                            let velocity = translation.point.x
                            let percent = Double(abs (velocity / maxOffset))
                            updateTransition(percent, isAnimated: true)
                        }
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // When environment values are available through the view hierarchy:
            //  - If we get a non-default theme through the environment values,
            //    we use to override the theme from this view and its hierarchy.
            //  - Otherwise we just refresh the tokens to reflect the theme
            //    associated with the window that this View belongs to.
            if theme == ThemeKey.defaultValue {
                self.tokens.updateForCurrentTheme()
            } else {
                self.tokens.theme = theme
            }
        }
    }

    @Environment(\.theme) var theme: FluentUIStyle

    /// Internal panel state
    @State internal var panelTransitionState: MSFDrawerTransitionState = .collapsed

    /// Transition percent, whem set to max value the panel is expaned
    /// Range [0,1]
    @State internal var panelTransitionPercent: Double? = 0.0

    /// tracks drawer content size
    @State internal var drawerSize: CGSize = .zero

    /// Threshold if exceeded the transition state is toggled
    private let horizontalGestureThreshold: Double = 0.225

    private var presentationAnimation: Animation {
        return Animation.easeInOut(duration: state.animationDuration)
    }

    private func dragGesture(screenWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = value.startLocation.x - value.location.x
                let isDragInReverseDirection = (state.presentationDirection == .right && delta > 0) ||
                    (state.presentationDirection == .left && delta < 0)
                guard !isDragInReverseDirection else {
                    return
                }

                let velocity = value.translation.width
                updateTransition(Double(abs (velocity / screenWidth)), isAnimated: true, reverseDirection: true)
            }
            .onEnded { _ in
                endTransition(inverse: true)
            }
    }

    /// Default direction is in the direction of `DrawerPresentation`
    private func updateTransition(_ percent: Double, isAnimated: Bool = false, reverseDirection: Bool = false) {
        if percent >= 0 && percent <= 1 {
            withAnimation(isAnimated ? presentationAnimation : .none) {
                panelTransitionState = .inTransisiton
                panelTransitionPercent = reverseDirection ? 1 - percent : percent
            }
        }
    }

    /// Default direction is in the direction of `DrawerPresentation`, inverse will reverse the default direction
    private func endTransition(inverse: Bool = false) {
        guard let percent = panelTransitionPercent else {
            return
        }
        let snapPercent = inverse ? 1 - percent : percent
        let snapThreshold = horizontalGestureThreshold
        if snapPercent < snapThreshold {
            state.isExpanded = inverse
        } else {
            state.isExpanded = !inverse
        }
    }
}

// MARK: - View Modifier

private extension MSFSlideOutPanel {
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

// MARK: - Previews

struct MSFDrawerContent: View {
    var body: some View {
        ZStack {
            Color.red
            Text("Tap outside to collapse.")
        }
    }
}

struct MSFDrawerPreview: View {
    var drawer = MSFDrawerView(content: MSFDrawerContent())
    var body: some View {
        ZStack {
            NavigationView {
                EmptyView()
                    .navigationBarTitle(Text("Drawer Background"))
                    .navigationBarItems(leading: Button(action: {
                        drawer.state.isExpanded.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })).background(Color.blue)
            }
            drawer
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MSFDrawerPreview()
    }
}
#endif
