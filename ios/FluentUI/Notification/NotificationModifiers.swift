//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Presents a Notification on top of the modified View.
    /// - Parameters:
    ///   - notification: The `FluentNotification` instance to present.
    /// - Returns: The modified view with the capability of presenting a Notification.
    func presentNotification(isPresented: Binding<Bool>,
                             isBlocking: Bool = true,
                             @ViewBuilder notification: @escaping () -> FluentNotification) -> some View {
        self.presentingView(isPresented: isPresented,
                            isBlocking: isBlocking) {
            notification()
        }
    }
}

public extension FluentNotification {
    /// An optional gradient to use as the background of the notification.
    ///
    /// If this property is nil, then this notification will use the background color defined by its design tokens.
    func backgroundGradient(_ gradientInfo: GradientInfo?) -> FluentNotification {
        state.backgroundGradient = gradientInfo
        return self
    }
}
