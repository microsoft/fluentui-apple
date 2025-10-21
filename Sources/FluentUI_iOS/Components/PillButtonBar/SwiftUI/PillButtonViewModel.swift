//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// View model object used to create the pill buttons in a `PillButtonBarView`.
@Observable
public final class PillButtonViewModel<Selection: Hashable>: Identifiable {
    /// Determines whether the pill button should show the unread dot.
    public var isUnread: Bool
    /// The leading image icon of the pill button.
    public var leadingImage: Image?
    /// The title of the pill button.
    public let title: String
    /// The unique identifier of this view model.
    public let id = UUID()
    /// The generic selection value of the pill button.
    public let selectionValue: Selection

    /// Initializes a new `PillButtonViewModel`.
    ///
    /// - Parameters:
    ///   - title: The title of the pill button.
    ///   - selectionValue: The generic selection value of the pill button.
    ///   - leadingImage: The leading image of the pill button.
    ///   - isUnread: Determines whether the pill button should show the unread dot.
    public init(title: String,
                selectionValue: Selection,
                leadingImage: Image? = nil,
                isUnread: Bool = false) {
        self.title = title
        self.selectionValue = selectionValue
        self.leadingImage = leadingImage
        self.isUnread = isUnread
    }
}
