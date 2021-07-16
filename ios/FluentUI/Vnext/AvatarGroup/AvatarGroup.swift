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

/// Properties available to customize the state of the Avatar in an Avatar Group
@objc public protocol MSFAvatarGroupAvatarState {
    var accessibilityLabel: String? { get set }
    var backgroundColor: UIColor? { get set }
    var foregroundColor: UIColor? { get set }
    var hasRingInnerGap: Bool { get set }
    var image: UIImage? { get set }
    var imageBasedRingColor: UIImage? { get set }
    var isRingVisible: Bool { get set }
    var isTransparent: Bool { get set }
    var primaryText: String? { get set }
    var ringColor: UIColor? { get set }
    var secondaryText: String? { get set }
}

/// `MSFAvatarGroupState` defines properties in an AvatarGroup
///
/// `maxDisplayedAvatars`: Caps the number of displayed avatars and shows the remaining not displayed in the overflow avatar
///
/// `overflowCount`: Adds to the overflow count in case the calling code did not provide all the avatars, but still wants to convey more
/// items than just the remainder of the avatars that could not be displayed due to the maxDisplayedAvatars property.
///
/// `style`: Type of AvatarGroup. Avatars in a Stack is layered on top of each other; Pile separates avatars
///
/// `createAvatar`: Creates an Avatar using an AvatarStyle and AvatarSize
///
/// `getAvatarState`: Gets the state of an Avatar using an index value
///
/// `removeAvatar`: Removes an Avatar with a specified index value
@objc public protocol MSFAvatarGroupState {
    var maxDisplayedAvatars: Int { get set }
    var overflowCount: Int { get set }
    var style: MSFAvatarGroupStyle { get set }

    func createAvatar() -> MSFAvatarGroupAvatarState
    func getAvatarState(at index: Int) -> MSFAvatarGroupAvatarState
    func removeAvatar(at index: Int)
}

/// Implementation of the Avatar state that is specific to be used in the Avatar Group
class MSFAvatarGroupAvatarStateImpl: MSFAvatarStateImpl, MSFAvatarGroupAvatarState {
    init(size: MSFAvatarSize) {
        super.init(style: .default, size: size)
    }
}

/// Properties that make up AvatarGroup content
class MSFAvatarGroupStateImpl: NSObject, ObservableObject, MSFAvatarGroupState {
    func createAvatar() -> MSFAvatarGroupAvatarState {
        let avatar = MSFAvatarGroupAvatarStateImpl(size: tokens.size)
        avatars.append(avatar)
        return avatar
    }

    func getAvatarState(at index: Int) -> MSFAvatarGroupAvatarState {
        guard index < avatars.count else {
            preconditionFailure("Index is out of bounds")
        }
        return avatars[index]
    }

    func removeAvatar(at index: Int) {
        guard index < avatars.count else {
            preconditionFailure("Index is out of bounds")
        }
        avatars.remove(at: index)
    }

    @Published var avatars: [MSFAvatarGroupAvatarStateImpl] = []
    @Published var maxDisplayedAvatars: Int = Int.max
    @Published var overflowCount: Int = 0

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
        let avatars: [MSFAvatarStateImpl] = state.avatars
        let maxDisplayedAvatars: Int = avatars.prefix(state.maxDisplayedAvatars).count
        let overflowCount: Int = (avatars.count > maxDisplayedAvatars ? avatars.count - maxDisplayedAvatars : 0) + state.overflowCount

        let interspace: CGFloat = tokens.interspace
        let size: CGFloat = tokens.size.size
        let ringOuterGap: CGFloat = tokens.ringOuterGap
        let ringOffset: CGFloat = tokens.ringThickness + tokens.ringInnerGap + tokens.ringOuterGap
        let x: CGFloat = size + tokens.interspace - tokens.ringThickness
        HStack(spacing: 0) {
            ForEach(0 ..< maxDisplayedAvatars, id: \.self) { index in
                // If the avatar is part of Stack style and is not the last avatar in the sequence, create a cutout
                let needsCutout = tokens.style == .stack && (overflowCount > 0 || index + 1 < maxDisplayedAvatars)
                let avatar = avatars[index]
                let currentAvatarHasRing = avatar.isRingVisible
                let nextAvatarHasRing = index + 1 < maxDisplayedAvatars ? avatars[index + 1].isRingVisible : false

                let ringPaddingInterspace = nextAvatarHasRing ? interspace - (ringOffset + ringOuterGap) : interspace - ringOffset
                let noRingPaddingInterspace = nextAvatarHasRing ? interspace - ringOuterGap : interspace
                let stackPadding = (currentAvatarHasRing ? ringPaddingInterspace : noRingPaddingInterspace)

                let xOrigin = currentAvatarHasRing ? x + ringOffset : x
                let yOrigin = currentAvatarHasRing ? (nextAvatarHasRing ? ringOuterGap : ringOffset) :
                    (nextAvatarHasRing ? 0 - ringOffset + tokens.ringOuterGap : 0)
                let cutoutSize = nextAvatarHasRing ? size + ringOffset + ringOuterGap : size

                AvatarView(avatar)
                    .modifyIf(needsCutout, { view in
                        view.mask(AvatarCutout(xOrigin: xOrigin,
                                               yOrigin: yOrigin,
                                               cutoutSize: cutoutSize)
                                    .fill(style: FillStyle(eoFill: true)))
                    })
                    .padding(.trailing, tokens.style == .stack ? stackPadding : interspace)
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
