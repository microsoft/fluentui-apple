//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// A static class used to calculate layout and sizing information for MSDateTimePickerView.
class MSDateTimePickerViewLayout {
	static let horizontalPadding: CGFloat = 6

    // Component widths, based on the ideal total width minus padding
    static let componentWidths: [MSDateTimePickerViewComponentType: CGFloat] = [
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
        return CGFloat(rowCount) * MSDateTimePickerViewComponentCell.idealHeight
    }

    static func sizeThatFits(_ size: CGSize, mode: MSDateTimePickerViewMode) -> CGSize {
        let componentTypes = MSDateTimePickerViewLayout.componentTypes(fromDatePickerMode: mode)
        let totalWidth = componentTypes.reduce(horizontalPadding * 2) { $0 + (componentWidths[$1] ?? 0) }

        return CGSize(width: totalWidth, height: max(size.height, MSDateTimePickerViewComponentCell.idealHeight * CGFloat(idealRowCount)))
    }

    static func componentTypes(fromDatePickerMode datePickerMode: MSDateTimePickerViewMode) -> [MSDateTimePickerViewComponentType] {
        switch datePickerMode {
        case .date:
            // Determine whether Day or Month picker should be first based on locale
            var componentTypes: [MSDateTimePickerViewComponentType]
            if isDateOrderDayMonth() {
                componentTypes = [.day, .month]
            } else {
                componentTypes = [.month, .day]
            }
            componentTypes.append(.year)
            return componentTypes

        case .dateTime:
            var componentTypes: [MSDateTimePickerViewComponentType] = [.date, .timeHour, .timeMinute]
            if !Date.has24HourFormat() {
                componentTypes.append(.timeAMPM)
            }
            return componentTypes

        case .dayOfMonth:
            return [.weekOfMonth, .dayOfWeek]
        }
    }

    static func componentsByType(fromTypes types: [MSDateTimePickerViewComponentType], mode: MSDateTimePickerViewMode) -> [MSDateTimePickerViewComponentType: MSDateTimePickerViewComponent] {
        return types.reduce([MSDateTimePickerViewComponentType: MSDateTimePickerViewComponent](), { map, type in
            var map = map
            let dataSource = MSDateTimePickerViewDataSourceFactory.dataSource(withType: type, mode: mode)

            // Set date on MSDateTimePickerViewDataSourceWithDate to properly set number of days for month
            (dataSource as? MSDateTimePickerViewDataSourceWithDate)?.date = Date()

            let component = MSDateTimePickerViewComponent(dataSource: dataSource)
            map[type] = component
            return map
        })
    }

    private static func isDateOrderDayMonth() -> Bool {
        return DateFormatter.dateFormat(fromTemplate: "MMMMd", options: 0, locale: Locale.current)?.hasPrefix("d") == true
    }
}
