//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - Drawer Model

@objc public enum DrawerDirection: Int, CaseIterable {
    /// Drawer originates from left
    case left
    /// Drawer originates from right
    case right
}

/// `DrawerState` assist to configure drawer functional properties via UIKit components.
@objc(DrawerState)
public class DrawerState: NSObject, ObservableObject {

    /// A callback executed when the drawer is expanded/collapsed
    public var onStateChange: (() -> Void)?

    /// Set `isExpanded` to `true` to maximize the drawer's width to fill the device screen horizontally minus the safe areas.
    /// Set to `false` to restore it to the normal size.
    @objc @Published public var isExpanded: Bool = false {
        didSet {
            onStateChange?()
        }
    }
    @objc @Published public var presentationDirection: DrawerDirection = .left

    /// Set `backgroundDimmed` to `true` to dim the spacer area between drawer and base view.
    /// If set to `false` it restores to `clear` color
    @objc @Published public var backgroundDimmed: Bool = false

    /// anitmation duration when drawer is collapsed/expanded
    @objc @Published public var animationDuration: Double = 0.0
}

// MARK: - Drawer Token

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
public class DrawerTokens: ObservableObject {

    @Published public var shadowColor: Color!
    @Published public var shadowOpacity: Double!
    @Published public var shadowBlur: CGFloat!
    @Published public var shadowDepthX: CGFloat!
    @Published public var shadowDepthY: CGFloat!
    @Published public var backgroundDimmedColor: Color!
    @Published public var backgroundClearColor: Color!
    @Published public var backgroundDimmedOpacity: CGFloat!
    @Published public var backgroundClearOpacity: CGFloat!

    public init() {
        self.themeAware = true
        didChangeAppearanceProxy()
    }

    @objc open func didChangeAppearanceProxy() {
        let appearanceProxy = StylesheetManager.S.DrawerTokens
        shadowColor = Color(appearanceProxy.shadowColor)
        shadowOpacity = Double(appearanceProxy.shadowOpacity)
        shadowBlur = appearanceProxy.shadowBlur
        shadowDepthX = appearanceProxy.shadowX
        shadowDepthY = appearanceProxy.shadowY
        backgroundClearColor = Color(appearanceProxy.backgroundClearColor)
        backgroundDimmedColor = Color(appearanceProxy.backgroundDimmedColor)
        backgroundDimmedOpacity = appearanceProxy.backgroundDimmedOpacity
        backgroundClearOpacity = appearanceProxy.backgroundClearOpacity
    }
}

// MARK: - Drawer

/// `Drawer` is used to present a overlay a content partially on another view.
/// `Drawer`  support horizontal axis and is expanded by default from left side of the screen unless explicitly specified
///  Set `Content` to provide content for the drawer.
public struct Drawer<Content: View>: View {

    // content view on top of `Drawer`
    public var content: Content

    // configure the behavior of drawer
    @ObservedObject public var state = DrawerState()

    // configure the apperance of drawer
    @ObservedObject public var tokens = DrawerTokens()

    // keep track of dragged offset
    @State internal var horizontalDragOffset: CGFloat?

    // internal drawer state
    @State internal var isContentPresented: Bool = false

    private let gestureSnapWidthRatio: CGFloat = 0.225

    public var body: some View {
        GeometryReader { proxy in
            SlideOverPanel(
                content: content,
                isOpen: $isContentPresented,
                preferredContentOffset: $horizontalDragOffset)
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
    }

    private var backgroundLayerOpacity: Double {
        return Double(state.backgroundDimmed ? tokens.backgroundDimmedOpacity : tokens.backgroundClearOpacity)
    }

    private var slideOutDirection: SlideOverDirection {
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
    func didChangeState(_ didChangeState: @escaping () -> Void) -> Drawer {
        let drawerState = state
        drawerState.onStateChange = didChangeState
        return Drawer(content: content,
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

struct DrawerContent: View {
    var body: some View {
        ZStack {
            Color.red
            Text("Tap outside to collapse.")
        }
    }
}

struct DrawerPreview: View {
    var drawer = Drawer(content: DrawerContent())
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
        DrawerPreview()
    }
}
#endif
