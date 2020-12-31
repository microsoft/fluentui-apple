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
    public var onStateChange: (DrawerStateChangedCompletionBlock)?

    /// Set `isExpanded` to `true` to maximize the drawer's width to fill the device screen horizontally minus the safe areas.
    /// Set to `false` to restore it to the normal size.
    @objc @Published public var isExpanded: Bool = false {
        didSet {
            onStateChange?(isExpanded)
        }
    }
    @objc @Published public var presentationDirection: DrawerDirection = .left

    /// Set `backgroundDimmed` to `true` to dim the spacer area between drawer and base view.
    /// If set to `false` it restores to `clear` color
    @objc @Published public var backgroundDimmed: Bool = false
}

public typealias DrawerStateChangedCompletionBlock = (_ isExpanded: Bool) -> Void

// MARK: - Drawer Token

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
public class DrawerTokens: ObservableObject {

    @Published public var shadowColor: Color!
    @Published public var shadowOpacity: Double!
    @Published public var shadowBlur: CGFloat!
    @Published public var shadowDepthX: CGFloat!
    @Published public var shadowDepthY: CGFloat!

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
    @State internal var draggedOffsetWidth: CGFloat?

    // internal drawer state
    @State internal var isDrawerOpen: Bool = false

    public var body: some View {
        GeometryReader { proxy in
            SlideOverPanel(
                content: content,
                isOpen: $isDrawerOpen,
                preferredContentOffset: $draggedOffsetWidth)
                .backgroundOpactiy(backgroundLayerOpacity)
                .direction(slideOutDirection)
                .width(proxy.portraitOrientationAgnosticSize().width)
                .performOnBackgroundTap {
                    state.isExpanded.toggle()
                }
                .onReceive(state.$isExpanded, perform: { value in
                    withAnimation {
                        self.isDrawerOpen = value
                        self.draggedOffsetWidth = nil // drag ends
                    }
                })
                .gesture(dragGesture(screenWidth: proxy.portraitOrientationAgnosticSize().width))
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var backgroundLayerOpacity: Double {
        return state.backgroundDimmed ? 0.5 : 0
    }

    private var slideOutDirection: SlideOverDirection {
        return state.presentationDirection == .left ? .left : .right
    }
}

// MARK: - Utility + Helpers

extension GeometryProxy {
    func portraitOrientationAgnosticSize() -> CGSize {
        let isPortraitMode = self.size.width < self.size.height
        if isPortraitMode {
            return CGSize(width: self.size.width, height: self.size.height)
        } else {
            return CGSize(width: self.size.height, height: self.size.width)
        }
    }
}

// MARK: - Previews

import SwiftUI

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
