//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ColorProviding

/// Protocol through which consumers can provide colors to "theme" their experiences
/// The window in which the color will be shown is sent to allow apps to provide different experiences per each window
@objc(MSFColorProviding)
public protocol ColorProviding {

    /// Primary branding color. If this protocol is not conformed to, communicationBlue will be used
    @objc func primaryColor(for window: UIWindow) -> UIColor?

    /// Tint colors. If this protocol is not conformed to, communicationBlueTint* colors will be used
    @objc func primaryTint10Color(for window: UIWindow) -> UIColor?
    @objc func primaryTint20Color(for window: UIWindow) -> UIColor?
    @objc func primaryTint30Color(for window: UIWindow) -> UIColor?
    @objc func primaryTint40Color(for window: UIWindow) -> UIColor?

    /// Shade colors. If this protocol is not conformed to, communicationBlueShade* colors will be used
    @objc func primaryShade10Color(for window: UIWindow) -> UIColor?
    @objc func primaryShade20Color(for window: UIWindow) -> UIColor?
    @objc func primaryShade30Color(for window: UIWindow) -> UIColor?
}

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
        case gray25
        case gray50
        case gray100
        case gray200
        case gray300
        case gray400
        case gray500
        case gray600
        case gray700
        case gray800
        case gray900
        case gray950
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
        case presenceAvailable
        case presenceAway
        case presenceBlocked
        case presenceBusy
        case presenceDnd
        case presenceOffline
        case presenceOof
        case presenceUnknown

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
            case .gray25:
                return "gray25"
            case .gray50:
                return "gray50"
            case .gray100:
                return "gray100"
            case .gray200:
                return "gray200"
            case .gray300:
                return "gray300"
            case .gray400:
                return "gray400"
            case .gray500:
                return "gray500"
            case .gray600:
                return "gray600"
            case .gray700:
                return "gray700"
            case .gray800:
                return "gray800"
            case .gray900:
                return "gray900"
            case .gray950:
                return "gray950"
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
            case .presenceAvailable:
                return "presenceAvailable"
            case .presenceAway:
                return "presenceAway"
            case .presenceBlocked:
                return "presenceBlocked"
            case .presenceBusy:
                return "presenceBusy"
            case .presenceDnd:
                return "presenceDnd"
            case .presenceOffline:
                return "presenceOffline"
            case .presenceOof:
                return "presenceOof"
            case .presenceUnknown:
                return "presenceUnknown"
            }
        }
    }

    @objc public static func setProvider(provider: ColorProviding, for window: UIWindow) {
        colorProvidersMap.setObject(provider, forKey: window)
    }

    // MARK: Primary

    /// Use these funcs to grab a color customized by a ColorProviding object for a specific window.. If no colorProvider exists for the window, falls back to deprecated singleton theme color
    @objc public static func primary(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryColor(for: window) ?? FallbackThemeColor.primary
    }

    @objc public static func primaryTint10(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryTint10Color(for: window) ?? FallbackThemeColor.primaryTint10
    }

    @objc public static func primaryTint20(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryTint20Color(for: window) ?? FallbackThemeColor.primaryTint20
    }

    @objc public static func primaryTint30(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryTint30Color(for: window) ?? FallbackThemeColor.primaryTint30
    }

    @objc public static func primaryTint40(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryTint40Color(for: window) ?? FallbackThemeColor.primaryTint40
    }

    @objc public static func primaryShade10(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryShade10Color(for: window) ?? FallbackThemeColor.primaryShade10
    }

    @objc public static func primaryShade20(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryShade20Color(for: window) ?? FallbackThemeColor.primaryShade20
    }

    @objc public static func primaryShade30(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.primaryShade30Color(for: window) ?? FallbackThemeColor.primaryShade30
    }

    private static var colorProvidersMap = NSMapTable<UIWindow, ColorProviding>(keyOptions: .weakMemory, valueOptions: .weakMemory)

    /// A namespace for holding fallback theme colors (empty enum is an uninhabited type)
    private enum FallbackThemeColor {
        static var primary: UIColor = communicationBlue

        static var primaryTint10: UIColor = Palette.communicationBlueTint10.color

        static var primaryTint20: UIColor = Palette.communicationBlueTint20.color

        static var primaryTint30: UIColor = Palette.communicationBlueTint30.color

        static var primaryTint40: UIColor = Palette.communicationBlueTint40.color

        static var primaryShade10: UIColor = Palette.communicationBlueShade10.color

        static var primaryShade20: UIColor = Palette.communicationBlueShade20.color

        static var primaryShade30: UIColor = Palette.communicationBlueShade30.color
    }

    /// Customization of primary colors should happen through the ColorProviding protocol rather than this singleton. Doing so
    /// will allow hosts of fluentui controls to simultaneously host different experiences with different themes
    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primary: UIColor {
        get {
            return FallbackThemeColor.primary
        }
        set {
            FallbackThemeColor.primary = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryTint10: UIColor {
        get {
            return FallbackThemeColor.primaryTint10
        }
        set {
            FallbackThemeColor.primaryTint10 = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryTint20: UIColor {
        get {
            return FallbackThemeColor.primaryTint20
        }
        set {
            FallbackThemeColor.primaryTint20 = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryTint30: UIColor {
        get {
            return FallbackThemeColor.primaryTint30
        }
        set {
            FallbackThemeColor.primaryTint30 = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryTint40: UIColor {
        get {
            return FallbackThemeColor.primaryTint40
        }
        set {
            FallbackThemeColor.primaryTint40 = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryShade10: UIColor {
        get {
            return FallbackThemeColor.primaryShade10
        }
        set {
            FallbackThemeColor.primaryShade10 = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryShade20: UIColor {
        get {
            return FallbackThemeColor.primaryShade20
        }
        set {
            FallbackThemeColor.primaryShade20 = newValue
        }
    }

    @available(*, deprecated, renamed: "setProvider(_:forWindow:)")
    @objc public static var primaryShade30: UIColor {
        get {
            return FallbackThemeColor.primaryShade30
        }
        set {
            FallbackThemeColor.primaryShade30 = newValue
        }
    }

    @available(*, deprecated, renamed: "textOnAccent")
    @objc public static var foregroundOnPrimary: UIColor = textOnAccent

    // MARK: Physical - grays

    @objc public static let gray950: UIColor = Palette.gray950.color
    @objc public static let gray900: UIColor = Palette.gray900.color
    @objc public static let gray800: UIColor = Palette.gray800.color
    @objc public static let gray700: UIColor = Palette.gray700.color
    @objc public static let gray600: UIColor = Palette.gray600.color
    @objc public static let gray500: UIColor = Palette.gray500.color
    @objc public static let gray400: UIColor = Palette.gray400.color
    @objc public static let gray300: UIColor = Palette.gray300.color
    @objc public static let gray200: UIColor = Palette.gray200.color
    @objc public static let gray100: UIColor = Palette.gray100.color
    @objc public static let gray50: UIColor = Palette.gray50.color
    @objc public static let gray25: UIColor = Palette.gray25.color

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

    @available(*, deprecated, renamed: "textDisabled")
    @objc public static let disabled: UIColor = textDisabled

    /// text color should not be lower than `gray500` in light mode to achieve 4.5:1 minimum contrast ratio in `.white` background
    /// text color should not be higher than `gray400` in dark mode to achieve 4.5:1 minimum contrast ratio in `.black` background
    /// when determining high contrast color, add 200 in light mode and substract 200 in dark mode from the default color.

    /// text color used for main level in the screen. eg. title in dialog, title in navigationbar with `surfacePrimary`, etc
    @objc public static let textDominant = UIColor(light: gray900, lightHighContrast: .black, dark: .white)
    /// text color used for titles
    @objc public static var textPrimary = UIColor(light: gray900, lightHighContrast: .black, dark: gray100, darkHighContrast: .white)
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
    /// The dark base colors are darker, making background interface appear to recede, and the elevate colors are lighter, making foreground interfaces appear to advance

    @objc public static var surfacePrimary = UIColor(light: .white, dark: .black, darkElevated: gray950)
    @objc public static let surfaceSecondary = UIColor(light: gray25, dark: gray950, darkElevated: gray900)
    @objc public static let surfaceTertiary = UIColor(light: gray50, dark: gray900, darkElevated: gray800)
    /// also used for disabled background color
    @objc public static let surfaceQuaternary = UIColor(light: gray100, dark: gray600)

    @objc public static let dividerOnPrimary = UIColor(light: gray100, dark: gray800, darkElevated: gray700)
    @objc public static let dividerOnSecondary = UIColor(light: gray200, dark: gray700, darkElevated: gray600)
    @objc public static let dividerOnTertiary = UIColor(light: gray200, dark: gray700, darkElevated: gray600)

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
