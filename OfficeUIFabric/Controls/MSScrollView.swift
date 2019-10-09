//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

protocol ContainerView { }

protocol ScrollableContainerView: class {
    func makeFirstResponderVisible()
}

/// `UIScrollView` subclass that automatically adjusts content insets when keyboard is shown/hidden to make sure scrollable area is always visible. Also provides methods to scroll any subview (or first responder if it's a subview) to visible area.
@available(iOSApplicationExtension, unavailable)
open class MSScrollView: UIScrollView, ScrollableContainerView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    open override var contentSize: CGSize {
        didSet {
            if contentSize != oldValue {
                makeFirstResponderVisible()
            }
        }
    }

    open var internalSubviews: [UIView] {
        var result = [UIView]()
        if let scrollIndicator = horizontalScrollIndicator {
            result.append(scrollIndicator)
        }
        if let scrollIndicator = verticalScrollIndicator {
            result.append(scrollIndicator)
        }
        return result
    }
    var horizontalScrollIndicator: UIView? {
        return value(forKey: "horizontalScrollIndicator") as? UIView
    }
    var verticalScrollIndicator: UIView? {
        return value(forKey: "verticalScrollIndicator") as? UIView
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialize()
    }

    open func makeFirstResponderVisible() {
        if let firstResponder = UIResponder.firstResponder as? UIView, firstResponder.isDescendant(of: self) {
            makeSubviewVisible(firstResponder)
        }
    }

    open func makeSubviewVisible(_ view: UIView) {
        layoutIfNeeded()
        let container = containerForView(view)
        let rect = convert(container.frame, from: container.superview)
        let contentBounds = bounds.inset(by: contentInset)

        contentOffset.y -= max(0, contentBounds.minY - rect.minY)
        contentOffset.y += max(0, rect.maxY - contentBounds.maxY)
    }

    private func containerForView(_ view: UIView) -> UIView {
        var container = view
        repeat {
            if container is ContainerView {
                return container
            }
            container = container.superview!
        } while container != self
        return view
    }

    private var originalBottomContentInset: CGFloat!

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let container = superview else {
            return
        }

        var keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = container.convert(keyboardFrame, from: nil)

        if originalBottomContentInset == nil {
            originalBottomContentInset = contentInset.bottom
        }
        let bottomInset = max(originalBottomContentInset, frame.maxY - keyboardFrame.minY)
        if contentInset.bottom != bottomInset {
            contentInset.bottom = bottomInset
            scrollIndicatorInsets.bottom = bottomInset

            if bottomInset != 0 {
                makeFirstResponderVisible()
            }
        }
    }
}
