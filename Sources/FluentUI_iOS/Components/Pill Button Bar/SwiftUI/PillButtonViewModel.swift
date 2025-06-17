//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public class PillButtonViewModel: ObservableObject {
    @Published public var isUnread: Bool
    public let title: String

    public init(isUnread: Bool, title: String) {
        self.isUnread = isUnread
        self.title = title
    }
}
