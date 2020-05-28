//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Colors

@available(*, deprecated, renamed: "Colors")
public typealias MSColors = Colors

@objc(MSFColors)
public final class Colors: NSObject {
    // MARK: - MSFColorPalette

    /// colors defined in asset catalog
     @objc(MSFColorPalette)
     public enum Palette: Int {
         case pinkRed10
         case red20
         case red10
         case orange30
         case orange20
         case orangeYellow20
         case green20
         case green10
         case cyan30
         case cyan20
         case cyanBlue20
         case cyanBlue10
         case blue10
         case blueMagenta30
         case blueMagenta20
         case magenta20
         case magenta10
         case magentaPink10
         case gray40
         case gray30
         case gray20
         case gray12
         case gray11
         case gray10
         case gray9
         case gray8
         case gray7
         case gray6
         case gray5
         case gray4
         case gray3
         case gray2
         case gray1
         case communicationBlue
         case communicationBlueTint40
         case communicationBlueTint30
         case communicationBlueTint20
         case communicationBlueTint10
         case communicationBlueShade30
         case communicationBlueShade20
         case communicationBlueShade10
         case dangerPrimary
         case dangerTint40
         case dangerTint30
         case dangerTint20
         case dangerTint10
         case dangerShade30
         case dangerShade20
         case dangerShade10
         case warningPrimary
         case warningTint40
         case warningTint30
         case warningTint20
         case warningTint10
         case warningShade30
         case warningShade20
         case warningShade10
         case successPrimary
         case successTint40
         case successTint30
         case successTint20
         case successTint10
         case successShade30
         case successShade20
         case successShade10

         public var color: UIColor {
             if let fluentColor = UIColor(named: "FluentColors/" + self.name, in: FluentUIFramework.resourceBundle, compatibleWith: nil) {
                 return fluentColor
             } else {
                 preconditionFailure("invalid fluent color")
             }
         }

         public var name: String {
             switch self {
             case .pinkRed10:
                 return "pinkRed10"
             case .red20:
                 return "red20"
             case .red10:
                 return "red10"
             case .orange30:
                 return "orange30"
             case .orange20:
                 return "orange20"
             case .orangeYellow20:
                 return "orangeYellow20"
             case .green20:
                 return "green20"
             case .green10:
                 return "green10"
             case .cyan30:
                 return "cyan30"
             case .cyan20:
                 return "cyan20"
             case .cyanBlue20:
                 return "cyanBlue20"
             case .cyanBlue10:
                 return "cyanBlue10"
             case .blue10:
                 return "blue10"
             case .blueMagenta30:
                 return "blueMagenta30"
             case .blueMagenta20:
                 return "blueMagenta20"
             case .magenta20:
                 return "magenta20"
             case .magenta10:
                 return "magenta10"
             case .magentaPink10:
                 return "magentaPink10"
             case .gray40:
                 return "gray40"
             case .gray30:
                 return "gray30"
             case .gray20:
                 return "gray20"
             case .gray12:
                 return "gray12"
             case .gray11:
                 return "gray11"
             case .gray10:
                 return "gray10"
             case .gray9:
                 return "gray9"
             case .gray8:
                 return "gray8"
             case .gray7:
                 return "gray7"
             case .gray6:
                 return "gray6"
             case .gray5:
                 return "gray5"
             case .gray4:
                 return "gray4"
             case .gray3:
                 return "gray3"
             case .gray2:
                 return "gray2"
             case .gray1:
                 return "gray1"
             case .communicationBlue:
                 return "communicationBlue"
             case .communicationBlueTint40:
                 return "communicationBlueTint40"
             case .communicationBlueTint30:
                 return "communicationBlueTint30"
             case .communicationBlueTint20:
                 return "communicationBlueTint20"
             case .communicationBlueTint10:
                 return "communicationBlueTint10"
             case .communicationBlueShade30:
                 return "communicationBlueShade30"
             case .communicationBlueShade20:
                 return "communicationBlueShade20"
             case .communicationBlueShade10:
                 return "communicationBlueShade10"
             case .dangerPrimary:
                 return "dangerPrimary"
             case .dangerTint40:
                return "dangerTint40"
             case .dangerTint30:
                return "dangerTint30"
             case .dangerTint20:
                return "dangerTint20"
             case .dangerTint10:
                return "dangerTint10"
             case .dangerShade30:
                return "dangerShade30"
             case .dangerShade20:
                return "dangerShade20"
             case .dangerShade10:
                return "dangerShade10"
             case .warningPrimary:
                return "warningPrimary"
             case .warningTint40:
                return "warningTint40"
             case .warningTint30:
                return "warningTint30"
             case .warningTint20:
                return "warningTint20"
             case .warningTint10:
                return "warningTint10"
             case .warningShade30:
                return "warningShade30"
             case .warningShade20:
                return "warningShade20"
             case .warningShade10:
                return "warningShade10"
             case .successPrimary:
                return "successPrimary"
             case .successTint40:
                return "successTint40"
             case .successTint30:
                return "successTint30"
             case .successTint20:
                return "successTint20"
             case .successTint10:
                return "successTint10"
             case .successShade30:
                return "successShade30"
             case .successShade20:
                return "successShade20"
             case .successShade10:
                return "successShade10"
            }
         }
     }

