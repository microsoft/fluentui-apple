//
// Copyright Microsoft Corporation
//

import AppKit
import OfficeUIFabric

class TestDatePickerController: NSViewController {
    
    var datePickerController : DatePickerController?
    var menuDatePickerController: DatePickerController?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let calendar = Calendar.current

        datePickerController = DatePickerController(date: Date(), calendar: calendar, style: .dateTime)
        menuDatePickerController = DatePickerController(date: Date(), calendar: calendar, style: .dateTime)
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
        
        containerView.addView(menuButton, in: .center)
        
        view = containerView
    }
}
