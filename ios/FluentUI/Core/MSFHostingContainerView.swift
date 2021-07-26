//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

@objc open class MSFHostingContainerView: UIView {

    // MARK: - initializers

    internal init(hostedView: AnyView) {
        super.init(frame: .zero)
        let rootView = hostedView

        self.hostingController = UIHostingController(rootView: AnyView(rootView))

        self.embedHostedView()
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    // MARK: - Private helpers

    private var hostingController: UIHostingController<AnyView>!

    private func embedHostedView() {
        guard let hostedView = self.hostingController.view else {
            preconditionFailure("Unable to load hosted SwiftUI view")
        }
        self.addSubview(hostedView)
        hostedView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            hostedView.topAnchor.constraint(equalTo: self.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostedView.leftAnchor.constraint(equalTo: self.leftAnchor),
            hostedView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        self.addConstraints(constraints)
    }
}
