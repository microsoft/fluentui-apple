//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public typealias ListItemAccessoryType = TableViewCellAccessoryType
public typealias ListItemBackgroundStyleType = TableViewCellBackgroundStyleType
public typealias ListItemLeadingContentSize = MSFTableViewCellCustomViewSize
public typealias ListItemTokenSet = TableViewCellTokenSet
public typealias ListItemToken = TableViewCellToken

extension ListItemTokenSet {
    /// The background color of `List` based on the style.
    /// - Parameter backgroundStyle: The background style of the `List`.
    /// - Returns: The color to use for the background of `List`.
    public static func listBackgroundColor(for backgroundStyle: ListItemBackgroundStyleType) -> Color {
        let tokenSet = ListItemTokenSet(customViewSize: { .default })
        switch backgroundStyle {
        case .grouped:
            return Color(uiColor: tokenSet[.backgroundGroupedColor].uiColor)
        case .plain:
            return Color(uiColor: tokenSet[.backgroundColor].uiColor)
        case .clear, .custom:
            return .clear
        }
    }

    /// The background color of `ListItem` based on the style.
    /// - Parameter backgroundStyle: The background style of the `List`.
    /// - Returns: The color to use for the background of `ListItem`.
    public static func listItemBackgroundColor(for backgroundStyle: ListItemBackgroundStyleType) -> Color {
        let tokenSet = ListItemTokenSet(customViewSize: { .default })
        switch backgroundStyle {
        case .grouped:
            return Color(uiColor: tokenSet[.cellBackgroundGroupedColor].uiColor)
        case .plain:
            return Color(uiColor: tokenSet[.cellBackgroundColor].uiColor)
        case .clear, .custom:
            return .clear
        }
    }
}
