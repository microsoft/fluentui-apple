//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that can be used to customize the appearance of the Avatar.
@objc public protocol MSFAvatarState {
    /// Sets the accessibility label for the Avatar.
    var accessibilityLabel: String? { get set }

    /// Sets a custom background color for the Avatar.
    /// The ring color inherit this color if not set explicitly to a different color.
    var backgroundColor: UIColor? { get set }

    /// The custom foreground color.
    /// This property allows customizing the initials text color or the default image tint color.
    var foregroundColor: UIColor? { get set }

    /// Configures the Avatar with a button accessibility trait overriding its default image trait.
    var hasButtonAccessibilityTrait: Bool { get set }

    /// Turns iPad Pointer interaction on/off.
    var hasPointerInteraction: Bool { get set }

    /// Whether the gap between the ring and the avatar content exists.
    var hasRingInnerGap: Bool { get set }

    /// The image used in the avatar content.
    var image: UIImage? { get set }

    /// The image used to fill the ring as a custom color.
    var imageBasedRingColor: UIImage? { get set }

    /// Defines whether the avatar state transitions are animated or not. Animations are enabled by default.
    var isAnimated: Bool { get set }

    /// Whether the presence status displays its "Out of office" or standard image.
    var isOutOfOffice: Bool { get set }

    /// Displays an outer ring for the avatar if set to true.
    /// The group style does not support rings.
    var isRingVisible: Bool { get set }

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence, and activity icon outline).
    /// Uses the solid default background color if set to false.
    var isTransparent: Bool { get set }

    /// Defines the presence displayed by the Avatar.
    /// Image displayed depends on the value of the isOutOfOffice property.
    /// Presence is not displayed in `.size16`.
    var presence: MSFAvatarPresence { get set }

    /// Defines the activity style displayed by the Avatar.
    /// Will not be displayed if activityImage is not set.
    /// Presence is only displayed in `.size56` and `.size40`.
    var activityStyle: MSFAvatarActivityStyle { get set }

    /// Displays the image used within the Avatar activity.
    /// Will not be displayed if activitySyle is not set.
    var activityImage: UIImage? { get set }

    /// The primary text of the avatar.
    /// Used for computing the initials and background/ring colors.
    var primaryText: String? { get set }

    /// Overrides the default ring color.
    var ringColor: UIColor? { get set }

    /// The secondary text of the avatar.
    /// Used for computing the initials and background/ring colors if primaryText is not set.
    var secondaryText: String? { get set }

    /// Defines the size of the avatar.
    /// Presence is not displayed in the xsmall size.
    var size: MSFAvatarSize { get set }

    /// Defines the style of the avatar (including the fallback appearance if initials can't be computed and no image is set).
    var style: MSFAvatarStyle { get set }
}

/// View that represents the avatar.
public struct Avatar: View, TokenizedControlView {
    public typealias TokenSetKeyType = AvatarTokenSet.Tokens
    @ObservedObject public var tokenSet: AvatarTokenSet

    /// Creates and initializes a SwiftUI Avatar
    /// - Parameters:
    ///   - style: The style of the avatar.
    ///   - size: The size of the avatar.
    ///   - image: The optional image that the avatar should display.
    ///   - primaryText: The primary text used to calculate the Avatar initials.
    ///   - secondaryText: The secondary text used to calculate the Avatar initials.
    public init(style: MSFAvatarStyle,
                size: MSFAvatarSize,
                image: UIImage? = nil,
                primaryText: String? = nil,
                secondaryText: String? = nil) {
        let state = MSFAvatarStateImpl(style: style,
                                       size: size)
        state.image = image
        state.primaryText = primaryText
        state.secondaryText = secondaryText

        self.init(state)
    }

