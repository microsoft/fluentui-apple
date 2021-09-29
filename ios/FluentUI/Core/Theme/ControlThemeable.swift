//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public protocol CardNudgeThemeable {
    var accentColor: ColorSet { get }
    var accentIconSize: Int { get }
    var accentPadding: Int { get }
    var backgroundColor: ColorSet { get }
    var buttonBackgroundColor: ColorSet { get }
    var buttonInnerPaddingHorizontal: Int { get }
    var circleSize: Int { get }
    var cornerRadius: Int { get }
    var horizontalPadding: Int { get }
    var iconSize: Int { get }
    var interTextVerticalPadding: Int { get }
    var mainContentVerticalPadding: Int { get }
    var minimumHeight: Int { get }
    var outlineColor: ColorSet { get }
    var outlineWidth: Int { get }
    var subtitleTextColor: ColorSet { get }
    var textColor: ColorSet { get }
    var verticalPadding: Int { get }
}
