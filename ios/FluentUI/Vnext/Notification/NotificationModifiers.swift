//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Presents a Notification on top of the modified View.
    /// - Parameters:
    ///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
    ///   - message: Optional text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - attributedMessage: Optional attributed text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - isBlocking: Whether the interaction with the view will be blocked while the Notification is being presented.
    ///   - isPresented: Controls whether the Notification is being presented.
    ///   - title: Optional text to draw above the message area.
    ///   - attributedTitle: Optional attributed text to draw above the message area.
    ///   - image: Optional icon to draw at the leading edge of the control.
    ///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
    ///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    /// - Returns: The modified view with the capability of presenting a Notification.
    func presentNotification(style: MSFNotificationStyle,
                             message: String? = nil,
                             attributedMessage: NSAttributedString? = nil,
                             isBlocking: Bool = true,
                             isPresented: Binding<Bool>,
                             title: String? = nil,
                             attributedTitle: NSAttributedString? = nil,
                             image: UIImage? = nil,
                             actionButtonTitle: String? = nil,
                             actionButtonAction: (() -> Void)? = nil,
                             messageButtonAction: (() -> Void)? = nil,
                             dismissAction: (() -> Void)? = nil) -> some View {
        self.presentingView(isPresented: isPresented,
                            isBlocking: isBlocking) {
            FluentNotification(style: style,
                               message: message,
                               attributedMessage: attributedMessage,
                               isPresented: isPresented,
                               title: title,
                               attributedTitle: attributedTitle,
                               image: image,
                               actionButtonTitle: actionButtonTitle,
                               actionButtonAction: actionButtonAction,
                               messageButtonAction: messageButtonAction)
        }
    }
}

public extension FluentNotification {
    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: NotificationTokens?) -> FluentNotification {
        state.overrideTokens = tokens
        return self
    }
}
