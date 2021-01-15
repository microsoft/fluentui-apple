//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// This is a generic UIView wrapper to allow SwiftUI to use views from non-SwiftUI environments.
public struct UIViewAdapter: UIViewRepresentable {

    var makeView: () -> UIView

    init(_ makeView: @escaping @autoclosure () -> UIView) {
        self.makeView = makeView
    }

    public func makeUIView(context: Context) -> UIView {
        makeView()
    }

    public func updateUIView(_ view: UIView, context: Context) {
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}

/// This is a generic UIViewController wrapper to allow SwiftUI to use views from non-SwiftUI environments.
public struct UIViewControllerAdapter: UIViewControllerRepresentable {

    var makeViewController: () -> UIViewController

    init(_ makeViewController: @escaping @autoclosure () -> UIViewController) {
        self.makeViewController = makeViewController
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return makeViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    public typealias UIViewControllerType = UIViewController
}
