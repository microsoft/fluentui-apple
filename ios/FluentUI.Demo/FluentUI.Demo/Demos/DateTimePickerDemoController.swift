//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DateTimePickerDemoController: DemoController {
    private let dateLabel = Label(style: .headline)
    private let dateTimePicker = DateTimePicker()

    private let datePickerTypeSelector: UISegmentedControl = {
        let selector = UISegmentedControl(items: ["Calendar", "Components"])
        selector.selectedSegmentIndex = 0
        return selector
    }()
    private var datePickerType: DateTimePicker.DatePickerType {
        if let value = DateTimePicker.DatePickerType(rawValue: datePickerTypeSelector.selectedSegmentIndex) {
            return value
        } else {
            preconditionFailure("Unknown date picker type index")
        }
    }

    private let validationSwitch = UISwitch()
    private var isValidating: Bool { return validationSwitch.isOn }

    private var startDate: Date?
    private var endDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTimePicker.delegate = self
        dateLabel.text = "No date selected"
        dateLabel.adjustsFontSizeToFitWidth = true

        container.addArrangedSubview(dateLabel)
        container.addArrangedSubview(createButton(title: "Show date picker", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dateTimePicker.present(from: strongSelf, with: .date, startDate: strongSelf.startDate ?? Date(), datePickerType: strongSelf.datePickerType)
        }).view)

        container.addArrangedSubview(createButton(title: "Show date time picker", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateTime, startDate: strongSelf.startDate ?? Date(), datePickerType: strongSelf.datePickerType)
        }).view)

        container.addArrangedSubview(createButton(title: "Show date range picker (paged)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let startDate = strongSelf.startDate ?? Date()
            let endDate = strongSelf.endDate ?? Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType)
        }).view)

        container.addArrangedSubview(createButton(title: "Show date range picker (tabbed)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let startDate = strongSelf.startDate ?? Date()
            let endDate = strongSelf.endDate ?? Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType, dateRangePresentation: .tabbed)
        }).view)

        container.addArrangedSubview(createButton(title: "Show date time range picker", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let startDate = strongSelf.startDate ?? Date()
            let endDate = strongSelf.endDate ?? Calendar.current.date(byAdding: .hour, value: 1, to: startDate) ?? startDate
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateTimeRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType)
        }).view)

        container.addArrangedSubview(createButton(title: "Show picker with custom subtitles or tabs", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let startDate = strongSelf.startDate ?? Date()
            let endDate = strongSelf.endDate ?? Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
            let titles: DateTimePicker.Titles
            if strongSelf.datePickerType == .calendar && !UIAccessibility.isVoiceOverRunning {
                titles = .with(startSubtitle: "Assignment Date", endSubtitle: "Due Date")
            } else {
                titles = .with(startTab: "Assignment Date", endTab: "Due Date")
            }
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType, titles: titles)
        }).view)

        container.addArrangedSubview(UIView())
        container.addArrangedSubview(createDatePickerTypeUI())
        container.addArrangedSubview(createValidationUI())

        container.addArrangedSubview(createButton(title: "Reset selected dates", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.startDate = nil
            strongSelf.endDate = nil
            strongSelf.dateLabel.text = "No date selected"
        }).view)
    }

    func createDatePickerTypeUI() -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .equalSpacing

        let label = Label(style: .subhead, colorStyle: .regular)
        label.text = "Date picker type"
        label.numberOfLines = 0
        container.addArrangedSubview(label)

        datePickerTypeSelector.setContentCompressionResistancePriority(.required, for: .horizontal)
        container.addArrangedSubview(datePickerTypeSelector)

        return container
    }

    func createValidationUI() -> UIStackView {
        let validationRow = UIStackView()
        validationRow.axis = .horizontal
        validationRow.alignment = .center
        validationRow.distribution = .equalSpacing

        let validationLabel = Label(style: .subhead, colorStyle: .regular)
        validationLabel.text = "Validate for date in future"

        validationRow.addArrangedSubview(validationLabel)
        validationRow.addArrangedSubview(validationSwitch)
        return validationRow
    }
}

// MARK: - DateTimePickerDemoController: MSDatePickerDelegate

extension DateTimePickerDemoController: DateTimePickerDelegate {
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didPickStartDate startDate: Date, endDate: Date) {
        guard let mode = dateTimePicker.mode else {
            preconditionFailure("Received delegate call when mode = nil")
        }

        self.startDate = startDate

        let compactness: DateStringCompactness
        if mode.singleSelection {
            if mode.includesTime {
                compactness = .longDaynameDayMonthHoursColumnsMinutes
            } else {
                compactness = .longDaynameDayMonthYear
            }
            dateLabel.text = String.dateString(from: startDate, compactness: compactness)
        } else {
            self.endDate = endDate
            if mode.includesTime {
                compactness = .shortDaynameShortMonthnameHoursColumnsMinutes
            } else {
                compactness = .shortDaynameDayShortMonthYear
            }
            dateLabel.text = String.dateString(from: startDate, compactness: compactness) + " - " + String.dateString(from: endDate, compactness: compactness)
        }
    }

    func dateTimePicker(_ dateTimePicker: DateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool {
        if isValidating && startDate.timeIntervalSinceNow < 0 {
            // Start date is in the past, cancel selection and don't dismiss the picker
            let alert = UIAlertController(title: "Error", message: "Can't pick a date in the past", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            presentedViewController?.present(alert, animated: true)
            return false
        }
        return true
    }
}
