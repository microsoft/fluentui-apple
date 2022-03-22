//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation.
@objc open class MSFAvatarGroup: ControlHostingContainer {

    /// Creates a new MSFAvatarGroup instance.
    /// - Parameters:
    ///   - style: The MSFAvatarGroupStyle value used by the AvatarGroup.
    ///   - size: The MSFAvatarSize value used by the Avatars that will compose the AvatarGroup.
    @objc public init(style: MSFAvatarGroupStyle,
                      size: MSFAvatarSize) {
        let avatarGroup = AvatarGroup(style: style,
                                     size: size)
        state = avatarGroup.state
        super.init(AnyView(avatarGroup))
        view.backgroundColor = UIColor.clear
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the AvatarGroup appearance.
    @objc public let state: MSFAvatarGroupState
}
