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
        }))

        container.addArrangedSubview(createButton(title: "Show date time picker", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateTime, startDate: strongSelf.startDate ?? Date(), datePickerType: strongSelf.datePickerType)
        }))

        container.addArrangedSubview(createButton(title: "Show date range picker (paged)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let (startDate, endDate, _) = strongSelf.calcDatePickerParams()
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType)
        }))

        container.addArrangedSubview(createButton(title: "Show date range picker (tabbed)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let (startDate, endDate, _) = strongSelf.calcDatePickerParams()
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType, dateRangePresentation: .tabbed)
        }))

        container.addArrangedSubview(createButton(title: "Show date time range picker", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let (startDate, endDate, _) = strongSelf.calcDatePickerParams()
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateTimeRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType)
        }))

        container.addArrangedSubview(createButton(title: "Show picker with custom subtitles or tabs", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let (startDate, endDate, titles) = strongSelf.calcDatePickerParams()
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType, titles: titles)
        }))

        container.addArrangedSubview(createButton(title: "Show picker with left bar-button", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let (startDate, endDate, titles) = strongSelf.calcDatePickerParams()
            let leftBarButtonItem = strongSelf.cancelButton(target: strongSelf, action: #selector(strongSelf.handleDidTapCancel))
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType, titles: titles, leftBarButtonItem: leftBarButtonItem)
        }))

        container.addArrangedSubview(createButton(title: "Show picker with left and right bar-buttons", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let (startDate, endDate, titles) = strongSelf.calcDatePickerParams()
            let leftBarButtonItem = strongSelf.confirmButton(target: strongSelf, action: #selector(strongSelf.handleDidTapDone))
            let rightBarButtonItem = strongSelf.cancelButton(target: strongSelf, action: #selector(strongSelf.handleDidTapCancel)) // or simply assign UIBarButtonItem() to hide the default confirm button
            strongSelf.dateTimePicker.present(from: strongSelf, with: .dateRange, startDate: startDate, endDate: endDate, datePickerType: strongSelf.datePickerType, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
        }))

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
        }))
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

    func calcDatePickerParams() -> (startDate: Date, endDate: Date, titles: DateTimePicker.Titles) {
        let calculatedStartDate = startDate ?? Date()
        let calculatedEndDate = endDate ?? Calendar.current.date(byAdding: .day, value: 1, to: calculatedStartDate) ?? calculatedStartDate
        let titles: DateTimePicker.Titles
        if datePickerType == .calendar && !UIAccessibility.isVoiceOverRunning {
            titles = .with(startSubtitle: "Assignment Date", endSubtitle: "Due Date")
        } else {
            titles = .with(startTab: "Assignment Date", endTab: "Due Date")
        }
        return (calculatedStartDate, calculatedEndDate, titles)
    }

    func confirmButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage(named: "checkmark-24x24", in: FluentUIFramework.resourceBundle, compatibleWith: nil)
        let landscapeImage = UIImage(named: "checkmark-thin-20x20", in: FluentUIFramework.resourceBundle, compatibleWith: nil)

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = NSLocalizedString("Accessibility.Done.Label", bundle: FluentUIFramework.resourceBundle, comment: "")
        return button
    }

    func cancelButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage(named: "dismiss-20x20", in: FluentUIFramework.resourceBundle, compatibleWith: nil)
        let landscapeImage = UIImage(named: "dismiss-36x36", in: FluentUIFramework.resourceBundle, compatibleWith: nil)

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = NSLocalizedString("Accessibility.Dismiss.Label", bundle: FluentUIFramework.resourceBundle, comment: "")
        return button
    }

    @objc private func handleDidTapCancel() {
        dateTimePicker.dismiss()
        let alert = UIAlertController(title: "Callback from picker", message: "User has pressed Cancel bar-button", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }

    @objc private func handleDidTapDone() {
        dateTimePicker.dismiss()
        let alert = UIAlertController(title: "Callback from picker", message: "User has pressed Confirm bar-button", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }

    @objc func resetDates() {
        startDate = nil
        endDate = nil
        dateLabel.text = "No date selected"
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
