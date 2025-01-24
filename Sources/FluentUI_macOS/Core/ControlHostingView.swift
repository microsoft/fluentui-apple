//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import SwiftUI

/// Common wrapper for hosting and exposing SwiftUI components to AppKit-based clients.
open class ControlHostingView: NSHostingView<AnyView> {
	/// Initializes and returns an instance of `ControlHostingContainer` that wraps `controlView`.
	///
	/// Unfortunately this class can't use Swift generics, which are incompatible with Objective-C interop. Instead we have to wrap
	/// the control view in an `AnyView.`
	///
	/// - Parameter controlView: An `AnyView`-wrapped component to host.
	/// - Parameter safeAreaRegions: Passthrough to the respective property on NSHostingView.
	/// Indicates which safe area regions the underlying hosting controller should add to its view.
	public init(_ controlView: AnyView, safeAreaRegions: SafeAreaRegions = .all) {
		super.init(rootView: controlView)
		if #available(macOS 13.3, *) {
			self.sizingOptions = [.intrinsicContentSize]
			self.safeAreaRegions = safeAreaRegions
		}

		layer?.backgroundColor = .clear
		translatesAutoresizingMaskIntoConstraints = false
	}

	@MainActor @preconcurrency required public init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	@MainActor @preconcurrency required public init(rootView: AnyView) {
		preconditionFailure("init(rootView:) has not been implemented")
	}
}
