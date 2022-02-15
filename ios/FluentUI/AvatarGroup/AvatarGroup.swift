//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that can be used to customize the appearance of the AvatarGroup.
@objc public protocol MSFAvatarGroupState {

    /// Caps the number of displayed avatars and shows the remaining not displayed in the overflow avatar.
    var maxDisplayedAvatars: Int { get set }

    /// Adds to the overflow count in case the calling code did not provide all the avatars, but still wants to convey more
    /// items than just the remainder of the avatars that could not be displayed due to the maxDisplayedAvatars property.
    var overflowCount: Int { get set }

    ///  Style of the AvatarGroup.
    var style: MSFAvatarGroupStyle { get set }

    ///  Size of the AvatarGroup.
    var size: MSFAvatarSize { get set }

    /// Creates a new Avatar within the AvatarGroup.
    func createAvatar() -> MSFAvatarGroupAvatarState

    /// Creates a new Avatar within the AvatarGroup at a specific index.
    func createAvatar(at index: Int) -> MSFAvatarGroupAvatarState

    /// Retrieves the state object for a specific Avatar so its appearance can be customized.
    /// - Parameter index: The zero-based index of the Avatar in the AvatarGroup.
    func getAvatarState(at index: Int) -> MSFAvatarGroupAvatarState

    /// Remove an Avatar from the AvatarGroup.
    /// - Parameter index: The zero-based index of the Avatar that will be removed from the AvatarGroup.
    func removeAvatar(at index: Int)

    /// Custom design token set for this control
    var overrideTokens: AvatarGroupTokens? { get set }
}

/// Enumeration of the styles used by the AvatarGroup.
/// The stack style presents Avatars laid on top of each other.
/// The pile style presents Avatars side by side.
@objc public enum MSFAvatarGroupStyle: Int, CaseIterable {
    case stack
    case pile
}

/// Properties that can be used to customize the appearance of the Avatar in the AvatarGroup.
@objc public protocol MSFAvatarGroupAvatarState {
    /// Sets the accessibility label for the Avatar.
    var accessibilityLabel: String? { get set }

    /// Sets a custom background color for the Avatar.
    /// The ring color inherit this color if not set explicitly to a different color.
    var backgroundColor: UIColor? { get set }

    /// The custom foreground color.
    /// This property allows customizing the initials text color or the default image tint color.
    var foregroundColor: UIColor? { get set }

    /// Whether the gap between the ring and the avatar content exists.
    var hasRingInnerGap: Bool { get set }

    /// The image used in the avatar content.
    var image: UIImage? { get set }

    /// The image used to fill the ring as a custom color.
    var imageBasedRingColor: UIImage? { get set }

    /// Displays an outer ring for the avatar if set to true.
    /// The group style does not support rings.
    var isRingVisible: Bool { get set }

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence icon outline).
    /// Uses the solid default background color if set to false.
    var isTransparent: Bool { get set }

    /// The primary text of the avatar.
    /// Used for computing the initials and background/ring colors.
    var primaryText: String? { get set }

    /// Overrides the default ring color.
    var ringColor: UIColor? { get set }

    /// The secondary text of the avatar.
    /// Used for computing the initials and background/ring colors if primaryText is not set.
    var secondaryText: String? { get set }
}

