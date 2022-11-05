//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class ReadmeViewController: UIViewController {

    private struct Constants {
        static let topPadding: CGFloat = 35
        static let bottomPadding: CGFloat = -25
        static let widthMultiplier: CGFloat = 0.9
        static let popoverWidth: CGFloat = 400
        static let popoverHeight: CGFloat = 250
    }

    let scrollView = UIScrollView()
    let contentView = UIView()

    let readme: String?

    let readmeLabel: Label = {
        let label = Label()
        label.numberOfLines = 0

        // TODO: Change color to fluent 2 tokens
        label.textColor = UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                             dark: ColorValue(0xFFFFFF)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollViewConstraints()
        setupReadmeLabelConstraints()

        if let readmeString = readme {
            readmeLabel.text = readmeString
        }
    }

    private func setupReadmeLabelConstraints() {
        contentView.addSubview(readmeLabel)

        NSLayoutConstraint.activate([
            readmeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            readmeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topPadding),
            readmeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.widthMultiplier),
            readmeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bottomPadding),

            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    init(readmeString: String?) {
        self.readme = readmeString

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: Constants.popoverWidth, height: Constants.popoverHeight)
        popoverPresentationController?.permittedArrowDirections = .up
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
