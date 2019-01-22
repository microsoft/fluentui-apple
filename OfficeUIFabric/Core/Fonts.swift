//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public struct MSFonts {
    /// Semibold 28pt
    public static let title1 = UIFont.preferredFont(forTextStyle: .title1).withWeight(.semibold)
    /// Semibold 22pt
    public static let title2 = UIFont.preferredFont(forTextStyle: .title2).withWeight(.semibold)
    /// Semibold 17pt
    public static let headline: UIFont = .preferredFont(forTextStyle: .headline)
    /// Regular 17pt
    public static let body: UIFont = .preferredFont(forTextStyle: .body)
    /// Regular 15pt
    public static let subhead: UIFont = .preferredFont(forTextStyle: .subheadline)
    /// Regular 13pt
    public static let footnote: UIFont = .preferredFont(forTextStyle: .footnote)
    /// Regular 12pt
    public static let caption1: UIFont = .preferredFont(forTextStyle: .caption1)
    /// Regular 11pt
    public static let caption2: UIFont = .preferredFont(forTextStyle: .caption2)
}

public enum MSTextStyle: Int, CaseIterable {
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
