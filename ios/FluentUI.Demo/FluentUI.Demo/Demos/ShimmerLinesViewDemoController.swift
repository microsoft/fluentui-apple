//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ShimmerViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = { () -> UIStackView in
            let label1 = UILabel()
            label1.text = "Label 1"
            label1.setContentHuggingPriority(.defaultHigh, for: .horizontal)

            let label2 = UILabel()
            label2.text = "Label 2"

            let label3 = UILabel()
            label3.text = "label 3"

            let verticalStackView = UIStackView(arrangedSubviews: [label2, label3])
            verticalStackView.axis = .vertical
            verticalStackView.spacing = 5
            verticalStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)

            let parentStackView = UIStackView(arrangedSubviews: [label1, verticalStackView])
            parentStackView.spacing = 5
            return parentStackView
        }

        let shimmeringContentView = { (shimmersLeafViews: Bool) -> UIStackView in
            let containerView = contentView()
            let shimmerView = ShimmerView(containerView: containerView, excludedViews: [], animationSynchronizer: nil)
            shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            shimmerView.shimmersLeafViews = shimmersLeafViews
            shimmerView.usesTextHeightForLabels = true
            shimmerView.labelHeight = -1 // Must be < 0 so we actually use the bool usesTextHeightForLabels
            containerView.addSubview(shimmerView)
            return containerView
        }

        let shimmeringImageView = { (shimmerStyle: ShimmerStyle) -> UIView in
            let imageView = UIImageView(image: UIImage(named: "PlaceholderImage")?.withTintColor(Colors.Shimmer.tint, renderingMode: .alwaysOriginal))
            let containerView = UIStackView(arrangedSubviews: [imageView])
            let shimmerView = ShimmerView(containerView: containerView, excludedViews: [], animationSynchronizer: nil, shimmerStyle: shimmerStyle)
            shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            shimmerView.shimmerStyle = shimmerStyle
            containerView.addSubview(shimmerView)
            return containerView
        }

        let shimmerViewLabel = { (text: String) -> UILabel in
            let label = Label(style: .headline)
            label.numberOfLines = 0
            label.text = text
            return label
        }

        container.addArrangedSubview(shimmerViewLabel("A ShimmerLinesView needs no containerview or subviews"))
        container.addArrangedSubview(MSFDivider().view)
        container.addArrangedSubview(ShimmerLinesView())
        container.addArrangedSubview(MSFDivider().view)

        container.addArrangedSubview(shimmerViewLabel("ShimmerView shimmers all the top level subviews of its container view"))
        container.addArrangedSubview(MSFDivider().view)
        container.addArrangedSubview(shimmeringContentView(false))
        container.addArrangedSubview(MSFDivider().view)

        container.addArrangedSubview(shimmerViewLabel("With shimmersLeafViews set, the ShimmerView will shimmer the labels inside the stackview"))
        container.addArrangedSubview(MSFDivider().view)
        container.addArrangedSubview(shimmeringContentView(true))
        container.addArrangedSubview(MSFDivider().view)

        container.addArrangedSubview(shimmerViewLabel("Revealing style shimmer on an image: the gradient reveals its container view as it moves"))
        container.addArrangedSubview(MSFDivider().view)
        container.addArrangedSubview(shimmeringImageView(.revealing))

        container.addArrangedSubview(MSFDivider().view)
        container.addArrangedSubview(shimmerViewLabel("Concealing style shimmer on an image: the gradient conceals its container view as it moves"))
        container.addArrangedSubview(MSFDivider().view)
        container.addArrangedSubview(shimmeringImageView(.concealing))
    }
}
