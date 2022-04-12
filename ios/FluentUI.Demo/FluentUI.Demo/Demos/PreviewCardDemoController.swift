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
            previewCardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16.0),
            previewCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            previewCardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16.0),
            previewCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16.0)
        ])
    }
}
