//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewStyleDataSource

protocol CalendarViewStyleDataSource: AnyObject {
    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, textStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents) -> CalendarViewDayCellTextStyle

    // Suggestion: Use provided components for performance improvements. Check where it's called to see what's available
    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, backgroundStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents) -> CalendarViewDayCellBackgroundStyle

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, selectionStyleForDayWithStart dayStartDate: Date, end: Date) -> CalendarViewDayCellSelectionStyle
}

// MARK: - CalendarViewIndicatorDataSource

protocol CalendarViewIndicatorDataSource {
    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, indicatorLevelForDayWithStart dayStartDate: Date, end: Date) -> Int
}

// MARK: - CalendarViewDataSource

class CalendarViewDataSource: NSObject {
    /// Preference for what day is the first day of the week. Defaults to the user's current Calendar's firstWeekday.
    /// 1 for Sunday, 2 for Monday, 7 for Saturday
    var firstWeekday: Int = Calendar.current.firstWeekday

    private(set) var calendar: Calendar
    private(set) var standaloneMonthSymbols: [String]
    private(set) var shortStandaloneMonthSymbols: [String]

    private(set) var firstDate: Date!
    private(set) var lastDate: Date!

    private(set) var todayIndexPath: IndexPath!
    private(set) var todayDate: Date!
    private(set) var todayDateComponents: DateComponents!

    private(set) var monthBannerViewSet: Set<NSValue>

    private let styleDataSource: CalendarViewStyleDataSource
    private let calendarConfiguration: CalendarConfiguration
    private let indicatorDataSource: CalendarViewIndicatorDataSource?

    private var startOfDayCache: [Int: Date]!
    private var indicatorLevelForDayCache: [Date: Int]!

    init(styleDataSource: CalendarViewStyleDataSource, indicatorDataSource: CalendarViewIndicatorDataSource? = nil, calendarConfiguration: CalendarConfiguration = CalendarConfiguration.default) {
        self.styleDataSource = styleDataSource
        self.calendarConfiguration = calendarConfiguration
        self.indicatorDataSource = indicatorDataSource

        // Calendar
        calendar = Calendar.current
        standaloneMonthSymbols = calendar.standaloneMonthSymbols
        shortStandaloneMonthSymbols = calendar.shortStandaloneMonthSymbols

        monthBannerViewSet = Set<NSValue>()

        super.init()
        reload()
    }

    func reload() {
        // Reload calendar in case of time zone changes
        calendar = Calendar.current

        // Reload symbols in case of language or locale changes
        standaloneMonthSymbols = calendar.standaloneMonthSymbols
        shortStandaloneMonthSymbols = calendar.shortStandaloneMonthSymbols

        // Reload first date and last date in case week start changed or time zone changed
        firstDate = calendar.startOfWeek(for: calendarConfiguration.referenceStartDate, firstWeekday: firstWeekday)
        lastDate = calendar.endOfWeek(for: calendarConfiguration.referenceEndDate, firstWeekday: firstWeekday)

        // Reload today date, today date components, and today index path in case midnight passed or time zone changed
        todayDate = calendar.startOfDay(for: Date())
        todayDateComponents = calendar.dateComponents([.year, .month, .day], from: todayDate)
        todayIndexPath = indexPath(forDayWithStart: todayDate)

        // Reset caches
        startOfDayCache = [Int: Date]()
        indicatorLevelForDayCache = [Date: Int]()
    }

    func indexPath(forDayWithStart dayStartDate: Date) -> IndexPath {
        let numberOfDaysBetweenFirstDateAndTargetDate = calendar.dateComponents([.day], from: firstDate, to: dayStartDate).day!

        return IndexPath(item: numberOfDaysBetweenFirstDateAndTargetDate % 7, section: numberOfDaysBetweenFirstDateAndTargetDate / 7)
    }

    func dayStart(forDayAt indexPath: IndexPath) -> Date {
        let numberOfDaysFromFirstDate = (indexPath.section * 7) + indexPath.item

        if let cachedDayStartDateForDay = startOfDayCache[numberOfDaysFromFirstDate] {
            return cachedDayStartDateForDay
        }

        guard let dayStartDate = calendar.date(byAdding: .day, value: numberOfDaysFromFirstDate, to: firstDate) else {
            return Date()
        }

        startOfDayCache[numberOfDaysFromFirstDate] = dayStartDate

        return dayStartDate
    }

    func dayEnd(forDayAt indexPath: IndexPath) -> Date {
        return dayStart(forDayAt: IndexPath(item: indexPath.item + 1, section: indexPath.section))
    }

    func indicatorLevel(forDayWithStart dayStartDate: Date, end: Date) -> Int {
        if let cachedIndicatorLevelForDay = indicatorLevelForDayCache[dayStartDate] {
            // Use cached indicator level for day
            return cachedIndicatorLevelForDay
        }

        guard let indicatorDataSource = self.indicatorDataSource else {
            return 0
        }

        let indicatorLevelForDay = indicatorDataSource.calendarViewDataSource(self, indicatorLevelForDayWithStart: dayStartDate, end: end)

        indicatorLevelForDayCache[dayStartDate] = indicatorLevelForDay

        return indicatorLevelForDay
    }
}

