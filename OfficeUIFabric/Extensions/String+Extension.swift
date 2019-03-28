//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension String {
    var initials: String {
        var initials = ""

        // Use the leading character from the first two words in the user's name
        let nameComponents = self.components(separatedBy: " ")
        for nameComponent: String in nameComponents {
            let trimmedName = nameComponent.trimmed()
            if trimmedName.count < 1 {
                continue
            }
            let initial = trimmedName.index(trimmedName.startIndex, offsetBy: 0)
            let initialLetter = String(trimmedName[initial])
            let initialUnicodeScalars = initialLetter.unicodeScalars
            let initialUnicodeScalar = initialUnicodeScalars[initialUnicodeScalars.startIndex]
            // Discard name if first char is not a letter
            let isInitialLetter: Bool = initialLetter.count > 0 && CharacterSet.letters.contains(initialUnicodeScalar)
            if isInitialLetter && initials.count < 2 {
                initials += initialLetter
            }
        }

        return initials
    }

    internal var localized: String {
        return NSLocalizedString(self, bundle: OfficeUIFabricFramework.bundle, comment: "")
    }

    func formatted(with args: CVarArg...) -> String {
        return String(format: self, locale: Locale.current, arguments: args)
    }

    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaceNewlineAndZeroWidthSpace)
    }

    /// Creates a string representing `optional` where:
    ///   * when non-nil: `optional` will be force-unwrapped prior to conversion
    ///   * when nil: falls back to `defaultValue` if specified or `String(describing)` if not
    ///
    /// Example:
    ///
    ///   var n: Int? = 3
    ///   String(describing: n)                                 // "Optional(3)"
    ///   String(describingOptional: n)                         // "3"
    ///
    ///   n = nil
    ///   String(describing: n)                                 // "nil"
    ///   String(describingOptional: n)                         // "nil"
    ///   String(describingOptional: n, defaultValue: "hello")  // "hello"
    ///
    init<T>(describingOptional optional: T?, defaultValue: String? = nil) {
        if optional != nil {
            self = String(describing: optional!)
        } else {
            self = defaultValue ?? String(describing: optional)
        }
    }

    func preferredSize(for font: UIFont, width: CGFloat = .greatestFiniteMagnitude, numberOfLines: Int = 0) -> CGSize {
        if numberOfLines == 1 {
            return CGSize(width: UIScreen.main.roundToDevicePixels(width), height: font.deviceLineHeightWithLeading)
        }
        let maxHeight = numberOfLines > 1 ? font.deviceLineHeightWithLeading * CGFloat(numberOfLines) : .greatestFiniteMagnitude
        let rect = self.boundingRect(
            with: CGSize(width: width, height: maxHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return CGSize(
            width: UIScreen.main.roundToDevicePixels(rect.width),
            height: UIScreen.main.roundToDevicePixels(rect.height)
        )
    }
}

// MARK: - Date

/**
 * Defines the string format of the date (time not included) of a Date
 */
@objc public enum MSDateStringCompactness: Int {
    case longDaynameDayMonth = 1                        // ex: Thursday, December 12
    case longDaynameDayMonthYear                        // ex: Thursday, December 12, 2015
    case shortDayname                                   // ex: Wed
    case shortDaynameShortMonthnameDay                  // ex: Wed, Dec 23
    case shortDaynameShortMonthnameDayFullYear          // ex: Wed, Dec 23, 2016
    case partialDaynameShortDayMonth                    // ex: Thu, 10/01
    case longDaynameDayMonthHoursColumnsMinutes         // ex: Thursday, October 1, 12:57 PM
    case shortDaynameShortMonthnameHoursColumnsMinutes  // ex: Wed, Dec 23, 5:00 PM
    case partialDaynameShortDayMonthHoursColumsMinutes  // ex: Thu 10/01, 12:57 PM
    case partialMonthnameDaynameFullYear                // ex: Sept 10, 2015
    case partialMonthnameDaynameHoursColumnsMinutes     // ex: Sept 10, 5:18 PM
    case partialMonthnameDayname                        // ex: Sept 10
    case longMonthNameFullYear                          // ex: September 2015
    case shortDaynameHoursColumnMinutes                 // ex: Tue. 8:00 AM or 8:AM if today
    case shortDayMonth                                  // ex: 9/10
    case longDayMonthYearTime                           // ex: 9/10/2016 12:00 PM
    case shortDaynameDayShortMonthYear                  // ex: Thur, Dec 12, 2015
}

/**
 * Defines the string format of the time of a Date
 */
@objc public enum MSTimeStringCompactness: Int {
    case hoursColumnsMinutes = 1  // ex: 2:15 AM
    case hours                    // ex: 2 AM
}

@objc private enum MSDurationUnitInSeconds: Int {
    case minute = 60
    case hour = 3600
    case day = 86400 // 24h, when using this, keep in mind that a day is not necessarily 24h long.
}

private struct DateFormatterCache {
    static let shared = DateFormatterCache()
    static let currentLocaleObserver = NotificationCenter.default.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: nil) { _ in
        shared.removeAll()
    }

    private var dateFormattersCache = NSCache<AnyObject, AnyObject>()
    private let dateComponentsFormattersCache = NSCache<AnyObject, AnyObject>()

    func dateFormatter(timeZone: TimeZone) -> DateFormatter {
        let hashKey = "relativeDayStringFormatter_" + timeZone.identifier

        if let dateFormatter = dateFormattersCache.object(forKey: hashKey as AnyObject) as? DateFormatter {
            return dateFormatter
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            dateFormattersCache.setObject(dateFormatter, forKey: hashKey as AnyObject)
            return dateFormatter
        }
    }

    func dateFormatter(dateFormat: String, timeZone: TimeZone) -> DateFormatter {
        let hashKey = dateFormat + "_" + timeZone.identifier

        if let dateFormatter = dateFormattersCache.object(forKey: hashKey as AnyObject) as? DateFormatter {
            return dateFormatter
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormat, options: 0, locale: Locale.current)
            dateFormatter.timeZone = timeZone
            dateFormattersCache.setObject(dateFormatter, forKey: hashKey as AnyObject)
            return dateFormatter
        }
    }

    func dateComponentsFormatter(allowedUnits: NSCalendar.Unit, unitsStyle: DateComponentsFormatter.UnitsStyle, timeZone: TimeZone) -> DateComponentsFormatter {
        let hashKey = String(allowedUnits.rawValue) + "_" + String(unitsStyle.rawValue) + "_" + timeZone.identifier

        if let dateFormatter = dateComponentsFormattersCache.object(forKey: hashKey as AnyObject) as? DateComponentsFormatter {
            return dateFormatter
        } else {
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.allowedUnits = allowedUnits
            dateFormatter.unitsStyle = unitsStyle
            // There seems to be an Apple bug where Calendar.autoupdatingCurrent doesn't use TimeZone.autoupdatingCurrent
            dateFormatter.calendar?.timeZone = timeZone

            dateComponentsFormattersCache.setObject(dateFormatter, forKey: hashKey as AnyObject)
            return dateFormatter
        }
    }

    private func removeAll() {
        dateFormattersCache.removeAllObjects()
        dateComponentsFormattersCache.removeAllObjects()
    }
}

