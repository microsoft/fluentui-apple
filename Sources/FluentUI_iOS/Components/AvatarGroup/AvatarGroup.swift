//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI
import UIKit

/// Properties that can be used to customize the appearance of the AvatarGroup.
@objc public protocol MSFAvatarGroupState {

    /// Caps the number of displayed avatars and shows the remaining not displayed in the overflow avatar.
    var maxDisplayedAvatars: Int { get set }

    /// Adds to the overflow count in case the calling code did not provide all the avatars, but still wants to convey more
    /// items than just the remainder of the avatars that could not be displayed due to the maxDisplayedAvatars property.
    var overflowCount: Int { get set }

    /// Whether a background-colored outline should be drawn behind all Avatars, including the overflow.
    var hasBackgroundOutline: Bool { get set }

    /// Show a top-trailing aligned unread dot when set to true.
    var isUnread: Bool { get set }

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

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence, activity icon outline).
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

    /// Creates and initializes a SwiftUI `AvatarGroup`.
    /// - Parameters:
    ///   - style: The style of the avatar group.
    ///   - size: The size of the avatars displayed in the avatar group.
    ///   - avatarCount: The number of Avatars in this group.
    ///   - maxDisplayedAvatars: Caps the number of displayed avatars and shows the remaining not displayed in the overflow avatar.
    ///   - overflowCount: Adds to the overflow count in case the calling code did not provide all the avatars, but still wants to convey more
    ///                    items than just the remainder of the avatars that could not be displayed due to the maxDisplayedAvatars property.
    ///   - hasBackgroundOutline: Whether a background-colored outline should be drawn behind all Avatars, including the overflow.
    ///   - isUnread: Show a top-trailing aligned unread dot when set to true.
    ///   - avatarBuilder: A ViewBuilder that creates an `Avatar` for a given index.
    public init(style: MSFAvatarGroupStyle,
                size: MSFAvatarSize,
                avatarCount: Int = 0,
                maxDisplayedAvatars: Int = Int.max,
                overflowCount: Int = 0,
                hasBackgroundOutline: Bool = false,
                isUnread: Bool = false,
                @ViewBuilder avatarBuilder: @escaping (_ index: Int) -> Avatar) {
        // Configure the avatars
        let avatars = (0..<avatarCount).map { index in
            let avatar = avatarBuilder(index)
            avatar.state.size = size
            avatar.state.style = .default
            avatar.state.hasBackgroundOutline = hasBackgroundOutline
            return avatar
        }

        let state = MSFAvatarGroupStateImpl(style: style,
                                            size: size)
        state.avatars = avatars
        state.maxDisplayedAvatars = maxDisplayedAvatars
        state.overflowCount = overflowCount
        state.hasBackgroundOutline = hasBackgroundOutline
        state.isUnread = isUnread

        self.state = state
        self.tokenSet = AvatarGroupTokenSet(style: { state.style },
                                            size: { state.size })
    }

    public var body: some View {
        tokenSet.update(fluentTheme)
        let avatars = state.avatars
        let avatarCount: Int = avatars.count
        let maxDisplayedAvatars: Int = state.maxDisplayedAvatars
        let avatarsToDisplay = avatarsToDisplay
        let overflowCount: Int = (avatarCount > maxDisplayedAvatars ? avatarCount - maxDisplayedAvatars : 0) + state.overflowCount
        let hasOverflow: Bool = overflowCount > 0
        let isStackStyle = state.style == .stack

        let overflowAvatar = createOverflow(count: overflowCount)

        let interspace: CGFloat = tokenSet[.interspace].float

        let groupHeight: CGFloat = {
            let avatarMaxHeight: CGFloat
            if let avatar = avatars.first {
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
        func avatarView(at index: Int, for avatar: Avatar) -> some View {
            let nextIndex = index + 1
            let isLastDisplayed = nextIndex == avatarsToDisplay

            // Calculating the size delta of the current and next avatar based off of ring visibility, which helps determine
            // starting coordinates for the cutout.
            let currentAvatarHasRing = avatar.state.isRingVisible
            let nextAvatarHasRing = !isLastDisplayed ? avatars[nextIndex].state.isRingVisible : false

            // Calculating the different interspace scenarios considering rings.
            let ringOuterGap = avatar.tokenSet[.ringOuterGap].float
            let ringOffset = avatar.tokenSet[.ringInnerGap].float + avatar.tokenSet[.ringThickness].float + ringOuterGap
            let stackPadding = interspace - (currentAvatarHasRing ? ringOffset : 0) - (nextAvatarHasRing ? ringOuterGap : 0)

            avatar
                .transition(.identity)
                .onChange(of: state.size) { _, size in
                    avatar.state.size = size
                }
            .padding(.trailing, (isLastDisplayed && !hasOverflow) ? 0 : isStackStyle ? stackPadding : interspace)
        }

        @ViewBuilder
        var avatarGroup: some View {
            HStack(spacing: 0) {
                ForEach(0..<avatarsToDisplay, id: \.self) { index in
                    let avatar = avatars[index]
                    avatarView(at: index, for: avatar)
                        .transition(AnyTransition.opacity)
                }

                if hasOverflow {
                    VStack {
                        overflowAvatar
                    }
                    .transition(AnyTransition.opacity)
                }
            }
        }

        @ViewBuilder
        var unreadGroup: some View {
            if state.isUnread {
                let strokeWidth = AvatarGroupTokenSet.unreadDotStrokeWidth
                let dotSize = AvatarGroupTokenSet.unreadDotSize
                avatarGroup
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .foregroundColor(Color(tokenSet[.unreadDotColor].uiColor))
                            .frame(width: dotSize, height: dotSize)
                            // Add half the strokeWidth as padding to get the stroke drawn around the outside of the
                            // dot instead of having the stroke centered on the edge of the dot, but it needs to be
                            // inset slightly to not have a gap.
                            .padding(strokeWidth / 2 - strokeInset)
                            .overlay {
                                Circle()
                                    .stroke(Color(tokenSet[.backgroundColor].uiColor),
                                            lineWidth: strokeWidth)
                            }
                            .offset(x: AvatarGroupTokenSet.unreadDotHorizontalOffset,
                                    y: AvatarGroupTokenSet.unreadDotVerticalOffset)
                    }
            } else {
                avatarGroup
            }
        }

        @ViewBuilder
        var animatedGroup: some View {
            let animation = Animation.linear(duration: animationDuration)
            unreadGroup
                .animation(animation, value: state.avatars)
                .animation(animation, value: [state.maxDisplayedAvatars, state.overflowCount])
                .animation(animation, value: state.style)
                .animation(animation, value: state.size)
                .frame(maxWidth: .infinity,
                       minHeight: groupHeight,
                       maxHeight: .infinity,
                       alignment: .leading)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(groupLabel)
        }

        return animatedGroup
    }

    var avatarsToDisplay: Int {
        return min(state.maxDisplayedAvatars, state.avatars.count)
    }

    var displayedAvatarAccessibilityLabels: [String] {
        var labels: [String] = []
        for i in 0..<avatarsToDisplay {
            let avatarState = state.avatars[i].state
            if let label = avatarState.accessibilityLabel ?? avatarState.primaryText ?? avatarState.secondaryText {
                labels.append(label)
            }
        }
        let overflowCount = state.avatars.count - avatarsToDisplay + state.overflowCount
        if overflowCount > 0 {
            labels.append(String(format: "Accessibility.AvatarGroup.Overflow.Value".localized, overflowCount))
        }
        return labels
    }

    var groupLabel: String {
        let displayedAvatarCount = displayedAvatarAccessibilityLabels.count
        guard displayedAvatarCount > 1 else {
            return displayedAvatarAccessibilityLabels.last ?? ""
        }

        var str: String = ""
        for i in 0..<displayedAvatarCount - 1 {
            str += String(format: "Accessibility.AvatarGroup.AvatarList".localized, displayedAvatarAccessibilityLabels[i])
        }
        str += String(format: "Accessibility.AvatarGroup.AvatarListLast".localized, displayedAvatarAccessibilityLabels.last ?? "")

        if state.isUnread {
            str = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, str)
        }

        return str
    }

    /// Creates and initializes a SwiftUI `AvatarGroup`.
    ///
    /// This internal initializer is used exclusively for our UIKit wrapper, and should not be made public.
    ///
    /// - Parameters:
    ///   - style: The style of the avatar group.
    ///   - size: The size of the avatars displayed in the avatar group.
    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        self.init(style: style,
                  size: size,
                  avatarCount: 0) { _ in
            Avatar(style: .default, size: .size32)
        }
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    @ObservedObject var state: MSFAvatarGroupStateImpl

    private let animationDuration: CGFloat = 0.1
    private let strokeInset: CGFloat = 0.1

    private func createOverflow(count: Int) -> Avatar {
        let state = MSFAvatarStateImpl(style: .overflow, size: state.size)
        state.primaryText = "\(count)"
        state.image = nil
        state.hasBackgroundOutline = self.state.hasBackgroundOutline
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
        let avatar = Avatar(style: .default, size: size)
        avatar.state.isTransparent = false
        avatars.insert(avatar, at: index)
        return avatar.state
    }

    func getAvatarState(at index: Int) -> MSFAvatarGroupAvatarState {
        guard avatars.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return avatars[index].state
    }

    func removeAvatar(at index: Int) {
        guard avatars.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        avatars.remove(at: index)
    }

    @Published var avatars: [Avatar] = []
    @Published var maxDisplayedAvatars: Int = Int.max
    @Published var overflowCount: Int = 0
    @Published var hasBackgroundOutline: Bool = false {
        didSet {
            avatars.forEach { $0.state.hasBackgroundOutline = hasBackgroundOutline }
        }
    }
    @Published var isUnread: Bool = false

    @Published var style: MSFAvatarGroupStyle
    @Published var size: MSFAvatarSize

    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        self.style = style
        self.size = size

        super.init()
    }
}

/// Simple extension to `MSFAvatarStateImpl` to prove conformance to `MSFAvatarGroupAvatarState`.
extension MSFAvatarStateImpl: MSFAvatarGroupAvatarState {
}
