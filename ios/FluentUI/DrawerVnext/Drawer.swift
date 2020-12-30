//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: State

/*
 `DrawerState` assist to configure drawer functional properties via UIKit components.
 */
@objc(DrawerState)
public class DrawerState: NSObject, ObservableObject {

    /// A callback executed when the drawer is expanded/collapsed
    public var onStateChange: (DrawerStateChangedCompletionBlock)?

    /*
     Set `isExpanded` to `true` to maximize the drawer's width to fill the device screen horizontally minus the safe areas. Set to `false` to restore it to the normal size.
     */
    @objc @Published public var isExpanded: Bool = false {
        didSet {
            onStateChange?(isExpanded)
        }
    }

    @objc @Published public var presentationDirection: DrawerDirection = .left

    /*
     Set `backgroundDimmed` to `true` to dim the spacer area between drawer and base view. If set to `false` it restores to `clear` color
     */
    @objc @Published public var backgroundDimmed: Bool = false
}

public typealias DrawerStateChangedCompletionBlock = (_ isExpanded: Bool) -> Void

@objc(DrawerViewModel)
public class DrawerAnimationModel: NSObject, ObservableObject {
    @Published public var expand: Bool = false
}

/*
 `DrawerTokens` assist to configure drawer apperance via UIKit components.
 */
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

@objc public enum DrawerDirection: Int, CaseIterable {
    /// Drawer animated right from a left base
    case left
    /// Drawer animated right from a right base
    case right
}

// MARK: Drawer

/**
 `Drawer` is used to present a content that is currently in hideout mode when collapsed and when expanded is used to present content view partially either on the left or right.
 `Drawer`  support horizontal axis and is expanded by default from left side of the screen unless explicitly specified
 Set `Content` to provide content for the drawer.
 */
public struct Drawer<Content: View>: View {

    // content view on top of `Drawer`
    public var content: Content

    // configure the behavior of drawer
    @ObservedObject public var state = DrawerState()

    // configure the apperance of drawer
    @ObservedObject public var tokens = DrawerTokens()

    @ObservedObject public var viewModel = DrawerAnimationModel()

    private let backgroundLayerColor: Color = .black
    private var backgroundLayerOpacity: Double {
        return state.backgroundDimmed ? 0.5 : 0
    }
    private let backgroundLayerAnimation: Animation = .default

    private let percentWidthOfContent: CGFloat = 0.9
    private let percentSnapWidthOfScreen: CGFloat = 0.225

    // `ivar` to keep track of dragged offset
    @State internal var draggedOffsetWidth: CGFloat?
    private func computedOffset(screenSize: CGSize) -> CGFloat {

        if let draggedOffsetWidth = draggedOffsetWidth {
            return draggedOffsetWidth
        }

        var width = CGFloat.zero
        let contentWidth = screenSize.width * percentWidthOfContent
        if !viewModel.expand { // if closed then hidden behind the screen
            width = state.presentationDirection == .left ? -contentWidth : contentWidth
        }

        return width
    }

    public var body: some View {
        GeometryReader { proxy in
            HStack {
                if state.presentationDirection == .right {
                    InteractiveSpacer().onTapGesture {
                        state.isExpanded.toggle()
                    }
                }

                content
                    .frame(width: proxy.portraitOrientationAgnosticSize().width * percentWidthOfContent)
                    .shadow(color: tokens.shadowColor.opacity(state.isExpanded ? tokens.shadowOpacity : 0),
                            radius: tokens.shadowBlur,
                            x: tokens.shadowDepth[0],
                            y: tokens.shadowDepth[1])
                    .offset(x: computedOffset(screenSize: proxy.portraitOrientationAgnosticSize()))

                if state.presentationDirection == .left {
                    InteractiveSpacer().onTapGesture {
                        state.isExpanded.toggle()
                    }
                }
            }
            .background(state.isExpanded ? backgroundLayerColor.opacity(backgroundLayerOpacity) : Color.clear)
            .gesture(dragGesture(snapWidth: proxy.portraitOrientationAgnosticSize().width * percentSnapWidthOfScreen))
        }
    }
}

// MARK: Utilieties + Helpers

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

// MARK: Composite View

public struct InteractiveSpacer: View {
    public var body: some View {
        ZStack {
            Color.black.opacity(0.001)
        }
    }
}
