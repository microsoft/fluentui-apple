//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestDatePickerController: NSViewController {
	
	override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		let calendar = Calendar.current
		let date = calendar.date(from: DateComponents(year: 2019, month: 12, day: 9))
		
		datePickerController = DatePickerController(date: date, calendar: calendar, style: .dateTime)
		menuDatePickerController = DatePickerController(date: date, calendar: calendar, style: .dateTime)
		
		datePickerController?.delegate = self
		menuDatePickerController?.delegate = self
		
		datePickerController?.hasEdgePadding = true
		menuDatePickerController?.hasEdgePadding = true
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		preconditionFailure()
	}
	
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		containerView.translatesAutoresizingMaskIntoConstraints = false
		
		let horizontalStack = NSStackView(frame: .zero)
		horizontalStack.orientation = .horizontal
		horizontalStack.distribution = .equalSpacing
		horizontalStack.translatesAutoresizingMaskIntoConstraints = false
		horizontalStack.spacing = 20
		
		containerView.addView(horizontalStack, in: .center)
		
		// Standalone datepicker
		let vfxView = NSVisualEffectView()
		vfxView.translatesAutoresizingMaskIntoConstraints = false
		vfxView.wantsLayer = true
		vfxView.layer?.cornerRadius = 5
		
		horizontalStack.addView(vfxView, in: .center)
		if let controller = datePickerController {
			vfxView.addSubview(controller.view)

			NSLayoutConstraint.activate([
				vfxView.topAnchor.constraint(equalTo: controller.view.topAnchor),
				vfxView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
				vfxView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
				vfxView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
			])
		}
		
		// Menu datepicker
		let menuLabel = NSTextField(labelWithString: "Different presentations:")
		let menuButton = NSPopUpButton(title: "TEST", target: nil, action: nil)
		
		let popoverButton = NSButton(title: "NSPopover", target: self, action: #selector(showPopover))
		
		menuButton.pullsDown = true
		let menu = NSMenu()
		datePickerMenuItem = NSMenuItem(title: "NSMenu", action: nil, keyEquivalent: "")
		
		if let controller = menuDatePickerController, let menuItem = datePickerMenuItem {
			menuItem.view = NSView(frame: NSRect(origin: .zero, size: controller.view.fittingSize))
			menuItem.view?.addSubview(controller.view)
			menu.addItem(menuItem)
		}
		menuButton.menu = menu
		
		// Label and buttons for setting and clearing a custom color
		let customColorLabel = NSTextField(labelWithString: "Custom selection color:")
		let colorPickerButton = NSButton(title: "Launch Color Picker", target: self, action: #selector(launchColorPicker))
		let clearCustomColorButton = NSButton(title: "Clear custom color", target: self, action: #selector(clearCustomColor))
		
		let flagsLabel = NSTextField(labelWithString: "Flags:")
		
		// Checkbox to toggle chinese secondaryCalendar
		let secondaryCalendarButton = NSButton(title: "secondaryCalendar", target: self, action: #selector(toggleSecondaryCalendar))
		secondaryCalendarButton.setButtonType(.switch)
		
		// Checkbox to toggle autoSelectWhenPaging
		let autoSelectButton = NSButton(title: "autoSelectWhenPaging", target: self, action: #selector(toggleAutoSelection))
		autoSelectButton.state = .on
		autoSelectButton.setButtonType(.switch)
		
		// Checkbox to toggle padding
		let paddingButton = NSButton(title: "hasEdgePadding", target: self, action: #selector(toggleEdgePadding))
		paddingButton.state = .on
		paddingButton.setButtonType(.switch)
		
		// Checkbox to toggle text date picker
		let textPickerButton = NSButton(title: "hasTextField", target: self, action: #selector(toggleTextDatePicker))
		textPickerButton.state = .on
		textPickerButton.setButtonType(.switch)
		
		let emptyCell = NSGridCell.emptyContentView
		let gridView = NSGridView(views: [
			[menuLabel, menuButton],
			[emptyCell, popoverButton],
			[customColorLabel, emptyCell],
			[emptyCell, colorPickerButton],
			[emptyCell, clearCustomColorButton],
			[flagsLabel, emptyCell],
			[emptyCell, secondaryCalendarButton],
			[emptyCell, autoSelectButton],
			[emptyCell, paddingButton],
			[emptyCell, textPickerButton]
		])
		gridView.column(at: 0).xPlacement = .trailing
		gridView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		gridView.setContentHuggingPriority(.defaultLow, for: .horizontal)
		gridView.rowAlignment = .firstBaseline
		
		horizontalStack.addView(gridView, in: .center)
		
		// Delegate messages
		let delegateMessagesLabel = NSTextField(labelWithString: "Selected dates from delegate:")
		let delegateMessagesScrollView = NSScrollView()
		delegateMessagesScrollView.documentView = delegateMessagesTextView
		
		[delegateMessagesLabel, delegateMessagesScrollView].forEach {
			containerView.addView($0, in: .bottom)
		}
		
		NSLayoutConstraint.activate([
			delegateMessagesScrollView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0),
			delegateMessagesScrollView.heightAnchor.constraint(equalToConstant: 100),
			delegateMessagesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
			
			horizontalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
			horizontalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			horizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
		])
		view = containerView
	}
	
	@objc func clearCustomColor() {
		datePickerController?.customSelectionColor = nil
		menuDatePickerController?.customSelectionColor = nil
	}
	
	@objc func launchColorPicker() {
		let panel = NSColorPanel.shared
		panel.setTarget(self)
		panel.setAction(#selector(changeColor(_:)))
		panel.makeKeyAndOrderFront(nil)
	}
	
	@objc func toggleSecondaryCalendar() {
		if datePickerController?.secondaryCalendar == nil {
			datePickerController?.secondaryCalendar = chineseLunarCalendar
		} else {
			datePickerController?.secondaryCalendar = nil
		}
		
		if menuDatePickerController?.secondaryCalendar == nil {
			menuDatePickerController?.secondaryCalendar = chineseLunarCalendar
		} else {
			menuDatePickerController?.secondaryCalendar = nil
		}
	}
	
	@objc func toggleAutoSelection(_ sender: NSButton) {
		let enabled = sender.state == .on
		datePickerController?.autoSelectWhenPaging = enabled
		menuDatePickerController?.autoSelectWhenPaging = enabled
	}
	
	@objc func toggleEdgePadding(_ sender: NSButton) {
		let enabled = sender.state == .on
		datePickerController?.hasEdgePadding = enabled
		menuDatePickerController?.hasEdgePadding = enabled
		datePickerMenuItem?.view?.frame.size = menuDatePickerController?.view.fittingSize ?? .zero
	}
	
	@objc func toggleTextDatePicker(_ sender: NSButton) {
		let enabled = sender.state == .on
		datePickerController?.hasTextField = enabled
		menuDatePickerController?.hasTextField = enabled
		datePickerMenuItem?.view?.frame.size = menuDatePickerController?.view.fittingSize ?? .zero
	}
	
	@objc func showPopover(_ sender: NSButton) {
		let popover = NSPopover()
		popover.behavior = .transient
		
		let controller = DatePickerController(date: nil, calendar: nil, style: .dateTime)
		controller.hasTextField = false
		controller.hasEdgePadding = true

		popover.contentViewController = controller
		popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
	}
	
	@objc func changeColor(_ sender: NSColorPanel?) {
		datePickerController?.customSelectionColor = sender?.color
		menuDatePickerController?.customSelectionColor = sender?.color
	}
	
	private let chineseLunarCalendar: Calendar = {
		var calendar = Calendar.init(identifier: .chinese)
		calendar.locale = Locale(identifier: "zh")
		
		return calendar
	}()
	
	private var datePickerController: DatePickerController?
	private var menuDatePickerController: DatePickerController?
	private var datePickerMenuItem: NSMenuItem?
		
	private let delegateMessagesTextView: NSTextView = {
		let textView = NSTextView()
		textView.isEditable = false
		textView.isSelectable = true
		textView.maxSize = NSSize(width: CGFloat(Float.greatestFiniteMagnitude), height: CGFloat(Float.greatestFiniteMagnitude))
		textView.autoresizingMask = .width
		textView.drawsBackground = false
		textView.isVerticallyResizable = true
		
		return textView
	}()
}

extension TestDatePickerController: DatePickerControllerDelegate {
	func datePickerController(_ controller : DatePickerController, didSelectDate date : Date) {
		delegateMessagesTextView.string += "\(date)\n"
		delegateMessagesTextView.scrollToEndOfDocument(nil)
	}
}
