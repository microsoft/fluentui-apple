//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public enum MSFAvatarPresence: Int, CaseIterable {
    case none
    case available
    case away
    case blocked
    case busy
    case doNotDisturb
    case offline
    case unknown

    func color(isOutOfOffice: Bool) -> Color {
        var color = UIColor.clear

        switch self {
        case .none:
            break
        case .available:
            color = FluentUIThemeManager.S.Colors.Presence.available
        case .away:
            color = isOutOfOffice ? FluentUIThemeManager.S.Colors.Presence.outOfOffice : FluentUIThemeManager.S.Colors.Presence.away
        case .busy:
            color = FluentUIThemeManager.S.Colors.Presence.busy
        case .blocked:
            color = FluentUIThemeManager.S.Colors.Presence.blocked
        case .doNotDisturb:
            color = FluentUIThemeManager.S.Colors.Presence.doNotDisturb
        case .offline:
            color = isOutOfOffice ? FluentUIThemeManager.S.Colors.Presence.outOfOffice : FluentUIThemeManager.S.Colors.Presence.offline
        case .unknown:
            color = FluentUIThemeManager.S.Colors.Presence.unknown
        }

        return Color(color)
    }

    func image(isOutOfOffice: Bool) -> Image {
        var imageName = ""

        switch self {
        case .none:
            break
        case .available:
            imageName = isOutOfOffice ? "ic_fluent_presence_available_16_regular" : "ic_fluent_presence_available_16_filled"
        case .away:
            imageName = isOutOfOffice ? "ic_fluent_presence_oof_16_regular" : "ic_fluent_presence_away_16_filled"
        case .busy:
            imageName = isOutOfOffice ? "ic_fluent_presence_unknown_16_regular" : "ic_fluent_presence_busy_16_filled"
        case .blocked:
            imageName = "ic_fluent_presence_blocked_16_regular"
        case .doNotDisturb:
            imageName = isOutOfOffice ? "ic_fluent_presence_dnd_16_regular" : "ic_fluent_presence_dnd_16_filled"
        case .offline:
            imageName = isOutOfOffice ? "ic_fluent_presence_oof_16_regular" : "ic_fluent_presence_offline_16_regular"
        case .unknown:
            imageName = "ic_fluent_presence_unknown_16_regular"
        }

        return Image(imageName,
                     bundle: FluentUIFramework.resourceBundle)
    }

    public func string() -> String? {
        switch self {
        case .none:
            return nil
        case .available:
            return "Presence.Available".localized
        case .away:
            return "Presence.Away".localized
        case .busy:
            return "Presence.Busy".localized
        case .blocked:
            return "Presence.Blocked".localized
        case .doNotDisturb:
            return "Presence.DND".localized
        case .offline:
            return "Presence.Offline".localized
        case .unknown:
            return "Presence.Unknown".localized
        }
    }
}

/// Properties available to customize the state of the avatar
@objc public protocol MSFAvatarState {
    var accessibilityLabel: String? { get set }
    var image: UIImage? { get set }
    var primaryText: String? { get set }
    var secondaryText: String? { get set }
    var ringColor: UIColor? { get set }
    var imageBasedRingColor: UIImage? { get set }
    var backgroundColor: UIColor? { get set }
    var foregroundColor: UIColor? { get set }
    var presence: MSFAvatarPresence { get set }
    var hasPointerInteraction: Bool { get set }
    var hasRingInnerGap: Bool { get set }
    var isRingVisible: Bool { get set }
    var isTransparent: Bool { get set }
    var isOutOfOffice: Bool { get set }
}

/// Properties available to customize the state of the avatar
class MSFAvatarStateImpl: NSObject, ObservableObject, MSFAvatarState {
    @Published var image: UIImage?
    @Published var primaryText: String?
    @Published var secondaryText: String?
    @Published var ringColor: UIColor?
    @Published var imageBasedRingColor: UIImage?
    @Published var backgroundColor: UIColor?
    @Published var foregroundColor: UIColor?
    @Published var presence: MSFAvatarPresence = .none
    @Published var hasPointerInteraction: Bool = false
    @Published var hasRingInnerGap: Bool = true
    @Published var isRingVisible: Bool = false
    @Published var isTransparent: Bool = true
    @Published var isOutOfOffice: Bool = false
}

