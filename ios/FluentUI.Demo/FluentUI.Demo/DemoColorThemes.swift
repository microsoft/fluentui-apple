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

    var provider: ColorProviding2? {
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

class DemoColorDefaultTheme: NSObject, ColorProviding2 {
    func brandBackground1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80),
          dark: GlobalTokens.brandColors(.comm100)))
    }

    func brandBackground1Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm50),
          dark: GlobalTokens.brandColors(.comm140)))
    }

    func brandBackground1Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
         dark: GlobalTokens.brandColors(.comm120)))
    }

    func brandBackground2(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm70)))
    }

    func brandBackground2Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm40)))
    }

    func brandBackground2Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80)))
    }

    func brandBackground3(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
         dark: GlobalTokens.brandColors(.comm120)))
    }

    func brandBackgroundTint(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm150),
                                 dark: GlobalTokens.brandColors(.comm40)))
    }

    func brandBackgroundDisabled(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm140),
          dark: GlobalTokens.brandColors(.comm40)))
    }

    func brandForeground1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80),
          dark: GlobalTokens.brandColors(.comm100)))
    }

    func brandForeground1Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm50),
          dark: GlobalTokens.brandColors(.comm140)))
    }

    func brandForeground1Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
          dark: GlobalTokens.brandColors(.comm120)))
    }

    func brandForegroundTint(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
          dark: GlobalTokens.brandColors(.comm130)))
    }

    func brandForegroundDisabled1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm90)))
    }

    func brandForegroundDisabled2(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm140),
          dark: GlobalTokens.brandColors(.comm40)))
    }

    func brandStroke1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm80),
                                 dark: GlobalTokens.brandColors(.comm100)))
    }

    func brandStroke1Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm50),
                                 dark: GlobalTokens.brandColors(.comm140)))
    }

    func brandStroke1Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                 dark: GlobalTokens.brandColors(.comm120)))
    }
}

class DemoColorGreenTheme: NSObject, ColorProviding2 {
    func brandBackground1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x107C41),
                                                  dark: ColorValue(0x55B17E)))
    }

    func brandBackground1Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325),
                                                  dark: ColorValue(0xCAEAD8)))
    }

    func brandBackground1Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0F703B),
                                                  dark: ColorValue(0x60BD82)))
    }

    func brandBackground2(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0F703B)))
    }

    func brandBackground2Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x052912)))
    }

    func brandBackground2Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325)))
    }

    func brandBackground3(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325)))
    }

    func brandBackgroundTint(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0xCAEAD8),
                                                  dark: ColorValue(0x094624)))
    }

    func brandBackgroundDisabled(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0xA0D8B9),
                                                  dark: ColorValue(0x0A5325)))
    }

    func brandForeground1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x107C41),
                                                  dark: ColorValue(0x55B17E)))
    }

    func brandForeground1Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325),
                                                  dark: ColorValue(0xCAEAD8)))
    }

    func brandForeground1Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0F703B),
                                                  dark: ColorValue(0x60BD82)))
    }

    func brandForegroundTint(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0C5F32),
                                                  dark: ColorValue(0x60BD82)))
    }

    func brandForegroundDisabled1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x37A660),
                                                  dark: ColorValue(0x218D51)))
    }

    func brandForegroundDisabled2(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0xCAEAD8),
                                                  dark: ColorValue(0x0F703B)))
    }

    func brandStroke1(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x107C41),
                                                  dark: ColorValue(0x55B17E)))
    }

    func brandStroke1Pressed(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0A5325),
                                                  dark: ColorValue(0xCAEAD8)))
    }

    func brandStroke1Selected(for theme: FluentTheme) -> UIColor? {
        return UIColor(dynamicColor: DynamicColor(light: ColorValue(0x0F703B),
                                                  dark: ColorValue(0x60BD82)))
    }
}
