//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI
import UIKit

/// Common wrapper for hosting and exposing SwiftUI components to UIKit-based clients.
open class ControlHostingView: UIView {

    /// The intrinsic content size of the wrapped SwiftUI view.
    @objc public override var intrinsicContentSize: CGSize {
        guard let hostedView = hostingController.view else {
            return super.intrinsicContentSize
        }

        // Our desired size should always be the same as our hosted view.
        return hostedView.intrinsicContentSize
    }

    /// Asks the view to calculate and return the size that best fits the specified size.
    @objc public override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let hostedView = hostingController.view else {
            return super.sizeThatFits(size)
        }

        // Our desired size should always be the same as our hosted view.
        return hostedView.sizeThatFits(size)
    }

    /// Initializes and returns an instance of `ControlHostingContainer` that wraps `controlView`.
    ///
    /// Unfortunately this class can't use Swift generics, which are incompatible with Objective-C interop. Instead we have to wrap
    /// the control view in an `AnyView.`
    ///
    /// - Parameter controlView: An `AnyView`-wrapped component to host.
    /// - Parameter safeAreaRegions: Passthrough to the respective property on UIHostingController.
    /// Indicates which safe area regions the underlying hosting controller should add to its view.
    public init(_ controlView: AnyView, safeAreaRegions: SafeAreaRegions = .all) {
        hostingController = FluentThemedHostingController.init(rootView: controlView)
        hostingController.sizingOptions = [.intrinsicContentSize]
        hostingController.safeAreaRegions = safeAreaRegions

        super.init(frame: .zero)

        self.configureHostedView()
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Adds `hostingController.view` to ourselves as a subview, and enables necessary constraints.
    private func configureHostedView() {
        guard let hostedView = hostingController.view else {
            return
        }
        hostedView.backgroundColor = UIColor.clear

        addSubview(hostedView)
        hostedView.translatesAutoresizingMaskIntoConstraints = false

        let requiredConstraints = [
            hostedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostedView.topAnchor.constraint(equalTo: topAnchor)
        ]
        self.addConstraints(requiredConstraints)
    }

    private let hostingController: FluentThemedHostingController
}
