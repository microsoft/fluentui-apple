//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// This is a generic UIView wrapper to allow SwiftUI to use views from non-SwiftUI environments.
struct UIViewAdapter: UIViewRepresentable {

    var makeView: () -> UIView
    let foregroundColor: UIColor?

    init(_ makeView: @escaping @autoclosure () -> UIView, foregroundColor: UIColor? = nil) {
        self.makeView = makeView
        self.foregroundColor = foregroundColor
    }

    func makeUIView(context: Context) -> UIView {
        let view = makeView()
        if let color = foregroundColor {
            view.tintColor = color
        }
        // Wrapping the view passed on a StackView is a workaround for a hang that occurs
        // on iOS 13 when the view passed directly comes from a UIHostingController.view
        // property. (e.g. using the MSFAvatar.view property).
        return UIStackView(arrangedSubviews: [view])
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

/// This is a generic UIViewController wrapper to allow SwiftUI to use views from non-SwiftUI environments.
struct UIViewControllerAdapter: UIViewControllerRepresentable {

    var makeViewController: () -> UIViewController

    init(_ makeViewController: @escaping @autoclosure () -> UIViewController) {
        self.makeViewController = makeViewController
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return makeViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    typealias UIViewControllerType = UIViewController
}
