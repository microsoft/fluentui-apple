//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import SwiftUI

/// Common wrapper for hosting and exposing SwiftUI components to UIKit-based clients.
open class ControlHostingView: NSView {

	/// The intrinsic content size of the wrapped SwiftUI view.
	@objc public override var intrinsicContentSize: CGSize {
		// Our desired size should always be the same as our hosted view.
		return hostingView.intrinsicContentSize
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
		hostingView = NSHostingView.init(rootView: controlView)
		if #available(macOS 13.3, *) {
			hostingView.sizingOptions = [.intrinsicContentSize]
			hostingView.safeAreaRegions = safeAreaRegions
		}

		super.init(frame: .zero)

		self.configureHostedView()
	}

	required public init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	let hostingView: NSHostingView<AnyView>

	/// Adds `hostingController.view` to ourselves as a subview, and enables necessary constraints.
	private func configureHostedView() {
		hostingView.layer?.backgroundColor = NSColor.clear.cgColor

		addSubview(hostingView)
		hostingView.translatesAutoresizingMaskIntoConstraints = false

		let requiredConstraints = [
			hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
			hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
			hostingView.bottomAnchor.constraint(equalTo: bottomAnchor),
			hostingView.topAnchor.constraint(equalTo: topAnchor)
		]
		self.addConstraints(requiredConstraints)
	}
}
