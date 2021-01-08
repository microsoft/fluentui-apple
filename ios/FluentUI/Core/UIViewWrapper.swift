//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// This is a generic UIView wrapper to allow SwiftUI  to use views from non-SwiftUI environments.
struct UIViewWrapper: UIViewRepresentable {

    var makeView: () -> UIView

    init(_ makeView: @escaping @autoclosure () -> UIView) {
        self.makeView = makeView
    }

    func makeUIView(context: Context) -> UIView {
        makeView()
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}
