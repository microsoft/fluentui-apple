//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc open class MSFPreviewCard: NSObject, FluentUIWindowProvider {
    @objc open var view: UIView {
        return hostingController.view
    }
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

public struct PreviewCard: View {

    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    private struct Constants {
        static let boxMinWidth: CGFloat = 343
        static let boxMinHeight: CGFloat = 200
        static let boxRoundedTitle: String = "Rounded Box"
        static let boxRadius: CGFloat = 8
        static let boxLineWidth: CGFloat = 0.5
    }
    @ViewBuilder
    var innerContents: some View {
        VStack {
            Text(Constants.boxRoundedTitle)
                .frame(minWidth: Constants.boxMinWidth, minHeight: Constants.boxMinHeight)
        }
    }
    public var body: some View {
        innerContents
            .background(
                RoundedRectangle(cornerRadius: Constants.boxRadius)
                    .strokeBorder(Color(.black), lineWidth: Constants.boxLineWidth)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.boxRadius)
                            .fill(.white)
                    )
    )}
}