    // MARK: Primary

    /// Variation of App brand colors. If an application is a hub of different apps, `primary` color could change within the same foreground session.
    /// It is not recommended to cache `primary` color because it could change.
    @objc public static var primary: UIColor = communicationBlue
    @objc public static var primaryTint10: UIColor = Palette.communicationBlueTint10.color
    @objc public static var primaryTint20: UIColor = Palette.communicationBlueTint20.color
    @objc public static var primaryTint30: UIColor = Palette.communicationBlueTint30.color
    @objc public static var primaryTint40: UIColor = Palette.communicationBlueTint40.color
    @objc public static var primaryShade10: UIColor = Palette.communicationBlueShade10.color
    @objc public static var primaryShade20: UIColor = Palette.communicationBlueShade20.color
    @objc public static var primaryShade30: UIColor = Palette.communicationBlueShade30.color

    @available(*, deprecated, renamed: "textOnAccent")
    @objc public static var foregroundOnPrimary: UIColor = textOnAccent

    // MARK: Physical - grays

    @objc public static let gray950: UIColor = Palette.gray1.color
    @objc public static let gray900: UIColor = Palette.gray2.color
    @objc public static let gray800: UIColor = Palette.gray3.color
    @objc public static let gray700: UIColor = Palette.gray4.color
    @objc public static let gray600: UIColor = Palette.gray5.color
    @objc public static let gray500: UIColor = Palette.gray6.color
    @objc public static let gray400: UIColor = Palette.gray7.color
    @objc public static let gray300: UIColor = Palette.gray8.color
    @objc public static let gray200: UIColor = Palette.gray9.color
    @objc public static let gray100: UIColor = Palette.gray10.color
    @objc public static let gray50: UIColor = Palette.gray11.color
    @objc public static let gray25: UIColor = Palette.gray12.color

    // MARK: Physical - Non-grays

    @objc public static let error: UIColor = Palette.dangerPrimary.color
    @objc public static let warning: UIColor = Palette.warningPrimary.color

    @objc public static var avatarBackgroundColors: [UIColor] = [
       Palette.cyanBlue10.color,
       Palette.red10.color,
       Palette.magenta20.color,
       Palette.green10.color,
       Palette.magentaPink10.color,
       Palette.cyanBlue20.color,
       Palette.orange20.color,
       Palette.cyan20.color,
       Palette.orangeYellow20.color,
       Palette.red20.color,
       Palette.blue10.color,
       Palette.magenta10.color,
       Palette.gray40.color,
       Palette.green20.color,
       Palette.blueMagenta20.color,
       Palette.pinkRed10.color,
       Palette.gray30.color,
       Palette.blueMagenta30.color,
       Palette.gray20.color,
       Palette.cyan30.color,
       Palette.orange30.color
    ]

    /// Used for hyperlinks
    @objc public static let communicationBlue: UIColor = Palette.communicationBlue.color

    // MARK: Base semantic

    @available(*, deprecated, renamed: "surfaceDisabled")
    @objc public static let disabled: UIColor = textDisabled

    /// text color should not be lower than `gray500` in light mode to achieve 4.5:1 minimum contrast ratio in `.white` background
    /// text color should not be higher than `gray400` in dark mode to achieve 4.5:1 minimum contrast ratio in `.black` background
    /// when determining high contrast color, add 200 in light mode and substract 200 in dark mode from the default color.

