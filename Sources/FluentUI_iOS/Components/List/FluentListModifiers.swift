//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension FluentList {
    /// The list style type for the `FluentList`.
    /// - Parameter listStyle: Type of style to display the list with.
    /// - Returns: The modified `FluentList` with the style property set.
    func fluentListStyle(_ listStyle: FluentListStyle) -> FluentList {
        var list = self
        list.listStyle = listStyle
        return list
    }
}
