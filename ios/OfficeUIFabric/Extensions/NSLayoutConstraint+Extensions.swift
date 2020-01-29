//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension NSLayoutConstraint {
    /// Constrains the view to the provided size
    ///
    /// - Parameters:
    ///   - view: the view to size
    ///   - size: the size for layout
    ///   - activateConstraints: whether to activate the constraints within this function, or to leave them unactivated for the caller to use in a larger activation (more performant)
    /// - Returns: the created constraints, for use in a larger activation. Can be ignored
    @discardableResult
    static func constrain(_ view: UIView, toSize size: CGSize, activateConstraints: Bool) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false

        let identifierHeader = String(describing: type(of: view)) + "_sizing_"

        let widthConstraint = view.widthAnchor.constraint(equalToConstant: size.width)
        widthConstraint.identifier = identifierHeader + "width"

        let heightConstraint = view.heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.identifier = identifierHeader + "height"

        let constraints = [widthConstraint, heightConstraint]

        if activateConstraints {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    /// Autolayout convenience method for matching a subview's layout to its superview
    /// Providing edge insets will shrink the subview as requested
    /// Optionally respects safe area insets of the superview, as desired
    /// Custom insets are additive to the safe area insets (left inset of 8 and safeAreaInsets.left of 8 == total inset of 16 points)
    /// - Parameters:
    ///   - view: the view to be contained, aka the new subview
    ///   - containerView: the view to do the containing, aka the new superview
    ///   - insets: Insets defining layout of the subview in relation to the superview. Provide .zero for a perfect match
    ///   - respectsSafeArea: whether to respect the containerView's safe area insets (iOS 11.0+)
    static func contain(view: UIView, in containerView: UIView, withInsets insets: UIEdgeInsets, respectingSafeAreaInsets respectsSafeArea: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(view)

        let identifierHeader = String(describing: type(of: view))

        let leadingAnchor: NSLayoutXAxisAnchor
        let trailingAnchor: NSLayoutXAxisAnchor
        let topAnchor: NSLayoutYAxisAnchor
        let bottomAnchor: NSLayoutYAxisAnchor

        leadingAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.leadingAnchor : containerView.leadingAnchor
        trailingAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.trailingAnchor : containerView.trailingAnchor
        topAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.topAnchor : containerView.topAnchor
        bottomAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.bottomAnchor : containerView.bottomAnchor

        let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left)
        leading.identifier = identifierHeader + "_containmentLeading"

        let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right * -1.0)
        trailing.identifier = identifierHeader + "_containmentTrailing"

        let top = view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        top.identifier = identifierHeader + "_containmentTop"

        let bottom = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom * -1.0)
        bottom.identifier = identifierHeader + "_containmentBottom"

        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    /// Constrains the provided view at the center of the provided container view
    /// Makes no definitions for the size (w/h) of the provided subview
    ///
    /// - Parameters:
    ///   - view: the view to center
    ///   - containerView: the view to do the containment
    static func center(view: UIView, in containerView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(view)

        NSLayoutConstraint.activate([view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor), view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)])
    }
}
