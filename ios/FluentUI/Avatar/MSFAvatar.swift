//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Avatar implementation.
@objc public class MSFAvatar: ControlHostingContainer {

    /// Creates a new MSFAvatar instance.
    /// - Parameters:
    ///   - style: The MSFAvatarStyle value used by the Avatar.
    ///   - size: The MSFAvatarSize value used by the Avatar.
    @objc public init(style: MSFAvatarStyle = .default,
                      size: MSFAvatarSize = .large) {
        let avatar = Avatar(style: style,
                            size: size)
        state = avatar.state
        super.init(AnyView(avatar))
    }

    /// The object that groups properties that allow control over the Avatar appearance.
    @objc public let state: MSFAvatarState
}
