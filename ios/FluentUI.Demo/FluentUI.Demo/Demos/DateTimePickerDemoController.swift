//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DateTimePickerDemoController: DemoController {
    private let dateLabel = Label(style: .body1Strong)
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

    private let customCalendarConfigurationSwitch = UISwitch()
    private var calendarConfiguration: CalendarConfiguration? {
        guard customCalendarConfigurationSwitch.isOn else {
            return nil
        }

        let customCalendarConfiguration = CalendarConfiguration()
        customCalendarConfiguration.referenceStartDate = Date()
        customCalendarConfiguration.referenceEndDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        customCalendarConfiguration.firstWeekday = 2

        return customCalendarConfiguration
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
        readmeString = "A date and time picker is a specialized interface that lets people choose a single date, a range of dates, or a time.\n\nDate and time pickers provide context that can help people make decisions, like the day of the week a date falls or unavailable dates. Avoid using date and time pickers for dates people know well or that will require a lot of scrolling, like birthdays."

        container.addArrangedSubview(dateLabel)
        container.addArrangedSubview(createButton(title: "Show date picker", action: #selector(presentDatePicker)))
        container.addArrangedSubview(createButton(title: "Show date time picker", action: #selector(presentDateTimePicker)))
        container.addArrangedSubview(createButton(title: "Show date range picker (paged)", action: #selector(presentDateRangePicker)))
        container.addArrangedSubview(createButton(title: "Show date range picker (tabbed)", action: #selector(presentTabbedDateRangePicker)))
        container.addArrangedSubview(createButton(title: "Show date time range picker", action: #selector(presentDateTimeRangePicker)))
        container.addArrangedSubview(createButton(title: "Show picker with custom subtitles or tabs", action: #selector(presentCustomSubtitlePicker)))
        container.addArrangedSubview(createButton(title: "Show picker with left bar-button", action: #selector(presentLeftBarButtonPicker)))
        container.addArrangedSubview(createButton(title: "Show picker with left and right bar-buttons", action: #selector(presentRightBarButtonPicker)))
        container.addArrangedSubview(UIView())
        container.addArrangedSubview(createDatePickerTypeUI())
        container.addArrangedSubview(createCustomCalendarConfigurationUI())
        container.addArrangedSubview(createValidationUI())
        container.addArrangedSubview(createButton(title: "Reset selected dates", action: #selector(resetDates)))
    }

    @objc func presentDatePicker() {
        dateTimePicker.present(
            from: self,
            with: .date,
            startDate: startDate ?? Date(),
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType)
    }

    @objc func presentDateTimePicker() {
        dateTimePicker.present(
            from: self,
            with: .dateTime,
            startDate: startDate ?? Date(),
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType)
    }

    @objc func presentDateRangePicker() {
        let (startDate, endDate, _) = calcDatePickerParams()
        dateTimePicker.present(
            from: self,
            with: .dateRange,
            startDate: startDate,
            endDate: endDate,
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType)
    }

    @objc func presentTabbedDateRangePicker() {
        let (startDate, endDate, _) = calcDatePickerParams()
        dateTimePicker.present(
            from: self,
            with: .dateRange,
            startDate: startDate,
            endDate: endDate,
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType,
            dateRangePresentation: .tabbed)
    }

    @objc func presentDateTimeRangePicker() {
        let (startDate, endDate, _) = calcDatePickerParams()
        dateTimePicker.present(
            from: self,
            with: .dateTimeRange,
            startDate: startDate,
            endDate: endDate,
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType)
    }

    @objc func presentCustomSubtitlePicker() {
        let (startDate, endDate, titles) = calcDatePickerParams()
        dateTimePicker.present(
            from: self,
            with: .dateRange,
            startDate: startDate,
            endDate: endDate,
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType,
            titles: titles)
    }

    @objc func presentLeftBarButtonPicker() {
        let (startDate, endDate, titles) = calcDatePickerParams()
        let leftBarButtonItem = cancelButton(target: self, action: #selector(handleDidTapCancel))
        dateTimePicker.present(
            from: self,
            with: .dateRange,
            startDate: startDate,
            endDate: endDate,
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType,
            titles: titles,
            leftBarButtonItem: leftBarButtonItem)
    }

    @objc func presentRightBarButtonPicker() {
        let (startDate, endDate, titles) = calcDatePickerParams()
        let leftBarButtonItem = confirmButton(target: self, action: #selector(handleDidTapDone))
        let rightBarButtonItem = cancelButton(target: self, action: #selector(handleDidTapCancel)) // or simply assign UIBarButtonItem() to hide the default confirm button
        dateTimePicker.present(
            from: self,
            with: .dateRange,
            startDate: startDate,
            endDate: endDate,
            calendarConfiguration: calendarConfiguration,
            datePickerType: datePickerType,
            titles: titles,
            leftBarButtonItem: leftBarButtonItem,
            rightBarButtonItem: rightBarButtonItem)
    }

    func createDatePickerTypeUI() -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .equalSpacing

        let label = Label(style: .body1Strong, colorStyle: .regular)
        label.text = "Date picker type"
        label.numberOfLines = 0
        container.addArrangedSubview(label)

        datePickerTypeSelector.setContentCompressionResistancePriority(.required, for: .horizontal)
        container.addArrangedSubview(datePickerTypeSelector)

        return container
    }

    func createCustomCalendarConfigurationUI() -> UIStackView {
        let customCalendarConfigurationTitleLabel = Label(style: .body1Strong, colorStyle: .regular)
        customCalendarConfigurationTitleLabel.text = "Custom calendar configuration"

        let customCalendarConfigurationBodyLabel = Label(style: .caption1, colorStyle: .regular)
        customCalendarConfigurationBodyLabel.text = "First weekday: Monday\nReference start date: Today\nReference end date: One month from today"
        customCalendarConfigurationBodyLabel.numberOfLines = 0

        let switchContainer = UIStackView()
        switchContainer.axis = .horizontal
        switchContainer.alignment = .center
        switchContainer.distribution = .equalSpacing
        switchContainer.addArrangedSubview(customCalendarConfigurationTitleLabel)
        switchContainer.addArrangedSubview(customCalendarConfigurationSwitch)

        let container = UIStackView()
        container.axis = .vertical
        container.addArrangedSubview(switchContainer)
        container.addArrangedSubview(customCalendarConfigurationBodyLabel)

        return container
    }

    func createValidationUI() -> UIStackView {
        let validationRow = UIStackView()
        validationRow.axis = .horizontal
        validationRow.alignment = .center
        validationRow.distribution = .equalSpacing

        let validationLabel = Label(style: .body1Strong, colorStyle: .regular)
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
