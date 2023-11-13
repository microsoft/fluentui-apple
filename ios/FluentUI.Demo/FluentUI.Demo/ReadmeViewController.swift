//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class ReadmeViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        readmeLabel.text = readmeString ?? "< Documentation will be added soon >"

        let popoverHeight = readmeLabel.frame.height + Constants.topPadding
        preferredContentSize = CGSize(width: Constants.popoverWidth, height: popoverHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(readmeLabel)
        setupConstraints()
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

    private struct Constants {
        static let topPadding: CGFloat = 25
        static let leadingAndTrailingPadding: CGFloat = 20
        static let popoverWidth: CGFloat = 400
    }

    private let readmeLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.textColor = UIColor(light: GlobalTokens.neutralColor(.black),
                                  dark: GlobalTokens.neutralColor(.white))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let readmeString: String?

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            readmeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            readmeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingAndTrailingPadding),
            readmeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.leadingAndTrailingPadding)
        ])
    }
}
