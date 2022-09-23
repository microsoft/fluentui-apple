//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class ReadmeViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()

    let readme: String?

    let readmeLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor(dynamicColor: DynamicColor(light: ColorValue(0x000000),
                                                             dark: ColorValue(0xFFFFFF)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollViewConstraints()
        setupReadmeLabelConstraints()
        setReadmeLabelText()
    }

    private func setupReadmeLabelConstraints() {
        contentView.addSubview(readmeLabel)
        readmeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        readmeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        readmeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3 / 4).isActive = true
        readmeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    init(readmeString: String?) {
        self.readme = readmeString

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 400, height: 250)
        popoverPresentationController?.permittedArrowDirections = .up
    }

    private func setReadmeLabelText() {
        if let readmeString = readme {
            readmeLabel.text = readmeString
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
