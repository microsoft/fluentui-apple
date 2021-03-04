//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// This is a generic UIView wrapper to allow SwiftUI to use views from non-SwiftUI environments.
struct UIViewAdapter: UIViewRepresentable {

    var makeView: () -> UIView
    private var tintColor: UIColor?

    init(_ makeView: @escaping @autoclosure () -> UIView) {
        self.makeView = makeView
    }

    func makeUIView(context: Context) -> UIView {
        let view = makeView()
        // Wrapping the view passed on a StackView is a workaround for a hang that occurs
        // on iOS 13 when the view passed directly comes from a UIHostingController.view
        // property. (e.g. using the MSFAvatar.view property).
        return UIStackView(arrangedSubviews: [view])
    }

    func updateUIView(_ view: UIView, context: Context) {
        if let tintColor = tintColor {
            view.tintColor = tintColor
        }
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

extension UIViewAdapter {
    func foregroundColor(_ color: UIColor) -> Self {
        var view = self
        view.tintColor = color
        view.makeView().tintColor = color
        return view
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
