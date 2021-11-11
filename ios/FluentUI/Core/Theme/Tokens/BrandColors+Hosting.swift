//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - UIWindow

protocol BrandColorsHosting {
    var brandColors: BrandColors? { get }
}

extension UIWindow: BrandColorsHosting {
    private struct Keys {
        static var brandColors: String = "brandColors_key"
    }

    public var brandColors: BrandColors? {
        get {
            return objc_getAssociatedObject(self, &Keys.brandColors) as? BrandColors
        }
        set {
            objc_setAssociatedObject(self, &Keys.brandColors, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: nil)
        }
    }
}

// MARK: - Environment

public extension View {
    /// Sets a custom token factory for a specific SwiftUI View and its view hierarchy.
    /// - Parameter brandColors: Instance of the custom overriding brand colors.
    /// - Returns: The view with its `brandColors` environment value overriden.
    func brandColors(_ brandColors: BrandColors?) -> some View {
        environment(\.brandColors, brandColors)
    }
}

extension EnvironmentValues {
    var brandColors: BrandColors? {
        get {
            self[BrandColorsKey.self]
        }
        set {
            self[BrandColorsKey.self] = newValue
        }
    }
}

private struct BrandColorsKey: EnvironmentKey {
    static var defaultValue: BrandColors? {
        return nil
    }
}