public extension String {
    /**
     * Returns a representation of a date (time not included) based on given Date, MSDateStringCompactness and NSTimeZone
     * Example: Thursday 12 December
     */
    static func dateString(from date: Date, compactness: MSDateStringCompactness, timeZone: TimeZone? = nil) -> String {
        switch compactness {
        case .longDaynameDayMonth:
            return stringFromDate(date, dateFormat: "EEEE d MMMM", timeZone: timeZone)
        case .longDaynameDayMonthYear:
            return stringFromDate(date, dateFormat: "EEEE d MMMM yyyy", timeZone: timeZone)
        case .shortDaynameDayShortMonthYear:
            return stringFromDate(date, dateFormat: "EEE d MMM yyyy", timeZone: timeZone)
        case .shortDayname:
            return stringFromDate(date, dateFormat: "EEE", timeZone: timeZone)
        case .shortDaynameShortMonthnameDay:
            return stringFromDate(date, dateFormat: "EEE, MMM d", timeZone: timeZone)
        case .shortDaynameShortMonthnameDayFullYear:
            return stringFromDate(date, dateFormat: "EEE, MMM d, yyyy", timeZone: timeZone)
        case .partialDaynameShortDayMonth:
            return stringFromDate(date, dateFormat: "EEEMd", timeZone: timeZone)
        case .longDaynameDayMonthHoursColumnsMinutes:
            return "\(dateString(from: date, compactness: .longDaynameDayMonth, timeZone: timeZone)), \(timeString(from: date, compactness: .hoursColumnsMinutes, timeZone: timeZone))"
        case .shortDaynameShortMonthnameHoursColumnsMinutes:
            return "\(dateString(from: date, compactness: .shortDaynameShortMonthnameDay, timeZone: timeZone)), \(timeString(from: date, compactness: .hoursColumnsMinutes, timeZone: timeZone))"
        case .partialDaynameShortDayMonthHoursColumsMinutes:
            return "\(dateString(from: date, compactness: .partialDaynameShortDayMonth, timeZone: timeZone)), \(timeString(from: date, compactness: .hoursColumnsMinutes, timeZone: timeZone))"
        case .partialMonthnameDaynameFullYear:
            return stringFromDate(date, dateFormat: "MMM, d yyyy", timeZone: timeZone)
        case .partialMonthnameDaynameHoursColumnsMinutes:
            return "\(dateString(from: date, compactness: .partialMonthnameDayname, timeZone: timeZone)), \(timeString(from: date, compactness: .hoursColumnsMinutes, timeZone: timeZone))"
        case .partialMonthnameDayname:
            return stringFromDate(date, dateFormat: "MMM d", timeZone: timeZone)
        case .longMonthNameFullYear:
            return stringFromDate(date, dateFormat: "MMMM yyyy", timeZone: timeZone)
        case .shortDaynameHoursColumnMinutes:
            let time = timeString(from: date, compactness: .hoursColumnsMinutes, timeZone: timeZone)
            if Calendar.sharedCalendarWithTimeZone(timeZone).isDateInToday(date) {
                return time
            }
            return "\(stringFromDate(date, dateFormat: "EEE", timeZone: timeZone)). \(time)"
        case .shortDayMonth:
            return stringFromDate(date, dateFormat: "dMM", timeZone: timeZone)
        case .longDayMonthYearTime:
            let time = timeString(from: date, compactness: .hoursColumnsMinutes, timeZone: timeZone)
            return "\(stringFromDate(date, dateFormat: "dMMyyyy ", timeZone: timeZone)) \(time)"
        }
    }

