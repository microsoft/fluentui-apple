//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

public struct TestViewController: Identifiable {
	public let id = UUID()
	public let title: String
	public let type: NSViewController.Type
}

public let testViewControllers = [TestViewController(title: "Avatar View",
													 type: TestAvatarViewController.self),
								  TestViewController(title: "Badge View",
													 type: TestBadgeViewController.self),
								  TestViewController(title: "Button",
													 type: TestButtonViewController.self),
								  TestViewController(title: "Color",
													 type: TestColorViewController.self),
								  TestViewController(title: "Date Picker",
													 type: TestDatePickerController.self),
								  TestViewController(title: "FilledTemplateImage",
													 type: TestFilledTemplateImageViewController.self),
								  TestViewController(title: "Link",
													 type: TestLinkViewController.self),
								  TestViewController(title: "Multiline Pill Picker",
													 type: TestMultilinePillPickerViewController.self),
								  TestViewController(title: "Notification Bar View",
													 type: TestNotificationBarViewController.self),
								  TestViewController(title: "Separator",
													 type: TestSeparatorViewController.self),
								  TestViewController(title: "Typography",
													 type: TestTypographyViewController.self)]
