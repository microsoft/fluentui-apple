//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension UIDevice {
    class var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }
    class var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }

    class var isPhone5or5s: Bool {
        return isPhone && (UIScreen.main.bounds.size.height == 568 || UIScreen.main.bounds.size.width == 568)
    }
    class var isPhone6orLarger: Bool {
        return isPhone && (UIScreen.main.bounds.size.height >= 667 || UIScreen.main.bounds.size.width >= 667)
    }
    class var isPhonePlus: Bool {
        return isPhone && (UIScreen.main.bounds.size.height == 736 || UIScreen.main.bounds.size.width == 736)
    }
    class var isPhoneX: Bool {
        return isPhone && (UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.width == 812)
    }

    class var isPadProLarge: Bool {
        return isPad && (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366)
    }
}
