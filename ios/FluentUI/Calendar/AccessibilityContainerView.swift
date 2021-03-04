//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// This is a container that forwards the calls to the tableview to create an adjustable picker.
/// Making the tableView adjustable directly does not work. Tableviews and cells have a weird way of working with accessibility
class AccessibilityContainerView: UIView {
    private weak var delegate: AccessibleViewDelegate?

    init(delegate: AccessibleViewDelegate) {
        self.delegate = delegate

        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override var isAccessibilityElement: Bool { get { return true } set { } }

    override var accessibilityTraits: UIAccessibilityTraits { get { return .adjustable } set { } }

    override var accessibilityLabel: String? { get { return delegate?.accessibilityLabelForAccessibleView?(self) } set { } }

    override var accessibilityValue: String? { get { return delegate?.accessibilityValueForAccessibleView?(self) } set { } }

    override func accessibilityIncrement() {
        delegate?.accessibilityIncrementForAccessibleView?(self)
    }

    override func accessibilityDecrement() {
        delegate?.accessibilityDecrementForAccessibleView?(self)
    }
}
