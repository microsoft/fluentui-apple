//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct FluentListSectionFooter<Description: StringProtocol>: View {

    // MARK: Initializer

    /// Creates a `FluentListSectionFooter`
    /// - Parameters:
    ///   - description: description of the section to be shown in the footer.
    public init(description: Description) {
        self.description = description
    }

    public var body: some View {
        Text(description)
            .textCase(nil)
    }

    // MARK: Private variables

    private let description: Description
}
