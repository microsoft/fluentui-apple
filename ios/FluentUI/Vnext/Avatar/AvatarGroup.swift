//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public enum MSFAvatarGroupStyle: Int, CaseIterable {
    case stack
    case pile
}

/// Properties that make up AvatarGroup content
@objc public class MSFAvatarGroupState: NSObject, ObservableObject {
    @objc @Published public var avatars: [MSFAvatarState] = []
    @objc @Published public var maxDisplayedAvatars: UInt32 = UInt32.max
    @objc @Published public var overflowCount: UInt = 0
}

/// View that represents the AvatarGroup
public struct AvatarGroup: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: MSFAvatarGroupState
    @ObservedObject var tokens: MSFAvatarGroupTokens

    init(style: MSFAvatarGroupStyle, size: MSFAvatarSize) {
        self.state = MSFAvatarGroupState()
        self.tokens = MSFAvatarGroupTokens(style: style, size: size)
    }

    public var body: some View {
        let size = tokens.size.size
        let x: CGFloat = size + tokens.interspace - tokens.ringOuterGap - tokens.ringThickness
        let avatars = state.avatars
        let maxDisplayedAvatars = avatars.prefix(Int(state.maxDisplayedAvatars)).count
        let overflowCount = (avatars.count > maxDisplayedAvatars ? UInt(avatars.count - maxDisplayedAvatars) : 0) + state.overflowCount
        HStack(spacing: 0) {
            ForEach(0 ..< maxDisplayedAvatars) { index in
                // maxDisplayed is updating but index isn't iterating through them ?
                let modify = tokens.style == .stack && overflowCount > 0
                    AvatarView(style: .default, size: tokens.size, state: avatars[index])
                        .modifyIf(modify, { view in
                            view.mask(AvatarCutout(xOrigin: x,
                                                   yOrigin: 0,
                                                   cutoutSize: size)
                                        .fill(style: FillStyle(eoFill: true)))
                        })
                        .padding(.trailing, tokens.interspace)
            }
            if overflowCount > 0 {
                createOverflow(count: Int(overflowCount))
            }
        }
    }

    private func createOverflow(count: Int) -> AvatarView {
        let overflow = MSFAvatarStateImpl()
        overflow.primaryText = "\(count)"
        return AvatarView(style: .overflow, size: tokens.size, state: overflow)
    }

    /// Cutout shape for the succeeding Avatar in an Avatar Group in Stack style.
    ///
    /// xOrigin: beginning location of cutout on the x axis
    ///
    /// yOrigin: beginning location of cutout on the y axis
    ///
    /// cutoutSize: dimensions of cutout shape of the Avatar
    private struct AvatarCutout: Shape {
        var xOrigin: CGFloat
        var yOrigin: CGFloat
        var cutoutSize: CGFloat

        func path(in rect: CGRect) -> Path {
                var cutoutFrame = Rectangle().path(in: rect)
                cutoutFrame.addPath(Circle().path(in: CGRect(x: xOrigin,
                                                             y: yOrigin,
                                                             width: cutoutSize,
                                                             height: cutoutSize)))
                return cutoutFrame
        }
    }
}

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation
@objc open class MSFAvatarGroup: NSObject, FluentUIWindowProvider {
    @objc public init(style: MSFAvatarGroupStyle = .stack, size: MSFAvatarSize = .large, theme: FluentUIStyle? = nil) {
        super.init()

        avatarGroupView = AvatarGroup(style: style, size: size)
        hostingController = UIHostingController(rootView: AnyView(avatarGroupView
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaView in
                                                                        personaView.customTheme(theme!)
                                                                    })))
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience override init() {
        self.init(theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFAvatarGroupState {
        return avatarGroupView.state
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var avatarGroupView: AvatarGroup!
}
