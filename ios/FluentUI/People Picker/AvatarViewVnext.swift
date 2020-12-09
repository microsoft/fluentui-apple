//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(AvatarVnextStyle)
/// Pre-defined styles of the avatar
public enum AvatarVnextStyle: Int, CaseIterable {
    case `default`
    case noring
    case unauthenticated
    case overflow
    case group
}

@objc(MSFAvatarVnextSize)
/// Pre-defined sizes of the avatar
public enum AvatarVnextSize: Int, CaseIterable {
    case xsmall
    case small
    case medium
    case large
    case xlarge
    case xxlarge
}

@objc(MSFAvatarVnextPresence)
public enum AvatarVnextPresence: Int, CaseIterable {
    case none
    case available
    case away
    case busy
    case doNotDisturb
    case outOfOffice
    case offline
    case unknown
    case blocked

    public func color() -> UIColor? {
        var color: UIColor?

        switch self {
        case .none:
            break
        case .available:
            color = Colors.Palette.presenceAvailable.color
        case .away:
            color = Colors.Palette.presenceAway.color
        case .busy:
            color = Colors.Palette.presenceBusy.color
        case .doNotDisturb:
            color = Colors.Palette.presenceDnd.color
        case .outOfOffice:
            color = Colors.Palette.presenceOof.color
        case .offline:
            color = Colors.Palette.presenceOffline.color
        case .unknown:
            color = Colors.Palette.presenceUnknown.color
        case .blocked:
            color = Colors.Palette.presenceBlocked.color
        }

        return color
    }

    public func image() -> UIImage? {
        var imageName: String?

        switch self {
        case .none:
            break
        case .available:
            imageName = "ic_fluent_presence_available_16_filled"
        case .away:
            imageName = "ic_fluent_presence_away_16_filled"
        case .busy:
            imageName = "ic_fluent_presence_busy_16_filled"
        case .doNotDisturb:
            imageName = "ic_fluent_presence_dnd_16_filled"
        case .outOfOffice:
            imageName = "ic_fluent_presence_oof_16_regular"
        case .offline:
            imageName = "ic_fluent_presence_offline_16_regular"
        case .unknown:
            imageName = "ic_fluent_presence_unknown_16_regular"
        case .blocked:
            imageName = "ic_fluent_presence_blocked_16_regular"
        }

        var image: UIImage?
        if let imageName = imageName {
            image = UIImage.staticImageNamed(imageName)
        }

        return image
    }
}

@objc(MSFAvatarVnextState)
/// Properties available to customize the state of the avatar
public class AvatarVnextState: NSObject, ObservableObject {
    @objc @Published public var image: UIImage?
    @objc @Published public var primaryText: String?
    @objc @Published public var secondaryText: String?
    @objc @Published public var ringColor: UIColor?
    @objc @Published public var backgroundColor: UIColor?
    @objc @Published public var foregroundColor: UIColor?
    @objc @Published public var presence: AvatarVnextPresence = .none
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
public class AvatarTokens: ObservableObject {
    @Published public var avatarSize: CGFloat!
    @Published public var borderRadius: CGFloat!
    @Published public var textFont: UIFont!

    @Published public var ringDefaultColor: UIColor!
    @Published public var ringGapColor: UIColor!
    @Published public var ringThickness: CGFloat!
    @Published public var ringInnerGap: CGFloat!
    @Published public var ringOuterGap: CGFloat!

    @Published public var presenceIconSize: CGFloat!
    @Published public var presenceIconOutlineThickness: CGFloat!
    @Published public var presenceOutlineColor: UIColor!

    @Published public var backgroundDefaultColor: UIColor!
    @Published public var foregroundDefaultColor: UIColor!

    public var style: AvatarVnextStyle!
    public var size: AvatarVnextSize!

    public init(style: AvatarVnextStyle,
                size: AvatarVnextSize) {
        self.style = style
        self.size = size
        self.themeAware = true

        didChangeAppearanceProxy()
    }

