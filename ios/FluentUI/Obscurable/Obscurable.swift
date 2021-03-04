//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Obscurable represents any UIView containing class that obscures views behind it. It is used to generically use different styles of background obscuring for modals, as well as provide an interface to turn their effect on or off.
protocol Obscurable: AnyObject {
    var view: UIView { get }
    var isObscuring: Bool { get set }
}

@objc(MSFObscureStyle)
public enum ObscureStyle: Int {
    case blur
    case dim
}

/// ObsurableFactory creates an Obscurable UIView of a selected type, to be used behind modals, drawers, and other views that need to mask their backgrounds.
class ObscurableFactory {
    static func obscurable(with obscureStyle: ObscureStyle) -> Obscurable {
        switch obscureStyle {
        case .blur:
            return BlurringView(style: .dark)
        case .dim:
            return DimmingView(type: .black)
        }
    }
}
