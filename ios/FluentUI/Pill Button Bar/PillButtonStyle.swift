//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - PillButtonStyle

@objc(MSFPillButtonStyle)
public enum PillButtonStyle: Int {
    /// primary: the default style of PillButton; use this style in conjunction with a neutral or white background.
    case primary

    /// onBrand: use this style in conjunction with branded background where the background features
    /// a prominent brand color in light mode and a muted gray in dark mode.
    case onBrand
}