    @objc open func didChangeAppearanceProxy() {
        var appearanceProxy: ApperanceProxyType

        switch style {
        case .default, .none:
            appearanceProxy = StylesheetManager.S.AvatarTokens
        case .noring:
            appearanceProxy = StylesheetManager.S.NoRingAvatarTokens
        case .unauthenticated:
            appearanceProxy = StylesheetManager.S.UnauthenticatedAvatarTokens
        case .overflow:
            appearanceProxy = StylesheetManager.S.OverflowAvatarTokens
        case .group:
            appearanceProxy = StylesheetManager.S.GroupAvatarTokens
        }

        ringDefaultColor = appearanceProxy.ringDefaultColor
        ringGapColor = appearanceProxy.ringGapColor
        presenceOutlineColor = appearanceProxy.presenceIconOutlineColor
        backgroundDefaultColor = appearanceProxy.backgroundDefaultColor
        foregroundDefaultColor = appearanceProxy.foregroundDefaultColor

        switch size {
        case .xsmall:
            avatarSize = appearanceProxy.size.xSmall
            borderRadius = appearanceProxy.borderRadius.xSmall
            ringThickness = appearanceProxy.ringThickness.xSmall
            ringInnerGap = appearanceProxy.ringInnerGap.xSmall
            ringOuterGap = appearanceProxy.ringOuterGap.xSmall
            presenceIconSize = appearanceProxy.presenceIconSize.xSmall
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.xSmall
            textFont = appearanceProxy.textFont.xSmall
        case .small:
            avatarSize = appearanceProxy.size.small
            borderRadius = appearanceProxy.borderRadius.small
            ringThickness = appearanceProxy.ringThickness.small
            ringInnerGap = appearanceProxy.ringInnerGap.small
            ringOuterGap = appearanceProxy.ringOuterGap.small
            presenceIconSize = appearanceProxy.presenceIconSize.small
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.small
            textFont = appearanceProxy.textFont.small
        case .medium:
            avatarSize = appearanceProxy.size.medium
            borderRadius = appearanceProxy.borderRadius.medium
            ringThickness = appearanceProxy.ringThickness.medium
            ringInnerGap = appearanceProxy.ringInnerGap.medium
            ringOuterGap = appearanceProxy.ringOuterGap.medium
            presenceIconSize = appearanceProxy.presenceIconSize.medium
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.medium
            textFont = appearanceProxy.textFont.medium
        case .large, .none:
            avatarSize = appearanceProxy.size.large
            borderRadius = appearanceProxy.borderRadius.large
            ringThickness = appearanceProxy.ringThickness.large
            ringInnerGap = appearanceProxy.ringInnerGap.large
            ringOuterGap = appearanceProxy.ringOuterGap.large
            presenceIconSize = appearanceProxy.presenceIconSize.large
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.large
            textFont = appearanceProxy.textFont.large
        case .xlarge:
            avatarSize = appearanceProxy.size.xlarge
            borderRadius = appearanceProxy.borderRadius.xlarge
            ringThickness = appearanceProxy.ringThickness.xlarge
            ringInnerGap = appearanceProxy.ringInnerGap.xlarge
            ringOuterGap = appearanceProxy.ringOuterGap.xlarge
            presenceIconSize = appearanceProxy.presenceIconSize.xlarge
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.xlarge
            textFont = appearanceProxy.textFont.xlarge
        case .xxlarge:
            avatarSize = appearanceProxy.size.xxlarge
            borderRadius = appearanceProxy.borderRadius.xxlarge
            ringThickness = appearanceProxy.ringThickness.xxlarge
            ringInnerGap = appearanceProxy.ringInnerGap.xxlarge
            ringOuterGap = appearanceProxy.ringOuterGap.xxlarge
            presenceIconSize = appearanceProxy.presenceIconSize.xxlarge
            presenceIconOutlineThickness = appearanceProxy.presenceIconOutlineThickness.xxlarge
            textFont = appearanceProxy.textFont.xxlarge
        }
    }
}

/// View that represents the avatar
public struct AvatarVnextView: View {
    @ObservedObject var tokens: AvatarTokens
    @ObservedObject var state: AvatarVnextState

    public init(style: AvatarVnextStyle,
                size: AvatarVnextSize) {
        self.tokens = AvatarTokens(style: style, size: size)
        self.state = AvatarVnextState()
    }