/// View that represents the avatar
public struct AvatarView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFAvatarTokens
    @ObservedObject var state: MSFAvatarStateImpl

    public init(style: MSFAvatarStyle,
                size: MSFAvatarSize) {
        self.tokens = MSFAvatarTokens(style: style, size: size)
        self.state = MSFAvatarStateImpl()
    }

    public var body: some View {
        let style = tokens.style
        let presence = state.presence
        let shouldDisplayPresence = presence != .none
        let isRingVisible = state.isRingVisible
        let hasRingInnerGap = state.hasRingInnerGap
        let isTransparent = state.isTransparent
        let isOutOfOffice = state.isOutOfOffice
        let initialsString: String = ((style == .overflow) ? state.primaryText ?? "" : InitialsView.initialsText(fromPrimaryText: state.primaryText,
                                                                                                                 secondaryText: state.secondaryText))
        let shouldUseCalculatedColors = !initialsString.isEmpty && style != .overflow

        let ringInnerGap: CGFloat = isRingVisible && hasRingInnerGap ? tokens.ringInnerGap : 0
        let ringThickness: CGFloat = isRingVisible ? tokens.ringThickness : 0
        let ringOuterGap: CGFloat = isRingVisible ? tokens.ringOuterGap : 0
        let avatarImageSize: CGFloat = tokens.avatarSize!
        let ringInnerGapSize: CGFloat = avatarImageSize + (ringInnerGap * 2)
        let ringSize: CGFloat = ringInnerGapSize + ( ringThickness * 2)
        let ringOuterGapSize: CGFloat = ringSize + (ringOuterGap * 2)
        let presenceIconSize: CGFloat = tokens.presenceIconSize!
        let presenceIconOutlineSize: CGFloat = presenceIconSize + (tokens.presenceIconOutlineThickness * 2)

        // Calculates the positioning of the presence icon ensuring its center is always on top of the avatar circle's edge
        let ringInnerGapRadius: CGFloat = (ringInnerGapSize / 2)
        let ringInnerGapHypotenuse: CGFloat = sqrt(2 * pow(ringInnerGapRadius, 2))
        let presenceIconHypotenuse: CGFloat = sqrt(2 * pow(presenceIconOutlineSize / 2, 2))
        let presenceFrameHypotenuse: CGFloat = ringInnerGapHypotenuse + ringInnerGapRadius + presenceIconHypotenuse
        let presenceIconFrameSideRelativeToInnerRing: CGFloat = sqrt(pow(presenceFrameHypotenuse, 2) / 2)

        // Creates positioning coordinates for the presence cutout (enabling the transparency of the presence icon)
        let outerGapAndRingThicknesCombined: CGFloat = ringOuterGap + ringThickness
        let presenceIconFrameDiffRelativeToOuterRing: CGFloat = ringOuterGapSize - (presenceIconFrameSideRelativeToInnerRing + outerGapAndRingThicknesCombined)
        let presenceCutoutOriginCoordinates: CGFloat = ringOuterGapSize - presenceIconFrameDiffRelativeToOuterRing - presenceIconOutlineSize
        let presenceIconFrameSideRelativeToOuterRing: CGFloat = presenceIconFrameSideRelativeToInnerRing + outerGapAndRingThicknesCombined
        let overallFrameSide = max(ringOuterGapSize, presenceIconFrameSideRelativeToOuterRing)

        let foregroundColor = state.foregroundColor ?? ( !shouldUseCalculatedColors ?
                                                            tokens.foregroundDefaultColor! :
                                                            InitialsView.initialsCalculatedColor(fromPrimaryText: state.primaryText,
                                                                                                 secondaryText: state.secondaryText,
                                                                                                 colorOptions: tokens.foregroundCalculatedColorOptions))
        let backgroundColor = state.backgroundColor ?? ( !shouldUseCalculatedColors ?
                                                            tokens.backgroundDefaultColor! :
                                                            InitialsView.initialsCalculatedColor(fromPrimaryText: state.primaryText,
                                                                                                 secondaryText: state.secondaryText,
                                                                                                 colorOptions: tokens.backgroundCalculatedColorOptions))
        let ringGapColor = Color(tokens.ringGapColor).opacity(isTransparent ? 0 : 1)
        let ringColor = !isRingVisible ? Color.clear : Color(state.ringColor ?? ( !shouldUseCalculatedColors ?
                                                                                    tokens.ringDefaultColor! :
                                                                                    backgroundColor))

        let shouldUseDefaultImage = (state.image == nil && initialsString.isEmpty && style != .overflow)
        let avatarImage: UIImage? = ((style == .outlined || style == .outlinedPrimary) ? UIImage.staticImageNamed("person_48_regular") :
                                        (shouldUseDefaultImage ? UIImage.staticImageNamed("person_48_filled") : state.image))
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
            if let image = avatarImage {
                Image(uiImage: image)
                    .resizable()
                    .foregroundColor(Color(foregroundColor))
            } else {
                if #available(iOS 14.0, *) {
                    Text(initialsString)
                        .foregroundColor(Color(foregroundColor))
                        .font(Font(tokens.textFont))
                } else {
                    Text(initialsString)
                        .foregroundColor(Color(foregroundColor))
                        .font(Font(tokens.textFont))
                        // Workaround for iOS 13 only: disabling animations as a "flickering"
                        // happens as the text is truncated during the animation
                        .animation(.none)
                }
            }
        }

        // The avatarRingView is not available in the .group style.
        // This variable is not going to be computed in that scenario.
        @ViewBuilder
        var avatarRingView: some View {
            if let imageBasedRingColor = state.imageBasedRingColor {
                // The potentially maximum size of the ring view must be used in order to avoid abrupt
                // transitions during the animation as the ImagePaint scale value is not animatable.
                let ringMaxSize = avatarImageSize + (tokens.ringInnerGap + tokens.ringThickness) * 2
                let scaleFactor = ringMaxSize / imageBasedRingColor.size.width
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
            if tokens.style == .group {
                avatarContent
                    .background(Rectangle()
                                    .frame(width: tokens.avatarSize, height: tokens.avatarSize, alignment: .center)
                                    .foregroundColor(Color(backgroundColor)))
                    .frame(width: tokens.avatarSize, height: tokens.avatarSize, alignment: .center)
                    .contentShape(RoundedRectangle(cornerRadius: tokens.borderRadius))
                    .clipShape(RoundedRectangle(cornerRadius: tokens.borderRadius))
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
                    .modifyIf(shouldDisplayPresence, { thisView in
                            thisView.mask(PresenceCutout(presenceCutoutOriginCoordinates: presenceCutoutOriginCoordinates,
                                                         presenceIconOutlineSize: presenceIconOutlineSize)
                                            .fill(style: FillStyle(eoFill: true)))
                                .overlay(Circle()
                                            .foregroundColor(Color(tokens.ringGapColor).opacity(isTransparent ? 0 : 1))
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

        // iPad Pointer Interaction support
        var avatarBodyWithPointerInteraction: AnyView {
            if #available(iOS 13.4, *) {
                if state.hasPointerInteraction {
                    return AnyView(avatarBody.hoverEffect())
                }
            }

            return AnyView(avatarBody)
        }

        return avatarBodyWithPointerInteraction
            .animation(.linear(duration: animationDuration))
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: .isImage)
            .accessibility(label: Text(accessibilityLabel))
            .accessibility(value: Text(presence.string() ?? ""))
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }

    public func setStyle(style: MSFAvatarStyle) {
        tokens.style = style
    }

    public func setSize(size: MSFAvatarSize) {
        tokens.size = size
    }

    private let animationDuration: Double = 0.1

    private struct PresenceCutout: Shape {
        var presenceCutoutOriginCoordinates: CGFloat
        var presenceIconOutlineSize: CGFloat

        var animatableData: AnimatablePair<CGFloat, CGFloat> {
            get {
                AnimatablePair(presenceCutoutOriginCoordinates, presenceIconOutlineSize)
            }

            set {
                presenceCutoutOriginCoordinates = newValue.first
                presenceIconOutlineSize = newValue.second
            }
        }

        func path(in rect: CGRect) -> Path {
            var cutoutFrame = Rectangle().path(in: rect)
            cutoutFrame.addPath(Circle().path(in: CGRect(x: presenceCutoutOriginCoordinates,
                                                         y: presenceCutoutOriginCoordinates,
                                                         width: presenceIconOutlineSize,
                                                         height: presenceIconOutlineSize)))
            return cutoutFrame
        }
    }
}

/// UIKit wrapper that exposes the SwiftUI Avatar implementation
@objc open class MSFAvatar: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFAvatarState {
        return self.avatarview.state
    }

    @objc open func setStyle(style: MSFAvatarStyle) {
        self.avatarview.setStyle(style: style)
    }

    @objc open func setSize(size: MSFAvatarSize) {
        self.avatarview.setSize(size: size)
    }

    @objc public convenience init(style: MSFAvatarStyle = .default,
                                  size: MSFAvatarSize = .large) {
        self.init(style: style,
                  size: size,
                  theme: nil)
    }

    @objc public init(style: MSFAvatarStyle = .default,
                      size: MSFAvatarSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        avatarview = AvatarView(style: style,
                                size: size)
        hostingController = UIHostingController(rootView: AnyView(avatarview
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { avatarview in
                                                                        avatarview.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var avatarview: AvatarView!
}
