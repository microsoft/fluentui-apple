//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
    
    /// Font size of the month-year label
    static let fontSize: CGFloat = 18.0
    
    /// Width of the forward/back button
    static let buttonWidth: CGFloat = 20
    
    /// Height of the forward/back button
    static let buttonHeight: CGFloat = 30
    
    /// Number of weekday labels to display
    static let weekdayCount = 7
    
    /// Width of each weekday label
    static let weekdayLabelWidth: CGFloat = 32.0
    
    /// Spacing between the button row and the label row
    static let verticalSpacing: CGFloat = 5.0
    
    private init() {}
}

/// Two-row calendar header that includes arrow buttons and the month-year label in the first row,
/// and weekday column labels in the second row
class CalendarHeaderView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        let containerStackView = NSStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.orientation = .vertical
        containerStackView.distribution = .gravityAreas
        containerStackView.wantsLayer = true
        containerStackView.spacing = Constants.verticalSpacing
        
        addSubview(containerStackView)
        
        let headerStackView = NSStackView()
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.orientation = .horizontal
        headerStackView.distribution = .gravityAreas
        headerStackView.wantsLayer = true
        
        containerStackView.addView(headerStackView, in: .top)
        
        let leadingButton = NSButton(image: NSImage(named: NSImage.goBackTemplateName)!, target: self, action: #selector(leadingButtonPressed))
        let trailingButton = NSButton(image: NSImage(named: NSImage.goForwardTemplateName)!, target: self, action: #selector(trailingButtonPressed))
        
        leadingButton.isBordered = false
        trailingButton.isBordered = false
        
        leadingButton.setAccessibilityLabel(NSLocalizedString(
            "DATEPICKER_ACCESSIBILITY_PREVIOUS_MONTH_LABEL",
            tableName: "OfficeUIFabric",
            bundle: Bundle(for: CalendarHeaderView.self),
            comment: ""
        ))
        
        trailingButton.setAccessibilityLabel(NSLocalizedString(
            "DATEPICKER_ACCESSIBILITY_NEXT_MONTH_LABEL",
            tableName: "OfficeUIFabric",
            bundle: Bundle(for: CalendarHeaderView.self),
            comment: ""
        ))
        
        headerStackView.addView(monthYearLabel, in: .center)
        headerStackView.addView(leadingButton, in: .leading)
        headerStackView.addView(trailingButton, in: .trailing)
        
        let weekdayLabelStackView = NSStackView()
        weekdayLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        weekdayLabelStackView.orientation = .horizontal
        weekdayLabelStackView.distribution = .equalCentering
        weekdayLabelStackView.wantsLayer = true
        weekdayLabelStackView.spacing = 0
        
        for label in weekdayLabels {
            weekdayLabelStackView.addView(label, in: .center)
        }
        
        containerStackView.addView(weekdayLabelStackView, in: .top)
        
        NSLayoutConstraint.activate([
            monthYearLabel.centerXAnchor.constraint(equalTo: headerStackView.centerXAnchor),
            monthYearLabel.centerYAnchor.constraint(equalTo: headerStackView.centerYAnchor),
            leadingButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            leadingButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            trailingButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            trailingButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            weekdayLabelStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            weekdayLabelStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)
        ])
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: CalendarHeaderViewDelegate?
    
    let monthYearLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.font = NSFont.boldSystemFont(ofSize: Constants.fontSize)
        
        return textField
    }()
    
    var weekdayStrings: [(short: String, long: String)] = [] {
        didSet {
            guard weekdayStrings.count == weekdayLabels.count else {
                return
            }
            
            for (weekdayString, weekdayLabel) in zip(weekdayStrings, weekdayLabels) {
                weekdayLabel.stringValue = weekdayString.short
                weekdayLabel.setAccessibilityLabel(weekdayString.long)
            }
        }
    }
    
    private let weekdayLabels: [NSTextField] = {
        var labels: [NSTextField] = []
        for _ in 0..<Constants.weekdayCount {
            let label = NSTextField(labelWithString: "")
            label.alignment = .center
            label.setAccessibilityRole(.staticText)
            label.widthAnchor.constraint(equalToConstant: Constants.weekdayLabelWidth).isActive = true
            labels.append(label)
        }
        return labels
    }()
    
    @objc private func leadingButtonPressed(_ sender: NSButton) {
        delegate?.calendarHeaderView(self, didPressLeading: sender)
    }
    
    @objc private func trailingButtonPressed(_ sender: NSButton) {
        delegate?.calendarHeaderView(self, didPressTrailing: sender)
    }
}

protocol CalendarHeaderViewDelegate: class {
    
    /// Tells the delegate that the leading arrow button was pressed.
    ///
    /// - Parameters:
    ///   - calendarHeader: The calendar header.
    ///   - button: The button that was pressed.
    func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressLeading button: NSButton)
    
    /// Tells the delegate that the trailing arrow button was pressed.
    ///
    /// - Parameters:
    ///   - calendarHeader: The calendar header.
    ///   - button: The button that was pressed.
    func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressTrailing button: NSButton)
}

/// Default delegate implementation
extension CalendarHeaderViewDelegate {
    
    func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressLeading button: NSButton) {}
    
    func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressTrailing button: NSButton) {}
}