// MARK: - CalendarViewDataSource: UICollectionViewDataSource

extension CalendarViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let daysBetweenFirstDateAndLastDate = calendar.dateComponents([.day], from: firstDate, to: lastDate).day!
        let numberOfDays = daysBetweenFirstDateAndLastDate + 1

        guard numberOfDays % 7 == 0 else {
            return 0
        }

        return numberOfDays / 7  // 1 week per section
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7  // 7 days per week
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Calculate date information
        let dayStartDate = dayStart(forDayAt: indexPath)
        let dayStartDateComponents = calendar.dateComponents([.year, .month, .day], from: dayStartDate)
        let dayEndDate = dayEnd(forDayAt: indexPath)

        // Calculate style parameters
        let textStyle = styleDataSource.calendarViewDataSource(self, textStyleForDayWithStart: dayStartDate, end: dayEndDate, dayStartComponents: dayStartDateComponents, todayComponents: todayDateComponents)

        let backgroundStyle = styleDataSource.calendarViewDataSource(self, backgroundStyleForDayWithStart: dayStartDate, end: dayEndDate, dayStartComponents: dayStartDateComponents, todayComponents: todayDateComponents)

        let selectionStyle = styleDataSource.calendarViewDataSource(self, selectionStyleForDayWithStart: dayStartDate, end: dayEndDate)

        let monthLabelIndex = dayStartDateComponents.month! - 1
        let monthLabelText: String = monthLabelIndex >= 0 && monthLabelIndex < shortStandaloneMonthSymbols.count ? shortStandaloneMonthSymbols[monthLabelIndex] : ""

        let dateLabelText = String(describingOptional: dayStartDateComponents.day)

        let yearLabelText = String(describingOptional: dayStartDateComponents.year)

        let indicatorLevel = self.indicatorLevel(forDayWithStart: dayStartDate, end: dayEndDate)

        // Setup cell
        if dayStartDate.compare(calendar.startOfDay(for: calendarConfiguration.referenceStartDate)) == .orderedAscending {
            // Before reference start date
            guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewDayCell.identifier, for: indexPath) as? CalendarViewDayCell else {
                return UICollectionViewCell()
            }
            dayCell.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: "", indicatorLevel: 0)
            return dayCell
        }

        if dayStartDate == todayDate {
            guard let dayTodayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewDayTodayCell.identifier, for: indexPath) as? CalendarViewDayTodayCell else {
                return UICollectionViewCell()
            }
            dayTodayCell.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)
            return dayTodayCell
        }

        if dayStartDateComponents.day == 1 {
            if dayStartDateComponents.year != todayDateComponents.year {
                guard let dayMonthYearCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewDayMonthYearCell.identifier, for: indexPath) as? CalendarViewDayMonthYearCell else {
                    return UICollectionViewCell()
                }
                dayMonthYearCell.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, monthLabelText: monthLabelText, dateLabelText: dateLabelText, yearLabelText: yearLabelText, indicatorLevel: indicatorLevel)
                return dayMonthYearCell
            } else {
                guard let dayMonthCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewDayMonthCell.identifier, for: indexPath) as? CalendarViewDayMonthCell else {
                    return UICollectionViewCell()
                }
                dayMonthCell.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, monthLabelText: monthLabelText, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)
                return dayMonthCell
            }
        }

        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewDayCell.identifier, for: indexPath) as? CalendarViewDayCell else {
            return UICollectionViewCell()
        }
        dayCell.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)
        return dayCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == CalendarViewMonthBannerView.supplementaryElementKind else {
            return UICollectionReusableView()
        }

        let firstDayStartDateOfWeek = dayStart(forDayAt: IndexPath(item: 0, section: indexPath.section))
        let firstDayStartDateOfWeekDateComponents = calendar.dateComponents([.month, .year], from: firstDayStartDateOfWeek)

        var monthLabelText: String
        if firstDayStartDateOfWeekDateComponents.year == todayDateComponents.year {
            let index = firstDayStartDateOfWeekDateComponents.month! - 1

            if index >= 0 && index < standaloneMonthSymbols.count {
                monthLabelText = standaloneMonthSymbols[index]
            } else {
                monthLabelText = ""
            }
        } else {
            monthLabelText = String.dateString(from: firstDayStartDateOfWeek, compactness: .longMonthNameFullYear)
        }

        guard let monthBannerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarViewMonthBannerView.reuseIdentifier, for: indexPath) as? CalendarViewMonthBannerView else {
            return UICollectionViewCell()
        }
        monthBannerView.setup(monthLabelText: monthLabelText)

        // Keep weak reference
        monthBannerViewSet.insert(NSValue(nonretainedObject: monthBannerView))

        return monthBannerView
    }
}