/// View that represents the AvatarGroup.
public struct AvatarGroup: View, TokenizedControlConfigurable {
    /// Creates and initializes a SwiftUI AvatarGroup.
    /// - Parameters:
    ///   - style: The style of the avatar group.
    ///   - size: The size of the avatars displayed in the avatar group.
    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        let state = MSFAvatarGroupStateImpl(style: style,
                                            size: size)
        self.state = state
    }

    /// Renders the avatar with an optional cutout for the Stack group style.
    @ViewBuilder
    private func avatarCutout(_ avatar: Avatar,
                              _ needsCutout: Bool,
                              _ xOrigin: CGFloat,
                              _ yOrigin: CGFloat,
                              _ cutoutSize: CGFloat,
                              _ padding: CGFloat) -> some View {
        avatar.modifyIf(needsCutout, { view in
            view.clipShape(Avatar.AvatarCutout(xOrigin: xOrigin,
                                               yOrigin: yOrigin,
                                               cutoutSize: cutoutSize),
                           style: FillStyle(eoFill: true))
            })
            .padding(.trailing, padding)
    }

    public var body: some View {
        let avatars: [MSFAvatarStateImpl] = state.avatars
        let avatarViews: [Avatar] = avatars.map { Avatar($0) }
        let enumeratedAvatars = Array(avatars.enumerated())
        let maxDisplayedAvatars: Int = avatars.prefix(state.maxDisplayedAvatars).count
        let overflowCount: Int = (avatars.count > maxDisplayedAvatars ? avatars.count - maxDisplayedAvatars : 0) + state.overflowCount

        let interspace: CGFloat = tokens.interspace
        let imageSize: CGFloat = tokens.size.size
        let ringOuterGap: CGFloat = tokens.ringOuterGap
        let ringGapOffset: CGFloat = ringOuterGap * 2
        let ringOffset: CGFloat = tokens.ringThickness + tokens.ringInnerGap + tokens.ringOuterGap

        let groupHeight: CGFloat = imageSize + (ringOffset * 2)

        @ViewBuilder
        var avatarGroupContent: some View {
            HStack(spacing: 0) {
                ForEach(enumeratedAvatars.prefix(maxDisplayedAvatars), id: \.1) { index, avatar in
                    // If the avatar is part of Stack style and is not the last avatar in the sequence, create a cutout.
                    let avatarView = avatarViews[index]
                    let needsCutout = tokens.style == .stack && (overflowCount > 0 || index + 1 < maxDisplayedAvatars)
                    let avatarSize: CGFloat = avatarView.state.totalSize()
                    let nextAvatarSize: CGFloat = needsCutout ? avatarViews[index + 1].state.totalSize() : 0
                    let isLastDisplayed = index == maxDisplayedAvatars - 1

                    // Calculating the size delta of the current and next avatar based off of ring visibility, which helps determine
                    // starting coordinates for the cutout.
                    let currentAvatarHasRing = avatar.isRingVisible
                    let nextAvatarHasRing = index + 1 < maxDisplayedAvatars ? avatars[index + 1].isRingVisible : false
                    let avatarSizeDifference = avatarSize - nextAvatarSize
                    let sizeDiff = !isLastDisplayed ? (currentAvatarHasRing ? avatarSizeDifference : avatarSizeDifference - ringGapOffset) :
                    currentAvatarHasRing ? (avatarSize - ringGapOffset) - imageSize : (avatarSize - (ringGapOffset * 2)) - imageSize
                    let x = avatarSize + tokens.interspace - ringGapOffset

                    // Calculating the different interspace scenarios considering rings.
                    let ringPaddingInterspace = nextAvatarHasRing ? interspace - (ringOffset + ringOuterGap) : interspace - ringOffset
                    let noRingPaddingInterspace = nextAvatarHasRing ? interspace - ringOuterGap : interspace
                    let stackPadding = (currentAvatarHasRing ? ringPaddingInterspace : noRingPaddingInterspace)

                    // Finalized calculations for x and y coordinates of the Avatar if it needs a cutout, including RTL.
                    let cutoutSize = isLastDisplayed ? (ringOuterGap * 2) + imageSize : nextAvatarSize
                    let xOrigin: CGFloat = {
                        if layoutDirection == .rightToLeft {
                            return -cutoutSize - interspace + ringOuterGap + (currentAvatarHasRing ? ringOffset : 0)
                        }
                        return x - ringOuterGap - (currentAvatarHasRing ? ringOuterGap : 0)
                    }()
                    let yOrigin = sizeDiff / 2

                    // Hand the rendering of the avatar to a helper function to appease Swift's
                    // strict type-checking timeout.
                    VStack {
                        avatarView
                            .transition(.identity)
                            .modifyIf(needsCutout, { view in
                                view.mask(Avatar.AvatarCutout(
                                    xOrigin: xOrigin,
                                    yOrigin: yOrigin,
                                    cutoutSize: cutoutSize)
                                            .fill(style: FillStyle(eoFill: true)))
                            })
                    }
                    .padding(.trailing, tokens.style == .stack ? stackPadding : interspace)
                    .animation(Animation.linear(duration: animationDuration))
                    .transition(AnyTransition.move(edge: .leading))
                }

                if overflowCount > 0 {
                    VStack {
                        createOverflow(count: overflowCount)
                    }
                    .animation(Animation.linear(duration: animationDuration))
                    .transition(AnyTransition.move(edge: .leading))
                }
            }
            .frame(maxWidth: .infinity,
                   minHeight: groupHeight,
                   maxHeight: .infinity,
                   alignment: .leading)
        }

        return avatarGroupContent
    }

    var tokens: AvatarGroupTokens { state.tokens }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    @ObservedObject var state: MSFAvatarGroupStateImpl

    private let animationDuration: CGFloat = 0.1

    private func createOverflow(count: Int) -> Avatar {
        var avatar = Avatar(style: .overflow, size: tokens.size)
        let data = MSFAvatarStateImpl(style: .overflow, size: tokens.size)
        data.primaryText = "\(count)"
        data.image = nil
        avatar.state = data
        return avatar
    }
}

class MSFAvatarGroupStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFAvatarGroupState {
    func createAvatar() -> MSFAvatarGroupAvatarState {
        return createAvatar(at: avatars.endIndex)
    }

    func createAvatar(at index: Int) -> MSFAvatarGroupAvatarState {
        guard index <= avatars.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let avatar = MSFAvatarGroupAvatarStateImpl(size: tokens.size)
        avatars.insert(avatar, at: index)
        return avatar
    }

    func getAvatarState(at index: Int) -> MSFAvatarGroupAvatarState {
        guard avatars.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return avatars[index]
    }

    func removeAvatar(at index: Int) {
        guard avatars.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        avatars.remove(at: index)
    }

    @Published var avatars: [MSFAvatarGroupAvatarStateImpl] = []
    @Published var maxDisplayedAvatars: Int = Int.max
    @Published var overflowCount: Int = 0

    @Published var style: MSFAvatarGroupStyle {
        didSet {
            tokens.style = style
        }
    }
    @Published var size: MSFAvatarSize {
        didSet {
            tokens.size = size
        }
    }

    @Published var overrideTokens: AvatarGroupTokens?
    @Published var tokens: AvatarGroupTokens = .init() {
        didSet {
            tokens.style = style
            tokens.size = size
        }
    }

    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        self.style = style
        self.size = size

        let tokens = AvatarGroupTokens()
        tokens.style = style
        tokens.size = size
        self.tokens = tokens

        super.init()
    }
}

class MSFAvatarGroupAvatarStateImpl: MSFAvatarStateImpl, MSFAvatarGroupAvatarState {
    init(size: MSFAvatarSize) {
        super.init(style: .default, size: size)
    }
}
