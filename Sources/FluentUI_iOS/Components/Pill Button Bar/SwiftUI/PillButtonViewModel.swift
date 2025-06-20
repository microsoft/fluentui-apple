//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// View model object used to create a `PillButtonView`.
public class PillButtonViewModel: ObservableObject {
    /// Determines whether the pill button should show the unread dot.
    @Published public var isUnread: Bool
    /// The leading image icon of the pill button.
    @Published public var leadingImage: Image?
    /// The title of the pill button.
    public let title: String

    /// Initializes a new `PillButtonViewModel`.
    ///
    /// - Parameters:
    ///   - title: The title of the pill button.
    ///   - leadingImage: The leading image icon of the pill button.
    ///   - isUnread: Determines whether the pill button should show the unread dot.
    public init(title: String,
                leadingImage: Image? = nil,
                isUnread: Bool = false) {
        self.title = title
        self.leadingImage = leadingImage
        self.isUnread = isUnread
    }
}
