//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Avatar implementation.
@objc open class MSFAvatar: ControlHostingView {

    /// Creates a new MSFAvatar instance.
    /// - Parameters:
    ///   - style: The MSFAvatarStyle value used by the Avatar.
    ///   - size: The MSFAvatarSize value used by the Avatar.
    @objc public init(style: MSFAvatarStyle = .default,
                      size: MSFAvatarSize = .size40) {
        let avatar = Avatar(style: style,
                            size: size)
        state = avatar.state
        tokenSet = avatar.tokenSet
        super.init(AnyView(avatar))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the Avatar appearance.
    @objc public let state: MSFAvatarState

    /// Access to the control's `ControlTokenSet` for reading default values and providing overrides.
    public let tokenSet: AvatarTokenSet
}
