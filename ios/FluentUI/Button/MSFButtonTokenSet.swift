//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ButtonStyle

@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case dangerFilled
    case dangerOutline
    case secondaryOutline
    case tertiaryOutline
    case borderless

    public var contentEdgeInsets: NSDirectionalEdgeInsets {
        switch self {
        case .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        case .secondaryOutline:
            return NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        case .borderless:
            return NSDirectionalEdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12)
        case .tertiaryOutline:
            return NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .borderless, .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline, .secondaryOutline:
            return 8
        case .tertiaryOutline:
            return 5
        }
    }

    var hasBorders: Bool {
        switch self {
        case .dangerOutline, .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return true
        case .borderless, .dangerFilled, .primaryFilled:
            return false
        }
    }

    var isDangerStyle: Bool {
        switch self {
        case .dangerFilled, .dangerOutline:
            return true
        case .borderless, .primaryFilled, .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return false
        }
    }

    var isFilledStyle: Bool {
        switch self {
        case .dangerFilled, .primaryFilled:
            return true
        case .borderless, .dangerOutline, .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return false
        }
    }

    var minTitleLabelHeight: CGFloat {
        switch self {
        case .borderless, .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return 20
        case .secondaryOutline, .tertiaryOutline:
            return 18
        }
    }

    var titleFont: UIFont {
        switch self {
        case .borderless, .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return Fonts.button1
        case .secondaryOutline, .tertiaryOutline:
            return Fonts.button2
        }
    }

    var titleImagePadding: CGFloat {
        switch self {
        case .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return 10
        case .secondaryOutline, .borderless:
            return 8
        case .tertiaryOutline:
            return 0
        }
    }
}


