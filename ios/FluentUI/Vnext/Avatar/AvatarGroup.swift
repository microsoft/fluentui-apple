//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that make up AvatarGroup content
@objc public class MSFAvatarGroupState: NSObject, ObservableObject {
    @objc @Published public var avatars: [MSFAvatarStateImpl] = []
    @objc @Published public var style: MSFAvatarStyle = .default
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
        HStack(spacing: 0) {
            ForEach(state.avatars, id: \.self) { avatar in
                AvatarView(style: state.style, size: state.size, state: avatar)
                    .padding(.trailing, 8)
            }
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
