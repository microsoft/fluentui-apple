//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objcMembers
public final class MSFonts: NSObject {
    /// Bold 30pt - Does not scale automatically with Dynamic Type
    public static let largeTitle = UIFont.systemFont(ofSize: 30, weight: .bold)
    /// Bold 26pt - Does not scale automatically with Dynamic Type
    public static let title1 = UIFont.systemFont(ofSize: 26, weight: .bold)
    /// Semibold 22pt
    public static var title2: UIFont { return UIFont.preferredFont(forTextStyle: .title2).withWeight(.semibold) }
    /// Semibold 17pt
    public static var headline: UIFont { return .preferredFont(forTextStyle: .headline) }
    public static var headlineUnscaled: UIFont { return .preferredFont(forTextStyle: .headline, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)) }
    /// Regular 17pt
    public static var body: UIFont { return .preferredFont(forTextStyle: .body) }
    public static var bodyUnscaled: UIFont { return .preferredFont(forTextStyle: .body, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)) }
    /// Regular 15pt
    public static var subhead: UIFont { return .preferredFont(forTextStyle: .subheadline) }
    /// Regular 13pt
    public static var footnote: UIFont { return .preferredFont(forTextStyle: .footnote) }
    public static var footnoteUnscaled: UIFont { return .preferredFont(forTextStyle: .footnote, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)) }
    /// Medium 15pt
    public static var button1: UIFont { return UIFont.preferredFont(forTextStyle: .subheadline).withWeight(.medium) }
    /// Medium 13pt
    public static var button2: UIFont { return UIFont.preferredFont(forTextStyle: .footnote).withWeight(.medium) }
    /// Medium 10pt - Does not scale automatically with Dynamic Type
    public static let button3 = UIFont.systemFont(ofSize: 10, weight: .medium)
    /// Regular 12pt
    public static var caption1: UIFont { return .preferredFont(forTextStyle: .caption1) }
    /// Regular 11pt
    public static var caption2: UIFont { return .preferredFont(forTextStyle: .caption2) }

    private override init() {
        super.init()
    }
}

@objc public enum MSTextStyle: Int, CaseIterable {
    case largeTitle
    case title1
    case title2
    case headline
    case headlineUnscaled
    case body
    case bodyUnscaled
    case subhead
    case footnote
    case footnoteUnscaled
    case button1
    case button2
    case button3
    case caption1
    case caption2

    public var font: UIFont {
        switch self {
        case .largeTitle:
            return MSFonts.largeTitle
        case .title1:
            return MSFonts.title1
        case .title2:
            return MSFonts.title2
        case .headline:
            return MSFonts.headline
        case .headlineUnscaled:
            return MSFonts.headlineUnscaled
        case .body:
            return MSFonts.body
        case .bodyUnscaled:
            return MSFonts.bodyUnscaled
        case .subhead:
            return MSFonts.subhead
        case .footnote:
            return MSFonts.footnote
        case .footnoteUnscaled:
            return MSFonts.footnoteUnscaled
        case .button1:
            return MSFonts.button1
        case .button2:
            return MSFonts.button2
        case .button3:
            return MSFonts.button3
        case .caption1:
            return MSFonts.caption1
        case .caption2:
            return MSFonts.caption2
        }
    }
}
