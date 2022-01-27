//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation.
@objc open class MSFAvatarGroup: NSObject, FluentUIWindowProvider {

    /// The UIView representing the AvatarGroup.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the AvatarGroup appearance.
    @objc open var state: MSFAvatarGroupState {
        return avatarGroup.state
    }

    /// Creates a new MSFAvatarGroup instance.
    /// - Parameters:
    ///   - style: The MSFAvatarGroupStyle value used by the AvatarGroup.
    ///   - size: The MSFAvatarSize value used by the Avatars that will compose the AvatarGroup.
    @objc public convenience init(style: MSFAvatarGroupStyle = .stack,
                                  size: MSFAvatarSize = .large) {
        self.init(style: style,
                  size: size,
                  theme: nil)
    }

    /// Creates a new MSFAvatarGroup instance.
    /// - Parameters:
    ///   - style: The MSFAvatarGroupStyle value used by the AvatarGroup.
    ///   - size: The MSFAvatarSize value used by the Avatars that will compose the AvatarGroup.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this AvatarGroup.
    @objc public init(style: MSFAvatarGroupStyle,
                      size: MSFAvatarSize,
                      theme: FluentUIStyle?) {
        super.init()

        avatarGroup = AvatarGroup(style: style,
                                  size: size)
        hostingController = FluentUIHostingController(rootView: AnyView(avatarGroup
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { avatarGroupView in
                                                                                avatarGroupView.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: FluentUIHostingController!

    private var avatarGroup: AvatarGroup!
}
