//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {

    /// Presents a Notification on top of the modified View.
    /// - Parameters:
    ///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
    ///   - message: Text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - isBlocking: Whether the interaction with the view will be blocked while the Notification is being presented.
    ///   - isPresented: Controls whether the Notification is being presented.
    ///   - title: Optional text to draw above the message area.
    ///   - image: Optional icon to draw at the leading edge of the control.
    ///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
    ///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    ///   - dismissAction: Action to be dispatched when dismissing toast/bar notification.
    /// - Returns: The modified view with the capability of presenting a Notification.
    func presentNotification(style: MSFNotificationStyle,
                             message: String,
                             isBlocking: Bool = true,
                             isPresented: Binding<Bool>,
                             title: String = "",
                             image: UIImage? = nil,
                             actionButtonTitle: String = "",
                             actionButtonAction: (() -> Void)? = nil,
                             messageButtonAction: (() -> Void)? = nil,
                             dismissAction: (() -> Void)? = nil) -> some View {
        self.presentingView(isPresented: isPresented,
                            isBlocking: isBlocking) {
            NotificationViewSwiftUI(style: style,
                                    message: message,
                                    isPresented: isPresented,
                                    title: title,
                                    image: image,
                                    actionButtonTitle: actionButtonTitle,
                                    actionButtonAction: actionButtonAction,
                                    messageButtonAction: messageButtonAction,
                                    dismissAction: dismissAction)
        }
    }
}
