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
    @objc @Published public var isExpanded: Bool = false {
        didSet {
            onStateChange?()
        }
    }

    @objc public var presentationDirection: MSFDrawerDirection = .left

    /// Set `backgroundDimmed` to `true` to dim the spacer area between drawer and base view.
    /// If set to `false` it restores to `clear` color
    @objc @Published public var backgroundDimmed: Bool = false

    /// anitmation duration when drawer is collapsed/expanded
    @objc public var animationDuration: Double = 0.0
}

// MARK: - Drawer

/// `MSFDrawerView` is used to present a overlay a content partially on another view.
/// `MSFDrawerView`  support horizontal axis and is expanded by default from left side of the screen unless explicitly specified
///  Set `Content` to provide content for the drawer.
public struct MSFDrawerView<Content: View>: View {

    // content view on top of `Drawer`
    public var content: Content

    @Environment(\.theme) var theme: FluentUIStyle

    // configure the behavior of drawer
    @ObservedObject public var state = MSFDrawerState()

    // configure the apperance of drawer
    @ObservedObject public var tokens = MSFDrawerTokens()

    // keep track of dragged offset
    @State internal var horizontalDragOffset: CGFloat?

    // internal drawer state
    @State internal var isContentPresented: Bool = false

    private let gestureSnapWidthRatio: CGFloat = 0.225

    public var body: some View {
        GeometryReader { proxy in
            MSFSlideOverPanel(content: content,
                              isOpen: $isContentPresented,
                              preferredContentOffset: $horizontalDragOffset,
                              tokens: tokens)
                .backgroundOpactiy(backgroundLayerOpacity)
                .direction(slideOutDirection)
                .width(sizeInCurrentOrientation(proxy).width)
                .performOnBackgroundTap {
                    state.isExpanded = false
                }
                .onReceive(state.$isExpanded, perform: { value in
                    withAnimation(.easeInOut(duration: state.animationDuration)) {
                        isContentPresented = value
                        // drag ends
                        horizontalDragOffset = nil
                    }
                })
                .onDisappear {
                    state.isExpanded = false
                }
                .gesture(dragGesture(screenWidth: sizeInCurrentOrientation(proxy).width))
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

    private var backgroundLayerOpacity: Double {
        return Double(state.backgroundDimmed ? tokens.backgroundDimmedOpacity : tokens.backgroundClearOpacity)
    }

    private var slideOutDirection: MSFDrawerSlideOverDirection {
        return state.presentationDirection == .left ? .left : .right
    }

    private func dragGesture(screenWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let withinDragBounds = state.presentationDirection == .left ? value.translation.width < 0 : value.translation.width > 0
                if withinDragBounds {
                    horizontalDragOffset = value.translation.width
                }
            }
            .onEnded { _ in
                if let horizontalDragOffset = horizontalDragOffset {
                    if abs(horizontalDragOffset) < screenWidth * gestureSnapWidthRatio {
                        state.isExpanded = true
                    } else {
                        state.isExpanded = false
                    }
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
                             tokens: tokens,
                             horizontalDragOffset: horizontalDragOffset)
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
