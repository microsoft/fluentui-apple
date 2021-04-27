//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

extension UIHostingController {
    /// Disables the UIHostingController's view safe area insets by swizzling the UIView.safeAreaInsets property and returning UIEdgeInsets.zero.
    /// This is a known issue and it's currently tracked by Radar bug FB8176223 - https://openradar.appspot.com/FB8176223
    func disableSafeAreaInsets() {
        guard let hostingControllerViewClass = view?.classForCoder else {
            return
        }

        guard let safeAreaInsetsMethod = class_getInstanceMethod(hostingControllerViewClass.self,
                                                                 #selector(getter: UIView.safeAreaInsets)) else {
            return
        }

        let zeroSafeAreaInsetsImpl: @convention(block) (AnyObject) -> UIEdgeInsets = { (_ self: AnyObject!) -> UIEdgeInsets in
            return .zero
        }

        class_replaceMethod(hostingControllerViewClass,
                            #selector(getter: UIView.safeAreaInsets),
                            imp_implementationWithBlock(zeroSafeAreaInsetsImpl),
                            method_getTypeEncoding(safeAreaInsetsMethod))
    }
}

/// This is a generic UIView wrapper to allow SwiftUI to use views from non-SwiftUI environments.
struct UIViewAdapter: UIViewRepresentable {

    var makeView: () -> UIView

    init(_ makeView: @escaping @autoclosure () -> UIView) {
        self.makeView = makeView
    }

    func makeUIView(context: Context) -> UIView {
        // Wrapping the view passed on a StackView is a workaround for a hang that occurs
        // on iOS 13 when the view passed directly comes from a UIHostingController.view
        // property. (e.g. using the MSFAvatar.view property).
        return UIStackView(arrangedSubviews: [makeView()])
    }

    func updateUIView(_ view: UIView, context: Context) {
        // This logic should be removed wnce the "wrapping in a UIStackView" workaround is removed.
        guard let stackView = view as? UIStackView else {
            return
        }

        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        stackView.addArrangedSubview(makeView())
    }
}
