//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

public struct TestViewController: Identifiable {
	public let id: String
	public let type: NSViewController.Type
}

public let testViewControllers = [TestViewController(id: "Avatar View",
													 type: TestAvatarViewController.self),
								  TestViewController(id: "Button",
													 type: TestButtonViewController.self),
								  TestViewController(id: "Date Picker",
													 type: TestDatePickerController.self),
								  TestViewController(id: "Link",
													 type: TestLinkViewController.self),
								  TestViewController(id: "Separator",
													 type: TestSeparatorViewController.self)]
