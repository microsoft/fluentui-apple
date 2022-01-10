//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// This is a generic UIView wrapper that allows SwiftUI to use UIKit views in its hierarchy.
struct UIViewAdapter: UIViewRepresentable {

    var makeView: () -> UIView

    init(_ makeView: @escaping @autoclosure () -> UIView) {
        self.makeView = makeView
    }

    func makeUIView(context: Context) -> UIStackView {
        // Using a UIStackView as the container ensures that the content
        // UIView respects the frame defined in the SwiftUI layer.
        return UIStackView(arrangedSubviews: [makeView()])
    }

    func updateUIView(_ stackview: UIStackView, context: Context) {
        // The UIStackView container needs to update its arranged subviews to cover
        // the case where the makeview property now provides a different view.
        stackview.arrangedSubviews.forEach({ subview in
            subview.removeFromSuperview()
        })

        stackview.addArrangedSubview(makeView())
    }
}
