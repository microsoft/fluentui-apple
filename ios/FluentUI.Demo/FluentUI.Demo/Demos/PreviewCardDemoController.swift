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
        guard let placeholderImage = UIImage.init(named: "W11_Placeholder") else {
            return
        }
        let previewFlatCard = MSFPreviewCard(theme: nil, placeholderImage: placeholderImage)
        let previewElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, placeholderImage: placeholderImage)
        let previewFlatCardView = previewFlatCard.view
        let previewElevatedCardView = previewElevatedCard.view
        view.backgroundColor = Colors.surfaceSecondary
        view.addSubview(previewFlatCardView)
        view.addSubview(previewElevatedCardView)
        previewFlatCardView.translatesAutoresizingMaskIntoConstraints = false
        previewElevatedCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewFlatCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.constantOffset),
            previewElevatedCardView.topAnchor.constraint(equalTo: previewFlatCardView.bottomAnchor, constant: Constants.constantOffset),
            previewFlatCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.constantOffset),
            previewElevatedCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.constantOffset)
        ])
    }
// MARK: - Constraint Constant Attribute Values
    private struct Constants {
        static let constantOffset: CGFloat = 16.0
    }
}
