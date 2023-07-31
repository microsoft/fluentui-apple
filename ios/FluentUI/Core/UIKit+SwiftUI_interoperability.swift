//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UILabel wrapper that allows SwiftUI to support NSAttributedString
struct AttributedText: UIViewRepresentable {

    let attributedString: NSAttributedString
    let preferredMaxWidth: CGFloat

    init(_ attributedString: NSAttributedString, _ preferredMaxWidth: CGFloat) {
        self.attributedString = attributedString
        self.preferredMaxWidth = preferredMaxWidth
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()

        // Setting this ensures the UIViewRepresentable respects the parent view's width
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    func updateUIView(_ label: UILabel, context: Context) {
        // Update the UILabel's attributes if it changes.
        DispatchQueue.main.async {
            label.attributedText = attributedString
            label.preferredMaxLayoutWidth = preferredMaxWidth
        }
    }
}