    /**
     * Returns a representation of a time based on given Date, MSTimeStringCompactness and NSTimezone
     * Example: 2:15
     */
    static func timeString(from date: Date, compactness: MSTimeStringCompactness, timeZone: TimeZone? = nil) -> String {
        switch compactness {
        case .hoursColumnsMinutes:
            return stringFromDate(date, dateFormat: "j:m", timeZone: timeZone)
        case .hours:
            return stringFromDate(date, dateFormat: "j", timeZone: timeZone)
        }
    }

    /**
     Returns Yesterday, Today or Tomorrow depending on the number of days relative to now
     */
    static func relativeDayString(forNumberOfDaysSinceNow numberOfDays: Int, timeZone: TimeZone? = nil) -> String? {
        let dateFormatter = DateFormatterCache.shared.dateFormatter(timeZone: timeZone ?? TimeZone.autoupdatingCurrent)
        let timeIntervalSinceNow = TimeInterval(numberOfDays * MSDurationUnitInSeconds.day.rawValue)
        return dateFormatter.string(from: Date(timeIntervalSinceNow: timeIntervalSinceNow))
    }

    private static func stringFromDate(_ date: Date, dateFormat: String, timeZone: TimeZone?) -> String {
        let dateFormatter = DateFormatterCache.shared.dateFormatter(dateFormat: dateFormat, timeZone: timeZone ?? TimeZone.autoupdatingCurrent)
        return dateFormatter.string(from: date)
    }
}
