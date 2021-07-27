//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DemoColorThemeWindow: UIWindow, ColorProviding {
    public static var theme: NSString = "Default"

    func setTheme(theme: NSString) {
        DemoColorThemeWindow.theme = theme
    }

    func primaryColor(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryColor")
        } else {
            return Colors.communicationBlue
        }
    }

    func primaryTint10Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryTint10Color")
        } else {
            return Colors.Palette.communicationBlueTint10.color
        }
    }

    func primaryTint20Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryTint20Color")
        } else {
            return Colors.Palette.communicationBlueTint20.color
        }
    }

    func primaryTint30Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryTint30Color")
        } else {
            return Colors.Palette.communicationBlueTint30.color
        }
    }

    func primaryTint40Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryTint40Color")
        } else {
            return Colors.Palette.communicationBlueTint40.color
        }
    }

    func primaryShade10Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryShade10Color")
        } else {
            return Colors.Palette.communicationBlueShade10.color
        }
    }

    func primaryShade20Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryShade20Color")
        } else {
            return Colors.Palette.communicationBlueShade20.color
        }
    }

    func primaryShade30Color(for window: UIWindow) -> UIColor? {
        if DemoColorThemeWindow.theme == "Green" {
            return UIColor(named: "Colors/DemoPrimaryShade30Color")
        } else {
            return Colors.Palette.communicationBlueShade30.color
        }
    }
}