    public var body: some View {
        let avatarImageSize: CGFloat = tokens.avatarSize!
        let ringInnerGapSize: CGFloat = avatarImageSize + (tokens.ringInnerGap * 2)
        let ringSize: CGFloat = ringInnerGapSize + (tokens.ringThickness * 2)
        let ringOuterGapSize: CGFloat = ringSize + (tokens.ringOuterGap * 2)
        let presenceIconSize: CGFloat = tokens.presenceIconSize!
        let presenceIconOutlineSize: CGFloat = presenceIconSize + (tokens.presenceIconOutlineThickness * 2)

        // Calculates the positioning of the presence icon ensuring its center is always on top of the avatar circle's edge
        let ringInnerGapRadius: CGFloat = (ringInnerGapSize / 2)
        let ringInnerGapHypotenuse: CGFloat = sqrt(2 * pow(ringInnerGapRadius, 2))
        let presenceIconHypotenuse: CGFloat = sqrt(2 * pow(presenceIconOutlineSize / 2, 2))
        let presenceFrameHypotenuse: CGFloat = ringInnerGapHypotenuse + ringInnerGapRadius + presenceIconHypotenuse
        let presenceIconFrameSide: CGFloat = sqrt(pow(presenceFrameHypotenuse, 2) / 2)

        let ringColor = state.ringColor ?? tokens.ringDefaultColor!
        let backgroundColor = state.backgroundColor ?? tokens.backgroundDefaultColor!
        let foregroundColor = state.foregroundColor ?? tokens.foregroundDefaultColor!

        let presence = state.presence
        let style = tokens.style
        let initialsString: String = ((style == .overflow) ? state.primaryText ?? "" : InitialsView.initialsText(fromPrimaryText: state.primaryText,
                                                                                                                 secondaryText: state.secondaryText))
        let shouldUseDefaultImage = (state.image == nil && initialsString.isEmpty && style != .overflow)
        let avatarImage: UIImage? = ((style == .unauthenticated) ? UIImage.staticImageNamed("person_48_regular") :
                                        (shouldUseDefaultImage ? UIImage.staticImageNamed("person_48_filled") : state.image))
        let avatarImageSizeRatio: CGFloat = (style == .unauthenticated || shouldUseDefaultImage) ? 0.7 : 1

        let avatarContent = (avatarImage != nil) ?
            AnyView(Image(uiImage: avatarImage!)
                        .resizable()
                        .foregroundColor(Color(foregroundColor)))
            :
            AnyView(Text(initialsString)
                        .foregroundColor(Color(foregroundColor))
                        .font(Font(tokens.textFont)))

        if tokens.style == .group {
            avatarContent
                .background(Rectangle()
                                .frame(width: tokens.avatarSize, height: tokens.avatarSize, alignment: .center)
                                .foregroundColor(Color(backgroundColor)))
                .frame(width: tokens.avatarSize, height: tokens.avatarSize, alignment: .center)
                .cornerRadius(tokens.borderRadius)
        } else {
            Circle()
                .foregroundColor(Color(tokens.ringGapColor))
                .frame(width: ringOuterGapSize, height: ringOuterGapSize, alignment: .center)
                .overlay(Circle()
                            .foregroundColor(Color(ringColor))
                            .frame(width: ringSize, height: ringSize, alignment: .center)
                            .overlay(Circle()
                                        .foregroundColor(Color(tokens.ringGapColor))
                                        .frame(width: ringInnerGapSize, height: ringInnerGapSize, alignment: .center)
                                        .overlay(Circle()
                                                    .foregroundColor(Color(backgroundColor))
                                                    .frame(width: avatarImageSize, height: avatarImageSize, alignment: .center)
                                                    .overlay(avatarContent
                                                                .frame(width: avatarImageSize * avatarImageSizeRatio, height: avatarImageSize * avatarImageSizeRatio, alignment: .center)
                                                                .clipShape(Circle()),
                                                             alignment: .center)
                                        )
                                        .overlay((presence != .none) ?
                                                    AnyView(Circle()
                                                                .foregroundColor(Color(tokens.presenceOutlineColor))
                                                                .frame(width: presenceIconOutlineSize, height: presenceIconOutlineSize, alignment: .center)
                                                                .overlay(Image(uiImage: presence.image()!)
                                                                            .resizable()
                                                                            .frame(width: presenceIconSize, height: presenceIconSize, alignment: .center)
                                                                            .foregroundColor(Color(presence.color()!)))
                                                                .frame(width: presenceIconFrameSide, height: presenceIconFrameSide, alignment: .bottomTrailing)
                                                    )
                                                    :
                                                    AnyView(EmptyView()),
                                                 alignment: .topLeading)
                            ),
                         alignment: .center)
        }
    }
}

@objc(MSFAvatarVnext)
/// UIKit wrapper that exposes the SwiftUI Button implementation
open class AvatarVnext: NSObject {

    private var hostingController: UIHostingController<AvatarVnextView>

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: AvatarVnextState {
        return self.hostingController.rootView.state
    }

    @objc public init(style: AvatarVnextStyle = .default,
                      size: AvatarVnextSize = .large) {
        self.hostingController = UIHostingController(rootView: AvatarVnextView(style: style,
                                                                               size: size))
        super.init()
        self.view.backgroundColor = UIColor.clear
    }
}
