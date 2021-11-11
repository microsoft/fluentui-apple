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

    var brandColors: BrandColors? {
        switch self {
        case .default:
            return DemoDefaultBrandColors()
        case .green:
            return DemoGreenBrandColors()
        case .none:
            return nil
        }
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

struct DemoDefaultBrandColors: BrandColors {
    let primary: ColorSet? = GlobalTokens.Colors.Brand.primary.value
    let shade10: ColorSet? = GlobalTokens.Colors.Brand.shade10.value
    let shade20: ColorSet? = GlobalTokens.Colors.Brand.shade20.value
    let shade30: ColorSet? = GlobalTokens.Colors.Brand.shade30.value
    let tint10: ColorSet? = GlobalTokens.Colors.Brand.tint10.value
    let tint20: ColorSet? = GlobalTokens.Colors.Brand.tint20.value
    let tint30: ColorSet? = GlobalTokens.Colors.Brand.tint30.value
    let tint40: ColorSet? = GlobalTokens.Colors.Brand.tint40.value
}

struct DemoGreenBrandColors: BrandColors {
    let primary: ColorSet? = ColorSet("Colors/DemoPrimaryColor")
    let shade10: ColorSet? = ColorSet("Colors/DemoPrimaryShade10Color")
    let shade20: ColorSet? = ColorSet("Colors/DemoPrimaryShade20Color")
    let shade30: ColorSet? = ColorSet("Colors/DemoPrimaryShade30Color")
    let tint10: ColorSet? = ColorSet("Colors/DemoPrimaryTint10Color")
    let tint20: ColorSet? = ColorSet("Colors/DemoPrimaryTint20Color")
    let tint30: ColorSet? = ColorSet("Colors/DemoPrimaryTint30Color")
    let tint40: ColorSet? = ColorSet("Colors/DemoPrimaryTint40Color")
}
