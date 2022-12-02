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

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence icon outline).
    /// Uses the solid default background color if set to false.
    var isTransparent: Bool { get set }

    /// Defines the presence displayed by the Avatar.
    /// Image displayed depends on the value of the isOutOfOffice property.
    /// Presence is not displayed in the xsmall size.
    var presence: MSFAvatarPresence { get set }

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
        let style = state.style
        let presence = state.presence
        let shouldDisplayPresence = presence != .none
        let isRingVisible = state.isRingVisible
        let hasRingInnerGap = state.hasRingInnerGap
        let ringThicknessToken: CGFloat = tokenSet[.ringThickness].float
        let isTransparent = state.isTransparent
        let isOutOfOffice = state.isOutOfOffice
        let initialsString: String = ((style == .overflow) ? state.primaryText ?? "" : Avatar.initialsText(fromPrimaryText: state.primaryText,
                                                                                                           secondaryText: state.secondaryText))
        let shouldUseCalculatedColors = !initialsString.isEmpty && style != .overflow

        // Adding ringInnerGapOffset to ringInnerGap & ringThickness to accommodate for a small space between
        // the ring and avatar when the ring is visible and there is no inner ring gap
        let ringInnerGapOffset = 0.5
        let ringInnerGap: CGFloat = isRingVisible ? (hasRingInnerGap ? tokenSet[.ringInnerGap].float : -ringInnerGapOffset) : 0
        let ringThickness: CGFloat = isRingVisible ? (hasRingInnerGap ? ringThicknessToken : ringThicknessToken + ringInnerGapOffset) : 0
        let ringOuterGap: CGFloat = isRingVisible ? tokenSet[.ringOuterGap].float : 0
        let avatarImageSize: CGFloat = contentSize
        let ringInnerGapSize: CGFloat = avatarImageSize + (ringInnerGap * 2)
        let ringSize: CGFloat = ringInnerGapSize + (ringThickness * 2)
        let ringOuterGapSize: CGFloat = ringSize + (ringOuterGap * 2)
        let presenceIconSize: CGFloat = AvatarTokenSet.presenceIconSize(state.size)
        let presenceIconOutlineSize: CGFloat = presenceIconSize + (tokenSet[.presenceIconOutlineThickness].float * 2)

        // Calculates the positioning of the presence icon ensuring its center is always on top of the avatar circle's edge
        let ringInnerGapRadius: CGFloat = (ringInnerGapSize / 2)
        let ringInnerGapHypotenuse: CGFloat = sqrt(2 * pow(ringInnerGapRadius, 2))
        let presenceIconHypotenuse: CGFloat = sqrt(2 * pow(presenceIconOutlineSize / 2, 2))
        let presenceFrameHypotenuse: CGFloat = ringInnerGapHypotenuse + ringInnerGapRadius + presenceIconHypotenuse
        let presenceIconFrameSideRelativeToInnerRing: CGFloat = sqrt(pow(presenceFrameHypotenuse, 2) / 2)

        // Creates positioning coordinates for the presence cutout (enabling the transparency of the presence icon)
        let outerGapAndRingThicknesCombined: CGFloat = ringOuterGap + ringThickness
        let presenceIconFrameDiffRelativeToOuterRing: CGFloat = ringOuterGapSize - (presenceIconFrameSideRelativeToInnerRing + outerGapAndRingThicknesCombined)
        let presenceCutoutOriginXLTR = ringOuterGapSize - presenceIconFrameDiffRelativeToOuterRing - presenceIconOutlineSize
        let presenceCutoutOriginXRTL = presenceIconFrameDiffRelativeToOuterRing
        let presenceCutoutOriginX: CGFloat = layoutDirection == .rightToLeft ? presenceCutoutOriginXRTL : presenceCutoutOriginXLTR
        let presenceCutoutOriginY = presenceCutoutOriginXLTR
        let presenceIconFrameSideRelativeToOuterRing: CGFloat = presenceIconFrameSideRelativeToInnerRing + outerGapAndRingThicknesCombined
        let overallFrameSide = max(ringOuterGapSize, presenceIconFrameSideRelativeToOuterRing)

        let colorHashCode = CalculatedColors.initialsHashCode(fromPrimaryText: state.primaryText, secondaryText: state.secondaryText)

        let foregroundColor = state.foregroundColor?.dynamicColor ?? (
            !shouldUseCalculatedColors ? tokenSet[.foregroundDefaultColor].dynamicColor :
                CalculatedColors.foregroundColor(hashCode: colorHashCode))
        let backgroundColor = state.backgroundColor?.dynamicColor ?? (
            !shouldUseCalculatedColors ? tokenSet[.backgroundDefaultColor].dynamicColor :
                CalculatedColors.backgroundColor(hashCode: colorHashCode))
        let ringGapColor = Color(dynamicColor: tokenSet[.ringGapColor].dynamicColor).opacity(isTransparent ? 0 : 1)
        let ringColor = !isRingVisible ? Color.clear :
        Color(dynamicColor: state.ringColor?.dynamicColor ?? ( !shouldUseCalculatedColors ?
                                                               tokenSet[.ringDefaultColor].dynamicColor :
                                                               CalculatedColors.ringColor(hashCode: colorHashCode)))

        let shouldUseDefaultImage = (state.image == nil && initialsString.isEmpty && style != .overflow)
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

        @ViewBuilder
        var avatarContent: some View {
            if let image = avatarImageInfo.image {
                Image(uiImage: image)
                    .renderingMode(avatarImageInfo.renderingMode)
                    .resizable()
                    .foregroundColor(Color(dynamicColor: foregroundColor))
            } else {
                Text(initialsString)
                    .foregroundColor(Color(dynamicColor: foregroundColor))
                    .font(.fluent(tokenSet[.textFont].fontInfo, shouldScale: false))
            }
        }

        // The avatarRingView is not available in the .group style.
        // This variable is not going to be computed in that scenario.
        @ViewBuilder
        var avatarRingView: some View {
            if let imageBasedRingColor = state.imageBasedRingColor {
                // The potentially maximum size of the ring view must be used in order to avoid abrupt
                // transitions during the animation as the ImagePaint scale value is not animatable.
                let ringMaxSize = avatarImageSize + (tokenSet[.ringInnerGap].float + ringThicknessToken) * 2
                let scaleFactor = ringMaxSize / imageBasedRingColor.size.width

                // ImagePaint is being used as creating a Color struct from a UIColor created with
                // the patternImage initializer (https://developer.apple.com/documentation/uikit/uicolor/1621933-init)
                // does not render any content.
                Circle()
                    .strokeBorder(ImagePaint(image: Image(uiImage: imageBasedRingColor),
                                             scale: scaleFactor),
                                  lineWidth: ringThickness)
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
                        .foregroundColor(Color(dynamicColor: backgroundColor)))
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
                                            .foregroundColor(Color(dynamicColor: backgroundColor))
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
                    .modifyIf(shouldDisplayPresence, { thisView in
                        thisView
                            .clipShape(CircleCutout(xOrigin: presenceCutoutOriginX,
                                                    yOrigin: presenceCutoutOriginY,
                                                    cutoutSize: presenceIconOutlineSize),
                                       style: FillStyle(eoFill: true))
                            .overlay(Circle()
                                        .foregroundColor(Color(dynamicColor: tokenSet[.ringGapColor].dynamicColor).opacity(isTransparent ? 0 : 1))
                                        .frame(width: presenceIconOutlineSize, height: presenceIconOutlineSize, alignment: .center)
                                        .overlay(presence.image(isOutOfOffice: isOutOfOffice)
                                                    .interpolation(.high)
                                                    .resizable()
                                                    .frame(width: presenceIconSize, height: presenceIconSize, alignment: .center)
                                                    .foregroundColor(presence.color(isOutOfOffice: isOutOfOffice)))
                                        .contentShape(Circle())
                                        .frame(width: presenceIconFrameSideRelativeToOuterRing, height: presenceIconFrameSideRelativeToOuterRing,
                                               alignment: .bottomTrailing),
                                     alignment: .topLeading)
                            .frame(width: overallFrameSide, height: overallFrameSide, alignment: .topLeading)
                    })
            }
        }

        let standardAnimation = Animation.linear(duration: Self.animationDuration)

        return avatarBody
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
                               value: state.size)
                    .animation(standardAnimation,
                               value: [state.primaryText, state.secondaryText])
                    .animation(standardAnimation,
                               value: [state.image, state.imageBasedRingColor])
            })
            .showsLargeContentViewer(text: accessibilityLabel, image: shouldUseDefaultImage ? avatarImageInfo.image : nil)
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: state.hasButtonAccessibilityTrait ? .isButton : .isImage)
            .accessibility(label: Text(accessibilityLabel))
            .accessibility(value: Text(presence.string() ?? ""))
            .fluentTokens(tokenSet, fluentTheme)
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

    private struct PresenceCutout: Shape {
        var originX: CGFloat
        var originY: CGFloat
        var presenceIconOutlineSize: CGFloat

        var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat> {
            get {
                AnimatablePair(AnimatablePair(originX, originY), presenceIconOutlineSize)
            }

            set {
                originX = newValue.first.first
                originY = newValue.first.second
                presenceIconOutlineSize = newValue.second
            }
        }

        func path(in rect: CGRect) -> Path {
            var cutoutFrame = Rectangle().path(in: rect)
            cutoutFrame.addPath(Circle().path(in: CGRect(x: originX,
                                                         y: originY,
                                                         width: presenceIconOutlineSize,
                                                         height: presenceIconOutlineSize)))
            return cutoutFrame
        }
    }

    /// Handles calculating colors for Avatar foreground and background.
    private struct CalculatedColors {
        static func backgroundColor(hashCode: Int) -> DynamicColor {
            let colorSet = colors[hashCode % colors.count]
            return DynamicColor(light: GlobalTokens.sharedColors(colorSet, .tint40),
                                dark: GlobalTokens.sharedColors(colorSet, .shade30))
        }

        static func foregroundColor(hashCode: Int) -> DynamicColor {
            let colorSet = colors[hashCode % colors.count]
            return DynamicColor(light: GlobalTokens.sharedColors(colorSet, .shade30),
                                dark: GlobalTokens.sharedColors(colorSet, .tint40))
        }

        static func ringColor(hashCode: Int) -> DynamicColor {
            let colorSet = colors[hashCode % colors.count]
            return DynamicColor(light: GlobalTokens.sharedColors(colorSet, .primary),
                                dark: GlobalTokens.sharedColors(colorSet, .tint30))
        }

        static func initialsHashCode(fromPrimaryText primaryText: String?, secondaryText: String?) -> Int {
            let combined = (primaryText ?? "") + (secondaryText ?? "")
            let combinedHashable = combined as NSString
            return Int(abs(hashCode(combinedHashable)))
        }

        /// Hash algorithm to determine Avatar color.
        /// Referenced from: https://github.com/microsoft/fluentui/blob/master/packages/react-components/react-avatar/src/components/Avatar/useAvatar.tsx#L200
        /// - Returns: Hash code
        private static func hashCode(_ text: NSString) -> Int32 {
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

        private static var colors: [GlobalTokens.SharedColorSets] = [
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
