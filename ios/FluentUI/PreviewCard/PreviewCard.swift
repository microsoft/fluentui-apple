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
    @objc public init(theme: FluentUIStyle?) {
        super.init()
        previewCardView = PreviewCard()
        hostingController = FluentUIHostingController(rootView: AnyView(previewCardView.windowProvider(self)))
        hostingController.disableSafeAreaInsets()
    }
    var window: UIWindow? {
        return self.view.window
    }
    private var hostingController: FluentUIHostingController!
    private var previewCardView: PreviewCard!
}

/// View that represents the PreviewCard.
public struct PreviewCard: View {

    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    /// Creates inner PreviewCard view.
    @ViewBuilder
    var innerContents: some View {
        HStack {
            Spacer()
                .frame(minWidth: Constants.cardMinWidth, minHeight: Constants.cardMinHeight)
        }
    }
    /// Creates the PreviewCard.
    public var body: some View {
// TODO: - Implement elevated card
// TODO: - Update to implement light and dark mode
        innerContents
            .background(
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                    .strokeBorder(Color(.black), lineWidth: Constants.cardLineWidth)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                            .fill(.white)
                    )
    )}
// MARK: - PreviewCard Box Properties
    // TODO: - Update the hard values with tokens
    private struct Constants {
        static let cardMinWidth: CGFloat = 343
        static let cardMinHeight: CGFloat = 147
        static let cardCornerRadius: CGFloat = 8
        static let cardLineWidth: CGFloat = 0.5
    }
}
