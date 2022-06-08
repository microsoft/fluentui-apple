//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Attachment implementation.
@objc open class MSFAttachment: NSObject, FluentUIWindowProvider {
    /// The UIView representing the Attachment.
    @objc open var view: UIView {
        return hostingController.view
    }
    /// Creates a new MSFAttachment instance.
    /// - Parameters:
    ///   - theme: The FluentUIStyle instance representing the theme to be overridden for this Attachment.
    ///   - thumbnail: The UIImage used as a thumbnail within the Attachment.
    ///   - isElevated: Boolean determining if PreviewCard is flat or elevated.
    @objc public init(theme: FluentUIStyle?, thumbnail: UIImage, isElevated: Bool = false, text: String = "Text", subtext: String = "Subtext") {
        super.init()
        attachmentView = Attachment(isElevated: isElevated, thumbnail: thumbnail, text: text, subtext: subtext)
        hostingController = FluentUIHostingController(rootView: AnyView(attachmentView.windowProvider(self)))
        hostingController.disableSafeAreaInsets()
        hostingController.view.backgroundColor = .clear
    }
    var window: UIWindow? {
        return self.view.window
    }
    private var hostingController: FluentUIHostingController!
    private var attachmentView: Attachment!
}

/// View that represents the Attachment.
public struct Attachment: View {
    var isElevated: Bool
    var thumbnail: UIImage
    var text: String
    var subtext: String
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    /// Creates Attachment's thumbnail view.
    @ViewBuilder
    var attachmentThumbnail: some View {
        HStack {
            Image(uiImage: thumbnail)
                .frame(width: Constants.attachmentThumbnailWidth,
                       height: Constants.attachmentThumbnailHeight)
                .padding(EdgeInsets(
                    top: Constants.attachmentThumbnailPaddingTop,
                    leading: Constants.attachmentThumbnailPaddingLeading,
                    bottom: Constants.attachmentZeroValue,
                    trailing: Constants.attachmentZeroValue))
        }
    }
    /// Creates Attachment's entire text view.
    @ViewBuilder
    var attachmentText: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.body)
                .foregroundColor(Color(
                    red: Constants.attachmentTextColor,
                    green: Constants.attachmentTextColor,
                    blue: Constants.attachmentTextColor))
                .frame(width: Constants.attachmentTextWidth,
                       height: Constants.attachmentTextHeight,
                       alignment: .leading)
            Text(subtext)
                .font(.caption)
                .foregroundColor(Color(
                    red: Constants.attachmentSubtextColor,
                    green: Constants.attachmentSubtextColor,
                    blue: Constants.attachmentSubtextColor))
                .frame(width: Constants.attachmentSubtextWidth,
                       height: Constants.attachmentSubtextHeight,
                       alignment: .leading)
                .padding(EdgeInsets(
                    top: Constants.attachmentSubtextPaddingTop,
                    leading: Constants.attachmentZeroValue,
                    bottom: Constants.attachmentZeroValue,
                    trailing: Constants.attachmentZeroValue))
        }
        .frame(width: Constants.attachmentEntireTextWidth,
               height: Constants.attachmentEntireTextHeight)
        .padding(EdgeInsets(
            top: Constants.attachmentZeroValue,
            leading: Constants.attachmentEntireTextPaddingLeading,
            bottom: Constants.attachmentZeroValue,
            trailing: Constants.attachmentZeroValue))
    }
    /// Creates inner Attachment view containing the thumbnail and text.
    @ViewBuilder
    var innerContents: some View {
        HStack(spacing: 0) {
            attachmentThumbnail
            attachmentText
            Spacer()
        }
        .frame(minWidth: Constants.attachmentWidth, minHeight: Constants.attachmentHeight)
    }
    public var body: some View {
        innerContents
                /// Creates a background that matches the PreviewCard.
            .frame(width: Constants.cardMinWidth, height: Constants.attachmentBorderHeight)
            .background(
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                    .strokeBorder(Color(red: Constants.cardStrokeBorderColor,
                                        green: Constants.cardStrokeBorderColor,
                                        blue: Constants.cardStrokeBorderColor),
                                  lineWidth: Constants.cardLineWidth)
                    .modifyIf(isElevated, { view in view
                            .shadow(color: .black.opacity(Constants.cardAmbientAlphaColor),
                                    radius: Constants.cardShadowRadius,
                                    x: Constants.ambientShadowOffsetX,
                                    y: Constants.ambientShadowOffsetY)
                            .shadow(color: .black.opacity(Constants.cardPerimeterAlphaColor),
                                    radius: Constants.cardShadowRadius,
                                    x: Constants.perimeterShadowOffsetX,
                                    y: Constants.perimeterShadowOffsetY)
                    })
    )}
// MARK: - Attachment Properties
    struct Constants {
        static let attachmentBorderHeight: CGFloat = 64
        static let attachmentBorderWidth: CGFloat = 343
        static let attachmentThumbnailWidth: CGFloat = 40
        static let attachmentThumbnailHeight: CGFloat = 48
        static let attachmentTextWidth: CGFloat = 33
        static let attachmentTextHeight: CGFloat = 22
        static let attachmentSubtextWidth: CGFloat = 47
        static let attachmentSubtextHeight: CGFloat = 18
        static let attachmentEntireTextWidth: CGFloat = 47
        static let attachmentEntireTextHeight: CGFloat = 40
        static let attachmentWidth: CGFloat = 119
        static let attachmentHeight: CGFloat = 40

        static let attachmentThumbnailPaddingTop: CGFloat = -4
        static let attachmentThumbnailPaddingLeading: CGFloat = 16
        static let attachmentSubtextPaddingTop: CGFloat = -8
        static let attachmentEntireTextPaddingLeading: CGFloat = 22
        static let attachmentZeroValue: CGFloat = 0

        static let cardMinWidth: CGFloat = 343
        static let cardCornerRadius: CGFloat = 8
        static let cardLineWidth: CGFloat = 0.5
        static let cardShadowRadius: CGFloat = 2
        static let cardAmbientAlphaColor: CGFloat = 0.14
        static let cardPerimeterAlphaColor: CGFloat = 0.12
        static let ambientShadowOffsetX: CGFloat = 0
        static let ambientShadowOffsetY: CGFloat = 1
        static let perimeterShadowOffsetX: CGFloat = 0
        static let perimeterShadowOffsetY: CGFloat = 0

        static let cardStrokeBorderColor: Double = 0x61 / 255.0
        static let attachmentSubtextColor: Double = 0x97 / 255.0
        static let attachmentTextColor: Double = 0x34 / 255.0
    }
}