    /// text color used for main level in the screen. eg. title in dialog, title in navigationbar with `surfacePrimary`, etc
    @objc public static let textDominant = UIColor(light: gray900, lightHighContrast: .black, dark: .white)
    /// text color used for titles
    @objc public static let textPrimary = UIColor(light: gray900, lightHighContrast: .black, dark: gray100, darkHighContrast: .white)
    /// text color used for subtitles
    @objc public static let textSecondary = UIColor(light: gray500, lightHighContrast: gray700, dark: gray400, darkHighContrast: gray200)
    /// text color used in disabled state
    @objc public static let textDisabled = UIColor(light: gray300, lightHighContrast: gray500, dark: gray600, darkHighContrast: gray400)
    /// text appears on top of the surface that uses `Colors.primary` as background color
    @objc public static let textOnAccent = UIColor(light: .white, dark: .black)

    /// icon used as call-to-actions without a label attached. They need to reach a minimum contrast ratio 4.5:1 to its background
    @objc public static let iconPrimary = UIColor(light: gray500, lightHighContrast: gray700, dark: .white)
    /// icon that are attached to a label and are only used for decorative purposes
    @objc public static let iconSecondary = UIColor(light: gray400, lightHighContrast: gray600, dark: gray500, darkHighContrast: gray300, darkElevated: gray400)
    /// icon color used in disabled state
    @objc public static let iconDisabled = UIColor(light: gray300, lightHighContrast: gray500, dark: gray600, darkHighContrast: gray400)
    /// icon appears on top of surfaces that uses `Colors.primary` as background color
    @objc public static let iconOnAccent = UIColor(light: .white, dark: .black)

    /// In Darkmode, our system use two sets of background colors -- called base and elevated -- to enhance the perception of depath when one dark interface is layered above another.
    /// The dark base colors are darker, making background interface appear to recede, and the elevete colors are lighter, making foreground interfaces appear to advance

    @objc public static let surfacePrimary = UIColor(light: .white, dark: .black, darkElevated: gray950)
    @objc public static let surfaceSecondary = UIColor(light: gray25, dark: gray950, darkElevated: gray900)
    @objc public static let surfaceTertiary = UIColor(light: gray50, dark: gray900, darkElevated: gray800)
    /// also used for disabled background color
    @objc public static let surfaceQuaternary = UIColor(light: gray100, dark: gray600)

    @objc public static let dividerOnPrimary = UIColor(light: gray100, dark: gray800, darkElevated: gray700)
    @objc public static let dividerOnSecondary = UIColor(light: gray200, dark: gray700, darkElevated: gray600)
    @objc public static let dividerOnTertiary = UIColor(light: gray200, dark: gray700, darkElevated: gray600)

    // MARK: Final semantic

    // Add semantic colors describing colors used for particular control elements

    public struct ActivityIndicator {
        public static var foreground: UIColor = iconSecondary
    }

    public struct Avatar {
        // Should use physical color because this text is shown on physical avatar background
        public static var text: UIColor = textOnAccent
        public static var border = UIColor(light: .white, dark: gray900, darkElevated: gray800)
    }

    public struct Badge {
        public static var background: UIColor { return primaryTint40 }
        public static var backgroundSelected: UIColor { return primary }
        public static var backgroundDisabled = UIColor(light: surfaceSecondary, dark: gray700)
        public static var backgroundError = UIColor(light: Palette.dangerTint40.color, dark: Palette.dangerTint30.color)
        public static var backgroundErrorSelected: UIColor = error
        public static var backgroundWarning = UIColor(light: Palette.warningTint40.color, dark: Palette.warningTint30.color)
        public static var backgroundWarningSelected: UIColor = warning
        public static var text: UIColor { return primary }
        public static var textSelected: UIColor = textOnAccent
        public static var textDisabled: UIColor = textSecondary
        public static var textError = UIColor(light: Palette.dangerShade10.color, dark: Palette.dangerShade20.color)
        public static var textErrorSelected: UIColor = textOnAccent
        public static var textWarning = UIColor(light: Palette.warningShade30.color, dark: Palette.warningPrimary.color)
        public static var textWarningSelected = UIColor(light: Palette.warningShade30.color, dark: .black)
    }

    public struct BadgeField {
        public static var background: UIColor = surfacePrimary
        public static var label: UIColor = textSecondary
        public static var placeholder: UIColor = textSecondary
    }

    public struct BarButtonItem {
        public static var primary: UIColor { return UIColor(light: Colors.primary, dark: textDominant) }
        public static var secondary: UIColor = iconPrimary
    }

