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
        guard let previewCardPlaceholder = UIImage.init(named: "PreviewCard_Placeholder") else {
            return
        }
        guard let thumbnailPlaceholder = UIImage.init(named: "Thumbnail_Placeholder") else {
            return
        }

        let previewUltrawideFlatCard = MSFPreviewCard(theme: nil, image: previewCardPlaceholder, cardHeight: .ultrawideHeight)
        let previewUltrawideElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: previewCardPlaceholder, cardHeight: .ultrawideHeight)
        let previewLandscapeFlatCard = MSFPreviewCard(theme: nil, image: previewCardPlaceholder, cardHeight: .landscapeHeight)
        let previewLandscapeElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: previewCardPlaceholder, cardHeight: .landscapeHeight)
        let previewFullscreenFlatCard = MSFPreviewCard(theme: nil, image: previewCardPlaceholder, cardHeight: .fullscreenHeight)
        let previewFullscreenElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: previewCardPlaceholder, cardHeight: .fullscreenHeight)
        let previewSquareFlatCard = MSFPreviewCard(theme: nil, image: previewCardPlaceholder, cardHeight: .squareHeight)
        let previewSquareElevatedCard = MSFPreviewCard(theme: nil, isElevated: true, image: previewCardPlaceholder, cardHeight: .squareHeight)

        let flatAttachmentUltrawide = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder)
        let elevatedAttachmentUltrawide = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder, isElevated: true)
        let flatAttachmentLandscape = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder)
        let elevatedAttachmentLandscape = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder, isElevated: true)
        let flatAttachmentFullscreen = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder)
        let elevatedAttachmentFullscreen = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder, isElevated: true)
        let flatAttachmentSquare = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder)
        let elevatedAttachmentSquare = MSFAttachment(theme: nil, thumbnail: thumbnailPlaceholder, isElevated: true)

        let previewUltrawideFlatCardView = previewUltrawideFlatCard.view
        let previewUltrawideElevatedCardView = previewUltrawideElevatedCard.view
        let previewLanscapeFlatCardView = previewLandscapeFlatCard.view
        let previewLandscapeElevatedCardView = previewLandscapeElevatedCard.view
        let previewFullscreenFlatCardView = previewFullscreenFlatCard.view
        let previewFullscreenElevatedCardView = previewFullscreenElevatedCard.view
        let previewSquareFlatCardView = previewSquareFlatCard.view
        let previewSquareElevatedCardView = previewSquareElevatedCard.view

        let flatAttachmentUltrawideView = flatAttachmentUltrawide.view
        let elevatedAttachmentUltrawideView = elevatedAttachmentUltrawide.view
        let flatAttachmentLandscapeView = flatAttachmentLandscape.view
        let elevatedAttachmentLandscapeView = elevatedAttachmentLandscape.view
        let flatAttachmentFullscreenView = flatAttachmentFullscreen.view
        let elevatedAttachmentFullscreenView = elevatedAttachmentFullscreen.view
        let flatAttachmentSquareView = flatAttachmentSquare.view
        let elevatedAttachmentSquareView = elevatedAttachmentSquare.view

        container.addArrangedSubview(previewUltrawideFlatCardView)
        container.addArrangedSubview(flatAttachmentUltrawideView)
        container.addArrangedSubview(previewUltrawideElevatedCardView)
        container.addArrangedSubview(elevatedAttachmentUltrawideView)
        addTitle(text: "21:9")

        container.addArrangedSubview(previewLanscapeFlatCardView)
        container.addArrangedSubview(flatAttachmentLandscapeView)
        container.addArrangedSubview(previewLandscapeElevatedCardView)
        container.addArrangedSubview(elevatedAttachmentLandscapeView)
        addTitle(text: "16:9")

        container.addArrangedSubview(previewFullscreenFlatCardView)
        container.addArrangedSubview(flatAttachmentFullscreenView)
        container.addArrangedSubview(previewFullscreenElevatedCardView)
        container.addArrangedSubview(elevatedAttachmentFullscreenView)
        addTitle(text: "4:3")

        container.addArrangedSubview(previewSquareFlatCardView)
        container.addArrangedSubview(flatAttachmentSquareView)
        container.addArrangedSubview(previewSquareElevatedCardView)
        container.addArrangedSubview(elevatedAttachmentSquareView)
        addTitle(text: "1:1")
        view.backgroundColor = Colors.surfaceSecondary

    }
// MARK: - Constraint Constant Attribute Values
    private struct Constants {
        static let constantOffset: CGFloat = 16.0
    }
}