    public var body: some View {
        tokenSet.update(fluentTheme)
        let style = state.style
        let size = state.size

        let initialsString: String = ((style == .overflow) ? state.primaryText ?? "" : Avatar.initialsText(fromPrimaryText: state.primaryText,
                                                                                                           secondaryText: state.secondaryText))
        let shouldUseCalculatedColors = !initialsString.isEmpty && style != .overflow
        let shouldUseDefaultImage = (state.image == nil && initialsString.isEmpty && style != .overflow)

        let activityStyle = state.activityStyle
        let presence = state.presence

        let isActivitySizeZero = AvatarTokenSet.activityIconSize(size) == 0
        let isPresenceSizeZero = AvatarTokenSet.presenceIconSize(size) == 0
        let shouldDisplayActivity = state.activityImage != nil && activityStyle != .none && (style == .default && !shouldUseDefaultImage) && !isActivitySizeZero
        let shouldDisplayPresence = (shouldDisplayActivity ? false : presence != .none) && !isPresenceSizeZero && style != .group
        let cornerRadius = shouldDisplayActivity ? (activityStyle == .square ? AvatarTokenSet.activityIconRadius(size) : .infinity) : .infinity
        let isRingVisible = state.isRingVisible
        let hasRingInnerGap = state.hasRingInnerGap
        let ringThicknessToken: CGFloat = tokenSet[.ringThickness].float
        let accessoryBorderThicknessToken: CGFloat = tokenSet[.borderThickness].float
        let accessoryBorderColorToken: UIColor = tokenSet[.borderColor].uiColor
        let isTransparent = state.isTransparent
        let isOutOfOffice = state.isOutOfOffice

        // Adding ringInnerGapOffset to ringInnerGap & ringThickness to accommodate for a small space between
        // the ring and avatar when the ring is visible and there is no inner ring gap
        let ringInnerGapOffset = 0.5
        let ringInnerGap: CGFloat = isRingVisible ? (hasRingInnerGap ? tokenSet[.ringInnerGap].float : -ringInnerGapOffset) : 0
        let ringThickness: CGFloat = isRingVisible ? (hasRingInnerGap ? ringThicknessToken : ringThicknessToken + ringInnerGapOffset) : 0
        let ringOuterGap: CGFloat = isRingVisible ? tokenSet[.ringOuterGap].float : 0
        let totalRingGap: CGFloat = ringInnerGap + ringThickness + ringOuterGap
        let avatarImageSize: CGFloat = contentSize
        let ringInnerGapSize: CGFloat = avatarImageSize + (ringInnerGap * 2)
        let ringSize: CGFloat = ringInnerGapSize + (ringThickness * 2)
        let ringOuterGapSize: CGFloat = ringSize + (ringOuterGap * 2)

        let colorHashCode = CalculatedColors.initialsHashCode(fromPrimaryText: state.primaryText, secondaryText: state.secondaryText)

        let foregroundColor: UIColor = state.foregroundColor ?? (
            !shouldUseCalculatedColors ? tokenSet[.foregroundDefaultColor].uiColor :
                CalculatedColors.foregroundColor(hashCode: colorHashCode))
        let backgroundColor: UIColor = state.backgroundColor ?? (
            !shouldUseCalculatedColors ? tokenSet[.backgroundDefaultColor].uiColor :
                CalculatedColors.backgroundColor(hashCode: colorHashCode))
        let ringGapColor = Color(tokenSet[.ringGapColor].uiColor).opacity(isTransparent ? 0 : 1)
        let ringColor = !isRingVisible ? Color.clear :
        Color(state.ringColor ?? ( !shouldUseCalculatedColors ?
                                       tokenSet[.ringDefaultColor].uiColor :
                                       CalculatedColors.ringColor(hashCode: colorHashCode)))

        let avatarImageInfo: (image: UIImage?, renderingMode: Image.TemplateRenderingMode) = {
            if shouldUseDefaultImage {
                let isOutlinedStyle = style == .outlined || style == .outlinedPrimary
                return (UIImage.staticImageNamed(isOutlinedStyle ? "person_48_regular" : "person_48_filled"), .template)
            }

            return (state.image, .original)
        }()
        let avatarImageSizeRatio: CGFloat = (shouldUseDefaultImage) ? 0.7 : 1

        let accessibilityLabel: String = {
            if let overriddenAccessibilityLabel = state.accessibilityLabel {
                return overriddenAccessibilityLabel
            }

            let defaultAccessibilityText = state.primaryText ?? state.secondaryText ?? ""
            return (state.isOutOfOffice ?
                        String.localizedStringWithFormat("Accessibility.AvatarView.LabelFormat".localized, defaultAccessibilityText, "Presence.OOF".localized) :
                        defaultAccessibilityText)
        }()

#if DEBUG
            let accessibilityIdentifier: String = {
                let imageDescription: String = state.image != nil ? "image" : initialsString != "" ? "initials" : "icon"
                let ringDescription: String = {
                    if !state.isRingVisible {
                        return "no ring"
                    }
                    if state.imageBasedRingColor == nil {
                        return state.hasRingInnerGap ? "a default ring with an inner gap" : "a default ring with no inner gap"
                    }
                    return state.hasRingInnerGap ? "an image based ring with an inner gap" : "an image based ring with no inner gap"
                }()
                let presenceActivityDescription: String = {
                    if shouldDisplayActivity {
                        return "activity \(state.activityStyle.rawValue)"
                    } else {
                        return state.isOutOfOffice ? "presence out of office" : "presence \(state.presence.rawValue)"
                    }
                }()

                if let title: String = state.primaryText ?? state.secondaryText {
                    return "Avatar of \(title)'s \(imageDescription) with \(ringDescription) and \(presenceActivityDescription) in size \(AvatarTokenSet.avatarSize(state.size)) and style \(state.style.rawValue)"
                }
                return "Avatar of an \(imageDescription) with \(ringDescription) and presence \(presenceActivityDescription) in size \(AvatarTokenSet.avatarSize(state.size)) and style \(state.style.rawValue)"
            }()
#endif

        @ViewBuilder
        var avatarContent: some View {
            if let image = avatarImageInfo.image {
                Image(uiImage: image)
                    .renderingMode(avatarImageInfo.renderingMode)
                    .resizable()
                    .foregroundColor(Color(foregroundColor))
            } else {
                Text(initialsString)
                    .foregroundColor(Color(foregroundColor))
                    .font(.init(tokenSet[.textFont].uiFont))
            }
        }

        // The avatarRingView is not available in the .group style.
        // This variable is not going to be computed in that scenario.
        @ViewBuilder
        var avatarRingView: some View {
            if let imageBasedRingColor = state.imageBasedRingColor {
                Circle()
                    .foregroundStyle(.clear)
                    .background(Image(uiImage: imageBasedRingColor)
                        .resizable())
                    .mask {
                        Circle()
                            .strokeBorder(lineWidth: ringThickness)
                    }
            } else {
                Circle()
                    .strokeBorder(ringColor,
                                  lineWidth: ringThickness)
            }
        }

        @ViewBuilder
        var avatarBody: some View {
            if style == .group {
                let avatarSize = contentSize
                avatarContent
                    .background(Rectangle()
                        .frame(width: avatarSize, height: avatarSize, alignment: .center)
                        .foregroundColor(Color(backgroundColor)))
                    .frame(width: avatarSize, height: avatarSize, alignment: .center)
                    .contentShape(RoundedRectangle(cornerRadius: tokenSet[.borderRadius].float))
                    .clipShape(RoundedRectangle(cornerRadius: tokenSet[.borderRadius].float))
            } else {
                Circle()
                    .foregroundColor(ringGapColor)
                    .frame(width: ringOuterGapSize, height: ringOuterGapSize, alignment: .center)
                    .overlay(avatarRingView
                                .frame(width: ringSize, height: ringSize, alignment: .center)
                                .overlay(Circle()
                                            .foregroundColor(Color(backgroundColor))
                                            .frame(width: avatarImageSize, height: avatarImageSize, alignment: .center)
                                            .overlay(avatarContent
                                                        .frame(width: avatarImageSize * avatarImageSizeRatio,
                                                               height: avatarImageSize * avatarImageSizeRatio,
                                                               alignment: .center)
                                                        .contentShape(Circle())
                                                        .clipShape(Circle())
                                                        .transition(.opacity),
                                                     alignment: .center)
                                        )
                                .contentShape(Circle()),
                             alignment: .center)
            }
        }

        @ViewBuilder
        var avatar: some View {
            if shouldDisplayPresence || shouldDisplayActivity {
                // Avatar accessory calculation
                let accessoryImage: Image = {
                    if let image = state.activityImage, shouldDisplayActivity {
                        return Image(uiImage: image)
                    } else {
                        return presence.image(isOutOfOffice: isOutOfOffice)
                    }
                }()
                let accessoryIconSize: CGFloat = shouldDisplayActivity ? AvatarTokenSet.activityIconBackgroundSize(size) : AvatarTokenSet.presenceIconSize(size)
                let accessoryBorderSize: CGFloat = accessoryIconSize + (accessoryBorderThicknessToken * 2)
                let accessoryBackgroundColor: UIColor = shouldDisplayActivity ? tokenSet[.activityBackgroundColor].uiColor : accessoryBorderColorToken
                let accessoryForegroundColor: Color = shouldDisplayActivity ? Color(tokenSet[.activityForegroundColor].uiColor) : presence.color(isOutOfOffice: isOutOfOffice, fluentTheme: fluentTheme)
                let accessoryIconOffset: CGFloat = shouldDisplayActivity ? accessoryBorderThicknessToken * 3 : accessoryBorderThicknessToken
                let accessoryCutoutCoordinates: CGPoint = accessoryCoordinates(iconOffset: accessoryIconOffset,
                                                                               iconSize: accessoryBorderSize,
                                                                               totalRingGap: totalRingGap)
                let accessoryBorderFrameLTR: CGFloat = accessoryCutoutCoordinates.x + accessoryBorderSize
                let accessoryBorderFrameRTL: CGFloat = AvatarTokenSet.avatarSize(size) + totalRingGap + accessoryBorderThicknessToken + (shouldDisplayActivity ? accessoryBorderThicknessToken : 0)
                let accessoryBorderFrameSideRelativeToOuterRing: CGFloat = layoutDirection == .rightToLeft ? accessoryBorderFrameRTL : accessoryBorderFrameLTR
                let accessoryOverallFrameSide = max(ringOuterGapSize, accessoryBorderFrameSideRelativeToOuterRing)

                // Activity icon background calculation
                let activityImageSize: CGFloat = AvatarTokenSet.activityIconSize(size)
                let activityBackgroundFrameLTR: CGFloat = accessoryBorderFrameLTR - accessoryBorderThicknessToken
                let activityBackgroundFrameRTL: CGFloat = accessoryBorderFrameRTL - accessoryBorderThicknessToken
                let activityBackgroundFrameSideRelativeToOuterRing: CGFloat = layoutDirection == .rightToLeft ? activityBackgroundFrameRTL : activityBackgroundFrameLTR

                avatarBody
                // Creates the cutout shape
                    .modifyIf((shouldDisplayActivity || shouldDisplayPresence), { thisView in
                        thisView
                            .clipShape(ShapeCutout(xOrigin: accessoryCutoutCoordinates.x,
                                                   yOrigin: accessoryCutoutCoordinates.y,
                                                   cornerRadius: cornerRadius,
                                                   cutoutSize: accessoryBorderSize),
                                       style: FillStyle(eoFill: true))
                    })
                // Creates the activity outer border overlay
                    .modifyIf(shouldDisplayActivity, { thisView in
                        thisView
                            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(Color(accessoryBorderColorToken).opacity(isTransparent ? 0 : 1))
                                .frame(width: accessoryBorderSize, height: accessoryBorderSize, alignment: .center)
                                .contentShape(Circle())
                                .frame(width: accessoryBorderFrameSideRelativeToOuterRing, height: accessoryBorderFrameSideRelativeToOuterRing,
                                       alignment: .bottomTrailing),
                                     alignment: .topLeading)
                    })
                // Creates the accessory icon overlay
                    .modifyIf((shouldDisplayActivity || shouldDisplayPresence), { thisView in
                        thisView
                            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(Color(accessoryBackgroundColor).opacity(isTransparent ? 0 : 1))
                                .frame(width: shouldDisplayActivity ? accessoryIconSize : accessoryBorderSize,
                                       height: shouldDisplayActivity ? accessoryIconSize : accessoryBorderSize,
                                       alignment: .center)
                                    .overlay(accessoryImage
                                        .interpolation(.high)
                                        .resizable()
                                        .frame(width: shouldDisplayActivity ? activityImageSize : accessoryIconSize,
                                               height: shouldDisplayActivity ? activityImageSize : accessoryIconSize,
                                               alignment: .center)
                                            .foregroundColor(accessoryForegroundColor))
                                        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
                                        .frame(width: shouldDisplayActivity ? activityBackgroundFrameSideRelativeToOuterRing : accessoryBorderFrameSideRelativeToOuterRing,
                                               height: shouldDisplayActivity ? activityBackgroundFrameSideRelativeToOuterRing : accessoryBorderFrameSideRelativeToOuterRing,
                                               alignment: .bottomTrailing),
                                     alignment: .topLeading)
                            .frame(width: accessoryOverallFrameSide, height: accessoryOverallFrameSide, alignment: .topLeading)
                    })
            } else {
                avatarBody
            }
        }

        let standardAnimation = Animation.linear(duration: Self.animationDuration)

        return avatar
            .pointerInteraction(state.hasPointerInteraction)
            .modifyIf(state.isAnimated, { thisView in
                thisView
                    .animation(standardAnimation,
                               value: [state.hasRingInnerGap,
                                       state.isRingVisible,
                                       state.isTransparent,
                                       state.isOutOfOffice])
                    .animation(standardAnimation,
                               value: [state.backgroundColor,
                                       state.foregroundColor,
                                       state.ringColor])
                    .animation(standardAnimation,
                               value: size)
                    .animation(standardAnimation,
                               value: [state.primaryText, state.secondaryText])
                    .animation(standardAnimation,
                               value: [state.image, state.imageBasedRingColor])
                    .animation(standardAnimation,
                               value: state.presence)
                    .animation(standardAnimation,
                               value: state.activityStyle)
            })
            .showsLargeContentViewer(text: accessibilityLabel, image: shouldUseDefaultImage ? avatarImageInfo.image : nil)
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: state.hasButtonAccessibilityTrait ? .isButton : .isImage)
            .accessibility(label: Text(accessibilityLabel))
            .accessibility(value: Text(presence.string() ?? ""))