    public struct Button {
        public static var background: UIColor = .clear
        public static var backgroundFilled: UIColor { return primary }
        public static var backgroundFilledDisabled: UIColor = surfaceQuaternary
        public static var backgroundFilledHighlighted: UIColor { return UIColor(light: primaryTint10, dark: primaryTint20) }
        public static var border: UIColor { return primaryTint20 }
        public static var borderDisabled: UIColor = surfaceQuaternary
        public static var borderHighlighted: UIColor { return primaryTint30 }
        public static var title: UIColor { return primary }
        public static var titleDisabled: UIColor = textDisabled
        public static var titleHighlighted: UIColor { return primaryTint20 }
        public static var titleWithFilledBackground: UIColor = textOnAccent
    }

    public struct Calendar {
        public struct Day {
            public static var textPrimary = UIColor(light: Colors.textSecondary, dark: Colors.textPrimary)
            public static var textSecondary: UIColor = Colors.textSecondary
            public static var textSelected: UIColor = textOnAccent
            public static var backgroundPrimary = UIColor(light: Calendar.background, dark: surfaceSecondary)
            public static var backgroundSecondary = UIColor(light: surfaceSecondary, dark: Calendar.background)
            public static var circleHighlighted: UIColor = gray400
            public static var circleSelected: UIColor { return primary }
        }
        public struct Today {
            public static var background: UIColor = Calendar.Day.backgroundPrimary
        }
        public struct WeekdayHeading {
            public struct Light {
                public static var textRegular = UIColor(light: gray600, lightHighContrast: gray700, dark: textPrimary)
                public static var textWeekend: UIColor = textSecondary
                public static var background: UIColor = Calendar.background
            }
            public struct Dark {
                public static var textRegular: UIColor = textOnAccent
                public static var textWeekend: UIColor = textOnAccent.withAlphaComponent(0.7)
                public static var background: UIColor { return primary }
            }
        }
        public static var background: UIColor = NavigationBar.background
    }

    public struct DateTimePicker {
        public static var background: UIColor = NavigationBar.background
        public static var text: UIColor = textSecondary
        public static var textEmphasized: UIColor { return primary }
    }

    public struct Drawer {
        public static var background = UIColor(light: surfacePrimary, dark: surfaceSecondary)
    }

    public struct HUD {
        public static var activityIndicator: UIColor = .white
        public static var background = UIColor(light: gray900.withAlphaComponent(0.9), dark: gray700)
        public static var text = UIColor(light: textOnAccent, dark: textPrimary)
    }

    public struct Navigation {
        public struct System {
            public static var background: UIColor = NavigationBar.background
            public static var tint: UIColor = NavigationBar.tint
            public static var title: UIColor = NavigationBar.title
        }
        public struct Primary {
            public static var background: UIColor { return UIColor(light: primary, dark: System.background) }
            public static var tint = UIColor(light: textOnAccent, dark: System.tint)
            public static var title = UIColor(light: textOnAccent, dark: System.title)
        }
    }

    public struct Notification {
        public struct PrimaryToast {
            public static var background: UIColor { return UIColor(light: primary.withAlphaComponent(0.2), dark: primary) }
            public static var foreground: UIColor { return UIColor(light: primaryShade20, dark: .black) }
        }
        public struct NeutralToast {
            public static var background: UIColor = surfaceQuaternary.withAlphaComponent(0.6)
            public static var foreground: UIColor = Colors.textDominant
        }
        public struct PrimaryBar {
            public static var background: UIColor { return PrimaryToast.background }
            public static var foreground: UIColor { return PrimaryToast.foreground }
        }
        public struct PrimaryOutlineBar {
            public static var background = UIColor(light: surfacePrimary, dark: surfaceQuaternary).withAlphaComponent(0.6)
            public static var foreground: UIColor { return UIColor(light: primary, dark: textPrimary) }
        }
        public struct NeutralBar {
            public static var background: UIColor = NeutralToast.background
            public static var foreground: UIColor = NeutralToast.foreground
        }
    }

    public struct NavigationBar {
        public static var background = UIColor(light: surfacePrimary, dark: surfaceTertiary)
        public static var tint: UIColor = BarButtonItem.secondary
        public static var title: UIColor = Colors.textDominant
    }

    public struct PageCardPresenter {
        // Should use physical color because page indicators are shown on physical blurred dark background
        public static var currentPageIndicator: UIColor = .white
        public static var pageIndicator = UIColor.white.withAlphaComponent(0.5)
    }

