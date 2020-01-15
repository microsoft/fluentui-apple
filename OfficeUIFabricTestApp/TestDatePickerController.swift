//
// Copyright Microsoft Corporation
//

import AppKit
import OfficeUIFabric

class TestDatePickerController: NSViewController {
	
	var datePickerController: DatePickerController?
	var menuDatePickerController: DatePickerController?
	
	let delegateMessagesTextView: NSTextView = {
		let textView = NSTextView()
		textView.isEditable = false
		textView.isSelectable = true
		textView.maxSize = NSSize(width: CGFloat(Float.greatestFiniteMagnitude), height: CGFloat(Float.greatestFiniteMagnitude))
		textView.autoresizingMask = .width
		textView.drawsBackground = false
		textView.isVerticallyResizable = true
		
		return textView
	}()
		
	override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		let calendar = Calendar.current
		
		datePickerController = DatePickerController(date: Date(), calendar: calendar, style: .dateTime)
		menuDatePickerController = DatePickerController(date: Date(), calendar: calendar, style: .dateTime)
		
		datePickerController?.delegate = self
		menuDatePickerController?.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		containerView.translatesAutoresizingMaskIntoConstraints = false
		
		// Standalone datepicker
		let vfxView = NSVisualEffectView()
		vfxView.translatesAutoresizingMaskIntoConstraints = false
		vfxView.wantsLayer = true
		vfxView.layer?.cornerRadius = 5
		vfxView.widthAnchor.constraint(equalToConstant: 270).isActive = true
		vfxView.heightAnchor.constraint(equalToConstant: 330).isActive = true
		
		containerView.addView(vfxView, in: .center)
		if let controller = datePickerController {
			vfxView.addSubview(controller.view)
			
			vfxView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
			vfxView.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
		}
		
		// Menu datepicker
		let menuButton = NSPopUpButton(title: "TEST", target: nil, action: nil)
		
		menuButton.pullsDown = true
		let menu = NSMenu()
		let menuItem = NSMenuItem(title: "Date Picker in a menu", action: nil, keyEquivalent: "")
		
		menuItem.view = NSView(frame: NSRect(x: 0, y: 0, width: 270, height: 330))
		
		if let controller = menuDatePickerController {
			menuItem.view?.addSubview(controller.view)
			menuItem.view?.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
			menuItem.view?.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
		}
		
		menu.addItem(menuItem)
		menuButton.menu = menu
		
		// Buttons for setting and clearing a custom color
		let colorPickerButton = NSButton(title: "Launch Color Picker", target: self, action: #selector(launchColorPicker))
		let clearCustomColorButton = NSButton(title: "Clear custom color", target: self, action: #selector(clearCustomColor))
		
		// Checkbox to toggle chinese secondaryCalendar
		let secondaryCalendarButton = NSButton(title: "secondaryCalendar", target: self, action: #selector(toggleSecondaryCalendar))
		secondaryCalendarButton.setButtonType(.switch)
		
		// Checkbox to toggle autoSelectWhenPaging
		let autoSelectButton = NSButton(title: "autoSelectWhenPaging", target: self, action: #selector(toggleAutoSelection))
		autoSelectButton.state = .on
		autoSelectButton.setButtonType(.switch)
		
		let checkBoxStack = NSStackView(views: [secondaryCalendarButton, autoSelectButton])
		checkBoxStack.orientation = .horizontal
		
		[menuButton, colorPickerButton, clearCustomColorButton, checkBoxStack].forEach {
			containerView.addView($0, in: .center)
		}
		
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
			delegateMessagesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0)
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
	
	@objc func changeColor(_ sender: NSColorPanel?) {
		datePickerController?.customSelectionColor = sender?.color
		menuDatePickerController?.customSelectionColor = sender?.color
	}
	
	private let chineseLunarCalendar: Calendar = {
		var calendar = Calendar.init(identifier: .chinese)
		calendar.locale = Locale(identifier: "zh")
		
		return calendar
	}()
}

extension TestDatePickerController: DatePickerControllerDelegate {
	func datePickerController(_ controller : DatePickerController, didSelectDate date : Date) {
		delegateMessagesTextView.string += "\(date)\n"
		delegateMessagesTextView.scrollToEndOfDocument(nil)
	}
}
