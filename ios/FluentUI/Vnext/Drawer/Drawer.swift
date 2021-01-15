//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - Drawer Model

@objc public enum MSFDrawerDirection: Int, CaseIterable {
    /// Drawer originates from left
    case left
    /// Drawer originates from right
    case right
}

/// `MSFDrawerState` assist to configure drawer functional properties via UIKit components.
@objc public class MSFDrawerState: NSObject, ObservableObject {

    /// A callback executed when the drawer is expanded/collapsed
    public var onStateChange: (() -> Void)?

    /// Set `isExpanded` to `true` to maximize the drawer's width to fill the device screen horizontally minus the safe areas.
    /// Set to `false` to restore it to the normal size.
    @Published public var isExpanded: Bool? {
        didSet {
            onStateChange?()
        }
    }

    @objc public var presentationDirection: MSFDrawerDirection = .left

    /// Set `backgroundDimmed` to `true` to dim the spacer area between drawer and base view.
    /// If set to `false` it restores to `clear` color
    @objc @Published public var backgroundDimmed: Bool = false

    /// Anitmation duration when drawer is collapsed/expanded
    @objc public var animationDuration: Double = 0.0

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
        return state == .none || state == .began
    }

    public var body: some View {
        GeometryReader { proxy in
            MSFSlideOverPanel(
                percentTransition: $panelTransitionPercent,
                tokens: tokens,
                content: content,
                transitionState: $panelTransitionState)
                .isBackgroundDimmed(state.backgroundDimmed)
                .direction(slideOutDirection)
                .width(sizeInCurrentOrientation(proxy).width)
                .performOnBackgroundTap {
                    state.isExpanded = false
                }
                .onReceive(state.$isExpanded, perform: { value in
                    guard let value = value else {
                        return
                    }
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
                .gesture(dragGesture(screenWidth: sizeInCurrentOrientation(proxy).width))
                .onReceive(state.$translation) { value in
                    if let translation = value {
                        switch translation.state {
                        case .ended:
                            endTransition()
                        default:
                            let maxOffset = sizeInCurrentOrientation(proxy).width
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

    /// Custom modifier for adding a callback placeholder when drawer's state is changed
    /// - Parameter `didChangeState`: closure executed with drawer is expanded or collapsed
    /// - Returns: `Drawer`
    func didChangeState(_ didChangeState: @escaping () -> Void) -> MSFDrawerView {
        let drawerState = state
        drawerState.onStateChange = didChangeState
        return MSFDrawerView(content: content,
                      state: drawerState,
                      tokens: tokens)
    }

    @Environment(\.theme) var theme: FluentUIStyle

    /// Internal panel state
    @State internal var panelTransitionState: MSFSlideOverTransitionState = .collapsed

    /// Transition percent, whem set to max value the panel is expaned
    /// Range [0,1]
    @State internal var panelTransitionPercent: Double? = 0.0

    /// Threshold if exceeded the transition state is toggled
    private let horizontalGestureThreshold: Double = 0.225

    private var presentationAnimation: Animation {
        return Animation.easeInOut(duration: state.animationDuration)
    }

    private var slideOutDirection: MSFDrawerSlideOverDirection {
        return state.presentationDirection == .left ? .left : .right
    }

    private func dragGesture(screenWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = value.startLocation.x - value.location.x
                let isDragInReverseDirection = slideOutDirection == .right && delta > 0 ||
                     slideOutDirection == .left && delta < 0
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

    private func sizeInCurrentOrientation(_ proxy: GeometryProxy) -> CGSize {
        if proxy.size.width < proxy.size.height {
            return CGSize(width: proxy.size.width, height: proxy.size.height)
        } else {
            return CGSize(width: proxy.size.height, height: proxy.size.width)
        }
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
                        drawer.state.isExpanded?.toggle()
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
