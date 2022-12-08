//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class ReadmeViewController: UIViewController {

    private struct Constants {
        static let topPadding: CGFloat = 25
        static let leadingAndTrailingPadding: CGFloat = 20
        static let popoverWidth: CGFloat = 400
    }

    private let readmeLabel: Label = {
        let label = Label()
        label.numberOfLines = 0

        // TODO: Change color to fluent 2 tokens
        label.textColor = UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                             dark: ColorValue(0xFFFFFF)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let readmeString: String?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let readmeString = readmeString {
            readmeLabel.text = readmeString
        }

        setupConstraints()

        let popoverHeight = readmeLabel.frame.height + Constants.topPadding
        preferredContentSize = CGSize(width: Constants.popoverWidth, height: popoverHeight)
    }

    init(readmeString: String?) {
        self.readmeString = readmeString

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = .up
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        view.addSubview(readmeLabel)

        NSLayoutConstraint.activate([
            readmeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            readmeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingAndTrailingPadding),
            readmeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.leadingAndTrailingPadding)
        ])
    }
}
