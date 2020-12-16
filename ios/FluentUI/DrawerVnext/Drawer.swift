//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(DrawerState)

public class DrawerState: NSObject, ObservableObject {
    @objc @Published public var presentationDirection: DrawerDirection = .left
    @objc @Published public var isExpanded: Bool = false
    @objc @Published public var backgroundDimmed: Bool = false
}

public class DrawerTokens: ObservableObject {

    @Published public var shadowColor: Color! = Color.black
    @Published public var shadowOpacity: Double! = 0.24
    @Published public var shadowBlur: CGFloat! = 28
    @Published public var shadowDepth: [CGFloat]! =  [0, 14.0] // x,y axis

    public init() {
        self.themeAware = true
        didChangeAppearanceProxy()
    }

    @objc open func didChangeAppearanceProxy() {
        let appearanceProxy = StylesheetManager.S.DrawerTokens
        shadowColor = Color(appearanceProxy.shadowColor)
        shadowOpacity = Double(appearanceProxy.shadowOpacity)
        shadowBlur = appearanceProxy.shadowBlur
        shadowDepth = appearanceProxy.shadowDepth
    }
}

// Mark - Drawer View

@objc public enum DrawerDirection: Int, CaseIterable {
    case left
    case right
}

/**
 `Drawer` is used to present a content that is currently in hideout mode when collapsed and when expanded is used to present content view partially either on the left or right.
 
 Currently `Drawer` only support horizontal axis and is expanded by default from left side of the screen unless explicitly specified
 
 Set `Content` to provide content for the drawer.
 */
public struct Drawer<Content: View>: View {

    @ObservedObject var state: DrawerState
    @ObservedObject var tokens: DrawerTokens

    var backgroundLayerColor: Color! = Color.black
    private var backgroundLayerOpacity: Double! {
        return state.backgroundDimmed ? 0.5 : 0
    }
    var backgroundLayerAnimation: Animation! = Animation.default

    var percentWidthOfContent: CGFloat! = 0.9

    // content view on top of
    public var content: Content

    // `ivar` to keep track of dragged offset
    @State private var draggedOffsetWidth: CGFloat?
    private func computedOffset(screenSize: CGSize) -> CGFloat {

        if let draggedOffsetWidth = draggedOffsetWidth {
            return draggedOffsetWidth
        }

        var width = CGFloat.zero
        let contentWidth = screenSize.width * percentWidthOfContent
        if !state.isExpanded { // if closed then hidden behind the screen
            width = state.presentationDirection == .left ? -contentWidth : contentWidth
        }

        return width
    }

//    // percentage of space occupied by drawer when open
//    private var openDrawerWidth: CGFloat {
//        return UIScreen.main.bounds.width * 0.9
//    }

    public init(content: Content) {
        self.content = content
        tokens = DrawerTokens()
        state = DrawerState()
    }

    public var body: some View {

        GeometryReader { reader in
            HStack {

                if state.presentationDirection == .right {
                    Spacer()
                }

                content
                    .frame(width: reader.size.width * percentWidthOfContent)
                    .shadow(color: tokens.shadowColor.opacity(state.isExpanded ? tokens.shadowOpacity : 0),
                            radius: tokens.shadowBlur,
                            x: tokens.shadowDepth[0],
                            y: tokens.shadowDepth[1])
                    .offset(x: computedOffset(screenSize: reader.size))
                    .animation(backgroundLayerAnimation)

                if state.presentationDirection == .left {
                    Spacer()
                }

            }.onTapGesture {
                state.isExpanded.toggle()
            }.background(state.isExpanded ? backgroundLayerColor.opacity(backgroundLayerOpacity) : Color.clear)
            .gesture(drag)
        }
    }

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in

                let withinDragBounds = state.presentationDirection == .left ? value.translation.width < 0 : value.translation.width > 0
                if withinDragBounds {
                    draggedOffsetWidth = value.translation.width
                }
            }
            .onEnded { _ in
                if let draggedOffsetWidth = draggedOffsetWidth {
                    if abs(draggedOffsetWidth) < 270 / 4 {
                        state.isExpanded = true
                    } else {
                        state.isExpanded = false
                    }
                    self.draggedOffsetWidth = nil
                }
            }
    }
}

@objc(VXTDrawerController)

/// UIKit wrapper that exposes the SwiftUI Button implementation
open class VXTDrawerController: NSObject {

    private var hostingController: UIHostingController<DrawerShimView>

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var drawerState: DrawerState {
        return self.hostingController.rootView.drawerState
    }

    @objc public init(contentView: UIView, presentationController: UIViewController) {
        self.hostingController = UIHostingController(rootView: DrawerShimView(contentView: contentView, controller: presentationController))
        super.init()
    }

    struct DrawerContentView: UIViewRepresentable {

        private var contentView: UIView

        init(contentView: UIView) {
            self.contentView = contentView
        }

        func makeUIView(context: Context) -> UIView {
            return contentView
        }

        func updateUIView(_ uiView: UIView, context: Context) {}

        typealias UIViewType = UIView

    }

    struct DrawerPresentationViewController: UIViewControllerRepresentable {

        private var presentationController: UIViewController

        init(controller: UIViewController) {
            self.presentationController = controller
        }

        func makeUIViewController(context: Context) -> UIViewController {
            return presentationController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

        typealias UIViewControllerType = UIViewController

    }

    struct DrawerShimView: View {

        private var drawer: Drawer<DrawerContentView>
        private var presentationController: DrawerPresentationViewController

        public var drawerState: DrawerState {
            return drawer.state
        }

        init(contentView: UIView, controller: UIViewController) {
            drawer = Drawer(content: DrawerContentView(contentView: contentView))
            presentationController = DrawerPresentationViewController(controller: controller)
        }

        var body: some View {
            ZStack {
                presentationController
                drawer
            }
        }
    }
}