    public struct PillButton {
        public struct Outline {
            public static var background = UIColor(light: surfaceTertiary, dark: surfaceSecondary)
            public static var title = UIColor(light: textSecondary, dark: textPrimary)
            public static var backgroundSelected: UIColor { return UIColor(light: primary, dark: surfaceQuaternary) }
            public static var titleSelected = UIColor(light: textOnAccent, dark: textDominant)
        }
        public struct Filled {
            public static var background: UIColor { return UIColor(light: primaryShade10, dark: Outline.background) }
            public static var title = UIColor(light: textOnAccent, dark: Outline.title)
            public static var backgroundSelected = UIColor(light: surfacePrimary, dark: Outline.backgroundSelected)
            public static var titleSelected: UIColor { return UIColor(light: primary, dark: Outline.titleSelected) }
        }
    }

    public struct PopupMenu {
        public static var description: UIColor = textSecondary
        public struct Item {
            public static var imageSelected: UIColor { return primary }
            public static var titleSelected: UIColor { return primary }
            public static var subtitleSelected: UIColor { return primary }
        }
        public static var background = UIColor(light: Colors.Drawer.background, dark: surfaceQuaternary)
    }

    public struct Progress {
        public static var progressTint: UIColor { return primary }
        public static var trackTint = UIColor(light: surfaceQuaternary, dark: surfaceTertiary)
    }

    public struct ResizingHandle {
        public static var mark = iconSecondary
    }

    public struct SearchBar {
        public struct DarkContent {
            public static var background = UIColor(light: surfaceTertiary, dark: LightContent.background)
            public static var cancelButton = UIColor(light: textSecondary, dark: LightContent.cancelButton)
            public static var clearIcon = UIColor(light: iconSecondary, dark: LightContent.clearIcon)
            public static var placeholderText = UIColor(light: textSecondary, dark: LightContent.placeholderText)
            public static var searchIcon = UIColor(light: iconPrimary, dark: LightContent.searchIcon)
            public static var text = UIColor(light: textDominant, dark: LightContent.text)
            public static var tint = UIColor(light: iconSecondary, dark: LightContent.tint)
        }
        public struct LightContent {
            public static var background = UIColor(light: UIColor.black.withAlphaComponent(0.2), dark: gray700, darkElevated: gray600)
            public static var cancelButton: UIColor = LightContent.text
            public static var clearIcon = UIColor(light: UIColor.white.withAlphaComponent(0.6), dark: gray400)
            public static var placeholderText = UIColor(light: textOnAccent, dark: textSecondary)
            public static var searchIcon: UIColor = placeholderText
            public static var text = UIColor(light: textOnAccent, dark: textDominant)
            public static var tint: UIColor = LightContent.text
        }
    }

    public struct SegmentedControl {
        public struct Tabs {
            public static var background: UIColor = NavigationBar.background
            public static var backgroundDisabled: UIColor = background
            public static var segmentText: UIColor = textSecondary
            public static var segmentTextSelected: UIColor { return UIColor(light: primary, dark: textDominant) }
            public static var segmentTextDisabled: UIColor = surfaceQuaternary
            public static var segmentTextSelectedAndDisabled: UIColor = textDisabled
            public static var selection: UIColor { return UIColor(light: primary, dark: textDominant) }
            public static var selectionDisabled: UIColor = textDisabled
        }

        public struct Switch {
            public static var background: UIColor { return PillButton.Filled.background }
            public static var backgroundDisabled: UIColor = background
            public static var segmentText: UIColor = PillButton.Filled.title
            public static var segmentTextSelected: UIColor { return PillButton.Filled.titleSelected }
            public static var segmentTextDisabled: UIColor { return UIColor(light: primaryTint10, dark: textDisabled) }
            public static var segmentTextSelectedAndDisabled = UIColor(light: primaryTint20, dark: gray500)
            public static var selection: UIColor = PillButton.Filled.backgroundSelected
            public static var selectionDisabled: UIColor = selection
        }
    }

    public struct Separator {
        public static var `default`: UIColor = dividerOnPrimary
        public static var shadow = dividerOnSecondary
    }
    // Objective-C support
    @objc public static var separatorDefault: UIColor { return Separator.default }

    public struct Switch {
        public static var onTint: UIColor { return primary }
    }

