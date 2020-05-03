//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "Fonts")
public typealias MSFonts = Fonts

@objc(MSFFonts)
public final class Fonts: NSObject {
    /// Bold 30pt - Does not scale automatically with Dynamic Type
    @objc public static let largeTitle = UIFont.systemFont(ofSize: 30, weight: .bold)
    /// Bold 26pt - Does not scale automatically with Dynamic Type
    @objc public static let title1 = UIFont.systemFont(ofSize: 26, weight: .bold)
    /// Semibold 22pt
    @objc public static var title2: UIFont { return preferredFont(forTextStyle: .title2, weight: .semibold) }
    /// Semibold 17pt
    @objc public static var headline: UIFont { return .preferredFont(forTextStyle: .headline) }
    @objc public static var headlineUnscaled: UIFont { return .preferredFont(forTextStyle: .headline, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)) }
    /// Regular 17pt
    @objc public static var body: UIFont { return .preferredFont(forTextStyle: .body) }
    @objc public static var bodyUnscaled: UIFont { return .preferredFont(forTextStyle: .body, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)) }
    /// Regular 15pt
    @objc public static var subhead: UIFont { return .preferredFont(forTextStyle: .subheadline) }
    /// Regular 13pt
    @objc public static var footnote: UIFont { return .preferredFont(forTextStyle: .footnote) }
    @objc public static var footnoteUnscaled: UIFont { return .preferredFont(forTextStyle: .footnote, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)) }
    /// Medium 15pt
    @objc public static var button1: UIFont { return preferredFont(forTextStyle: .subheadline, weight: .medium) }
    /// Medium 13pt
    @objc public static var button2: UIFont { return preferredFont(forTextStyle: .footnote, weight: .medium) }
    /// Medium 10pt - Does not scale automatically with Dynamic Type
    @objc public static let button3 = UIFont.systemFont(ofSize: 10, weight: .medium)
    /// Medium 15pt - Does not scale automatically with Dynamic Type
    @objc public static let button4 = UIFont.systemFont(ofSize: 15, weight: .medium)
    /// Regular 12pt
    @objc public static var caption1: UIFont { return .preferredFont(forTextStyle: .caption1) }
    /// Regular 11pt
    @objc public static var caption2: UIFont { return .preferredFont(forTextStyle: .caption2) }

    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight, size: CGFloat? = 0) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let newDescriptor = descriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        let pointSize: CGFloat
        if let size = size, size > 0 {
            pointSize = size
        } else {
            pointSize = descriptor.pointSize
        }
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }

    private override init() {
        super.init()
    }
}

@available(*, deprecated, renamed: "TextStyle")
public typealias MSTextStyle = TextStyle

@objc(MSFTextStyle)
public enum TextStyle: Int, CaseIterable {
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
            return Fonts.largeTitle
        case .title1:
            return Fonts.title1
        case .title2:
            return Fonts.title2
        case .headline:
            return Fonts.headline
        case .headlineUnscaled:
            return Fonts.headlineUnscaled
        case .body:
            return Fonts.body
        case .bodyUnscaled:
            return Fonts.bodyUnscaled
        case .subhead:
            return Fonts.subhead
        case .footnote:
            return Fonts.footnote
        case .footnoteUnscaled:
            return Fonts.footnoteUnscaled
        case .button1:
            return Fonts.button1
        case .button2:
            return Fonts.button2
        case .button3:
            return Fonts.button3
        case .caption1:
            return Fonts.caption1
        case .caption2:
            return Fonts.caption2
        }
    }
}
