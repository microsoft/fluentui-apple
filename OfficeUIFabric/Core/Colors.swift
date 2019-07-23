//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSColors

@objcMembers
public final class MSColors: NSObject {
    // MARK: Primary

    /// #0078D4
    public static var primary: UIColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.831372549, alpha: 1)
    public static var foregroundOnPrimary: UIColor = white
    /// #E1EFFA
    public static var lightPrimary: UIColor = #colorLiteral(red: 0.8823529412, green: 0.937254902, blue: 0.9803921569, alpha: 1)
    /// #F5FAFD - Primary with 4% opacity
    public static var extraLightPrimary: UIColor = #colorLiteral(red: 0.9607843137, green: 0.9803921569, blue: 0.9921568627, alpha: 1)

    // MARK: Physical

    /// #A8A8AC
    public static var lightGray: UIColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6745098039, alpha: 1)
    /// #8E8E93
    public static var gray: UIColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
    /// #777777
    public static var darkGray: UIColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)

    /// #F8F8F8
    public static var backgroundLightGray: UIColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    /// #F1F1F1
    public static var backgroundGray: UIColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)

    /// #E1E1E1
    public static var borderLightGray: UIColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
    /// #C8C8C8
    public static var borderGray: UIColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)

    /// #FFFFFF
    public static var white: UIColor = .white
    /// #222222
    public static var black: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)

    // TODO: decide if error and warning colors need to be split into semantic/physical sets

    /// #E8484C
    public static var error: UIColor = #colorLiteral(red: 0.9098039216, green: 0.2823529412, blue: 0.2980392157, alpha: 1)
    /// #FFF3F4
    public static var lightError: UIColor = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.9568627451, alpha: 1)

    /// #574305
    public static var warning: UIColor = #colorLiteral(red: 0.3411764706, green: 0.262745098, blue: 0.01960784314, alpha: 1)
    /// #E2DDCC
    public static var lightWarning: UIColor = #colorLiteral(red: 0.8862745098, green: 0.8666666667, blue: 0.8, alpha: 1)

    public static var avatarBackgroundColors: [UIColor] = [
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

    // MARK: Base semantic

    public static var background1 = UIColor(light: white)
    public static var background2 = UIColor(light: backgroundLightGray)
    public static var background3 = UIColor(light: backgroundGray)
    public static var background4 = UIColor(light: gray)
    public static var background5 = UIColor(light: black)
    public static var disabled = UIColor(light: borderLightGray)
    public static var foreground1 = UIColor(light: black)
    public static var foreground2 = UIColor(light: darkGray)
    public static var foreground3 = UIColor(light: gray)
    public static var foreground4 = UIColor(light: lightGray)
    public static var foreground5 = UIColor(light: borderLightGray)
    public static var foreground6 = UIColor(light: white)
    public static var selected = UIColor(light: primary)
    public static var foregroundOnSelected = UIColor(light: foregroundOnPrimary)

    // MARK: Final semantic

    // Add semantic colors describing colors used for particular control elements

    public struct Action {
        public static var text: UIColor = primary
        public static var textHighlighted: UIColor = primary.withAlphaComponent(0.4)
        public static var textDestructive: UIColor = error
        public static var textDestructiveHighlighted: UIColor = error.withAlphaComponent(0.4)
    }

    public struct ActivityIndicator {
        public static var foreground: UIColor = foreground4
    }

    public struct Avatar {
        // Should use physical color because this text is shown on physical avatar background
        public static var text: UIColor = white
    }

    public struct Badge {
        public static var background: UIColor = primary.withAlphaComponent(0.24)
        public static var backgroundDisabled: UIColor = background2
        public static var backgroundError: UIColor = lightError
        public static var backgroundErrorSelected: UIColor = error
        public static var backgroundSelected: UIColor = selected
        public static var backgroundWarning: UIColor = lightWarning
        public static var backgroundWarningSelected: UIColor = warning
        public static var text: UIColor = primary
        public static var textDisabled: UIColor = foreground2
        public static var textError: UIColor = error
        public static var textErrorSelected: UIColor = lightError
        public static var textSelected: UIColor = foregroundOnSelected
        public static var textWarning: UIColor = warning
        public static var textWarningSelected: UIColor = lightWarning
    }

    public struct BadgeField {
        public static var background: UIColor = background1
        public static var label: UIColor = foreground3
        public static var placeholder: UIColor = foreground4
    }

    public struct Button {
        public static var background: UIColor = .clear
        public static var backgroundFilled: UIColor = primary
        public static var backgroundFilledDisabled: UIColor = disabled
        public static var backgroundFilledHighlighted: UIColor = primary.withAlphaComponent(0.5)
        public static var border: UIColor = primary.withAlphaComponent(0.2)
        public static var borderDisabled: UIColor = disabled
        public static var borderHighlighted: UIColor = primary.withAlphaComponent(0.08)
        public static var title: UIColor = primary
        public static var titleDisabled: UIColor = foreground4
        public static var titleHighlighted: UIColor = primary.withAlphaComponent(0.4)
        public static var titleWithFilledBackground: UIColor = foregroundOnPrimary
    }

    public struct Calendar {
        public struct Day {
            // TODO: Readd availability colors?
            public static var textPrimary: UIColor = foreground2
            public static var textSecondary: UIColor = foreground1
            public static var textSelected: UIColor = foregroundOnSelected
            public static var backgroundPrimary: UIColor = background1
            public static var backgroundSecondary: UIColor = background2
            public static var circleHighlighted: UIColor = background4
            public static var circleSelected: UIColor = selected
        }
        public struct Today {
            public static var background: UIColor = background1
        }
        public struct WeekdayHeading {
            public struct Light {
                public static var textRegular: UIColor = foreground3
                public static var textWeekend: UIColor = foreground4
                public static var background: UIColor = background1
            }
            public struct Dark {
                public static var textRegular: UIColor = foregroundOnPrimary
                public static var textWeekend: UIColor = foregroundOnPrimary.withAlphaComponent(0.7)
                public static var background: UIColor = primary
            }
        }
        public static var background: UIColor = background1
    }

    public struct DateTimePicker {
        public static var background: UIColor = background1
        public static var text: UIColor = foreground3
        public static var textEmphasized: UIColor = selected
    }

    public struct Drawer {
        public static var background: UIColor = background1
    }

    public struct HUD {
        public static var activityIndicator: UIColor = foreground6
        public static var background: UIColor = background5.withAlphaComponent(0.9)
        public static var text: UIColor = foreground6
    }

    public struct NavigationBar {
        public static var background: UIColor = background1
        public static var tint: UIColor = primary
        public static var title: UIColor = primary
    }

    public struct PageCardPresenter {
        // Should use physical color because page indicators are shown on physical blurred dark background
        public static var currentPageIndicator: UIColor = white
        public static var pageIndicator: UIColor = white.withAlphaComponent(0.5)
    }

    public struct PopupMenu {
        public struct Item {
            public static var image: UIColor = foreground3
            public static var imageSelected: UIColor = selected
            public static var titleSelected: UIColor = selected
            public static var titleDisabled: UIColor = disabled
            public static var subtitleSelected: UIColor = selected
            public static var subtitleDisabled: UIColor = disabled
        }
    }

    public struct ResizingHandle {
        public static var background: UIColor = background1
        public static var mark: UIColor = foreground5
    }

    public struct SegmentedControl {
        public static var background: UIColor = background1
        public static var buttonTextNormal: UIColor = foreground1
        public static var buttonTextSelected: UIColor = selected
        public static var buttonTextDisabled: UIColor = foreground4
        public static var buttonTextSelectedAndDisabled: UIColor = foreground2
        public static var selectionBarNormal: UIColor = selected
        public static var selectionBarDisabled: UIColor = background4
    }

    public struct Separator {
        public static var `default`: UIColor = foreground5
        // Matches shadow used in UINavigationBar
        public static var shadow = UIColor.black.withAlphaComponent(0.3)
    }

    public struct Switch {
        public static var onTint: UIColor = primary
    }

    public struct Table {
        public struct Cell {
            public static var background: UIColor = background1
            public static var backgroundSelected: UIColor = background3
            public static var checkmark: UIColor = selected
            public static var title: UIColor = foreground1
            public static var subtitle: UIColor = foreground3
            public static var footer: UIColor = foreground3
        }
        public struct CenteredLabelCell {
            public static var text: UIColor = primary
        }
        public struct HeaderFooter {
            public static var background: UIColor = background1
            public static var backgroundDivider: UIColor = background2
            public static var backgroundDividerHighlighted: UIColor = extraLightPrimary
            public static var text: UIColor = foreground3
            public static var textHighlighted: UIColor = primary
        }
        public static var background: UIColor = background1
    }

    public struct Toolbar {
        public static var background: UIColor = background1
        public static var tint: UIColor = primary
    }

    public struct Tooltip {
        public static var background: UIColor = background5.withAlphaComponent(0.95)
        public static var text: UIColor = foreground6
    }

    public struct TwoLineTitle {
        public static var titleDark: UIColor = primary
        public static var titleLight: UIColor = foreground6
        public static var subtitleDark: UIColor = foreground3
        public static var subtitleLight: UIColor = foreground6.withAlphaComponent(0.8)
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
    case disabled

    public var color: UIColor {
        switch self {
        case .regular:
            return MSColors.foreground1
        case .secondary:
            return MSColors.foreground3
        case .white:
            return MSColors.white
        case .primary:
            return MSColors.primary
        case .error:
            return MSColors.error
        case .warning:
            return MSColors.warning
        case .disabled:
            return MSColors.disabled
        }
    }
}
