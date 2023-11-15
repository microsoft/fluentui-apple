//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

enum DemoColorTheme: CaseIterable {
    case `default`
    case green
    case purple

    var name: String {
        switch self {
        case .default:
            return "Default"
        case .green:
            return "Green"
        case .purple:
            return "Purple"
        }
    }

    var provider: ColorProviding? {
        switch self {
        case .default:
            return nil
        case .green:
            return DemoColorGreenTheme()
        case .purple:
            return DemoColorPurpleTheme()
        }
    }

    /// Controls the app-wide theme and caches the value for later review.
    static var currentAppWideTheme: DemoColorTheme = .default {
        didSet {
            FluentTheme.setSharedThemeColorProvider(currentAppWideTheme.provider)
        }
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

class DemoColorPurpleTheme: NSObject, ColorProviding {
    var brandBackground1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x822FFF),
                       dark: UIColor(hexValue: 0xA275FF))
    }

    var brandBackground1Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x550FBE),
                       dark: UIColor(hexValue: 0xC2AAFD))
    }

    var brandBackground1Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x6415DB),
                       dark: UIColor(hexValue: 0xB695FF))
    }

    var brandBackground2: UIColor {
        return UIColor(hexValue: 0x6415DB)
    }

    var brandBackground2Pressed: UIColor {
        return UIColor(hexValue: 0x410693)
    }

    var brandBackground2Selected: UIColor {
        return UIColor(hexValue: 0x4B09A8)
    }

    var brandBackground3: UIColor {
        return UIColor(hexValue: 0x4B09A8)
    }

    var brandBackgroundTint: UIColor {
        return UIColor(light: UIColor(hexValue: 0xEDE8FF),
                       dark: UIColor(hexValue: 0x4B09A8))
    }

    var brandBackgroundDisabled: UIColor {
        return UIColor(light: UIColor(hexValue: 0xD0BDFD),
                       dark: UIColor(hexValue: 0x4B09A8))
    }

    var brandForeground1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x822FFF),
                       dark: UIColor(hexValue: 0xA275FF))
    }

    var brandForeground1Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x550FBE),
                       dark: UIColor(hexValue: 0xC2AAFD))
    }

    var brandForeground1Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x6415DB),
                       dark: UIColor(hexValue: 0xB695FF))
    }

    var brandForegroundTint: UIColor {
        return UIColor(light: UIColor(hexValue: 0x6415DB),
                       dark: UIColor(hexValue: 0xC2AAFD))
    }

    var brandForegroundDisabled1: UIColor {
        return UIColor(light: UIColor(hexValue: 0xB695FF),
                       dark: UIColor(hexValue: 0x751FF5))
    }

    var brandForegroundDisabled2: UIColor {
        return UIColor(light: UIColor(hexValue: 0xC2AAFD),
                       dark: UIColor(hexValue: 0x4B09A8))
    }

    var brandStroke1: UIColor {
        return UIColor(light: UIColor(hexValue: 0x822FFF),
                       dark: UIColor(hexValue: 0xA275FF))
    }

    var brandStroke1Pressed: UIColor {
        return UIColor(light: UIColor(hexValue: 0x550FBE),
                       dark: UIColor(hexValue: 0xC2AAFD))
    }

    var brandStroke1Selected: UIColor {
        return UIColor(light: UIColor(hexValue: 0x6415DB),
                       dark: UIColor(hexValue: 0xB695FF))
    }
}
