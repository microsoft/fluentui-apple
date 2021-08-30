//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation.
@objc open class MSFAvatarGroup: NSObject, FluentUIWindowProvider {

    /// The UIView representing the AvatarGroup.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the AvatarGroup appearance.
    @objc open var state: MSFAvatarGroupState {
        return avatarGroup.state
    }

    /// Creates a new MSFAvatarGroup instance.
    /// - Parameters:
    ///   - style: The MSFAvatarGroupStyle value used by the AvatarGroup.
    ///   - size: The MSFAvatarSize value used by the Avatars that will compose the AvatarGroup.
    @objc public convenience init(style: MSFAvatarGroupStyle = .stack,
                                  size: MSFAvatarSize = .large) {
        self.init(style: style,
                  size: size,
                  theme: nil)
    }

    /// Creates a new MSFAvatarGroup instance.
    /// - Parameters:
    ///   - style: The MSFAvatarGroupStyle value used by the AvatarGroup.
    ///   - size: The MSFAvatarSize value used by the Avatars that will compose the AvatarGroup.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this AvatarGroup.
    @objc public init(style: MSFAvatarGroupStyle,
                      size: MSFAvatarSize,
                      theme: FluentUIStyle?) {
        super.init()

        avatarGroup = AvatarGroup(style: style,
                                  size: size)
        hostingController = UIHostingController(rootView: AnyView(avatarGroup
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { avatarGroupView in
                                                                        avatarGroupView.customTheme(theme!)
                                                                    })))
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var avatarGroup: AvatarGroup!
}

/// Properties that can be used to customize the appearance of the AvatarGroup.
@objc public protocol MSFAvatarGroupState {

    /// Caps the number of displayed avatars and shows the remaining not displayed in the overflow avatar.
    var maxDisplayedAvatars: Int { get set }

    /// Adds to the overflow count in case the calling code did not provide all the avatars, but still wants to convey more
    /// items than just the remainder of the avatars that could not be displayed due to the maxDisplayedAvatars property.
    var overflowCount: Int { get set }

    ///  Style of the AvatarGroup.
    var style: MSFAvatarGroupStyle { get set }

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
public struct AvatarGroup: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: MSFAvatarGroupStateImpl
    @ObservedObject var tokens: MSFAvatarGroupTokens

    /// Creates and initializes a SwiftUI AvatarGroup.
    /// - Parameters:
    ///   - style: The style of the avatar group.
    ///   - size: The size of the avatars displayed in the avatar group.
    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize) {
        let state = MSFAvatarGroupStateImpl(style: style,
                                            size: size)
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let avatars: [MSFAvatarStateImpl] = state.avatars
        let maxDisplayedAvatars: Int = avatars.prefix(state.maxDisplayedAvatars).count
        let overflowCount: Int = (avatars.count > maxDisplayedAvatars ? avatars.count - maxDisplayedAvatars : 0) + state.overflowCount

        let interspace: CGFloat = tokens.interspace
        let imageSize: CGFloat = tokens.size.size
        let ringOuterGap: CGFloat = tokens.ringOuterGap
        let ringGapOffset: CGFloat = ringOuterGap * 2
        let ringOffset: CGFloat = tokens.ringThickness + tokens.ringInnerGap + tokens.ringOuterGap
        HStack(spacing: 0) {
            ForEach(0 ..< maxDisplayedAvatars, id: \.self) { index in
                // If the avatar is part of Stack style and is not the last avatar in the sequence, create a cutout
                let avatar = avatars[index]
                let avatarView = Avatar(avatar)
                let needsCutout = tokens.style == .stack && (overflowCount > 0 || index + 1 < maxDisplayedAvatars)
                let avatarSize = avatarView.size()
                let nextAvatarSize: CGFloat = needsCutout ? Avatar(avatars[index + 1]).size() : 0
                let isLastDisplayed = index == maxDisplayedAvatars - 1

                let currentAvatarHasRing = avatar.isRingVisible
                let nextAvatarHasRing = index + 1 < maxDisplayedAvatars ? avatars[index + 1].isRingVisible : false
                let avatarSizeDifference = avatarSize - nextAvatarSize
                let sizeDiff = !isLastDisplayed ? (currentAvatarHasRing ? avatarSizeDifference : avatarSizeDifference - ringGapOffset) :
                    currentAvatarHasRing ? (avatarSize - ringGapOffset) - imageSize : (avatarSize - (ringGapOffset * 2)) - imageSize
                let x = avatarSize + tokens.interspace - ringGapOffset

                let ringPaddingInterspace = nextAvatarHasRing ? interspace - (ringOffset + ringOuterGap) : interspace - ringOffset
                let noRingPaddingInterspace = nextAvatarHasRing ? interspace - ringOuterGap : interspace
                let rtlRingPaddingInterspace = (nextAvatarHasRing ? -x - ringOuterGap : -x + ringOffset)
                let rtlNoRingPaddingInterspace = (nextAvatarHasRing ? -x - ringOffset - ringOuterGap : -x)
                let stackPadding = (currentAvatarHasRing ? ringPaddingInterspace : noRingPaddingInterspace)

                let xPosition = currentAvatarHasRing ? x - ringOuterGap - ringOuterGap : x - ringOuterGap
                let xPositionRTL = currentAvatarHasRing ? rtlRingPaddingInterspace : rtlNoRingPaddingInterspace
                let xOrigin = Locale.current.isRightToLeftLayoutDirection() ? xPositionRTL : xPosition
                let yOrigin = sizeDiff / 2
                let cutoutSize = isLastDisplayed ? (ringOuterGap * 2) + imageSize : nextAvatarSize

                avatarView
                    .modifyIf(needsCutout, { view in
                        view.mask(Avatar.AvatarCutout(
                                    xOrigin: xOrigin,
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

    private func createOverflow(count: Int) -> Avatar {
        var avatar = Avatar(style: .overflow, size: tokens.size)
        let data = MSFAvatarStateImpl(style: .overflow, size: tokens.size)
        data.primaryText = "\(count)"
        data.image = nil
        avatar.state = data
        return avatar
    }
}

class MSFAvatarGroupStateImpl: NSObject, ObservableObject, MSFAvatarGroupState {
    func createAvatar() -> MSFAvatarGroupAvatarState {
        return createAvatar(at: avatars.endIndex)
    }

    func createAvatar(at index: Int) -> MSFAvatarGroupAvatarState {
        guard index <= avatars.count else {
            preconditionFailure("Index is out of bounds")
        }
        let avatar = MSFAvatarGroupAvatarStateImpl(size: tokens.size)
        avatars.insert(avatar, at: index)
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

class MSFAvatarGroupAvatarStateImpl: MSFAvatarStateImpl, MSFAvatarGroupAvatarState {
    init(size: MSFAvatarSize) {
        super.init(style: .default, size: size)
    }
}
