//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Avatar implementation.
@objc open class MSFAvatar: NSObject, FluentUIWindowProvider {

    /// The UIView representing the Avatar.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the Avatar appearance.
    @objc open var state: MSFAvatarState {
        return avatar.state
    }

    /// Creates a new MSFAvatar instance.
    /// - Parameters:
    ///   - style: The MSFAvatarStyle value used by the Avatar.
    ///   - size: The MSFAvatarSize value used by the Avatar.
    @objc public convenience init(style: MSFAvatarStyle = .default,
                                  size: MSFAvatarSize = .large) {
        self.init(style: style,
                  size: size,
                  theme: nil)
    }

    /// Creates a new MSFAvatar instance.
    /// - Parameters:
    ///   - style: The MSFAvatarStyle value used by the Avatar.
    ///   - size: The MSFAvatarSize value used by the Avatar.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this Avatar.
    @objc public init(style: MSFAvatarStyle,
                      size: MSFAvatarSize,
                      theme: FluentUIStyle?) {
        super.init()

        avatar = Avatar(style: style,
                        size: size)
        hostingController = FluentUIHostingController(rootView: AnyView(avatar
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { avatar in
                                                                                avatar.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: FluentUIHostingController!

    private var avatar: Avatar!
}

