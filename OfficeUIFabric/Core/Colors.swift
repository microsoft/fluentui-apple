//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

// MARK: MSColors

@objcMembers
public final class MSColors: NSObject {
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
    public static let error: UIColor = #colorLiteral(red: 0.9098039216, green: 0.2823529412, blue: 0.2980392157, alpha: 1)
    /// #FFF3F4
    public static let lightError: UIColor = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.9568627451, alpha: 1)

    /// #574305
    public static let warning: UIColor = #colorLiteral(red: 0.3411764706, green: 0.262745098, blue: 0.01960784314, alpha: 1)
    /// #E2DDCC
    public static let lightWarning: UIColor = #colorLiteral(red: 0.8862745098, green: 0.8666666667, blue: 0.8, alpha: 1)

    // MARK: Avatar background colors

    public static let avatarBackgroundColors: [UIColor] = [
        #colorLiteral(red: 0.4588235294, green: 0.0431372549, blue: 0.1098039216, alpha: 1), // #750B1C
        #colorLiteral(red: 0.6431372549, green: 0.1490196078, blue: 0.1725490196, alpha: 1), // #A4262C
        #colorLiteral(red: 0.8196078431, green: 0.2039215686, blue: 0.2196078431, alpha: 1), // #D13438
        #colorLiteral(red: 0.7921568627, green: 0.3137254902, blue: 0.06274509804, alpha: 1), // #CA5010
        #colorLiteral(red: 0.5960784314, green: 0.4352941176, blue: 0.0431372549, alpha: 1), // #986F0B
        #colorLiteral(red: 0.2862745098, green: 0.5098039216, blue: 0.01960784314, alpha: 1), // #498205
        #colorLiteral(red: 0, green: 0.368627451, blue: 0.3137254902, alpha: 1), // #005E50
        #colorLiteral(red: 0.01176470588, green: 0.5137254902, blue: 0.5294117647, alpha: 1), // #038387
        #colorLiteral(red: 0, green: 0.4705882353, blue: 0.831372549, alpha: 1), // #0078D4
        #colorLiteral(red: 0, green: 0.3058823529, blue: 0.5490196078, alpha: 1), // #004E8C
        #colorLiteral(red: 0.3098039216, green: 0.4196078431, blue: 0.9294117647, alpha: 1), // #4F6BED
        #colorLiteral(red: 0.2156862745, green: 0.1960784314, blue: 0.4666666667, alpha: 1), // #373277
        #colorLiteral(red: 0.5333333333, green: 0.09019607843, blue: 0.5960784314, alpha: 1), // #881798
        #colorLiteral(red: 0.7607843137, green: 0.2235294118, blue: 0.7019607843, alpha: 1), // #C239B3
        #colorLiteral(red: 0.8901960784, green: 0, blue: 0.5490196078, alpha: 1), // #E3008C
        #colorLiteral(red: 0.3764705882, green: 0.2392156863, blue: 0.1882352941, alpha: 1), // #603D30
        #colorLiteral(red: 0.337254902, green: 0.4862745098, blue: 0.4509803922, alpha: 1), // #567C73
        #colorLiteral(red: 0.4117647059, green: 0.4745098039, blue: 0.4941176471, alpha: 1)  // #69797E
    ]

    // MARK: Semantic

    // TODO: Add semantic colors describing colors used for particular control elements (must reference physical colors)

    public static let activityIndicator: UIColor = lightGray
    public static let background: UIColor = white
    public static let buttonImage: UIColor = gray
    public static let centeredLabelText: UIColor = primary
    public static let separator: UIColor = borderLightGray

    public struct Action {
        public static let text: UIColor = primary
        public static let textHighlighted: UIColor = primary.withAlphaComponent(0.4)
        public static let textDestructive: UIColor = error
        public static let textDestructiveHighlighted: UIColor = error.withAlphaComponent(0.4)
    }

    public struct Avatar {
        public static let text: UIColor = white
    }

    public struct Badge {
        public static let background: UIColor = primary.withAlphaComponent(0.24)
        public static let backgroundDisabled: UIColor = backgroundLightGray
        public static let backgroundError: UIColor = lightError
        public static let backgroundErrorSelected: UIColor = error
        public static let backgroundSelected: UIColor = primary
        public static let backgroundWarning: UIColor = lightWarning
        public static let backgroundWarningSelected: UIColor = warning
        public static let text: UIColor = primary
        public static let textDisabled: UIColor = darkGray
        public static let textError: UIColor = error
        public static let textErrorSelected: UIColor = lightError
        public static let textSelected: UIColor = white
        public static let textWarning: UIColor = warning
        public static let textWarningSelected: UIColor = lightWarning
    }

    public struct BadgeField {
        public static let label: UIColor = gray
        public static let placeholder: UIColor = lightGray
    }

    public struct Button {
        public static let background: UIColor = .clear
        public static let backgroundFilled: UIColor = primary
        public static let backgroundFilledDisabled: UIColor = borderLightGray
        public static let backgroundFilledHighlighted: UIColor = primary.withAlphaComponent(0.5)
        public static let border: UIColor = primary.withAlphaComponent(0.2)
        public static let borderDisabled: UIColor = borderLightGray
        public static let borderHighlighted: UIColor = primary.withAlphaComponent(0.08)
        public static let title: UIColor = primary
        public static let titleDisabled: UIColor = borderGray
        public static let titleHighlighted: UIColor = primary.withAlphaComponent(0.4)
        public static let titleWithFilledBackground: UIColor = white
    }

    public struct CalendarView {
        public struct TodayCell {
            public static let background: UIColor = white
        }
        public struct DayCell {
            // TODO: Readd availability colors?
            public static let textColorPrimary: UIColor = darkGray
            public static let textColorSecondary: UIColor = black
            public static let backgroundColorPrimary: UIColor = background
            public static let backgroundColorSecondary: UIColor = backgroundLightGray
            public static let todayTextColorNormal: UIColor = primary
            public static let todayTextColorEmphasized: UIColor = black
            public static let normalTextColor: UIColor = gray
            public static let highlightedCircleColor: UIColor = gray
            public static let selectedCircleNormalColor: UIColor = primary
        }
    }

    public struct DateTimePicker {
        public static let text: UIColor = gray
        public static let textEmphasized: UIColor = primary
    }

    public struct HUD {
        public static let activityIndicatorView: UIColor = white
        public static let background: UIColor = black.withAlphaComponent(0.9)
        public static let text: UIColor = white
    }

    public struct PageCardPresenter {
        public static let currentPageIndicatorTintColor: UIColor = white
        public static let pageIndicatorTintColor: UIColor = white.withAlphaComponent(0.5)
    }

    public struct Persona {
        public static let name: UIColor = black
        public static let subtitle: UIColor = gray
        public static let background: UIColor = white
        public static let backgroundSelected: UIColor = backgroundGray
    }

    public struct PopupMenu {
        public struct Item {
            public static let imageSelected: UIColor = primary
            public static let title: UIColor = black
            public static let titleSelected: UIColor = primary
            public static let titleDisabled: UIColor = borderLightGray
            public static let subtitle: UIColor = gray
            public static let subtitleSelected: UIColor = primary
            public static let subtitleDisabled: UIColor = borderLightGray
        }
        public static let sectionHeader: UIColor = darkGray
    }

    public struct ResizingHandle {
        public static let background: UIColor = white
        public static let mark: UIColor = borderLightGray
    }

    public struct SegmentedControl {
        public static let buttonTextNormal: UIColor = black
        public static let buttonTextSelected: UIColor = primary
        public static let selectionBarNormal: UIColor = primary
        public static let selectionBarDisabled: UIColor = gray
    }

    public struct TableViewCell {
        public static let background: UIColor = white
        public static let backgroundSelected: UIColor = backgroundGray
    }

    private override init() {
        super.init()
    }
}

// MARK: - MSTextColorStyle

@objc public enum MSTextColorStyle: Int, CaseIterable {
    case regular
    case secondary
    case white
    case primary
    case error
    case warning

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
        case .error:
            return MSColors.error
        case .warning:
            return MSColors.warning
        }
    }
}
