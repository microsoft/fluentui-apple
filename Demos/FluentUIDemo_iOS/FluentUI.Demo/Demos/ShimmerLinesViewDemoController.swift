//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ShimmerViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        readmeString = "A shimmer lets people know that information is loading and gives them an idea of the structure of the information.\n\nUse shimmers for loading states that take longer than one second but avoid them for long loading processes. They are indeterminate indicators, so they don’t communicate how much time is left before the process is done. Seeing a shimmer for too long could make people think something’s gone wrong."
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
            let shimmerView = ShimmerView(containerView: containerView,
                                          excludedViews: [],
                                          animationSynchronizer: nil,
                                          shimmersLeafViews: shimmersLeafViews,
                                          usesTextHeightForLabels: true)
            shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(shimmerView)
            return containerView
        }

        let shimmeringImageView = { (shimmerStyle: MSFShimmerStyle) -> UIView in
            // Uses a nice gray color that happens to match the gray of the shimmer control. Any color can be used here though.
            let tintColor = UIColor(hexValue: 0xF1F1F1)
            let imageView = UIImageView(image: UIImage(named: "PlaceholderImage")?.withTintColor(tintColor, renderingMode: .alwaysOriginal))
            let containerView = UIStackView(arrangedSubviews: [imageView])
            let shimmerView = ShimmerView(containerView: containerView,
                                          excludedViews: [],
                                          animationSynchronizer: nil,
                                          shimmerStyle: shimmerStyle)
            shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(shimmerView)
            return containerView
        }

        let shimmerViewLabel = { (text: String) -> UILabel in
            let label = Label()
            label.numberOfLines = 0
            label.text = text
            return label
        }

        container.addArrangedSubview(shimmerViewLabel("A ShimmerLinesView needs no containerview or subviews"))
        container.addArrangedSubview(Separator())
        container.addArrangedSubview(ShimmerLinesView())
        container.addArrangedSubview(Separator())

        container.addArrangedSubview(shimmerViewLabel("The middle lines of ShimmerLinesView are always at 100% width"))
        container.addArrangedSubview(Separator())
        let shimmerLinesView = ShimmerLinesView(containerView: nil,
                                                excludedViews: [],
                                                animationSynchronizer: nil)
        shimmerLinesView.lineCount = 6
        container.addArrangedSubview(shimmerLinesView)
        container.addArrangedSubview(Separator())

        container.addArrangedSubview(shimmerViewLabel("ShimmerView shimmers all the top level subviews of its container view"))
        container.addArrangedSubview(Separator())
        container.addArrangedSubview(shimmeringContentView(false))
        container.addArrangedSubview(Separator())

        container.addArrangedSubview(shimmerViewLabel("With shimmersLeafViews set, the ShimmerView will shimmer the labels inside the stackview"))
        container.addArrangedSubview(Separator())
        container.addArrangedSubview(shimmeringContentView(true))
        container.addArrangedSubview(Separator())

        container.addArrangedSubview(shimmerViewLabel("Revealing style shimmer on an image: the gradient reveals its container view as it moves"))
        container.addArrangedSubview(Separator())
        container.addArrangedSubview(shimmeringImageView(.revealing))

        container.addArrangedSubview(Separator())
        container.addArrangedSubview(shimmerViewLabel("Concealing style shimmer on an image: the gradient conceals its container view as it moves"))
        container.addArrangedSubview(Separator())
        container.addArrangedSubview(shimmeringImageView(.concealing))
    }
}
