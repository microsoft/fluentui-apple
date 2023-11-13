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

class DemoColorDefaultTheme: NSObject, ColorProviding {
    var brandBackground1: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm80),
                       dark: GlobalTokens.brandColor(.comm100))
    }

    var brandBackground1Pressed: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm50),
                       dark: GlobalTokens.brandColor(.comm140))
    }

    var brandBackground1Selected: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm60),
                       dark: GlobalTokens.brandColor(.comm120))
    }

    var brandBackground2: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm70))
    }

    var brandBackground2Pressed: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm40))
    }

    var brandBackground2Selected: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm80))
    }

    var brandBackground3: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm60),
                       dark: GlobalTokens.brandColor(.comm120))
    }

    var brandBackgroundTint: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm150),
                       dark: GlobalTokens.brandColor(.comm40))
    }

    var brandBackgroundDisabled: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm140),
                       dark: GlobalTokens.brandColor(.comm40))
    }

    var brandForeground1: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm80),
                       dark: GlobalTokens.brandColor(.comm100))
    }

    var brandForeground1Pressed: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm50),
                       dark: GlobalTokens.brandColor(.comm140))
    }

    var brandForeground1Selected: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm60),
                       dark: GlobalTokens.brandColor(.comm120))
    }

    var brandForegroundTint: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm60),
                       dark: GlobalTokens.brandColor(.comm130))
    }

    var brandForegroundDisabled1: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm90))
    }

    var brandForegroundDisabled2: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm140),
                       dark: GlobalTokens.brandColor(.comm40))
    }

    var brandStroke1: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm80),
                       dark: GlobalTokens.brandColor(.comm100))
    }

    var brandStroke1Pressed: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm50),
                       dark: GlobalTokens.brandColor(.comm140))
    }

    var brandStroke1Selected: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.comm60),
                       dark: GlobalTokens.brandColor(.comm120))
    }

    var brandGradient1: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.gradientPrimaryLight),
                       dark: GlobalTokens.brandColor(.gradientPrimaryDark))
    }

    var brandGradient2: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.gradientSecondaryLight),
                       dark: GlobalTokens.brandColor(.gradientSecondaryDark))
    }

    var brandGradient3: UIColor {
        return UIColor(light: GlobalTokens.brandColor(.gradientTertiaryLight),
                       dark: GlobalTokens.brandColor(.gradientTertiaryDark))
    }
}

class DemoColorGreenTheme: NSObject, ColorProviding {
    var brandBackground1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x107C41),
                       dark: UIColor(hexValue: 0x55B17E))
    }

    var brandBackground1Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0A5325),
                       dark: UIColor(hexValue: 0xCAEAD8))
    }

    var brandBackground1Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0F703B),
                       dark: UIColor(hexValue: 0x60BD82))
    }

    var brandBackground2: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0F703B))
    }

    var brandBackground2Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x052912))
    }

    var brandBackground2Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0A5325))
    }

    var brandBackground3: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0A5325))
    }

    var brandBackgroundTint: UIColor {
        return UIColor(light: UIColor(hexValue: 0xCAEAD8),
                       dark: UIColor(hexValue: 0x094624))
    }

    var brandBackgroundDisabled: UIColor {
        return UIColor(light: UIColor(hexValue: 0xA0D8B9),
                       dark: UIColor(hexValue: 0x0A5325))
    }

    var brandForeground1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x107C41),
                       dark: UIColor(hexValue: 0x55B17E))
    }

    var brandForeground1Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0A5325),
                       dark: UIColor(hexValue: 0xCAEAD8))
    }

    var brandForeground1Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0F703B),
                       dark: UIColor(hexValue: 0x60BD82))
    }

    var brandForegroundTint: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0C5F32),
                       dark: UIColor(hexValue: 0x60BD82))
    }

    var brandForegroundDisabled1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x37A660),
                       dark: UIColor(hexValue: 0x218D51))
    }

    var brandForegroundDisabled2: UIColor {
        return UIColor(light: UIColor(hexValue: 0xCAEAD8),
                       dark: UIColor(hexValue: 0x0F703B))
    }

    var brandStroke1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x107C41),
                       dark: UIColor(hexValue: 0x55B17E))
    }

    var brandStroke1Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0A5325),
                       dark: UIColor(hexValue: 0xCAEAD8))
    }

    var brandStroke1Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x0F703B),
                       dark: UIColor(hexValue: 0x60BD82))
    }

    var brandGradient1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x107C41),
                       dark: UIColor(hexValue: 0x10893C))
    }

    var brandGradient2: UIColor {
        return UIColor(hexValue: 0xDCF51D)
    }

    var brandGradient3: UIColor {
        return UIColor(hexValue: 0x42B8B2)
    }
}
