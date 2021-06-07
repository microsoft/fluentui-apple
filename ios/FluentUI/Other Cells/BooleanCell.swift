//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BooleanCell

@available(*, deprecated, renamed: "BooleanCell")
public typealias MSBooleanCell = BooleanCell

/**
 `BooleanCell` is used to present a cell with one line of text with an optional custom view and a UISwitch accessory view.

 Use the `isOn` property to update the cell accessory view's `isOn` property.

 Use the `isSwitchEnabled` property to update the cell accessory view's `isEnabled` property.

 Use `onValueChanged` as a callback for an event that changes the value of the accessory view.
 */
@objc(MSFBooleanCell)
open class BooleanCell: TableViewCell {
    /// Updates the cell accessory view's `isOn` property
    @objc public var isOn: Bool {
        get { return `switch`.isOn }
        set { `switch`.isOn = newValue }
    }

    /// Updates the cell accessory view's `isEnabled` property
    @objc public var isSwitchEnabled: Bool {
      get {
        return `switch`.isEnabled && isEnabled
      }
      set {
        `switch`.isEnabled = newValue
        updateAccessibility()
      }
    }

    @objc open override var isEnabled: Bool {
        didSet {
            updateAccessibility()
        }
    }

    /// `onValueChanged` is called when the cell accessory view's value has changed
    @objc open var onValueChanged: (() -> Void)?

    private lazy var `switch`: UISwitch = {
        let `switch` = UISwitch()
        `switch`.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)
        return `switch`
    }()

    @objc public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateAccessibility()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateAccessibility()
    }

    /// Sets up the content of the cell
    ///
    /// - Parameters:
    ///   - title: Text that appears as a single line
    ///   - customView: An optional custom view that appears on the leading edge, adjacent to the start of the `title` text
    ///   - isOn: A boolean value describing the `isOn` state of the accessory view
    @objc open func setup(title: String, customView: UIView? = nil, isOn: Bool = false) {
        setup(title: title, customView: customView, isOn: isOn, isSwitchEnabled: true)
    }

    /// Sets up the content of the cell
    ///
    /// - Parameters:
    ///   - title: Text that appears as a single line
    ///   - customView: An optional custom view that appears on the leading edge, adjacent to the start of the `title` text
    ///   - isOn: A boolean value describing the `isOn` state of the accessory view
    ///   - isSwitchEnabled: A boolean value describing the `isEnabled` state of the accessory view
    @objc open func setup(title: String, customView: UIView? = nil, isOn: Bool = false, isSwitchEnabled: Bool = true) {
        setup(title: title, customView: customView, customAccessoryView: `switch`)
        self.isOn = isOn
        self.isSwitchEnabled = isSwitchEnabled
    }

    @objc private func handleOnSwitchValueChanged() {
        onValueChanged?()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = window {
            `switch`.onTintColor = Colors.primary(for: window)
        }
    }

    private func updateAccessibility() {
        if isEnabled && isSwitchEnabled {
            accessibilityTraits.remove(.notEnabled)
        } else {
            accessibilityTraits.insert(.notEnabled)
        }
    }
}
