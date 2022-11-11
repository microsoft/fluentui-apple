//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewDayTodayCell

class CalendarViewDayTodayCell: CalendarViewDayCell {
    override class var identifier: String { return "CalendarViewDayTodayCell" }

    override var isSelected: Bool {
        didSet {
            configureBackgroundColor()
            configureFontColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            configureBackgroundColor()
            configureFontColor()
        }
    }

    // Only supports indicator levels from 0...4
    override func setup(textStyle: CalendarViewDayCellTextStyle, backgroundStyle: CalendarViewDayCellBackgroundStyle, selectionStyle: CalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        configureBackgroundColor()
        configureFontColor()
    }

    private func configureBackgroundColor() {
        if isHighlighted || isSelected {
            switch backgroundStyle {
            case .primary:
                contentView.backgroundColor = Colors.Calendar.Day.backgroundPrimary
            case .secondary:
                contentView.backgroundColor = Colors.Calendar.Day.backgroundSecondary
            }
        } else {
            contentView.backgroundColor = Colors.Calendar.Today.background
        }
    }

    private func configureFontColor() {
        if isHighlighted || isSelected {
            dateLabel.font = UIFontMetrics.default.scaledFont(for: Fonts.body, maximumPointSize: Constants.maximumFontSize)
            dateLabel.textColor = Colors.Calendar.Day.textSelected
            dateLabel.showsLargeContentViewer = true
        } else {
            dateLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Fonts.headline, maximumPointSize: Constants.maximumFontSize)
            switch textStyle {
            case .primary:
                dateLabel.textColor = Colors.Calendar.Day.textPrimary
                dotView.color = Colors.Calendar.Day.textPrimary
            case .secondary:
                dateLabel.textColor = Colors.Calendar.Day.textSecondary
                dotView.color = Colors.Calendar.Day.textSecondary
            }
        }
    }
}
