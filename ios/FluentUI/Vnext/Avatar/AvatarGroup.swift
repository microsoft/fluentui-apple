//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public enum MSFAvatarGroupStyle: Int, CaseIterable {
    case stack
    case pile
}

@objc public protocol MSFAvatarGroupState {
    var maxDisplayedAvatars: UInt32 { get set }
    var overflowCount: UInt { get set }
    var style: MSFAvatarGroupStyle { get set }

    func createAvatar(style: MSFAvatarStyle, size: MSFAvatarSize)
    func getAvatarState(_ atIndex: Int) -> MSFAvatarState
    func deleteAvatar(atIndex: Int)
}

/// Properties that make up AvatarGroup content
class MSFAvatarGroupStateImpl: NSObject, ObservableObject, MSFAvatarGroupState {
    func createAvatar(style: MSFAvatarStyle, size: MSFAvatarSize) {
        avatars.append(AvatarView(style: style, size: size))
    }

    func getAvatarState(_ atIndex: Int) -> MSFAvatarState {
        return avatars[atIndex].state
    }

    func deleteAvatar(atIndex: Int) {
        avatars.remove(at: atIndex)
    }

    @Published var avatars: [AvatarView] = []
    @Published var maxDisplayedAvatars: UInt32 = UInt32.max
    @Published var overflowCount: UInt = 0

    var size: MSFAvatarSize {
        get {
            return tokens.size
        }
        set {
            tokens.size = newValue
        }
    }

    var style: MSFAvatarGroupStyle {
        get {
            return tokens.style
        }
        set {
            tokens.style = newValue
        }
    }

    var tokens: MSFAvatarGroupTokens

    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        self.tokens = MSFAvatarGroupTokens(style: style,
                                      size: size)
        super.init()
    }
}

/// View that represents the AvatarGroup
public struct AvatarGroup: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: MSFAvatarGroupStateImpl
    @ObservedObject var tokens: MSFAvatarGroupTokens

    init(style: MSFAvatarGroupStyle, size: MSFAvatarSize) {
        let state = MSFAvatarGroupStateImpl(style: style, size: size)
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let size: CGFloat = tokens.size.size
        let x: CGFloat = size + tokens.interspace - tokens.ringOuterGap - tokens.ringThickness
        let avatars: [AvatarView] = state.avatars
        let maxDisplayedAvatars: Int = avatars.prefix(Int(state.maxDisplayedAvatars)).count
        let overflowCount: Int = Int((avatars.count > maxDisplayedAvatars ? UInt(avatars.count - maxDisplayedAvatars) : 0) + state.overflowCount)
        HStack(spacing: 0) {
            ForEach(0 ..< maxDisplayedAvatars, id: \.self) { index in
                let modify = tokens.style == .stack && (overflowCount > 0 || index + 1 < maxDisplayedAvatars)
                state.avatars[index]
                    .modifyIf(modify, { view in
                        view.mask(AvatarCutout(xOrigin: x,
                                               yOrigin: 0,
                                               cutoutSize: size)
                                    .fill(style: FillStyle(eoFill: true)))
                    })
                    .padding(.trailing, tokens.interspace)
            }
            if overflowCount > 0 {
                createOverflow(count: overflowCount)
            }
        }
    }

    private func createOverflow(count: Int) -> AvatarView {
        var avatar = AvatarView(style: .overflow, size: tokens.size)
        let data = MSFAvatarStateImpl(style: .overflow, size: tokens.size)
        data.primaryText = "\(count)"
        data.image = nil
        avatar.state = data
        return avatar
    }

    /// Cutout shape for the succeeding Avatar in an Avatar Group in Stack style.
    ///
    /// xOrigin: beginning location of cutout on the x axis
    ///
    /// yOrigin: beginning location of cutout on the y axis
    ///
    /// cutoutSize: dimensions of cutout shape of the Avatar
    private struct AvatarCutout: Shape {
        var xOrigin: CGFloat
        var yOrigin: CGFloat
        var cutoutSize: CGFloat

        func path(in rect: CGRect) -> Path {
                var cutoutFrame = Rectangle().path(in: rect)
                cutoutFrame.addPath(Circle().path(in: CGRect(x: xOrigin,
                                                             y: yOrigin,
                                                             width: cutoutSize,
                                                             height: cutoutSize)))
                return cutoutFrame
        }
    }
}

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation
@objc open class MSFAvatarGroup: NSObject, FluentUIWindowProvider {
    @objc public init(style: MSFAvatarGroupStyle = .stack, size: MSFAvatarSize = .large, theme: FluentUIStyle? = nil) {
        super.init()

        avatarGroupView = AvatarGroup(style: style, size: size)
        hostingController = UIHostingController(rootView: AnyView(avatarGroupView
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaView in
                                                                        personaView.customTheme(theme!)
                                                                    })))
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience override init() {
        self.init(theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFAvatarGroupState {
        return avatarGroupView.state
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var avatarGroupView: AvatarGroup!
}
