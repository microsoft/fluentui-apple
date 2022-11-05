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
public struct AvatarGroup: View, TokenizedControlView {
    public typealias TokenSetKeyType = AvatarGroupTokenSet.Tokens
    @ObservedObject public var tokenSet: AvatarGroupTokenSet

    /// Creates and initializes a SwiftUI AvatarGroup.
    /// - Parameters:
    ///   - style: The style of the avatar group.
    ///   - size: The size of the avatars displayed in the avatar group.
    public init(style: MSFAvatarGroupStyle,
                size: MSFAvatarSize) {
        let state = MSFAvatarGroupStateImpl(style: style,
                                            size: size)
        self.state = state
        self.tokenSet = AvatarGroupTokenSet(style: { state.style },
                                            size: { state.size })
    }

    public var body: some View {
        let avatars: [MSFAvatarStateImpl] = state.avatars
        let avatarViews: [Avatar] = avatars.map { Avatar($0) }
        let enumeratedAvatars = Array(avatars.enumerated())
        let avatarCount: Int = avatars.count
        let maxDisplayedAvatars: Int = state.maxDisplayedAvatars
        let avatarsToDisplay: Int = min(maxDisplayedAvatars, avatarCount)
        let overflowCount: Int = (avatarCount > maxDisplayedAvatars ? avatarCount - maxDisplayedAvatars : 0) + state.overflowCount
        let hasOverflow: Bool = overflowCount > 0
        let isStackStyle = state.style == .stack

        let overflowAvatar = createOverflow(count: overflowCount)

        let interspace: CGFloat = tokenSet[.interspace].float

        let groupHeight: CGFloat = {
            let avatarMaxHeight: CGFloat
            if let avatar = avatarViews.first {
                let avatarSize = avatar.contentSize
                let ringThickness = avatar.tokenSet[.ringThickness].float
                let ringInnerGap = avatar.tokenSet[.ringInnerGap].float
                let ringOuterGap = avatar.tokenSet[.ringOuterGap].float

                avatarMaxHeight = avatarSize + (2 * ringThickness) + ringInnerGap + ringOuterGap
            } else {
                avatarMaxHeight = 0
            }

            // Use the overflow tokens as a default in case we have no Avatars to show
            let avatarSize = overflowAvatar.contentSize
            let ringThickness = overflowAvatar.tokenSet[.ringThickness].float
            let ringInnerGap = overflowAvatar.tokenSet[.ringInnerGap].float
            let ringOuterGap = overflowAvatar.tokenSet[.ringOuterGap].float

            let overflowMaxHeight = avatarSize + (2 * ringThickness) + ringInnerGap + ringOuterGap

            return max(avatarMaxHeight, overflowMaxHeight)
        }()

        @ViewBuilder
        func avatarView(at index: Int, for avatar: MSFAvatarStateImpl) -> some View {
            let nextIndex = index + 1
            let isLastDisplayed = nextIndex == avatarsToDisplay
            // If the avatar is part of Stack style and is not the last avatar in the sequence, create a cutout.
            let avatarView = avatarViews[index]
            let needsCutout = isStackStyle && (hasOverflow || !isLastDisplayed)
            let avatarSize: CGFloat = avatarView.totalSize
            let nextAvatarSize: CGFloat = isLastDisplayed ? overflowAvatar.totalSize : avatarViews[nextIndex].totalSize

            // Calculating the size delta of the current and next avatar based off of ring visibility, which helps determine
            // starting coordinates for the cutout.
            let currentAvatarHasRing = avatar.isRingVisible
            let nextAvatarHasRing = !isLastDisplayed ? avatars[nextIndex].isRingVisible : false

            // Calculating the different interspace scenarios considering rings.
            let ringOuterGap = avatarView.tokenSet[.ringOuterGap].float
            let ringOffset = avatarView.tokenSet[.ringInnerGap].float + avatarView.tokenSet[.ringThickness].float + ringOuterGap
            let stackPadding = interspace - (currentAvatarHasRing ? ringOffset : 0) - (nextAvatarHasRing ? ringOuterGap : 0)

            // Finalized calculations for x and y coordinates of the Avatar if it needs a cutout, including RTL.
            let ringGapOffset = 2 * ringOuterGap
            let xOrigin: CGFloat = {
                if layoutDirection == .rightToLeft {
                    return -nextAvatarSize - interspace + ringOuterGap + (currentAvatarHasRing ? ringOffset : 0)
                }
                return avatarSize + interspace - ringGapOffset - ringOuterGap - (currentAvatarHasRing ? ringOuterGap : 0)
            }()

            let sizeDiff = avatarSize - nextAvatarSize - (currentAvatarHasRing ? 0 : ringGapOffset)
            let yOrigin = sizeDiff / 2

            // Hand the rendering of the avatar to a helper function to appease Swift's
            // strict type-checking timeout.
            VStack {
                avatarView
                    .transition(.identity)
                    .modifyIf(needsCutout, { view in
                        view.clipShape(CircleCutout(xOrigin: xOrigin,
                                                    yOrigin: yOrigin,
                                                    cutoutSize: nextAvatarSize),
                                       style: FillStyle(eoFill: true))
                    })
            }
            .padding(.trailing, isStackStyle ? stackPadding : interspace)
        }

        @ViewBuilder
        var avatarGroupContent: some View {
            let animation = Animation.linear(duration: animationDuration)

            HStack(spacing: 0) {
                ForEach(enumeratedAvatars.prefix(avatarsToDisplay), id: \.1) { index, avatar in
                    avatarView(at: index, for: avatar)
                        .transition(AnyTransition.move(edge: .leading))
                }

                if hasOverflow {
                    VStack {
                        overflowAvatar
                    }
                    .transition(AnyTransition.move(edge: .leading))
                }
            }
            .animation(animation, value: state.avatars)
            .animation(animation, value: [state.maxDisplayedAvatars, state.overflowCount])
            .animation(animation, value: state.style)
            .animation(animation, value: state.size)
            .frame(maxWidth: .infinity,
                   minHeight: groupHeight,
                   maxHeight: .infinity,
                   alignment: .leading)
        }

        return avatarGroupContent
            .fluentTokens(tokenSet, fluentTheme)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    @ObservedObject var state: MSFAvatarGroupStateImpl

    private let animationDuration: CGFloat = 0.1

    private func createOverflow(count: Int) -> Avatar {
        let state = MSFAvatarStateImpl(style: .overflow, size: state.size)
        state.primaryText = "\(count)"
        state.image = nil
        return Avatar(state)
    }
}

class MSFAvatarGroupStateImpl: ControlState, MSFAvatarGroupState {
    func createAvatar() -> MSFAvatarGroupAvatarState {
        return createAvatar(at: avatars.endIndex)
    }

    func createAvatar(at index: Int) -> MSFAvatarGroupAvatarState {
        guard index <= avatars.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let avatar = MSFAvatarGroupAvatarStateImpl(size: size)
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

    @Published var style: MSFAvatarGroupStyle
    @Published var size: MSFAvatarSize

    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        self.style = style
        self.size = size

        super.init()
    }
}

class MSFAvatarGroupAvatarStateImpl: MSFAvatarStateImpl, MSFAvatarGroupAvatarState {
    init(size: MSFAvatarSize) {
        super.init(style: .default, size: size)
    }
}
