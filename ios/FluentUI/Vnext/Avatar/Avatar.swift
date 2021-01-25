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

    public func color(isOutOfOffice: Bool) -> Color {
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

    public func image(isOutOfOffice: Bool) -> Image {
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
}

/// Properties available to customize the state of the avatar
@objc public class MSFAvatarState: NSObject, ObservableObject {
    @objc @Published public var image: UIImage?
    @objc @Published public var primaryText: String?
    @objc @Published public var secondaryText: String?
    @objc @Published public var ringColor: UIColor?
    @objc @Published public var backgroundColor: UIColor?
    @objc @Published public var foregroundColor: UIColor?
    @objc @Published public var presence: MSFAvatarPresence = .none
    @objc @Published public var isRingVisible: Bool = false
    @objc @Published public var isTransparent: Bool = true
    @objc @Published public var isOutOfOffice: Bool = false
}

/// View that represents the avatar
public struct AvatarView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var tokens: MSFAvatarTokens
    @ObservedObject var state: MSFAvatarState

    public init(style: MSFAvatarStyle,
                size: MSFAvatarSize) {
        self.tokens = MSFAvatarTokens(style: style, size: size)
        self.state = MSFAvatarState()
    }

    public var body: some View {
        let style = tokens.style
        let presence = state.presence
        let shouldDisplayPresence = presence != .none
        let isRingVisible = state.isRingVisible
        let isTransparent = state.isTransparent
        let isOutOfOffice = state.isOutOfOffice
        let initialsString: String = ((style == .overflow) ? state.primaryText ?? "" : InitialsView.initialsText(fromPrimaryText: state.primaryText,
                                                                                                                 secondaryText: state.secondaryText))
        let shouldUseCalculatedBackgroundColor = !initialsString.isEmpty && style != .overflow

        let ringInnerGap: CGFloat = isRingVisible ? tokens.ringInnerGap : 0
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

        let foregroundColor = state.foregroundColor ?? tokens.foregroundDefaultColor!
        let backgroundColor = state.backgroundColor ?? ( !shouldUseCalculatedBackgroundColor ?
                                                            tokens.backgroundDefaultColor! :
                                                            InitialsView.initialsBackgroundColor(fromPrimaryText: state.primaryText,
                                                                                                 secondaryText: state.secondaryText,
                                                                                                 colorOptions: tokens.backgroundCalculatedColorOptions))
        let ringGapColor = isTransparent ? Color.clear : Color(tokens.ringGapColor)
        let ringColor = !isRingVisible ? Color.clear : Color(state.ringColor ?? ( !shouldUseCalculatedBackgroundColor ?
                                                                                    tokens.ringDefaultColor! :
                                                                                    backgroundColor))

        let shouldUseDefaultImage = (state.image == nil && initialsString.isEmpty && style != .overflow)
        let avatarImage: UIImage? = ((style == .outlined || style == .outlinedPrimary) ? UIImage.staticImageNamed("person_48_regular") :
                                        (shouldUseDefaultImage ? UIImage.staticImageNamed("person_48_filled") : state.image))
        let avatarImageSizeRatio: CGFloat = (shouldUseDefaultImage) ? 0.7 : 1

        let avatarContent = (avatarImage != nil) ?
            AnyView(Image(uiImage: avatarImage!)
                        .resizable()
                        .foregroundColor(Color(foregroundColor)))
            :
            AnyView(Text(initialsString)
                        .foregroundColor(Color(tokens.textColor))
                        .font(Font(tokens.textFont)))

        let bodyView = tokens.style == .group ?
        AnyView(avatarContent
                    .background(Rectangle()
                                    .frame(width: tokens.avatarSize, height: tokens.avatarSize, alignment: .center)
                                    .foregroundColor(Color(backgroundColor)))
                    .frame(width: tokens.avatarSize, height: tokens.avatarSize, alignment: .center)
                    .cornerRadius(tokens.borderRadius))
            :
        AnyView(Circle()
                    .foregroundColor(ringGapColor)
                    .frame(width: ringOuterGapSize, height: ringOuterGapSize, alignment: .center)
                    .overlay(Circle()
                                .foregroundColor(ringColor)
                                .frame(width: ringSize, height: ringSize, alignment: .center)
                                .mask(circularCutoutMask(targetFrameRect: CGRect(x: 0,
                                                                                 y: 0,
                                                                                 width: ringSize,
                                                                                 height: ringSize),
                                                         cutoutFrameRect: CGRect(x: ringThickness,
                                                                                 y: ringThickness,
                                                                                 width: ringInnerGapSize,
                                                                                 height: ringInnerGapSize))
                                        .fill(style: FillStyle(eoFill: isTransparent)))
                                .overlay(Circle()
                                            .foregroundColor(ringGapColor)
                                            .frame(width: ringInnerGapSize, height: ringInnerGapSize, alignment: .center)
                                            .overlay(Circle()
                                                        .foregroundColor(Color(backgroundColor))
                                                        .frame(width: avatarImageSize, height: avatarImageSize, alignment: .center)
                                                        .overlay(avatarContent
                                                                    .frame(width: avatarImageSize * avatarImageSizeRatio, height: avatarImageSize * avatarImageSizeRatio, alignment: .center)
                                                                    .clipShape(Circle()),
                                                                 alignment: .center)
                                            )
                                )
                             ,
                             alignment: .center)
                    .mask(circularCutoutMask(targetFrameRect: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: ringOuterGapSize,
                                                                     height: ringOuterGapSize),
                                             cutoutFrameRect: CGRect(x: presenceCutoutOriginCoordinates,
                                                                     y: presenceCutoutOriginCoordinates,
                                                                     width: presenceIconOutlineSize,
                                                                     height: presenceIconOutlineSize))
                            .fill(style: FillStyle(eoFill: shouldDisplayPresence)))
                    .overlay(shouldDisplayPresence ?
                                AnyView(Circle()
                                            .foregroundColor(isTransparent ? Color.clear : Color(tokens.ringGapColor))
                                            .frame(width: presenceIconOutlineSize, height: presenceIconOutlineSize, alignment: .center)
                                            .overlay(presence.image(isOutOfOffice: isOutOfOffice)
                                                        .resizable()
                                                        .frame(width: presenceIconSize, height: presenceIconSize, alignment: .center)
                                                        .foregroundColor(presence.color(isOutOfOffice: isOutOfOffice)))
                                            .frame(width: presenceIconFrameSideRelativeToOuterRing, height: presenceIconFrameSideRelativeToOuterRing, alignment: .bottomTrailing)
                                )
                                :
                                AnyView(EmptyView()),
                             alignment: .topLeading))

        return bodyView
            .onAppear {
                // When environment values are available through the view hierarchy:
                //  - If we get a non-default theme through the environment values,
                //    we use to override the theme from this view and its hierarchy.
                //  - Otherwise we just refresh the tokens to reflect the theme
                //    associated with the window that this View belongs to.
                if theme == ThemeKey.defaultValue {
                    self.tokens.updateForCurrentTheme()
                } else {
                    self.tokens.theme = theme
                }
            }
    }

    func circularCutoutMask(targetFrameRect: CGRect, cutoutFrameRect: CGRect) -> Path {
        var cutoutFrame = Rectangle().path(in: targetFrameRect)
        cutoutFrame.addPath(Circle().path(in: cutoutFrameRect))

        return cutoutFrame
    }

    public func setStyle(style: MSFAvatarStyle) {
        tokens.style = style
    }

    public func setSize(size: MSFAvatarSize) {
        tokens.size = size
    }
}

/// UIKit wrapper that exposes the SwiftUI Button implementation
@objc open class MSFAvatar: NSObject, FluentUIWindowProvider {

    private var hostingController: UIHostingController<AnyView>!

    private var avatarview: AvatarView!

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFAvatarState {
        return self.avatarview.state
    }

    public var window: UIWindow? {
        return self.view.window
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
        self.avatarview = AvatarView(style: style,
                                           size: size)
        self.hostingController = UIHostingController(rootView: theme != nil ? AnyView(avatarview.usingTheme(theme!)) : AnyView(avatarview))

        super.init()

        avatarview.tokens.windowProvider = self
        self.view.backgroundColor = UIColor.clear
    }
}
