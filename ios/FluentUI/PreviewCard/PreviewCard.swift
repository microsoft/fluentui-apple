//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI PreviewCard implementation.
@objc open class MSFPreviewCard: NSObject, FluentUIWindowProvider {
    /// The UIView representing the Activity Indicator.
    @objc open var view: UIView {
        return hostingController.view
    }
    /// Creates a new MSFPreviewCard instance.
    /// - Parameters:
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this PreviewCard.
    @objc public init(theme: FluentUIStyle?, elevated: Bool) {
        super.init()
        previewCardView = PreviewCard(showEleavatedCard: elevated)
        hostingController = FluentUIHostingController(rootView: AnyView(previewCardView.windowProvider(self)))
        hostingController.disableSafeAreaInsets()
    }
    var window: UIWindow? {
        return self.view.window
    }
    private var hostingController: FluentUIHostingController!
    private var previewCardView: PreviewCard!
}

extension View {
    /// Sets the height and width of the Preview Card.
    func cardBorderModifiers() -> some View {
        self
            .frame(minWidth: PreviewCard.Constants.cardMinWidth, minHeight: PreviewCard.Constants.cardMinHeight)
    }
    /// Sets the background border style, radius, color, and linewidth of the Preview Card.
    func cardBackgroundModifiers() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: PreviewCard.Constants.cardCornerRadius)
                    .strokeBorder(Color(Color.RGBColorSpace.sRGB, red: PreviewCard.Constants.cardStrokeBorderColor, green: PreviewCard.Constants.cardStrokeBorderColor, blue: PreviewCard.Constants.cardStrokeBorderColor), lineWidth: PreviewCard.Constants.cardLineWidth)
    )}
}

/// View that represents the PreviewCard.
public struct PreviewCard: View {
    var showEleavatedCard: Bool
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    /// Creates inner PreviewCard view.
    @ViewBuilder
    var innerContents: some View {
        HStack {
            Spacer()
                .cardBorderModifiers()
                .cardBackgroundModifiers()
                .modifyIf(showEleavatedCard, { view in view
                        .shadow(color: Color(.black.withAlphaComponent(0.14)),
                                radius: Constants.cardShadowRadius,
                                x: Constants.ambientShadowOffsetX,
                                y: Constants.ambientShadowOffsetY)
                        .shadow(color: Color(.black.withAlphaComponent(0.12)),
                                radius: Constants.cardShadowRadius,
                                x: Constants.perimeterShadowOffsetX,
                                y: Constants.perimeterShadowOffsetY)
                })
        }
    }
    /// Creates the PreviewCard.
    public var body: some View {
// TODO: - Implement elevated card
// TODO: - Update to implement light and dark mode
        innerContents
    }
// MARK: - PreviewCard Box Properties
    // TODO: - Update the hard values with tokens
    struct Constants {
        static let cardMinWidth: CGFloat = 343
        static let cardMinHeight: CGFloat = 147
        static let cardCornerRadius: CGFloat = 8
        static let cardLineWidth: CGFloat = 0.5
        static let cardBottomPadding: CGFloat = 20
        static let cardShadowRadius: CGFloat = 2
        static let ambientShadowOffsetX: CGFloat = 0
        static let ambientShadowOffsetY: CGFloat = 1
        static let perimeterShadowOffsetX: CGFloat = 0
        static let perimeterShadowOffsetY: CGFloat = 0
        static let cardStrokeBorderColor: Double = 0x61 / 255.0
    }
}
