//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DateTimePickerMode

@available(*, deprecated, renamed: "DateTimePickerMode")
public typealias MSDateTimePickerMode = DateTimePickerMode

@objc(MSFDateTimePickerMode)
public enum DateTimePickerMode: Int {
    case date
    case dateTime
    case dateRange
    case dateTimeRange

    public var includesTime: Bool { return self == .dateTime || self == .dateTimeRange }
    public var singleSelection: Bool { return self == .date || self == .dateTime }
}

// MARK: - DateTimePickerDelegate

@available(*, deprecated, renamed: "DateTimePickerDelegate")
public typealias MSDateTimePickerDelegate = DateTimePickerDelegate

@objc(MSFDateTimePickerDelegate)
public protocol DateTimePickerDelegate: AnyObject {
    /// Allows a class to be notified when a user confirms their selected date
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didPickStartDate startDate: Date, endDate: Date)
    /// Allows for some validation and cancellation of picking behavior, including the dismissal of DateTimePicker classes when Done is pressed. If false is returned, the dismissal and `didPickStartDate` delegate calls will not occur. This is not called when dismissing the modal without selection, such as when tapping outside to dismiss.
    @objc optional func dateTimePicker(_ dateTimePicker: DateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool
}

// MARK: - DateTimePicker

@available(*, deprecated, renamed: "DateTimePicker")
public typealias MSDateTimePicker = DateTimePicker

/// Manages the presentation and coordination of different date and time pickers
@objc(MSFDateTimePicker)
public class DateTimePicker: NSObject {
    @objc(MSFDateTimePickerDatePickerType)
    public enum DatePickerType: Int {
        /// Date picker is represented as a calendar with 7 columns to show days of week and each row showing one week of dates.
        case calendar
        /// Date picker is represented by a set of "spinners" each allowing to modify one component of a date: day, month, or year. Only one spinner for the entire date is shown when time picking is also allowed.
        case components
    }

    @objc(MSFDateTimePickerDateRangePresentation)
    public enum DateRangePresentation: Int {
        case paged
        case tabbed
    }

    @objc(MSFDateTimePickerTitles)
    public class Titles: NSObject {
        public override init() { }

        @nonobjc public static func with(startTitle: String? = nil, startSubtitle: String? = nil, startTab: String? = nil, endTitle: String? = nil, endSubtitle: String? = nil, endTab: String? = nil, dateTitle: String? = nil, dateSubtitle: String? = nil, dateTimeTitle: String? = nil, dateTimeSubtitle: String? = nil) -> Titles {
            let titles = Titles()
            titles.startTitle = startTitle
            titles.startSubtitle = startSubtitle
            titles.startTab = startTab
            titles.endTitle = endTitle
            titles.endSubtitle = endSubtitle
            titles.endTab = endTab
            titles.dateTitle = dateTitle
            titles.dateSubtitle = dateSubtitle
            titles.dateTimeTitle = dateTimeTitle
            titles.dateTimeSubtitle = dateTimeSubtitle
            return titles
        }

        public var startTitle: String?
        public var startSubtitle: String?
        public var startTab: String?
        public var endTitle: String?
        public var endSubtitle: String?
        public var endTab: String?
        public var dateTitle: String?
        public var dateSubtitle: String?
        public var dateTimeTitle: String?
        public var dateTimeSubtitle: String?
    }

    private struct Constants {
        static let defaultDateDaysRange: Int = 1
        static let defaultDateTimeHoursRange: Int = 1
    }

    public private(set) var mode: DateTimePickerMode?
    @objc public weak var delegate: DateTimePickerDelegate?

    private var presentingController: UIViewController?
    private var presentedPickers: [GenericDateTimePicker]?

    private var datePickerType: DatePickerType = .calendar