#if DEBUG
            .accessibilityIdentifier(accessibilityIdentifier)
#endif
    }

    /// Internal initializer. Used by our public init, and also by internal container views. These containers should first initialize
    /// MSFAvatarStateImpl using style and size, and then use that state and this initializer in their ViewBuilder.
    init(_ avatarState: MSFAvatarStateImpl) {
        state = avatarState
        tokenSet = AvatarTokenSet(style: { avatarState.style },
                                  size: { avatarState.size })
    }

    /// Calculates the size of the avatar, including ring spacing
    var totalSize: CGFloat {
        let avatarImageSize: CGFloat = contentSize
        let ringOuterGap: CGFloat = tokenSet[.ringOuterGap].float
        if !state.isRingVisible {
            return avatarImageSize + (ringOuterGap * 2)
        } else {
            let ringThickness: CGFloat = tokenSet[.ringThickness].float
            let ringInnerGap: CGFloat = state.hasRingInnerGap ? tokenSet[.ringInnerGap].float : 0
            return ((ringInnerGap + ringThickness + ringOuterGap) * 2 + avatarImageSize)
        }
    }

    var contentSize: CGFloat {
        return AvatarTokenSet.avatarSize(state.size)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    @ObservedObject var state: MSFAvatarStateImpl

    private func accessoryCoordinates(iconOffset: CGFloat, iconSize: CGFloat, totalRingGap: CGFloat) -> CGPoint {
        let xLTR = contentSize + iconOffset - iconSize + totalRingGap
        let xRTL = totalRingGap - iconOffset
        let y = xLTR
        let coordinates = CGPoint(x: layoutDirection == .leftToRight ? xLTR : xRTL, y: y)
        return coordinates
    }

    private static func initialsText(fromPrimaryText primaryText: String?, secondaryText: String?) -> String {
        var initials = ""

        if let primaryText = primaryText, primaryText.count > 0 {
            initials = initialLetters(primaryText)
        } else if let secondaryText = secondaryText, secondaryText.count > 0 {
            // Use first letter of the secondary text
            initials = String(secondaryText.prefix(1))
        }

        return initials.uppercased()
    }

    private static func initialLetters(_ text: String) -> String {
        var initials = ""

        // Use the leading character from the first two words in the user's name
        let nameComponents = text.components(separatedBy: " ")
        for nameComponent: String in nameComponents {
            let trimmedName = nameComponent.trimmed()
            if trimmedName.count < 1 {
                continue
            }
            let initial = trimmedName.index(trimmedName.startIndex, offsetBy: 0)
            let initialLetter = String(trimmedName[initial])
            let initialUnicodeScalars = initialLetter.unicodeScalars
            let initialUnicodeScalar = initialUnicodeScalars[initialUnicodeScalars.startIndex]
            // Discard name if first char is not a letter
            let isInitialLetter: Bool = initialLetter.count > 0 && CharacterSet.letters.contains(initialUnicodeScalar)
            if isInitialLetter && initials.count < 2 {
                initials += initialLetter
            }
        }

        return initials
    }

    /// Handles calculating colors for Avatar foreground and background.
    struct CalculatedColors {
        static func backgroundColor(hashCode: Int) -> UIColor {
            let colorSet = colors[hashCode % colors.count]
            return UIColor(light: GlobalTokens.sharedColor(colorSet, .tint40),
                           dark: GlobalTokens.sharedColor(colorSet, .shade30))
        }

        static func foregroundColor(hashCode: Int) -> UIColor {
            let colorSet = colors[hashCode % colors.count]
            return UIColor(light: GlobalTokens.sharedColor(colorSet, .shade30),
                           dark: GlobalTokens.sharedColor(colorSet, .tint40))
        }

        static func ringColor(hashCode: Int) -> UIColor {
            let colorSet = colors[hashCode % colors.count]
            return UIColor(light: GlobalTokens.sharedColor(colorSet, .primary),
                           dark: GlobalTokens.sharedColor(colorSet, .tint30))
        }

        static func initialsHashCode(fromPrimaryText primaryText: String?, secondaryText: String?) -> Int {
            let combined = (primaryText ?? "") + (secondaryText ?? "")
            let combinedHashable = combined as NSString
            return Int(abs(hashCode(combinedHashable)))
        }

        /// Hash algorithm to determine Avatar color.
        /// Referenced from: https://github.com/microsoft/fluentui/blob/master/packages/react-components/react-avatar/src/components/Avatar/useAvatar.tsx#L200
        /// - Returns: Hash code
        static func hashCode(_ text: NSString) -> Int32 {
            var hash: Int32 = 0
            for len in (0..<text.length).reversed() {
                // Convert from `unichar` to `Int32` to avoid potential arithmetic overflow in the next few lines.
                // Note that JavaScript does the upconversion automatically, but we need to be explicit in Swift.
                let ch = Int32(text.character(at: len))
                let shift = len % 8
                hash ^= Int32((ch << shift) + (ch >> (8 - shift)))
              }

            return hash
        }

        static var colors: [GlobalTokens.SharedColorSet] = [
            .darkRed,
            .cranberry,
            .red,
            .pumpkin,
            .peach,
            .marigold,
            .gold,
            .brass,
            .brown,
            .forest,
            .seafoam,
            .darkGreen,
            .lightTeal,
            .teal,
            .steel,
            .blue,
            .royalBlue,
            .cornflower,
            .navy,
            .lavender,
            .purple,
            .grape,
            .lilac,
            .pink,
            .magenta,
            .plum,
            .beige,
            .mink,
            .platinum,
            .anchor
        ]
    }

    private static let animationDuration: Double = 0.1
}

/// Properties available to customize the state of the avatar
class MSFAvatarStateImpl: ControlState, MSFAvatarState {
    public var id = UUID()

    @Published var backgroundColor: UIColor?
    @Published var foregroundColor: UIColor?
    @Published var hasButtonAccessibilityTrait: Bool = false
    @Published var hasPointerInteraction: Bool = false
    @Published var hasRingInnerGap: Bool = true
    @Published var image: UIImage?
    @Published var imageBasedRingColor: UIImage?
    @Published var isAnimated: Bool = true
    @Published var isOutOfOffice: Bool = false
    @Published var isRingVisible: Bool = false
    @Published var isTransparent: Bool = true
    @Published var presence: MSFAvatarPresence = .none
    @Published var activityStyle: MSFAvatarActivityStyle = .none
    @Published var activityImage: UIImage?
    @Published var primaryText: String?
    @Published var ringColor: UIColor?
    @Published var secondaryText: String?

    @Published var style: MSFAvatarStyle
    @Published var size: MSFAvatarSize

    init(style: MSFAvatarStyle,
         size: MSFAvatarSize) {
        self.style = style
        self.size = size

        super.init()
    }
}
