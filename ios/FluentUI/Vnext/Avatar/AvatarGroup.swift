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
//
/// `MSFAvatarGroupState` defines properties in an AvatarGroup
///
/// `maxDisplayedAvatars`: Maximum number of avatars displayed
///
/// `overflowCount`: Number to be displayed in the overflow avatar
///
/// `style`: Type of AvatarGroup. Avatars in a Stack is layered on top of each other; Pile separates avatars
///
/// `createAvatar`: Create an Avatar using an AvatarStyle and AvatarSize
///
/// `getAvatarState`: Get the state of an Avatar using an index value
///
/// `deleteAvatar`: Delete an Avatar with a specified index value
@objc public protocol MSFAvatarGroupState {
    var maxDisplayedAvatars: Int { get set }
    var overflowCount: Int { get set }
    var style: MSFAvatarGroupStyle { get set }

    func createAvatar(style: MSFAvatarStyle, size: MSFAvatarSize)
    func getAvatarState(_ atIndex: Int) -> MSFAvatarState?
    func deleteAvatar(atIndex: Int)
}

/// Properties that make up AvatarGroup content
class MSFAvatarGroupStateImpl: NSObject, ObservableObject, MSFAvatarGroupState {
    func createAvatar(style: MSFAvatarStyle, size: MSFAvatarSize) {
        avatars.append(AvatarView(style: style, size: size))
    }

    func getAvatarState(_ atIndex: Int) -> MSFAvatarState? {
        if atIndex >= avatars.count {
            print("Requested index is out of bounds!")
            return nil
        } else {
            return avatars[atIndex].state
        }
    }

    func deleteAvatar(atIndex: Int) {
        avatars.remove(at: atIndex)
    }

    @Published var avatars: [AvatarView] = []
    @Published var maxDisplayedAvatars: Int = Int.max
    @Published var overflowCount: Int = 0

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
        let x: CGFloat = size + tokens.interspace - tokens.ringThickness
        let avatars: [AvatarView] = state.avatars
        let maxDisplayedAvatars: Int = avatars.prefix(state.maxDisplayedAvatars).count
        let overflowCount: Int = (avatars.count > maxDisplayedAvatars ? avatars.count - maxDisplayedAvatars : 0) + state.overflowCount
        HStack(spacing: 0) {
            ForEach(0 ..< maxDisplayedAvatars, id: \.self) { index in
                // If the avatar is part of Stack style and is not the last avatar in the sequence, create a cutout
                let needsCutout = tokens.style == .stack && (overflowCount > 0 || index + 1 < maxDisplayedAvatars)
                state.avatars[index]
                    .modifyIf(needsCutout, { view in
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

    /// `AvatarCutout`: Cutout shape for  succeeding Avatar in an Avatar Group in Stack style.
    ///
    /// `xOrigin`: beginning location of cutout on the x axis
    ///
    /// `yOrigin`: beginning location of cutout on the y axis
    ///
    /// `cutoutSize`: dimensions of cutout shape of the Avatar
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
                                                                    .modifyIf(theme != nil, { avatarGroupView in
                                                                        avatarGroupView.customTheme(theme!)
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
