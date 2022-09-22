//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class ReadmeViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleString: String?
    let subtitleString: String?

    let titleLabel: Label = {
        let label = Label()
        label.style = .headline
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollViewConstraints()
        setupViews()
        setLabelTexts()
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3 / 4).isActive = true

        contentView.addSubview(subtitleLabel)
        subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3 / 4).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    init(titleString: String?, subtitleString: String?) {
        self.titleString = titleString
        self.subtitleString = subtitleString

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 300, height: 400)
        popoverPresentationController?.permittedArrowDirections = .up
    }

    private func setLabelTexts() {
        if let titleString = titleString {
            titleLabel.text = titleString
        }

        if let subtitleString = subtitleString {
            subtitleLabel.text = subtitleString
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
