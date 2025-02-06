//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUITestViewControllers
import SwiftUI

struct TestViewControllerWrappingView: NSViewControllerRepresentable {

	var type: NSViewController.Type

	func makeNSViewController(context: Context) -> some NSViewController {
		return type.init(nibName: nil, bundle: nil)
	}

	func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
		// Required protocol method, but can be empty since we don't ever need to
		// update the wrapped view controller from SwiftUI after creating it
	}
}
