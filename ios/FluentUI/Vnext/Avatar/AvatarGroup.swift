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
    @objc @Published public var avatars: [MSFAvatarStateImpl] = []
    @objc @Published public var style: MSFAvatarGroupStyle = .pile
    @objc @Published public var size: MSFAvatarSize = .large
}

/// View that represents the AvatarGroup
public struct AvatarGroup: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var state: MSFAvatarGroupState

    init() {
        self.state = MSFAvatarGroupState()
    }

    public var body: some View {
        let size = state.size.size
        HStack(spacing: 0) {
            ForEach(state.avatars, id: \.self) { avatar in
                AvatarView(style: .default, size: state.size, state: avatar)
                    .modifyIf(state.style == .stack, { view in
                        view.mask(AvatarCutout(cutoutOriginCoordinates: size - 16, outlineSize: size)
                                    .fill(style: FillStyle(eoFill: true)))
                    })
            }
        }
    }

    private struct AvatarCutout: Shape {
        var cutoutOriginCoordinates: CGFloat
        var outlineSize: CGFloat

        func path(in rect: CGRect) -> Path {
                var cutoutFrame = Rectangle().path(in: rect)
                cutoutFrame.addPath(Circle().path(in: CGRect(x: cutoutOriginCoordinates,
                                                             y: 0,
                                                             width: outlineSize,
                                                             height: outlineSize)))
                return cutoutFrame
        }
    }
}

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation
@objc open class MSFAvatarGroup: NSObject, FluentUIWindowProvider {
    @objc public init(theme: FluentUIStyle? = nil) {
        super.init()

        avatarGroupView = AvatarGroup()
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
