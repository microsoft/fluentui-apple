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
    @objc public static var foregroundOnPrimary = UIColor(light: .white, dark: .black)

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

//    @objc public static let background1 = UIColor(light: .white, dark: .black, darkElevated: gray900)
//    @objc public static let background1b = UIColor(light: .white, dark: gray950, darkElevated: gray800)
//    @objc public static let background1c = UIColor(light: .white, dark: gray900, darkElevated: gray800)
//    @objc public static let background2 = UIColor(light: gray25, dark: gray950, darkElevated: gray700)
//    @objc public static let background2b = UIColor(light: gray25, dark: gray700)
//    @objc public static let background3 = UIColor(light: gray50, dark: gray900, darkElevated: gray700)
//    @objc public static let background3b = UIColor(light: gray50, dark: gray600)
    @available(*, deprecated, renamed: "surfaceDisabled")
    @objc public static let disabled = UIColor(light: gray100, dark: gray600)
//    @objc public static let foreground1 = UIColor(light: gray900, dark: gray100)
//    @objc public static let foreground1b = UIColor(light: gray900, dark: gray400)
//    @objc public static let foreground2 = UIColor(light: gray500, dark: gray400)
//    @objc public static let foreground2b = UIColor(light: gray500, dark: gray300)
//    @objc public static let foreground2c = UIColor(light: gray500, dark: gray500)
//    @objc public static let foreground2d = UIColor(light: gray500, dark: gray100)
//    @objc public static let foreground3 = UIColor(light: gray400, dark: gray400)
//    @objc public static let foreground3b = UIColor(light: gray400, dark: gray500)
//    @objc public static let foreground3c = UIColor(light: gray400, dark: gray600)
//    @objc public static let foreground4 = UIColor(light: gray300, dark: gray600)
//    @objc public static let foreground4b = UIColor(light: gray300, dark: gray500)
//    @objc public static let foreground5 = UIColor(light: gray200, dark: gray500)
//    @objc public static let foreground6 = UIColor(light: gray100, dark: gray700, darkElevated: gray600)
//    @objc public static let foreground6b = UIColor(light: gray100, dark: gray500)
//    @objc public static let foreground7b = UIColor(light: .white, dark: gray100)

    /// text appears on a main level in the screen. eg. title in dialog, title in navigationbar with `surfacePrimary`, etc
    @objc public static let textDominant = UIColor(light: gray900, lightHighContrast: .black, dark: .white)
    @objc public static let textPrimary = UIColor(light: gray900, lightHighContrast: .black, dark: gray100, darkHighContrast: .white)
    @objc public static let textSecondary = UIColor(light: gray500, lightHighContrast: gray700, dark: gray400, darkHighContrast: gray200)
    @objc public static let textDisabled = UIColor(light: gray300, lightHighContrast: gray500, dark: gray600, darkHighContrast: gray400)
    /// text appears on top of the surface that uses `Colors.primary` as background color
    @objc public static let textOnAccent = UIColor(light: .white, dark: .black) // same as `foregroundOnPrimary`

    /// icon used as call-to-actions without a label attached. They need to reach a minimum contrast ratio 4.5:1 to its background
    @objc public static let iconPrimary = UIColor(light: gray500, lightHighContrast: gray700, dark: .white)
    /// icon that are attached to a label and are only used for decorative purposes
    @objc public static let iconSecondary = UIColor(light: gray400, lightHighContrast: gray600, dark: gray500, darkHighContrast: gray300, darkElevated: gray400)
    @objc public static let iconDisabled = UIColor(light: gray300, lightHighContrast: gray500, dark: gray600, darkHighContrast: gray400)
    /// icon appears on top of surfaces that uses `Colors.primary` as background color
    @objc public static let iconOnAccent = UIColor(light: .white, dark: .black) // same as `foregroundOnPrimary`

    @objc public static let surfacePrimary = UIColor(light: .white, dark: .black, darkElevated: gray950)
    @objc public static let surfaceSecondary = UIColor(light: gray25, dark: gray950, darkElevated: gray900)
    @objc public static let surfaceTertiary = UIColor(light: gray50, dark: gray900, darkElevated: gray800)
    @objc public static let surfaceQuaternary = UIColor(light: gray100, dark: gray600, darkElevated: gray600)

    // should question
    @objc public static let surfaceDisabled = UIColor(light: gray100, dark: gray600)

    @objc public static let dividerOnPrimary = UIColor(light: gray100, dark: gray800, darkElevated: gray700)
    @objc public static let dividerOnSecondary = UIColor(light: gray200, dark: gray700, darkElevated: gray600)
    @objc public static let dividerOnTertiary = UIColor(light: gray200, dark: gray700, darkElevated: gray600)

    // MARK: Final semantic

    // Add semantic colors describing colors used for particular control elements

    public struct ActivityIndicator {
        public static var foreground = UIColor(light: gray300, dark: gray500)
    }

    public struct Avatar {
        // Should use physical color because this text is shown on physical avatar background
        public static var text = UIColor(light: .white, dark: .black)
        public static var border = UIColor(light: .white, dark: gray900, darkElevated: gray800)
    }

    public struct Badge {
        public static var background: UIColor { return primaryTint40 }
        public static var backgroundSelected: UIColor { return primary }
        public static var backgroundDisabled = UIColor(light: gray25, dark: gray700)
        public static var backgroundError = UIColor(light: Palette.dangerTint40.color, dark: Palette.dangerTint30.color)
        public static var backgroundErrorSelected: UIColor = error
        public static var backgroundWarning = UIColor(light: Palette.warningTint40.color, dark: Palette.warningTint30.color)
        public static var backgroundWarningSelected: UIColor = warning
        public static var text: UIColor { return primary }
        public static var textSelected: UIColor = textOnAccent
        public static var textDisabled: UIColor = Colors.textDisabled
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
        public static var primary: UIColor { return UIColor(light: Colors.primary, dark: .white) }
        public static var secondary: UIColor = iconPrimary
    }

    public struct Button {
        public static var background: UIColor = .clear
        public static var backgroundFilled: UIColor { return primary }
        public static var backgroundFilledDisabled: UIColor = surfaceDisabled
        public static var backgroundFilledHighlighted: UIColor { return UIColor(light: primaryTint10, dark: primaryTint20) }
        public static var border: UIColor { return primaryTint20 }
        public static var borderDisabled: UIColor = surfaceDisabled
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
            public static var backgroundPrimary: UIColor = surfaceSecondary
            public static var backgroundSecondary: UIColor = Calendar.background
            public static var circleHighlighted: UIColor = gray400
            public static var circleSelected: UIColor { return primary }
        }
        public struct Today {
            public static var background: UIColor = Calendar.background
        }
        public struct WeekdayHeading {
            public struct Light {
                public static var textRegular = UIColor(light: textSecondary, dark: textPrimary)
                public static var textWeekend: UIColor = gray400
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
        public static var background: UIColor = NavigationBar.background
    }

    public struct HUD {
        public static var activityIndicator: UIColor = .white
        public static var background = UIColor(light: gray900.withAlphaComponent(0.9), dark: gray700)
        public static var text = UIColor(light: .white, dark: gray100)
    }

    public struct Navigation {
        public struct System {
            public static var background: UIColor = NavigationBar.background
            public static var tint: UIColor = NavigationBar.tint
            public static var title: UIColor = NavigationBar.title
        }
        public struct Primary {
            public static var background: UIColor { return UIColor(light: primary, dark: System.background) }
            public static var tint = UIColor(light: .white, dark: System.tint)
            public static var title = UIColor(light: .white, dark: System.title)
        }
    }

    public struct Notification {
        public struct PrimaryToast {
            public static var background: UIColor { return UIColor(light: primary.withAlphaComponent(0.2), dark: primary) }
            public static var foreground: UIColor { return UIColor(light: primaryShade20, dark: .black) }
        }
        public struct NeutralToast {
            public static var background = UIColor(light: gray100, dark: gray600).withAlphaComponent(0.6)
            public static var foreground: UIColor = Colors.textDominant
        }
        public struct PrimaryBar {
            public static var background: UIColor { return PrimaryToast.background }
            public static var foreground: UIColor { return PrimaryToast.foreground }
        }
        public struct PrimaryOutlineBar {
            public static var background = UIColor(light: .white, dark: gray600).withAlphaComponent(0.6)
            public static var foreground: UIColor { return UIColor(light: primary, dark: gray100) }
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
            public static var titleSelected = UIColor(light: gray25, dark: .white)
        }
        public struct Filled {
            public static var background: UIColor { return UIColor(light: primaryShade10, dark: Outline.background) }
            public static var title = UIColor(light: .white, dark: Outline.title)
            public static var backgroundSelected = UIColor(light: .white, dark: Outline.backgroundSelected)
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
    }

    public struct Progress {
        public static var progressTint: UIColor { return primary }
        public static var trackTint = UIColor(light: gray100, dark: gray700, darkElevated: gray600)
    }

    public struct ResizingHandle {
        public static var background: UIColor = NavigationBar.background
        public static var mark = UIColor(light: gray100, dark: gray500)
    }

    public struct SearchBar {
        public struct DarkContent {
            public static var background = UIColor(light: gray50, dark: LightContent.background)
            public static var cancelButton = UIColor(light: gray500, dark: LightContent.cancelButton)
            public static var clearIcon = UIColor(light: gray400, dark: LightContent.clearIcon)
            public static var placeholderText = UIColor(light: gray500, dark: LightContent.placeholderText)
            public static var searchIcon = UIColor(light: gray500, dark: LightContent.searchIcon)
            public static var text = UIColor(light: gray900, dark: LightContent.text)
            public static var tint = UIColor(light: gray400, dark: LightContent.tint)
        }
        public struct LightContent {
            public static var background = UIColor(light: UIColor.black.withAlphaComponent(0.2), dark: UIColor.white.withAlphaComponent(0.1))
            public static var cancelButton: UIColor = .white
            public static var clearIcon = UIColor(light: UIColor.white.withAlphaComponent(0.6), dark: gray300)
            public static var placeholderText = UIColor(light: .white, dark: gray300)
            public static var searchIcon = UIColor(light: .white, dark: gray400)
            public static var text: UIColor = .white
            public static var tint: UIColor = .white
        }
    }

    public struct SegmentedControl {
        public struct Tabs {
            public static var background: UIColor = NavigationBar.background
            public static var backgroundDisabled: UIColor = background
            public static var segmentText: UIColor = textSecondary
            public static var segmentTextSelected: UIColor { return UIColor(light: primary, dark: .white) }
            public static var segmentTextDisabled: UIColor = surfaceDisabled
            public static var segmentTextSelectedAndDisabled: UIColor = textDisabled
            public static var selection: UIColor { return UIColor(light: primary, dark: .white) }
            public static var selectionDisabled: UIColor = textDisabled
        }

        public struct Switch {
            public static var background: UIColor { return UIColor(light: primaryShade10, dark: surfaceSecondary) }
            public static var backgroundDisabled = UIColor(light: iconDisabled, dark: .black)
            public static var segmentText = UIColor(light: textOnAccent, dark: textPrimary)
            public static var segmentTextSelected: UIColor { return UIColor(light: primary, dark: textDominant) }
            public static var segmentTextDisabled = UIColor(light: .white, dark: textDisabled)
            public static var segmentTextSelectedAndDisabled = UIColor(light: textDisabled, dark: textSecondary)
            public static var selection = UIColor(light: .white, dark: surfaceQuaternary)
            public static var selectionDisabled: UIColor = selection
        }
    }

    public struct Separator {
        public static var `default`: UIColor = dividerOnPrimary
        // Matches shadow used in UINavigationBar
        public static var shadow = UIColor(light: UIColor.black.withAlphaComponent(0.3), dark: dividerOnSecondary)
    }
    // Objective-C support
    @objc public static var separatorDefault: UIColor { return Separator.default }

    public struct Switch {
        public static var onTint: UIColor { return primary }
    }

    public struct Shimmer {
        public static var tint = UIColor(light: gray50, dark: gray800)
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
        public static var titleDark: UIColor = NavigationBar.title
        public static var titleLight: UIColor = .white
        public static var subtitleDark: UIColor = textSecondary
        public static var subtitleLight = UIColor.white.withAlphaComponent(0.8)
        public static var accessory: UIColor = iconSecondary
    }

    @objc public static func color(from palette: Palette) -> UIColor {
        return palette.color
    }

    @available(*, unavailable)
    override init() {
        super.init()
    }
}

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
