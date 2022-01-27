//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `AvatarGroup` control
public class AvatarGroupTokens: ControlTokens {
    /// Creates an instance of `AvatarGroupTokens`with optional token value overrides.
    /// - Parameters:
    ///   - interspace: CGFloat that defines the space between  the `Avatar` controls hosted by the `AvatarGroup`
    ///   - ringInnerGap: CGFloat that defines the thickness of the space between the `Avatar` and its ring
    ///   - ringThickness: CGFloat that defines the thickness of the ring around the `Avatar`
    ///   - ringOuterGap: CGFloat that defines the thickness of the space around the ring of the `Avatar`
    public init (style: MSFAvatarGroupStyle,
                 size: MSFAvatarSize,
                 interspace: CGFloat? = nil,
                 ringInnerGap: CGFloat? = nil,
                 ringThickness: CGFloat? = nil,
                 ringOuterGap: CGFloat? = nil) {
        self.style = style
        self.size = size

        super.init()

        // Optional overrides
        if let interspace = interspace {
            self.interspace = interspace
        }

        if let ringInnerGap = ringInnerGap {
            self.ringInnerGap = ringInnerGap
        }

        if let ringThickness = ringThickness {
            self.ringThickness = ringThickness
        }

        if let ringOuterGap = ringOuterGap {
            self.ringOuterGap = ringOuterGap
        }
    }

    // MARK: - Design Tokens

    let style: MSFAvatarGroupStyle
    let size: MSFAvatarSize

    lazy var interspace: CGFloat = {
        switch style {
        case .stack:
            switch size {
            case .xsmall, .small:
                return -2 // -spacing[.xxxsmall]
            case .medium:
                return -4 // -spacing[.xxsmall]
            case .large:
                return -8 // -spacing[.xsmall]
            case .xlarge, .xxlarge:
                return -12 // -spacing[.small]
            }
        case .pile:
            switch size {
            case .xsmall, .small:
                return globalTokens.spacing[.xxSmall]
            case .medium, .large, .xlarge, .xxlarge:
                return globalTokens.spacing[.xSmall]
            }
        }
    }()

    lazy var ringInnerGap: CGFloat = {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }()

    lazy var ringThickness: CGFloat = {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }()

    lazy var ringOuterGap: CGFloat = {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }()
}
