//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public struct MSColors {
    // MARK: Primary
    
    /// #0078D4
    public static var primary: UIColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.831372549, alpha: 1)
    /// #E1EFFA
    public static var lightPrimary: UIColor = #colorLiteral(red: 0.8823529412, green: 0.937254902, blue: 0.9803921569, alpha: 1)

    // MARK: Physical

    /// #A8A8AC
    public static let lightGray: UIColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6745098039, alpha: 1)
    /// #8E8E93
    public static let gray: UIColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
    /// #777777
    public static let darkGray: UIColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
    
    /// #F8F8F8
    public static let backgroundLightGray: UIColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    /// #F1F1F1
    public static let backgroundGray: UIColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    
    /// #E1E1E1
    public static let borderLightGray: UIColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
    /// #C8C8C8
    public static let borderGray: UIColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
    
    /// #FFFFFF
    public static let white: UIColor = .white
    /// #222222
    public static let black: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)

    /// #E8484C
    public static let warning: UIColor = #colorLiteral(red: 0.9098039216, green: 0.2823529412, blue: 0.2980392157, alpha: 1)
    /// #FFF3F4
    public static let lightWarning: UIColor = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.9568627451, alpha: 1)

    // MARK: Semantic
    
    // TODO: Add semantic colors describing colors used for particular control elements (must reference physical colors)

    public static let background: UIColor = white
    public static let separatorColor: UIColor = borderLightGray
}

public enum MSTextColorStyle: Int {
    case regular
    case secondary
    case white
    case primary
    case warning

    // TODO: Replace with conformance to CaseIterable after switch to Swift 4.2
    public static var allCases: [MSTextColorStyle] = [.regular, .secondary, .white, .primary, .warning]

    public var color: UIColor {
        switch self {
        case .regular:
            return MSColors.black
        case .secondary:
            return MSColors.gray
        case .white:
            return MSColors.white
        case .primary:
            return MSColors.primary
        case .warning:
            return MSColors.warning
        }
    }
}
