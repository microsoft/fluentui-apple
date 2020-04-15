//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSBooleanCell

/**
 `MSBooleanCell` is used to present a cell with one line of text with an optional custom view and a UISwitch accessory view.

 Use the `isOn` property to update the cell accessory view's `isOn` property.

 Use `onValueChanged` as a callback for an event that changes the value of the accessory view.
 */
open class MSBooleanCell: MSTableViewCell {
    /// Updates the cell accessory view's `isOn` property
    @objc public var isOn: Bool {
        get { return `switch`.isOn }
        set { `switch`.isOn = newValue }
    }

    /// `onValueChanged` is called when the cell accessory view's value has changed
    @objc open var onValueChanged: (() -> Void)?

    private lazy var `switch`: UISwitch = {
        let `switch` = UISwitch()
        FluentUIFramework.initializeUISwitchAppearance(`switch`)
        `switch`.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)
        return `switch`
    }()

    /// Sets up the content of the cell
    ///
    /// - Parameters:
    ///   - title: Text that appears as a single line
    ///   - customView: An optional custom view that appears on the leading edge, adjacent to the start of the `title` text
    ///   - isOn: A boolean value describing the `isOn` state of the accessory view
    @objc open func setup(title: String, customView: UIView? = nil, isOn: Bool = false) {
        setup(title: title, customView: customView, customAccessoryView: `switch`)
        self.isOn = isOn
    }

    @objc private func handleOnSwitchValueChanged() {
        onValueChanged?()
    }
}
