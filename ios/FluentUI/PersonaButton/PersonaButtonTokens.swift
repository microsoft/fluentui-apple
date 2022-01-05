//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined sizes of the persona button
@objc public enum MSFPersonaButtonSize: Int, CaseIterable {
    case small
    case large

    var avatarSize: MSFAvatarSize {
        switch self {
        case .large:
            return .xxlarge
        case .small:
            return .xlarge
        }
    }

    var shouldShowSubtitle: Bool {
        switch self {
        case .large:
            return true
        case .small:
            return false
        }
    }
}

/// Representation of design tokens to persona buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI persona button to update its view automatically.
public class PersonaButtonTokens: ControlTokens {
    @Published public var avatarInterspace: CGFloat!
    @Published public var backgroundColor: UIColor!
    @Published public var horizontalAvatarPadding: CGFloat!
    @Published public var horizontalTextPadding: CGFloat!
    @Published public var labelColor: UIColor!
    @Published public var labelFont: UIFont!
    @Published public var sublabelColor: UIColor!
    @Published public var sublabelFont: UIFont!
    @Published public var verticalPadding: CGFloat!

    var size: MSFPersonaButtonSize

    init(size: MSFPersonaButtonSize) {
        self.size = size

        super.init()

    }
}
