//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// A static class used to calculate layout and sizing information for DateTimePickerView.
class DateTimePickerViewLayout {
	static let horizontalPadding: CGFloat = 6

    // Component widths, based on the ideal total width minus padding
    static let componentWidths: [DateTimePickerViewComponentType: CGFloat] = [
        .date: Date.has24HourFormat() ? 154 : 134,
        .month: 174,
        .day: 100,
        .year: 100,
        .timeHour: Date.has24HourFormat() ? 70 : 50,
        .timeMinute: Date.has24HourFormat() ? 70 : 50,
        .timeAMPM: 60,
        .weekOfMonth: 134,
        .dayOfWeek: 134
    ]

    private static let idealRowCount: Int = 5

    static func height(forRowCount rowCount: Int) -> CGFloat {
        return CGFloat(rowCount) * DateTimePickerViewComponentCell.idealHeight
    }

    static func sizeThatFits(_ size: CGSize, mode: DateTimePickerViewMode) -> CGSize {
        let componentTypes = DateTimePickerViewLayout.componentTypes(fromDatePickerMode: mode)
        let totalWidth = componentTypes.reduce(horizontalPadding * 2) { $0 + (componentWidths[$1] ?? 0) }

        return CGSize(width: totalWidth, height: max(size.height, DateTimePickerViewComponentCell.idealHeight * CGFloat(idealRowCount)))
    }

    static func componentTypes(fromDatePickerMode datePickerMode: DateTimePickerViewMode) -> [DateTimePickerViewComponentType] {
        switch datePickerMode {
        case .date:
            // Determine whether Day or Month picker should be first based on locale
            var componentTypes: [DateTimePickerViewComponentType]
            if isDateOrderDayMonth() {
                componentTypes = [.day, .month]
            } else {
                componentTypes = [.month, .day]
            }
            componentTypes.append(.year)
            return componentTypes

        case .dateTime:
            var componentTypes: [DateTimePickerViewComponentType] = [.date, .timeHour, .timeMinute]
            if !Date.has24HourFormat() {
                componentTypes.append(.timeAMPM)
            }
            return componentTypes

        case .dayOfMonth:
            return [.weekOfMonth, .dayOfWeek]
        }
    }

    static func componentsByType(fromTypes types: [DateTimePickerViewComponentType], mode: DateTimePickerViewMode) -> [DateTimePickerViewComponentType: DateTimePickerViewComponent] {
        return types.reduce([DateTimePickerViewComponentType: DateTimePickerViewComponent](), { map, type in
            var map = map
            let dataSource = DateTimePickerViewDataSourceFactory.dataSource(withType: type, mode: mode)

            // Set date on MSDateTimePickerViewDataSourceWithDate to properly set number of days for month
            (dataSource as? DateTimePickerViewDataSourceWithDate)?.date = Date()

            let component = DateTimePickerViewComponent(dataSource: dataSource)
            map[type] = component
            return map
        })
    }

    private static func isDateOrderDayMonth() -> Bool {
        return DateFormatter.dateFormat(fromTemplate: "MMMMd", options: 0, locale: Locale.current)?.hasPrefix("d") == true
    }
}
