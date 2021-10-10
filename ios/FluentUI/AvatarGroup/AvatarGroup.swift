//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Enumeration of the styles used by the AvatarGroup.
/// The stack style presents Avatars laid on top of each other.
/// The pile style presents Avatars side by side.
@objc public enum MSFAvatarGroupStyle: Int, CaseIterable {
    case stack
    case pile
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

    /// Size of the AvatarGroup.
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
    ///   - avatarCount: Total number of avatars to represent, independent of what is visible at any time.
    ///   - avatarAtIndex: Callback to allow for customization of individual avatars.
    public init(style: MSFAvatarGroupStyle,
                size: MSFAvatarSize,
                avatars: [AvatarGroupAvatarState]) {
        let state = MSFAvatarGroupStateImpl(style: style,
                                            size: size,
                                            avatars: avatars)
        self.state = state
        self.tokens = state.tokens
    }

    /// Renders the avatar with an optional cutout
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
        let avatars: [AvatarGroupAvatarState] = state.avatars
        let avatarViews: [Avatar] = avatars.map { avatarGroupAvatarState in
            // Override the size of the avatarGroupAvatarState to conform
            // to our group's own size.
            let avatarState = avatarGroupAvatarState.avatarState
            avatarState.size = state.size
            return Avatar(avatarState)
        }
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
                let avatarView = avatarViews[index]
                let needsCutout = tokens.style == .stack && (overflowCount > 0 || index + 1 < maxDisplayedAvatars)
                let avatarSize: CGFloat = avatarView.state.totalSize()
                let nextAvatarSize: CGFloat = needsCutout ? avatarViews[index + 1].state.totalSize() : 0
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

                // Hand the rendering of the avatar to a helper function to appease Swift's
                // strict type-checking timeout.
                self.avatarCutout(avatarView,
                                  needsCutout,
                                  xOrigin,
                                  yOrigin,
                                  cutoutSize,
                                  tokens.style == .stack ? stackPadding : interspace)
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
        guard index <= avatars.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let avatar = AvatarGroupAvatarState()
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

    @Published var avatars: [AvatarGroupAvatarState] = []
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

    var size: MSFAvatarSize {
        get {
            return tokens.size
        }
        set {
            tokens.size = newValue
        }
    }

    var tokens: MSFAvatarGroupTokens

    init(style: MSFAvatarGroupStyle,
         size: MSFAvatarSize,
         avatars: [AvatarGroupAvatarState]) {
        self.tokens = MSFAvatarGroupTokens(style: style,
                                           size: size)
        self.avatars = avatars
        super.init()
    }
}
