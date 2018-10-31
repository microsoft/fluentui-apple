//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSCalendarViewDayTodayCell

class MSCalendarViewDayTodayCell: MSCalendarViewDayCell {
    override class var identifier: String { return "MSCalendarViewDayTodayCell" }

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
    override func setup(textStyle: MSCalendarViewDayCellTextStyle, backgroundStyle: MSCalendarViewDayCellBackgroundStyle, selectionStyle: MSCalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        configureBackgroundColor()
        configureFontColor()
    }

    private func configureBackgroundColor() {
        if isHighlighted || isSelected {
            switch backgroundStyle {
            case .primary:
                contentView.backgroundColor = MSColors.CalendarView.DayCell.backgroundColorPrimary
            case .secondary:
                contentView.backgroundColor = MSColors.CalendarView.DayCell.backgroundColorSecondary
            }
        } else {
            contentView.backgroundColor = MSColors.CalendarView.TodayCell.background
        }
    }

    private func configureFontColor() {
        if isHighlighted || isSelected {
            dateLabel.font = MSFonts.body
            dateLabel.textColor = MSColors.background
        } else {
            dateLabel.font = MSFonts.headline
            switch textStyle {
            case .primary:
                dateLabel.textColor = MSColors.CalendarView.DayCell.textColorPrimary
                dotView.color = MSColors.CalendarView.DayCell.textColorPrimary
            case .secondary:
                dateLabel.textColor = MSColors.CalendarView.DayCell.textColorSecondary
                dotView.color = MSColors.CalendarView.DayCell.textColorSecondary
            }
        }
    }
}
