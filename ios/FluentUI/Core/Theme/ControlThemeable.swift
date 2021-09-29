//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public protocol CardNudgeThemeable {
    var accentColor: ColorSet { get }
    var accentIconSize: CGFloat { get }
    var accentPadding: CGFloat { get }
    var backgroundColor: ColorSet { get }
    var buttonBackgroundColor: ColorSet { get }
    var buttonInnerPaddingHorizontal: CGFloat { get }
    var circleSize: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var horizontalPadding: CGFloat { get }
    var iconSize: CGFloat { get }
    var interTextVerticalPadding: CGFloat { get }
    var mainContentVerticalPadding: CGFloat { get }
    var minimumHeight: CGFloat { get }
    var outlineColor: ColorSet { get }
    var outlineWidth: CGFloat { get }
    var subtitleTextColor: ColorSet { get }
    var textColor: ColorSet { get }
    var verticalPadding: CGFloat { get }
}
