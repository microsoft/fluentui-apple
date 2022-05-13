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

/// UILabel wrapper that allows SwiftUI to support NSAttributedString
struct AttributedText: UIViewRepresentable {

    let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()

        // Setting this ensures the UIViewRepresentable respects the parent view's width
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        // Update the UILabel's attributes if it changes.
        DispatchQueue.main.async {
            uiView.attributedText = attributedString
            uiView.preferredMaxLayoutWidth = uiView.bounds.width
        }
    }
}
