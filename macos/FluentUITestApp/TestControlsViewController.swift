//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUITestViewControllers

private struct Constants {
	static let previousSelectionIndexUserDefaultsKey: String = "FluentUITestApp.previousSelectionIndexUserDefaultsKey"
	static let rowHeight: CGFloat = 44.0
	static let textFieldLeadingPadding: CGFloat = 5.0
	private init() {}
}

/// Master-detail view controller to implement a playground for testing various controls.
/// To add a control, add it and the type of its NSViewController to "controls"
class TestControlsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	override func loadView() {
		controlListView.usesAlternatingRowBackgroundColors = true
		controlListView.dataSource = self
		controlListView.delegate = self
		controlListView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Column")))
		controlListView.translatesAutoresizingMaskIntoConstraints = false
		controlListView.rowHeight = Constants.rowHeight

		view = stackView
		let standardUserDefaults = UserDefaults.standard
		if let previousSelection = standardUserDefaults.object(forKey: Constants.previousSelectionIndexUserDefaultsKey) {
			if let previousSelectedIndex = previousSelection as? NSNumber,
			   controlListView.numberOfRows > previousSelectedIndex.intValue {
				controlListView.selectRowIndexes(IndexSet(integer: previousSelectedIndex.intValue), byExtendingSelection: false)
			} else {
				// Selected row index information is invalid, remove it
				standardUserDefaults.removeObject(forKey: Constants.previousSelectionIndexUserDefaultsKey)
			}
		}

		NSLayoutConstraint.activate([controlListView.widthAnchor.constraint(equalToConstant: 200)])
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
		return testViewControllers.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let textField = NSTextField(labelWithString: testViewControllers[row].title)
		textField.translatesAutoresizingMaskIntoConstraints = false
		let view = NSView(frame: .zero)
		view.addSubview(textField)
		NSLayoutConstraint.activate([textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeadingPadding),
									 textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
									 textField.centerYAnchor.constraint(equalTo: view.centerYAnchor)])

		return view
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
		controlDetailViewController = testViewControllers[controlListView.selectedRow].type.init(nibName: nil, bundle: nil)
		UserDefaults.standard.set(controlListView.selectedRow, forKey: Constants.previousSelectionIndexUserDefaultsKey)
	}

	private var controlDetailViewController: NSViewController? {
		didSet {
			guard oldValue != controlDetailViewController else {
				return
			}
			oldValue?.removeFromParent()
			oldValue?.view.removeFromSuperview()

			if let controlDetailViewController = controlDetailViewController {
				addChild(controlDetailViewController)
				let controlDetailView = controlDetailViewController.view
				stackView.addArrangedSubview(controlDetailView)
				NSLayoutConstraint.activate([controlDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
			}
		}
	}

	private let controlListView = NSTableView(frame: .zero)

	private lazy var stackView: NSStackView = {
		let dividerView = NSView(frame: .zero)
		dividerView.wantsLayer = true
		dividerView.layer?.backgroundColor = NSColor.systemGray.cgColor
		dividerView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
		let stackView = NSStackView(views: [self.controlListView, dividerView])
		stackView.alignment = .top
		stackView.distribution = .fill
		stackView.spacing = 0.0
		return stackView
	}()
}
