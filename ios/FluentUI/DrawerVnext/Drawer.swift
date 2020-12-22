//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(DrawerState)

public class DrawerState: NSObject, ObservableObject {
    weak var delegate: DrawerStateDelegate?
    @objc @Published public var presentationDirection: DrawerDirection = .left
    @objc @Published public var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                delegate?.drawerDidExpand?()
            } else {
                delegate?.drawerDidCollapsed?()
            }
        }
    }
    @objc @Published public var backgroundDimmed: Bool = false
}

@objc(DrawerStateDelegate)

// State delegate is currently required to notify hosting viewcontroller about expansion
protocol DrawerStateDelegate: AnyObject {
    @objc optional func drawerDidExpand()
    @objc optional func drawerDidCollapsed()
}

public class DrawerTokens: ObservableObject {

    @Published public var shadowColor: Color!
    @Published public var shadowOpacity: Double!
    @Published public var shadowBlur: CGFloat!
    @Published public var shadowDepth: [CGFloat]! // x,y axis

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

    private let backgroundLayerColor: Color = .black
    private var backgroundLayerOpacity: Double {
        return state.backgroundDimmed ? 0.5 : 0
    }
    private let backgroundLayerAnimation: Animation = .default

    private let percentWidthOfContent: CGFloat = 0.9
    private let percentSnapWidthOfScreen: CGFloat = 0.225

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
            }
            .background(state.isExpanded ? backgroundLayerColor.opacity(backgroundLayerOpacity) : Color.clear)
            .gesture(dragGesture(snapWidth: reader.size.width * percentSnapWidthOfScreen))
        }
    }

    private func dragGesture(snapWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let withinDragBounds = state.presentationDirection == .left ? value.translation.width < 0 : value.translation.width > 0
                if withinDragBounds {
                    draggedOffsetWidth = value.translation.width
                }
            }
            .onEnded { _ in
                if let draggedOffsetWidth = draggedOffsetWidth {
                    if abs(draggedOffsetWidth) < snapWidth {
                        state.isExpanded = true
                    } else {
                        state.isExpanded = false
                    }
                    self.draggedOffsetWidth = nil
                }
            }
    }
}

/**
 `DrawerHost` is UIKit wrapper required to host UIViewController as content.
 */
public struct DrawerModal {

    public struct DrawerShimView: View {

        private var drawer: Drawer<DrawerContentViewController>

        public var drawerState: DrawerState {
            return drawer.state
        }

        init(contentViewController: UIViewController) {
            drawer = Drawer(content: DrawerContentViewController(contentViewController: contentViewController))
        }

        public var body: some View {
            ZStack {
                drawer.edgesIgnoringSafeArea(.all)
            }
        }
    }

    public struct DrawerContentViewController: UIViewControllerRepresentable {

        private var contentView: UIViewController

        init(contentViewController: UIViewController) {
            self.contentView = contentViewController
        }

        public func makeUIViewController(context: Context) -> UIViewController {
            return contentView
        }

        public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

        public typealias UIViewControllerType = UIViewController
    }
}

@objc(MSFDrawerVnext)

/// UIKit wrapper that exposes the SwiftUI Drawer implementation
open class DrawerVnext: UIHostingController<DrawerModal.DrawerShimView> {

    @objc open var drawerState: DrawerState {
        return self.rootView.drawerState
    }

    @objc public init(contentViewController: UIViewController) {
        super.init(rootView: DrawerModal.DrawerShimView(contentViewController: contentViewController))
        transitioningDelegate = self
        drawerState.delegate = self
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
    }

    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension DrawerVnext: DrawerStateDelegate {
    // two way binding if state is changed
    func drawerDidCollapsed() {
        dismiss(animated: true)
    }
}

extension DrawerVnext: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        let isPresentingDrawer = toView == view

        let drawerView = isPresentingDrawer ? toView : fromView

        // delegate animation to swiftui by changing state
        if isPresentingDrawer {
            transitionContext.containerView.addSubview(drawerView)
            drawerView.frame = UIScreen.main.bounds
            // Added a static interval as currently swiftui doesn't have an animation completion callback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                if let strongSelf = self {
                    strongSelf.drawerState.isExpanded = isPresentingDrawer
                }
                transitionContext.completeTransition(true)
            }
        } else {
            self.drawerState.isExpanded = isPresentingDrawer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                drawerView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