    /// Presents a picker or set of pickers from a `presentingController` depending on the mode selected. Also handles accessibility replacement presentation.
    /// The picker has a default range of dates available that works for most scenarios. To change that range, override referenceStartDate and referenceEndDate in the default instance of CalendarConfiguration.
    ///
    /// - Parameters:
    ///   - presentingController: The view controller that is presenting these pickers
    ///   - mode: Enum describing which mode of pickers should be presented
    ///   - startDate: The initial date selected on the presented pickers
    ///   - endDate: An optional end date to pick a range of dates. Ignored if mode is `.date` or `.dateTime`. If the mode selected is either `.dateRange` or `.dateTimeRange`, and this is omitted, it will be set to a default 1 day or 1 hour range, respectively.
    ///   - datePickerType: The type of UI to use for picking dates: calendar or spinners representing date components (day, month, and year) or date (when time picking is also enabled). `.components` will be forced when VoiceOver is running. `.paged` date range presentation is not supported for `.components` date picker type (tabbed presentation will be used instead).
    ///   - dateRangePresentation: The `DateRangePresentation` in which to show any date pickers when `mode` is `.dateRange` or `.dateTimeRange`. Does not affect the time picker, which is always tabbed in range mode, but may change whether the date picker is presented in certain modes.
    ///   - titles: A `Titles` object that holds strings for use in overriding the default picker titles, subtitles, and tab titles. If a string is provided for a property that does not apply to the current mode, it will be ignored.
    ///   - leftBarButtonItem: optional UIBarButtonItem to be presented on the left side of the toolbar.
    ///   - rightBarButtonItem: optional UIBarButtonItem to be presented on the right side of the toolbar. Note that if this view is presented, the Confirm button is not generated automatically.
    /// - Tag: MSDateTimePicker.present
    @objc public func present(from presentingController: UIViewController, with mode: DateTimePickerMode, startDate: Date = Date(), endDate: Date? = nil, datePickerType: DatePickerType = .calendar, dateRangePresentation: DateRangePresentation = .paged, titles: Titles? = nil, leftBarButtonItem: UIBarButtonItem? = nil, rightBarButtonItem: UIBarButtonItem? = nil) {
        self.presentingController = presentingController
        self.mode = mode
        self.datePickerType = datePickerType
        if UIAccessibility.isVoiceOverRunning {
            presentDateTimePickerForAccessibility(startDate: startDate, endDate: endDate ?? startDate, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            return
        }
        switch mode {
        case .date, .dateRange:
            let endDate = mode == .date ? startDate : endDate ?? startDate.adding(days: Constants.defaultDateDaysRange)
            presentDatePicker(startDate: startDate, endDate: endDate, dateRangePresentation: dateRangePresentation, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
        case .dateTime, .dateTimeRange:
            let endDate = mode == .dateTime ? startDate : endDate ?? startDate.adding(hours: Constants.defaultDateTimeHoursRange)
            presentDateTimePicker(startDate: startDate, endDate: endDate, dateRangePresentation: dateRangePresentation, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
        }
    }

    @objc public func dismiss() {
        presentingController?.dismiss(animated: true)
        mode = nil
        presentedPickers = nil
        presentingController = nil
    }

    private func presentDatePicker(startDate: Date, endDate: Date, dateRangePresentation: DateRangePresentation, titles: Titles?, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?) {
        guard let mode = mode else {
            preconditionFailure("Mode not set when presenting date picker")
        }
        let startDate = startDate.startOfDay
        let endDate = endDate.startOfDay
        if datePickerType == .calendar && mode == .dateRange && dateRangePresentation == .paged {
            let startDatePicker = DatePickerController(startDate: startDate, endDate: endDate, mode: mode, selectionMode: .start, rangePresentation: dateRangePresentation, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            let endDatePicker = DatePickerController(startDate: startDate, endDate: endDate, mode: mode, selectionMode: .end, rangePresentation: dateRangePresentation, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            present([startDatePicker, endDatePicker])
        } else {
            let endDate = mode.singleSelection ? startDate : endDate
            let datePicker: GenericDateTimePicker
            switch datePickerType {
            case .calendar:
                datePicker = DatePickerController(startDate: startDate, endDate: endDate, mode: mode, rangePresentation: dateRangePresentation, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            case .components:
                datePicker = DateTimePickerController(startDate: startDate, endDate: endDate, mode: mode, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            }
            present([datePicker])
        }
    }

    private func presentDateTimePicker(startDate: Date, endDate: Date, dateRangePresentation: DateRangePresentation, titles: Titles?, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?) {
        guard let mode = mode else {
            preconditionFailure("Mode not set when presenting date time picker")
        }
        // If we are not presenting a range, or if we have a range, but it is within the same calendar day, present both dateTimePicker and datePicker. Also presents this way if `presentation` is in `.tabbed` mode. Otherwise, present just a dateTimePicker.
        if datePickerType == .calendar &&
            (mode == .dateTime || Calendar.current.isDate(startDate, inSameDayAs: endDate) || dateRangePresentation == .tabbed) {
            let dateTimePicker = DateTimePickerController(startDate: startDate, endDate: endDate, mode: mode, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            // Create datePicker second to pick up the time that dateTimePicker rounded to the nearest minute interval
            let datePicker = DatePickerController(startDate: dateTimePicker.startDate, endDate: dateTimePicker.endDate, mode: mode, rangePresentation: dateRangePresentation, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            present([datePicker, dateTimePicker])
        } else {
            let dateTimePicker = DateTimePickerController(startDate: startDate, endDate: endDate, mode: mode, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
            present([dateTimePicker])
        }
    }

    private func presentDateTimePickerForAccessibility(startDate: Date, endDate: Date, titles: Titles?, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?) {
        guard let mode = mode else {
            preconditionFailure("Mode not set when presenting date time picker for accessibility")
        }
        let dateTimePicker = DateTimePickerController(startDate: startDate, endDate: endDate, mode: mode, titles: titles, leftBarButtonItem: leftBarButtonItem, rightBarButtonItem: rightBarButtonItem)
        present([dateTimePicker])
    }

    private func present(_ pickers: [GenericDateTimePicker]) {
        pickers.forEach { $0.delegate = self }
        presentedPickers = pickers

        let viewControllers = pickers.map { CardPresenterNavigationController(rootViewController: $0 as! UIViewController) }
        let pageCardPresenter = PageCardPresenterController(viewControllers: viewControllers, startingIndex: 0)
        pageCardPresenter.onDismiss = {
            self.dismiss()
        }
        presentingController?.present(pageCardPresenter, animated: true)
    }
}

// MARK: - DateTimePicker: GenericDateTimePickerDelegate

extension DateTimePicker: GenericDateTimePickerDelegate {
    func dateTimePicker(_ dateTimePicker: GenericDateTimePicker, didPickStartDate startDate: Date, endDate: Date) {
        delegate?.dateTimePicker(self, didPickStartDate: startDate, endDate: endDate)
    }

    func dateTimePicker(_ dateTimePicker: GenericDateTimePicker, didSelectStartDate startDate: Date, endDate: Date) {
        guard let presentedPickers = presentedPickers else {
            return
        }
        for picker in presentedPickers where picker !== dateTimePicker {
            picker.startDate = startDate
            picker.endDate = endDate
        }
    }

    func dateTimePicker(_ dateTimePicker: GenericDateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool {
        return delegate?.dateTimePicker?(self, shouldEndPickingStartDate: startDate, endDate: endDate) ?? true
    }
}
