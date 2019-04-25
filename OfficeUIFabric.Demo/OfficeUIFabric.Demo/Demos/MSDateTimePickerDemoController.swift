//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSDateTimePickerDemoController: DemoController {
    private let dateLabel = MSLabel(style: .headline)
    private let dateTimePicker = MSDateTimePicker()

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
        container.addArrangedSubview(createButton(title: "Show date picker", action: #selector(presentDatePicker)))
        container.addArrangedSubview(createButton(title: "Show date time picker", action: #selector(presentDateTimePicker)))
        container.addArrangedSubview(createButton(title: "Show date range picker", action: #selector(presentDateRangePicker)))
        container.addArrangedSubview(createButton(title: "Show date time range picker", action: #selector(presentDateTimeRangePicker)))
        container.addArrangedSubview(UIView())
        container.addArrangedSubview(createValidationUI())
        container.addArrangedSubview(createButton(title: "Reset selected dates", action: #selector(resetDates)))
    }

    func createValidationUI() -> UIStackView {
        let validationRow = UIStackView()
        validationRow.axis = .horizontal
        validationRow.alignment = .center
        validationRow.distribution = .equalSpacing

        let validationLabel = MSLabel(style: .subhead, colorStyle: .regular)
        validationLabel.text = "Validate for date in future"

        validationRow.addArrangedSubview(validationLabel)
        validationRow.addArrangedSubview(validationSwitch)
        return validationRow
    }

    @objc func presentDatePicker() {
        dateTimePicker.present(from: self, with: .date, startDate: startDate ?? Date())
    }

    @objc func presentDateTimePicker() {
        dateTimePicker.present(from: self, with: .dateTime, startDate: startDate ?? Date())
    }

    @objc func presentDateRangePicker() {
        let startDate = self.startDate ?? Date()
        let endDate = self.endDate ?? Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        dateTimePicker.present(from: self, with: .dateRange, startDate: startDate, endDate: endDate)
    }

    @objc func presentDateTimeRangePicker() {
        let startDate = self.startDate ?? Date()
        let endDate = self.endDate ?? Calendar.current.date(byAdding: .hour, value: 1, to: startDate) ?? startDate
        dateTimePicker.present(from: self, with: .dateTimeRange, startDate: startDate, endDate: endDate)
    }

    @objc func resetDates() {
        startDate = nil
        endDate = nil
        dateLabel.text = "No date selected"
    }
}

// MARK: - MSDateTimePickerDemoController: MSDatePickerDelegate

extension MSDateTimePickerDemoController: MSDateTimePickerDelegate {
    func dateTimePicker(_ dateTimePicker: MSDateTimePicker, didPickStartDate startDate: Date, endDate: Date) {
        guard let mode = dateTimePicker.mode else {
            fatalError("Received delegate call when mode = nil")
        }

        self.startDate = startDate

        let compactness: MSDateStringCompactness
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

    func dateTimePicker(_ dateTimePicker: MSDateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool {
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
