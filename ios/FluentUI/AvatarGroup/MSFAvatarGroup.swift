//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI AvatarGroup implementation.
@objc open class MSFAvatarGroup: ControlHostingView {

    /// Creates a new MSFAvatarGroup instance.
    /// - Parameters:
    ///   - style: The MSFAvatarGroupStyle value used by the AvatarGroup.
    ///   - size: The MSFAvatarSize value used by the Avatars that will compose the AvatarGroup.
    @objc public init(style: MSFAvatarGroupStyle,
                      size: MSFAvatarSize) {
        let avatarGroup = AvatarGroup(style: style,
                                     size: size)
        state = avatarGroup.state
        tokenSet = avatarGroup.tokenSet
        super.init(AnyView(avatarGroup))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the AvatarGroup appearance.
    @objc public let state: MSFAvatarGroupState

    /// Access to the control's `ControlTokenSet` for reading default values and providing overrides.
    public let tokenSet: AvatarGroupTokenSet
}
