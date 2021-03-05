//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "Fonts")
public typealias MSFonts = Fonts

@objc(MSFFonts)
public final class Fonts: NSObject {
    /// Bold 34pt
    @objc public static var largeTitle: UIFont { return preferredFont(forTextStyle: .largeTitle, weight: .bold) }
    /// Bold 28 pt
    @objc public static var title1: UIFont { return preferredFont(forTextStyle: .title1, weight: .bold) }
    /// Semibold 22pt
    @objc public static var title2: UIFont { return preferredFont(forTextStyle: .title2, weight: .semibold) }
    /// Semibold 17pt
    @objc public static var headline: UIFont { return .preferredFont(forTextStyle: .headline) }
    /// Regular 17pt
    @objc public static var body: UIFont { return .preferredFont(forTextStyle: .body) }
    /// Regular 15pt
    @objc public static var subhead: UIFont { return .preferredFont(forTextStyle: .subheadline) }
    /// Regular 13pt
    @objc public static var footnote: UIFont { return .preferredFont(forTextStyle: .footnote) }
    /// Medium 15pt
    @objc public static var button1: UIFont { return preferredFont(forTextStyle: .subheadline, weight: .medium) }
    /// Medium 13pt
    @objc public static var button2: UIFont { return preferredFont(forTextStyle: .footnote, weight: .medium) }
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
    case body
    case subhead
    case footnote
    case button1
    case button2
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
        case .body:
            return Fonts.body
        case .subhead:
            return Fonts.subhead
        case .footnote:
            return Fonts.footnote
        case .button1:
            return Fonts.button1
        case .button2:
            return Fonts.button2
        case .caption1:
            return Fonts.caption1
        case .caption2:
            return Fonts.caption2
        }
    }
}
