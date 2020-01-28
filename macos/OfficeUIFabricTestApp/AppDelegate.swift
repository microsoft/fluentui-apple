//
// Copyright Microsoft Corporation
//

import AppKit
fileprivate struct Constants {
	private init() {}
	static let initialWindowWidth: CGFloat = 800
	static let initialWindowHeight: CGFloat = 600
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationWillFinishLaunching(_ notification: Notification) {
		let window = NSWindow(contentViewController: TestControlsViewController(nibName: nil, bundle: nil))
		window.autorecalculatesKeyViewLoop = true
		window.title = "Fabric macOS"
		window.setFrame(.init(origin: .zero, size: .init(width: Constants.initialWindowWidth, height: Constants.initialWindowHeight)), display: true)
		window.center()
		window.makeKeyAndOrderFront(nil)
	}
}

