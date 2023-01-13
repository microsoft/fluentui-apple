//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

enum DemoColorTheme: CaseIterable {
    case `default`
    case green
    case none

    var name: String {
        switch self {
        case .default:
            return "Default"
        case .green:
            return "Green"
        case .none:
            return "None"
        }
    }

    var provider: ColorProviding? {
        switch self {
        case .default:
            return DemoColorDefaultTheme()
        case .green:
            return DemoColorGreenTheme()
        case .none:
            return nil
        }
    }
}

class DemoColorDefaultTheme2: NSObject, ColorProviding2 {
    func brandBackground1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80),
          dark: GlobalTokens.brandColors(.comm100)))
    }

    func brandBackground1Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm50),
          dark: GlobalTokens.brandColors(.comm140)))
    }

    func brandBackground1Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
         dark: GlobalTokens.brandColors(.comm120)))
    }

    func brandBackground2(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm70)))
    }

    func brandBackground2Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm40)))
    }

    func brandBackground2Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80)))
    }

    func brandBackground3(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
         dark: GlobalTokens.brandColors(.comm120)))
    }

    func brandBackgroundTint(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm150),
                                 dark: GlobalTokens.brandColors(.comm40)))
    }

    func brandBackgroundDisabled(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm140),
          dark: GlobalTokens.brandColors(.comm40)))
    }

    func brandForeground1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80),
          dark: GlobalTokens.brandColors(.comm100)))
    }

    func brandForeground1Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm50),
          dark: GlobalTokens.brandColors(.comm140)))
    }

    func brandForeground1Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
          dark: GlobalTokens.brandColors(.comm120)))
    }

    func brandForegroundTint(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
          dark: GlobalTokens.brandColors(.comm130)))
    }

    func brandForegroundDisabled1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm90)))
    }

    func brandForegroundDisabled2(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm140),
          dark: GlobalTokens.brandColors(.comm40)))
    }

    func brandStroke1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80),
                                 dark: GlobalTokens.brandColors(.comm100)))
    }

    func brandStroke1Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm50),
                                 dark: GlobalTokens.brandColors(.comm140)))
    }

    func brandStroke1Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                 dark: GlobalTokens.brandColors(.comm120)))
    }

}

class DemoColorDefaultTheme: NSObject, ColorProviding {
    func primaryColor(for window: UIWindow) -> UIColor? {
        return Colors.communicationBlue
    }

    func primaryTint10Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueTint10.color
    }

    func primaryTint20Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueTint20.color
    }

    func primaryTint30Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueTint30.color
    }

    func primaryTint40Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueTint40.color
    }

    func primaryShade10Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueShade10.color
    }

    func primaryShade20Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueShade20.color
    }

    func primaryShade30Color(for window: UIWindow) -> UIColor? {
        Colors.Palette.communicationBlueShade30.color
    }
}

class DemoColorGreenTheme2: NSObject, ColorProviding2 {
    func brandBackground1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x107C41),
                                                  dark: ColorValue(0x55B17E)))
    }

    func brandBackground1Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325),
                                                  dark: ColorValue(0xCAEAD8)))
    }

    func brandBackground1Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0F703B),
                                                  dark: ColorValue(0x60BD82)))
    }

    func brandBackground2(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0F703B)))
    }

    func brandBackground2Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x052912)))
    }

    func brandBackground2Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325)))
    }

    func brandBackground3(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325)))
    }

    func brandBackgroundTint(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0xCAEAD8),
                                                  dark: ColorValue(0x094624)))
    }

    func brandBackgroundDisabled(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0xFFFFFF),
                                                  dark: ColorValue(0xFFFFFF)))
    }

    func brandForeground1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandForeground1Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandForeground1Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandForegroundTint(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandForegroundDisabled1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandForegroundDisabled2(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandStroke1(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandStroke1Pressed(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

    func brandStroke1Selected(for theme: FluentUI.FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                  dark: ColorValue(0x000000)))
    }

}

class DemoColorGreenTheme: NSObject, ColorProviding {
    func primaryColor(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryColor")
    }

    func primaryTint10Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryTint10Color")
    }

    func primaryTint20Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryTint20Color")
    }

    func primaryTint30Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryTint30Color")
    }

    func primaryTint40Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryTint40Color")
    }

    func primaryShade10Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryShade10Color")
    }

    func primaryShade20Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryShade20Color")
    }

    func primaryShade30Color(for window: UIWindow) -> UIColor? {
        return UIColor(named: "Colors/DemoPrimaryShade30Color")
    }
}
