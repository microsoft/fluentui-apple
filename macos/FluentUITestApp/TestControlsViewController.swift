//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

fileprivate struct Constants {
	static let previousSelectionIndexUserDefaultsKey = "FluentUITestApp.previousSelectionIndexUserDefaultsKey"
	static let rowHeight: CGFloat = 44.0
	static let textFieldLeadingPadding: CGFloat = 5.0
	private init() {}
}

/// Master-detail view controller to implement a playground for testing various controls.
/// To add a control, add it and the type of its NSViewController to "controls"
class TestControlsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
	private let controls: [(title: String, type: NSViewController.Type)] = [
							("FluentUI-macOS (placeholder)", TestPlaceholderViewController.self),
							("Avatar View", TestAvatarViewController.self),
							("Button", TestButtonViewController.self),
							("Date Picker", TestDatePickerController.self),
							("Link", TestLinkViewController.self)
	]
	
	override func loadView() {
		controlListView.usesAlternatingRowBackgroundColors = true
		controlListView.dataSource = self
		controlListView.delegate = self
		controlListView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Column")))
		controlListView.translatesAutoresizingMaskIntoConstraints = false
		controlListView.rowHeight = Constants.rowHeight

		view = masterView

		controlDetailViewController = TestPlaceholderViewController(nibName: nil, bundle: nil)
		
		NSLayoutConstraint.activate([controlListView.widthAnchor.constraint(equalToConstant: 200)])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let standardUserDefaults = UserDefaults.standard
		let previouslySelectedRowIndex = standardUserDefaults.integer(forKey: Constants.previousSelectionIndexUserDefaultsKey)
		if controlListView.numberOfRows > previouslySelectedRowIndex {
			controlListView.selectRowIndexes(IndexSet(integer: previouslySelectedRowIndex), byExtendingSelection: false)
		} else {
			// Selected row index information is invalid, remove it
			standardUserDefaults.removeObject(forKey: Constants.previousSelectionIndexUserDefaultsKey)
		}
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
		return controls.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let textField = NSTextField(labelWithString: controls[row].title)
		textField.translatesAutoresizingMaskIntoConstraints = false
		let view = NSView(frame: .zero)
		view.addSubview(textField)
		NSLayoutConstraint.activate([textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeadingPadding),
									 textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
									 textField.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
		
		return view
	}
	
	func tableViewSelectionDidChange(_ notification: Notification) {
		controlDetailViewController = controls[controlListView.selectedRow].type.init(nibName: nil, bundle: nil)
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
				masterView.addArrangedSubview(controlDetailView)
				NSLayoutConstraint.activate([controlDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
			}
		}
	}
	
	private let controlListView = NSTableView(frame: .zero)
	
	private lazy var masterView: NSStackView = {
		let dividerView = NSView(frame: .zero)
		dividerView.wantsLayer = true
		dividerView.layer?.backgroundColor = NSColor.systemGray.cgColor
		dividerView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
		let masterView = NSStackView(views: [self.controlListView, dividerView])
		masterView.alignment = .top
		masterView.distribution = .fill
		masterView.spacing = 0.0
		return masterView
	}()
}
