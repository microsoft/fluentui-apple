//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class PreviewCardDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let previewCard = MSFPreviewCard(theme: nil)
        let previewCardView = previewCard.view
        view.addSubview(previewCardView)
        previewCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.constantOffset),
            previewCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.constantOffset),
            previewCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.constantOffset),
            previewCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.constantOffset)
        ])
    }
// MARK: - Constraint Constant Attribute Values
    private struct Constants {
        static let constantOffset: CGFloat = 16.0
    }
}
