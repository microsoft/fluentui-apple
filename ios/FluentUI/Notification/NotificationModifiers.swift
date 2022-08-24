//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Presents a Notification on top of the modified View.
    /// - Parameters:
    ///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
    ///   - isFlexibleWidthToast: Whether the width of the toast is set based on the width of the screen or on its contents/
    ///   - message: Optional text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - attributedMessage: Optional attributed text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - isBlocking: Whether the interaction with the view will be blocked while the Notification is being presented.
    ///   - isPresented: Controls whether the Notification is being presented.
    ///   - title: Optional text to draw above the message area.
    ///   - attributedTitle: Optional attributed text to draw above the message area.
    ///   - image: Optional icon to draw at the leading edge of the control.
    ///   - trailingImage: Optional icon to show in the action button if no button title is provided.
    ///   - trailingImageAccessibilityLabel: Optional localized accessibility label for the trailing image.
    ///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
    ///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
    ///   - showDefaultDismissActionButton: Bool to control if the Notification has a dismiss action by default.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    ///   - showFromBottom: Defines whether the notification shows from the bottom of the presenting view or the top.
    ///   - overrideTokens: Custom NotificationTokens class that will override the default tokens.
    /// - Returns: The modified view with the capability of presenting a Notification.
    func presentNotification(style: MSFNotificationStyle,
                             isFlexibleWidthToast: Bool,
                             message: String? = nil,
                             attributedMessage: NSAttributedString? = nil,
                             isBlocking: Bool = true,
                             isPresented: Binding<Bool>,
                             title: String? = nil,
                             attributedTitle: NSAttributedString? = nil,
                             image: UIImage? = nil,
                             trailingImage: UIImage? = nil,
                             trailingImageAccessibilityLabel: String? = nil,
                             actionButtonTitle: String? = nil,
                             actionButtonAction: (() -> Void)? = nil,
                             showDefaultDismissActionButton: Bool? = nil,
                             messageButtonAction: (() -> Void)? = nil,
                             showFromBottom: Bool = true,
                             overrideTokens: [NotificationTokenSet.Tokens: ControlTokenValue]? = nil) -> some View {
        self.presentingView(isPresented: isPresented,
                            isBlocking: isBlocking) {
            FluentNotification(style: style,
                               isFlexibleWidthToast: isFlexibleWidthToast,
                               message: message,
                               attributedMessage: attributedMessage,
                               isPresented: isPresented,
                               title: title,
                               attributedTitle: attributedTitle,
                               image: image,
                               trailingImage: trailingImage,
                               trailingImageAccessibilityLabel: trailingImageAccessibilityLabel,
                               actionButtonTitle: actionButtonTitle,
                               actionButtonAction: actionButtonAction,
                               showDefaultDismissActionButton: showDefaultDismissActionButton,
                               messageButtonAction: messageButtonAction,
                               showFromBottom: showFromBottom)
            .overrideTokens(overrideTokens)
        }
    }
}

public extension FluentNotification {
}