    public struct Shimmer {
        public static var tint = UIColor(light: surfaceTertiary, dark: surfaceQuaternary)
    }

    public struct TabBar {
        public static var unselected: UIColor = textSecondary
        public static var selected: UIColor { return primary }
    }

    public struct Table {
        public struct Cell {
            public static var background: UIColor = surfacePrimary
            public static var backgroundGrouped: UIColor = surfacePrimary
            public static var backgroundSelected: UIColor = surfaceTertiary
            public static var image: UIColor = iconSecondary
            public static var title: UIColor = textPrimary
            public static var subtitle: UIColor = textSecondary
            public static var footer: UIColor = textSecondary
            public static var accessoryDisclosureIndicator: UIColor = iconSecondary
            public static var accessoryDetailButton: UIColor = iconSecondary
            public static var accessoryCheckmark: UIColor { return primary }
            public static var selectionIndicatorOn: UIColor { return primary }
            public static var selectionIndicatorOff: UIColor = iconSecondary
        }
        public struct ActionCell {
            public static var text: UIColor { return primary }
            public static var textHighlighted: UIColor { return primary.withAlphaComponent(0.4) }
            public static var textDestructive: UIColor = error
            public static var textDestructiveHighlighted: UIColor = error.withAlphaComponent(0.4)
            public static var textCommunication: UIColor = communicationBlue
            public static var textCommunicationHighlighted: UIColor = communicationBlue.withAlphaComponent(0.4)
        }
        public struct CenteredLabelCell {
            public static var text: UIColor { return primary }
        }
        public struct HeaderFooter {
            public static var accessoryButtonText: UIColor = textSecondary
            public static var accessoryButtonTextPrimary: UIColor { return primary }
            public static var background: UIColor = .clear
            public static var backgroundDivider: UIColor = surfaceSecondary
            public static var backgroundDividerHighlighted: UIColor { return UIColor(light: primaryTint40, dark: surfaceSecondary) }
            public static var text: UIColor = textSecondary
            public static var textDivider: UIColor = textSecondary
            public static var textDividerHighlighted: UIColor { return primary }
            public static var textLink: UIColor = communicationBlue
        }
        public static var background: UIColor = surfacePrimary
        public static var backgroundGrouped: UIColor = surfaceSecondary
    }
    // Objective-C support
    @objc public static var tableBackground: UIColor { return Table.background }
    @objc public static var tableBackgroundGrouped: UIColor { return Table.backgroundGrouped }
    @objc public static var tableCellBackground: UIColor { return Table.Cell.background }
    @objc public static var tableCellBackgroundGrouped: UIColor { return Table.Cell.backgroundGrouped }
    @objc public static var tableCellImage: UIColor { return Table.Cell.image }

    public struct Toolbar {
        public static var background: UIColor = NavigationBar.background
        public static var tint: UIColor = BarButtonItem.secondary
    }

    public struct Tooltip {
        public static var background: UIColor { return UIColor(light: gray900.withAlphaComponent(0.95), dark: primary)}
        public static var text: UIColor = textOnAccent
    }

    public struct TwoLineTitle {
        // light style is used Navigation.Primary.background. Dark style is used for Navigation.System.background
        public static var titleDark: UIColor = Navigation.System.title
        public static var titleLight: UIColor = Navigation.Primary.title
        public static var subtitleDark = UIColor(light: textSecondary, dark: textDominant)
        public static var subtitleLight: UIColor = titleLight
        public static var titleAccessoryLight = UIColor(light: iconOnAccent, dark: iconPrimary)
        public static var titleAccessoryDark = UIColor(light: iconSecondary, dark: iconPrimary)
    }

    @objc public static func color(from palette: Palette) -> UIColor {
        return palette.color
    }

    @available(*, unavailable)
    override init() {
        super.init()
    }
}

/// Make palette enum CaseIterable for unit testing purposes
extension Colors.Palette: CaseIterable {}

// MARK: - TextColorStyle

@available(*, deprecated, renamed: "TextColorStyle")
public typealias MSTextColorStyle = TextColorStyle

@objc(MSFTextColorStyle)
public enum TextColorStyle: Int, CaseIterable {
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
            return Colors.textPrimary
        case .secondary:
            return Colors.textSecondary
        case .white:
            return .white
        case .primary:
            return Colors.primary
        case .error:
            return Colors.error
        case .warning:
            return Colors.warning
        case .disabled:
            return Colors.textDisabled
        }
    }
}
