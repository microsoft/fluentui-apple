//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFCommandBarItemGroup)
public class CommandBarItemGroup: NSObject, ExpressibleByArrayLiteral, Sequence {
    public let items: [CommandBarItem]
    public let label: String?

    /// Initializer for `CommandBarItemGroup`
    /// - Parameters:
    ///   - items: List of `CommandBarItem`s.
    ///   - label: Label to be shown under the `CommandBarItem`s.
    /// - Note: CommandBarItemGroup labels are currently **experimental**.
    @objc public init(_ items: [CommandBarItem], label: String? = nil) {
        self.items = items
        self.label = label
    }

    /// Convenience initializer for `CommandBarItemGroup`
    /// - Parameters:
    ///  - items: List of `CommandBarItem`s.
    ///  - label: Label to be shown under the `CommandBarItem`s.
    ///  - Note: CommandBarItemGroup labels are currently **experimental**.
    /// - Example:
    /// ```
    /// CommandBarItemGroup(commandBarItems[0...3])
    /// ```
    public convenience init(_ items: ArraySlice<CommandBarItem>, label: String? = nil) {
        self.init(Array(items), label: label)
    }

    /// Initializer for `CommandBarItemGroup` using array literal syntax.
    required public init(arrayLiteral elements: CommandBarItem...) {
        self.items = elements
        self.label = nil
    }

    /// Sequence protocol conformance. This allows `CommandBarItemGroup` to be used in a for-in loop.
    public func makeIterator() -> IndexingIterator<[CommandBarItem]> {
        return items.makeIterator()
    }

    /// Subscript operator for `CommandBarItemGroup`. This allows you to access `CommandBarItem`s with [].
    public subscript(index: Int) -> CommandBarItem {
        return items[index]
    }
}
