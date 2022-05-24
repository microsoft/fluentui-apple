//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class PreviewCardDemoController: DemoController {
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
        let previewUltrawideFlatCard = MSFPreviewCard(theme: nil, image: placeholderImage, cardHeight: .ultrawideHeight)
        let previewUltrawideElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: placeholderImage, cardHeight: .ultrawideHeight)
        let previewLandscapeFlatCard = MSFPreviewCard(theme: nil, image: placeholderImage, cardHeight: .landscapeHeight)
        let previewLandscapeElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: placeholderImage, cardHeight: .landscapeHeight)
        let previewOldLanscapeFlatCard = MSFPreviewCard(theme: nil, image: placeholderImage, cardHeight: .oldLandscapeHeight)
        let previewOldLanscapeElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: placeholderImage, cardHeight: .oldLandscapeHeight)
        let previewSquareFlatCard = MSFPreviewCard(theme: nil, image: placeholderImage, cardHeight: .squareHeight)
        let previewSquareElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: placeholderImage, cardHeight: .squareHeight)
        let previewUltrawideFlatCardView = previewUltrawideFlatCard.view
        let previewUltrawideElevatedCardView = previewUltrawideElevatedCard.view
        let previewLanscapeFlatCardView = previewLandscapeFlatCard.view
        let previewLandscapeElevatedCardView = previewLandscapeElevatedCard.view
        let previewOldLandscapeFlatCardView = previewOldLanscapeFlatCard.view
        let previewOldLandscapeElevatedCardView = previewOldLanscapeElevatedCard.view
        let previewSquareFlatCardView = previewSquareFlatCard.view
        let previewSquareElevatedCardView = previewSquareElevatedCard.view
        container.addArrangedSubview(previewUltrawideFlatCardView)
        container.addArrangedSubview(previewUltrawideElevatedCardView)
        addTitle(text: "21:9")
        container.addArrangedSubview(previewLanscapeFlatCardView)
        container.addArrangedSubview(previewLandscapeElevatedCardView)
        addTitle(text: "16:9")
        container.addArrangedSubview(previewOldLandscapeFlatCardView)
        container.addArrangedSubview(previewOldLandscapeElevatedCardView)
        addTitle(text: "4:3")
        container.addArrangedSubview(previewSquareFlatCardView)
        container.addArrangedSubview(previewSquareElevatedCardView)
        addTitle(text: "1:1")
        view.backgroundColor = Colors.surfaceSecondary

    }
// MARK: - Constraint Constant Attribute Values
    private struct Constants {
        static let constantOffset: CGFloat = 16.0
    }
}
