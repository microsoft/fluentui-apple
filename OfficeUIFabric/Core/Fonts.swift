//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public struct MSFonts {
    /// Semibold 28pt
    public static var title1: UIFont { return UIFont.preferredFont(forTextStyle: .title1).withWeight(.semibold) }
    /// Semibold 22pt
    public static var title2: UIFont { return UIFont.preferredFont(forTextStyle: .title2).withWeight(.semibold) }
    /// Semibold 17pt
    public static var headline: UIFont { return .preferredFont(forTextStyle: .headline) }
    /// Regular 17pt
    public static var body: UIFont { return .preferredFont(forTextStyle: .body) }
    /// Regular 15pt
    public static var subhead: UIFont { return .preferredFont(forTextStyle: .subheadline) }
    /// Regular 13pt
    public static var footnote: UIFont { return .preferredFont(forTextStyle: .footnote) }
    /// Regular 12pt
    public static var caption1: UIFont { return .preferredFont(forTextStyle: .caption1) }
    /// Regular 11pt
    public static var caption2: UIFont { return .preferredFont(forTextStyle: .caption2) }
}

@objc public enum MSTextStyle: Int, CaseIterable {
    case title1
    case title2
    case headline
    case body
    case subhead
    case footnote
    case caption1
    case caption2

    public var font: UIFont {
        switch self {
        case .title1:
            return MSFonts.title1
        case .title2:
            return MSFonts.title2
        case .headline:
            return MSFonts.headline
        case .body:
            return MSFonts.body
        case .subhead:
            return MSFonts.subhead
        case .footnote:
            return MSFonts.footnote
        case .caption1:
            return MSFonts.caption1
        case .caption2:
            return MSFonts.caption2
        }
    }
}
